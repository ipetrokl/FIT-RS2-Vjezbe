using System;
using eProdaja.Model.Requests;

namespace eProdaja.Services
{
	public interface IKorisniciService
	{
		Task<List<Model.Korisnici>> Get();
		Model.Korisnici Insert(KorisniciInsertRequest request);
		Model.Korisnici Update(int id, KorisniciUpdateRequest request);
	}
}

