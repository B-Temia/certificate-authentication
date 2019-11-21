using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

using System;
using System.Threading.Tasks;

namespace WebApp.Controllers
{
	[ApiController]
	[Route("[controller]")]
	[AllowAnonymous]
	public class AnonymousController : ControllerBase
	{
		[HttpGet]
		public async Task<IActionResult> Get()
		{
			var request = this.HttpContext.Request;
			foreach (var header in request.Headers)
			{
				Console.WriteLine($"{header.Key} = {header.Value}");
			}

			return this.Ok(
				new
				{
					type = "Anonymous Controller"
				}
			);
		}
	}
}
