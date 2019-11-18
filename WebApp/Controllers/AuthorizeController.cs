using Microsoft.AspNetCore.Mvc;

namespace WebApp.Controllers
{
	[ApiController]
	[Route("[controller]")]
	public class AuthorizeController : ControllerBase
	{
		[HttpGet]
		public IActionResult Get()
		{
			return this.Ok(
				new
				{
					type = "Authorize Controller"
				}
			);
		}
	}
}
