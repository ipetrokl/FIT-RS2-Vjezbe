using eProdaja.Model;
using eProdaja.Model.Requests;
using eProdaja.Model.SearchObjects;
using eProdaja.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eProdaja.Controllers;

[ApiController]
[AllowAnonymous]
public class JediniceMjereController : BaseController<Model.JediniceMjere, JediniceMjereSearchObject>
{
    public JediniceMjereController(ILogger<BaseController<JediniceMjere, JediniceMjereSearchObject>> logger, IJediniceMjereService service) : base(logger, service)
    {
    }
}

