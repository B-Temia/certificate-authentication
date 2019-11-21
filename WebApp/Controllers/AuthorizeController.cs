using Microsoft.AspNetCore.Mvc;

using System;
using System.Threading.Tasks;

namespace WebApp.Controllers
{
	[ApiController]
	[Route("[controller]")]
	public class AuthorizeController : ControllerBase
	{
		[HttpPost]
		public async Task<IActionResult> Post()
		{
			var request = this.HttpContext.Request;
			foreach (var header in request.Headers)
			{
				Console.WriteLine($"{header.Key} = {header.Value}");
			}

			return this.Ok(
				new
				{
					type = "Authorize Controller"
				}
			);
		}
	}
}
