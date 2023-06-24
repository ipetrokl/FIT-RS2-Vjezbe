using System;
using AutoMapper;
using eProdaja.Services.Database;

namespace eProdaja.Services.ProizvodiStateMachine
{
    public class ActiveProductState : BaseState
    {
        public ActiveProductState(IServiceProvider serviceProvider, EProdajaContext context, IMapper mapper) : base(serviceProvider,context, mapper)
        {
        }
    }
}

