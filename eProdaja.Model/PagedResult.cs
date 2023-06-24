using System;
namespace eProdaja.Model
{
	public class PagedResult<T>
	{
		public List<T> Result { get; set; }
		public int? Count { get; set; }
	}
}

