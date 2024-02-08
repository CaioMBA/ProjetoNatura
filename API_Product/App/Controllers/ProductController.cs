using Domain.Interfaces;
using Domain.Models;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;
using System.Net;

namespace App.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProductController : ControllerBase
    {
        private IProductService _service;
        public ProductController(IProductService service)
        {
            _service = service;
        }

        [HttpGet("/GetFutureProduct")]
        public async Task<ActionResult> GetFutureProduct(
            [FromHeader, Required] string? Type)
        {

            ProductInfo? Response = _service.ProductAI(Type);

            if (Response != null)
            {
                return StatusCode((int)HttpStatusCode.OK, Response);
            }
            else
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, Response);
            }
        }

        [HttpGet("/GetProductTypes")]
        public async Task<ActionResult> GetFutureProduct()
        {

            List<ProductTypesModel> Response = _service.ProductTypes();

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
