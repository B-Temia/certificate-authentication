using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;

using System.IO;
using System.Security.Cryptography.X509Certificates;

namespace WebApp
{
	public class Program
	{
		public static void Main(string[] args)
		{
			CreateHostBuilder(args).Build().Run();
		}

		public static IHostBuilder CreateHostBuilder(string[] args) =>
			Host.CreateDefaultBuilder(args)
				.ConfigureWebHostDefaults(webBuilder =>
				{
					webBuilder.UseStartup<Startup>();
					webBuilder.ConfigureKestrel(serverOptions =>
					{
						var cert = new X509Certificate2(Path.Combine("..", "certificates", "localhost.pfx"), "1234");
						serverOptions.ListenLocalhost(5001, listenOptions =>
						{
							listenOptions.UseHttps(cert);
						});
					});
				});
	}
}
