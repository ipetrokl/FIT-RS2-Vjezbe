using eProdaja.Model;
using eProdaja.Model.Requests;
using eProdaja.Model.SearchObjects;
using eProdaja.Services;
using Microsoft.AspNetCore.Mvc;

namespace eProdaja.Controllers;

[ApiController]

public class ProizvodiController : BaseCRUDController<Model.Proizvodi, ProizvodiSearchObject, ProizvodiInsertRequest, ProizvodiUpdateRequest>
{
    public ProizvodiController(ILogger<BaseController<Proizvodi, ProizvodiSearchObject>> logger, IProizvodiService service) : base(logger, service)
    {
    }

    [HttpPut("{id}/activate")]
    public virtual async Task<Model.Proizvodi> Activate(int id)
    {
        return await (_service as IProizvodiService).Activate(id);
    }

    [HttpPut("{id}/hide")]
    public virtual async Task<Model.Proizvodi> Hide(int id)
    {
        return await (_service as IProizvodiService).Hide(id);
    }

    [HttpGet("{id}/allowedActions")]
    public virtual async Task<List<String>> AllowedActions(int id)
    {
        return await (_service as IProizvodiService).AllowedActions(id);
    }

    [HttpGet("{id}/recommend")]
    public virtual List<Model.Proizvodi> Recomend(int id)
    {
        return (_service as IProizvodiService).Recommend(id);
    }
}

