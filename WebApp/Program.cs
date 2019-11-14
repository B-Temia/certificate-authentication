using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Server.Kestrel.Https;
using Microsoft.Extensions.Hosting;
using System.Diagnostics;
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
					webBuilder.ConfigureKestrel(o =>
					{
						Debugger.Break();
						// var cert = new X509Certificate2(Path.Combine("..", "certificates", "btemiatestroot.pfx"), "1234");
						var cert = new X509Certificate2(Path.Combine("..", "certificates", "keeogotestinter1.pfx"), "1234");
						// var cert = new X509Certificate2(Path.Combine("..", "certificates", "keeogotestinter1leaf1.pfx"), "1234");
						o.ConfigureHttpsDefaults(co =>
						{
							co.ServerCertificate = cert;
							co.AllowAnyClientCertificate();
							co.ClientCertificateMode = ClientCertificateMode.RequireCertificate;
						});
					});
				});
	}
}
