using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Puma.Security.Functions.Azure
{
    public class InternalServerErrorObjectResult : JsonResult
    {
        public InternalServerErrorObjectResult(object value) : base(value)
        {
            StatusCode = StatusCodes.Status500InternalServerError;
        }

        public InternalServerErrorObjectResult() : this(null)
        {
            StatusCode = StatusCodes.Status500InternalServerError;
        }
    }

}