using Domain.Interfaces;
using Domain.Models;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;
using System.Net;

namespace App.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UserController : ControllerBase
    {
        private IUserService _service;
        public UserController(IUserService service)
        {
            _service = service;
        }

        [HttpGet("/InformacoesUsuario")]
        public async Task<ActionResult> PostRegisterUser(
            [FromHeader, Required] string? Credencial)
        {

            GetExtraInfoUserModel? Response = _service.ExtraInfoUsuario(Credencial);

            if (Response != null)
            {
                return StatusCode((int)HttpStatusCode.OK, Response);
            }
            else
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, Response);
            }
        }
    }
}
