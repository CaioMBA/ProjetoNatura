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

        [HttpPost("/CadastrarUsuario")]
        public async Task<ActionResult> PostRegisterUser(
            [FromBody, Required] CreateUserRequestModel? Body)
        {

            var Response = _service.PostRegisterUser(Body);

            if (Response != null)
            {
                if (Response.STATUS != "0")
                {
                    return StatusCode((int)HttpStatusCode.OK, Response);
                }
                else
                {
                    return StatusCode((int)HttpStatusCode.BadRequest, Response);
                }

            }
            else
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, Response);
            }
        }

        [HttpGet("/ValidarUsuario")]
        public async Task<ActionResult> GetValidationUser(
            [FromHeader, Required] string? LoginUser,
            [FromHeader, Required] string? Password
            )
        {
            if (String.IsNullOrEmpty(LoginUser))
            {
                DefaultResponseModel ErrorResponse = new DefaultResponseModel()
                {
                    STATUS = "0",
                    MSG = "Campo LOGIN não pode ser VAZIO"
                };
                return StatusCode((int)HttpStatusCode.BadRequest, ErrorResponse);
            }
            else if (String.IsNullOrEmpty(Password))
            {
                DefaultResponseModel ErrorResponse = new DefaultResponseModel()
                {
                    STATUS = "0",
                    MSG = "Campo SENHA não pode ser VAZIO"
                };
                return StatusCode((int)HttpStatusCode.BadRequest, ErrorResponse);
            }

            ValidateUserRequestModel Obj = new ValidateUserRequestModel()
            {
                P_USERLOGIN = LoginUser,
                P_USERPASSWORD = Password
            };

            var Response = _service.ValidateUser(Obj);

            if (Response != null)
            {
                if (Response.STATUS != "0")
                {
                    return StatusCode((int)HttpStatusCode.OK, Response);
                }
                else
                {
                    return StatusCode((int)HttpStatusCode.BadRequest, Response);
                }

            }
            else
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, Response);
            }
        }

        [HttpPut("/TrocarSenha")]
        public async Task<ActionResult> PutChangePassword(
            [FromHeader, Required] string? LoginCredential,
            [FromHeader] string? OldPassword,
            [FromHeader] string? NewPassword,
            [FromHeader] bool ForgotPassword = false
            )
        {
            var Response = _service.PutChangePassword(LoginCredential, OldPassword, NewPassword, ForgotPassword);

            if (Response != null)
            {
                if (Response.STATUS != "0")
                {
                    return StatusCode((int)HttpStatusCode.OK, Response);
                }
                else
                {
                    return StatusCode((int)HttpStatusCode.BadRequest, Response);
                }

            }
            else
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, Response);
            }
        }

        [HttpPut("/TrocarFoto")]
        public async Task<ActionResult> PutChangePhoto(
            [FromHeader, Required] string? Credential,
            [FromHeader] string? NewPhoto
            )
        {
            var Response = _service.PutChangePhoto(Credential, NewPhoto);

            if (Response != null)
            {
                if (Response.STATUS != "0")
                {
                    return StatusCode((int)HttpStatusCode.OK, Response);
                }
                else
                {
                    return StatusCode((int)HttpStatusCode.BadRequest, Response);
                }

            }
            else
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, Response);
            }
        }

        [HttpPut("/AtualizarInformacoesDeUsuario")]
        public async Task<ActionResult> PutUpdateDetails(
            [FromBody, Required] ChangeUserDetailsModel Body)
        {
            var Response = _service.PutChangeUserDetails(Body);

            if (Response != null)
            {
                if (Response.STATUS != "0")
                {
                    return StatusCode((int)HttpStatusCode.OK, Response);
                }
                else
                {
                    return StatusCode((int)HttpStatusCode.BadRequest, Response);
                }

            }
            else
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, Response);
            }
        }
    }
}
