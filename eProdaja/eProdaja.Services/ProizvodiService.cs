using AutoMapper;
using eProdaja.Model;
using eProdaja.Model.Requests;
using eProdaja.Model.SearchObjects;
using eProdaja.Services.Database;
using eProdaja.Services.ProizvodiStateMachine;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace eProdaja.Services
{
    public class ProizvodiService : BaseCRUDService<Model.Proizvodi, Database.Proizvodi, ProizvodiSearchObject, ProizvodiInsertRequest, ProizvodiUpdateRequest>, IProizvodiService
    {
        public BaseState _baseState { get; set; }
        public ProizvodiService(BaseState baseState, EProdajaContext context, IMapper mapper) : base(context, mapper)
        {
            _baseState = baseState;
        }

        public override IQueryable<Database.Proizvodi> AddFilter(IQueryable<Database.Proizvodi> query, ProizvodiSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                filteredQuery = filteredQuery.Where(x => x.Naziv.Contains(search.FTS) || x.Sifra.Contains(search.FTS));
            }

            if (!string.IsNullOrWhiteSpace(search?.Sifra))
            {
                filteredQuery = filteredQuery.Where(x => x.Sifra == search.Sifra);
            }

            return filteredQuery;
        }

        public override Task<Model.Proizvodi> Insert(ProizvodiInsertRequest insert)
        {
            var state = _baseState.CreateState("initial");

            return state.Insert(insert);

        }

        public override async Task<Model.Proizvodi> Update(int id, ProizvodiUpdateRequest update)
        {
            var entity = await _context.Proizvodis.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Update(id, update);
        }

        public async Task<Model.Proizvodi> Activate(int id)
        {
            var entity = await _context.Proizvodis.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Activate(id);
        }

        public async Task<Model.Proizvodi> Hide(int id)
        {
            var entity = await _context.Proizvodis.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Hide(id);
        }

        public async Task<List<string>> AllowedActions(int id)
        {
            var entity = await _context.Proizvodis.FindAsync(id);
            var state = _baseState.CreateState(entity?.StateMachine ?? "initial");
            return await state.AllowedActions();
        }


        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;

        public List<Model.Proizvodi> Recommend(int id)
        {
            lock(isLocked)
            {
                if (mlContext == null)
                {
                    mlContext = new MLContext();

                    var tmpData = _context.Narudzbes.Include("NarudzbaStavkes").ToList();
                    var data = new List<ProductEntry>();

                    foreach (var x in tmpData)
                    {
                        if(x.NarudzbaStavkes.Count > 1)
                        {
                            var disticnctIdemId = x.NarudzbaStavkes.Select(y => y.ProizvodId).ToList();
                            disticnctIdemId.ForEach(y =>
                            {
                                var relatedIdems = x.NarudzbaStavkes.Where(z => z.ProizvodId != y);

                                foreach (var z in relatedIdems)
                                {
                                    data.Add(new ProductEntry()
                                    {
                                        ProductID = (uint)y,
                                        CoPurchaseProductID = (uint)z.ProizvodId,

                                    });
                                }
                            });
                        }
                    }

                    var trainData = mlContext.Data.LoadFromEnumerable(data);

                    //STEP 3: Your data is already encoded so all you need to do is specify options for MatrxiFactorizationTrainer with a few extra hyperparameters
                    //        LossFunction, Alpa, Lambda and a few others like K and C as shown below and call the trainer.
                    MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                    options.MatrixColumnIndexColumnName = nameof(ProductEntry.ProductID);
                    options.MatrixRowIndexColumnName = nameof(ProductEntry.CoPurchaseProductID);
                    options.LabelColumnName = "Label";
                    options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                    options.Alpha = 0.01;
                    options.Lambda = 0.025;
                    // For better results use the following parameters
                    options.NumberOfIterations = 100;
                    options.C = 0.00001;

                    //Step 4: Call the MatrixFactorization trainer by passing options.
                    var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    //STEP 5: Train the model fitting to the DataSet
                    //Please add Amazon0302.txt dataset from https://snap.stanford.edu/data/amazon0302.html to Data folder if FileNotFoundException is thrown.
                    model = est.Fit(trainData);

                }
            }

            //prediction

            var products = _context.Proizvodis.Where(x => x.ProizvodId != id);
            var predictionResult = new List<Tuple<Database.Proizvodi, float>>();
            foreach (var product in products)
            {
                //STEP 6: Create prediction engine and predict the score for Product 63 being co-purchased with Product 3.
                //        The higher the score the higher the probability for this particular productID being co-purchased
                var predictionengine = mlContext.Model.CreatePredictionEngine<ProductEntry, Copurchase_prediction>(model);
                var prediction = predictionengine.Predict(
                                         new ProductEntry()
                                         {
                                             ProductID = (uint)id,
                                             CoPurchaseProductID = (uint)product.ProizvodId
                                         });

                predictionResult.Add(new Tuple<Database.Proizvodi, float>(product, prediction.Score));
            }

            var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(3).ToList();

            return _mapper.Map<List<Model.Proizvodi>>(finalResult);
        }

    }

    public class Copurchase_prediction
    {
        public float Score { get; set; }
    }

    public class ProductEntry
    {
        [KeyType(count: 10)]
        public uint ProductID { get; set; }

        [KeyType(count: 10)]
        public uint CoPurchaseProductID { get; set; }

        public float Label { get; set; }
    }
}

