using System;
namespace eProdaja.Model.Requests
{
	public class KorisniciInsertRequest
	{

        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string? Email { get; set; }

        public string? Telefon { get; set; }

        public string KorisnickoIme { get; set; } = null!;

        public bool? Status { get; set; }

        public String Password { get; set; }

        public String PasswordPotvrda { get; set; }
    }
}

