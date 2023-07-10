using System;
using System.Text;
using AutoMapper;
using Azure.Core;
using EasyNetQ;
using eProdaja.Model;
using eProdaja.Model.Requests;
using eProdaja.Services.Database;
using RabbitMQ.Client;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace eProdaja.Services.ProizvodiStateMachine
{
    public class DraftProductState : BaseState
    {
        public DraftProductState(IServiceProvider serviceProvider, EProdajaContext context, IMapper mapper) : base(serviceProvider,context, mapper)
        {
        }

        public override async Task<Model.Proizvodi> Update(int id, ProizvodiUpdateRequest request)
        {
            var set = _context.Set<Database.Proizvodi>();

            var entity = await set.FindAsync(id);

            _mapper.Map(request, entity);

            if (entity.Cijena < 0)
            {
                throw new Exception("Cijena ne moze biti u minusu");
            }


            if (entity.Cijena < 1)
            {
                throw new UserException("Cijena ispod minimuma");
            }

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Proizvodi>(entity);
        }

        public override async Task<Model.Proizvodi> Activate(int id)
        {
            var set = _context.Set<Database.Proizvodi>();

            var entity = await set.FindAsync(id);

            entity.StateMachine = "active";

            await _context.SaveChangesAsync();
            

            //var factory = new ConnectionFactory { HostName = "localhost" };
            //using var connection = factory.CreateConnection();
            //using var channel = connection.CreateModel();

            //channel.QueueDeclare(queue: "product_added",
            //                     durable: false,
            //                     exclusive: false,
            //                     autoDelete: false,
            //                     arguments: null);

            //const string message = "Hello World!";
            //var body = Encoding.UTF8.GetBytes(message);

            //channel.BasicPublish(exchange: string.Empty,
            //                     routingKey: "product_added",
            //                     basicProperties: null,
            //                     body: body);

            var mappedEntity = _mapper.Map<Model.Proizvodi>(entity);

            using var bus = RabbitHutch.CreateBus("host=localhost");
            
            bus.PubSub.Publish(mappedEntity);
            
            return mappedEntity;
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Update");
            list.Add("Active");

            return list;
        }
    }
}

