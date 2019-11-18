using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebApp.Controllers
{
	[ApiController]
	[Route("[controller]")]
	[AllowAnonymous]
	public class AnonymousController : ControllerBase
	{
		[HttpGet]
		public IActionResult Get()
		{
			return this.Ok(
				new
				{
					type = "Anonymous Controller"
				}
			);
		}
	}
}
