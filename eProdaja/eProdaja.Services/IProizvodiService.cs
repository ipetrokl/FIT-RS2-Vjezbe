﻿using System;
using eProdaja.Model;
using eProdaja.Model.Requests;
using eProdaja.Model.SearchObjects;

namespace eProdaja.Services
{
	public interface IProizvodiService : ICRUDService<Proizvodi, ProizvodiSearchObject, ProizvodiInsertRequest, ProizvodiUpdateRequest>
	{
		Task<Proizvodi> Activate(int id);
		Task<Proizvodi> Hide(int id);
		Task<List<string>> AllowedActions(int id);
		List<Model.Proizvodi> Recommend(int id);

    }
}

