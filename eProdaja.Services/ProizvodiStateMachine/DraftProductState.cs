using System;
using AutoMapper;
using Azure.Core;
using eProdaja.Model.Requests;
using eProdaja.Services.Database;
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

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Proizvodi>(entity);
        }

        public override async Task<Model.Proizvodi> Activate(int id)
        {
            var set = _context.Set<Database.Proizvodi>();

            var entity = await set.FindAsync(id);

            entity.StateMachine = "active";

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Proizvodi>(entity);
        }
    }
}

