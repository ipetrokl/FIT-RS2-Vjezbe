using System;
using AutoMapper;
using eProdaja.Model;
using eProdaja.Model.Requests;
using eProdaja.Services.Database;
using Microsoft.Extensions.DependencyInjection;

namespace eProdaja.Services.ProizvodiStateMachine
{
    public class BaseState
	{
        protected IMapper _mapper { get; set; }
        protected EProdajaContext _context;
        public IServiceProvider _serviceProvider { get; set; }

        public BaseState(IServiceProvider serviceProvider, EProdajaContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }

        public virtual Task<Model.Proizvodi> Insert(ProizvodiInsertRequest request)
		{
			throw new UserException("Not allowed");
		}

        public virtual Task<Model.Proizvodi> Update(int id, ProizvodiUpdateRequest request)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Proizvodi> Activate(int id)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Proizvodi> Hide(int id)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Proizvodi> Delete(int id)
        {
            throw new UserException("Not allowed");
        }

        public BaseState CreateState(string StateName)
        {
            switch (StateName)
            {
                case "initial":
                    case null:
                    return _serviceProvider.GetService<InitialProductState>();
                    break;
                case "draft":
                    return _serviceProvider.GetService<DraftProductState>();
                    break;
                case "active":
                    return _serviceProvider.GetService<ActiveProductState>();
                    break;
                default:
                    throw new UserException("Not allowed");
            }
        }

        public virtual async Task<List<String>> AllowedActions()
        {
            return new List<string>();
        }
    }
}

