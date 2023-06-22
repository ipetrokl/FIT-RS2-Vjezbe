using System;
using eProdaja.Model;
using eProdaja.Services.Database;

namespace eProdaja.Services
{
	public class ProizvodiService : IProizvodiService
	{
        EProdajaContext _context;

        public ProizvodiService(EProdajaContext context)
        {
            _context = context;
        }
        List<Model.Proizvodi> proizvodis = new List<Model.Proizvodi>()
        {
            new Model.Proizvodi()
            {
                ProizvodID = 1,
                Naziv = "Mobitel"
            }
        };
        public IList<Model.Proizvodi> Get()
        {
            var list = _context.Proizvodis.ToList();
            return proizvodis;
        }
    }
}

