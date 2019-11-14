using Microsoft.AspNetCore.Authentication.Certificate;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

using System;
using System.Diagnostics;
using System.Security.Claims;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;

namespace WebApp
{
	public class Startup
	{
		public Startup(IConfiguration configuration)
		{
			Configuration = configuration;
		}

		public IConfiguration Configuration { get; }

		public void ConfigureServices(IServiceCollection services)
		{
			services.AddAuthorization();

			services.AddAuthentication(CertificateAuthenticationDefaults.AuthenticationScheme)
				.AddCertificate(options => // code from ASP.NET Core sample
				{
					options.AllowedCertificateTypes = CertificateTypes.All;

					options.Events = new CertificateAuthenticationEvents
					{
						OnCertificateValidated = context =>
						{
							Debugger.Break();
							var claims = new[]
							{
									new Claim(ClaimTypes.NameIdentifier, context.ClientCertificate.Subject, ClaimValueTypes.String, context.Options.ClaimsIssuer),
									new Claim(ClaimTypes.Name, context.ClientCertificate.Subject, ClaimValueTypes.String, context.Options.ClaimsIssuer)
								};

							context.Principal = new ClaimsPrincipal(new ClaimsIdentity(claims, context.Scheme.Name));
							context.Success();

							return Task.CompletedTask;
						},
						OnAuthenticationFailed = context =>
						{
							Console.WriteLine(context.Exception.Message);

							return Task.CompletedTask;
						}
					};
				});

			services.AddControllers();

			services.AddCertificateForwarding(options =>
			{
				options.CertificateHeader = "X-ARR-ClientCert";
				options.HeaderConverter = (headerValue) =>
				{
					X509Certificate2 clientCertificate = null;
					if (!string.IsNullOrWhiteSpace(headerValue))
					{
						byte[] bytes = StringToByteArray(headerValue);
						clientCertificate = new X509Certificate2(bytes);
					}

					return clientCertificate;
				};
			});
		}

		public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
		{
			app.UseRouting();

			app.UseCertificateForwarding();
			app.UseAuthentication();
			app.UseAuthorization();
			
			app.UseEndpoints(endpoints =>
			{
				endpoints.MapControllers();
			});
		}

		private static byte[] StringToByteArray(string hex)
		{
			int NumberChars = hex.Length;
			byte[] bytes = new byte[NumberChars / 2];
			for (int i = 0; i < NumberChars; i += 2)
				bytes[i / 2] = Convert.ToByte(hex.Substring(i, 2), 16);
			return bytes;
		}
	}
}
