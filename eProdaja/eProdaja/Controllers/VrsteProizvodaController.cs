using eProdaja.Model.SearchObjects;
using eProdaja.Services;
using Microsoft.AspNetCore.Mvc;

namespace eProdaja.Controllers
{
    [ApiController]
    public class VrsteProizvodaController : BaseController<Model.VrsteProizvoda, BaseSearchObject>
    {
        public VrsteProizvodaController(ILogger<BaseController<Model.VrsteProizvoda, BaseSearchObject>> logger
            , IService<Model.VrsteProizvoda, BaseSearchObject> service) : base(logger, service)
        {
        }
    }
}

