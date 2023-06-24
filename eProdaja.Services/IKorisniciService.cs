using System;
using eProdaja.Model.Requests;
using eProdaja.Model.SearchObjects;

namespace eProdaja.Services
{
	public interface IKorisniciService : ICRUDService<Model.Korisnici, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>
	{
	
	}
}

