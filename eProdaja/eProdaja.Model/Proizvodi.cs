using System;
namespace eProdaja.Model
{
	public partial class Proizvodi
	{
		public int ProizvodId { get; set; }
		public string Naziv { get; set; }
		public string Sifra { get; set; }
		public decimal Cijena { get; set; }
		public int VrstaId { get; set; }
		public int JedinicaMjedeId { get; set; }
		public byte[] Slika { get; set; }
		public byte[] SlikaThumb { get; set; }
		public bool? Status { get; set; }

		public string StateMachine { get; set; }
	}
}

