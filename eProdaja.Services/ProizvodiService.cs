using System;
using eProdaja.Model;

namespace eProdaja.Services
{
	public class ProizvodiService : IProizvodiService
	{
        List<Proizvodi> proizvodis = new List<Proizvodi>()
        {
            new Proizvodi()
            {
                ProizvodID = 1,
                Naziv = "Mobitel"
            }
        };
        public IList<Proizvodi> Get()
        {
            return proizvodis;
        }
    }
}

