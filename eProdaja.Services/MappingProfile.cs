using System;
using AutoMapper;
namespace eProdaja.Services
{
	public class MappingProfile : Profile
	{
		public MappingProfile()
		{
            CreateMap<Database.Korisnici, Model.Korisnici>();
			CreateMap<Model.Requests.KorisniciInsertRequest, Database.Korisnici>();
			CreateMap<Model.Requests.KorisniciUpdateRequest, Database.Korisnici>();
			CreateMap<Database.JediniceMjere, Model.JediniceMjere>();
        }
		
	}
}
