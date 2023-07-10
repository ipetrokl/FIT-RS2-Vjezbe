﻿using System;
using eProdaja.Model;

namespace eProdaja.Services
{
	public interface IService<T, TSearch> where TSearch : class
	{
		Task<PagedResult<T>> Get(TSearch search = null);
		Task<T> GetById(int id);
	}
}

