using System;
using System.Collections.Generic;
using AutoMapper;
using eProdaja.Model;
using eProdaja.Model.Requests;

namespace eProdaja.Services.ProizvodiStateMachine
{
	public class InitialProductState : BaseState
	{
        public InitialProductState(IServiceProvider serviceProvider, Database.EProdajaContext context, IMapper mapper) : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<Proizvodi> Insert(ProizvodiInsertRequest request)
        {
            var set = _context.Set<Database.Proizvodi>();

            var entity = _mapper.Map<Database.Proizvodi>(request);

            entity.StateMachine = "draft";

            set.Add(entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<Proizvodi>(entity);
        }
    }
}

