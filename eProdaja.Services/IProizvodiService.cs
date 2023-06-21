using System;
using eProdaja.Model;

namespace eProdaja.Services
{
	public interface IProizvodiService
	{
		IList<Proizvodi> Get();
	}
}

