using Microsoft.AspNetCore.Authentication.Certificate;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Authorization;
using Microsoft.AspNetCore.Server.Kestrel.Core;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

using System;
using System.Net;
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
			services.Configure<KestrelServerOptions>(Configuration.GetSection("Kestrel"));

			services
				.AddAuthentication(CertificateAuthenticationDefaults.AuthenticationScheme)
				.AddCertificate(options =>
				{
					options.AllowedCertificateTypes = CertificateTypes.All;
					options.RevocationMode = X509RevocationMode.NoCheck;

					options.Events = new CertificateAuthenticationEvents
					{
						OnCertificateValidated = context =>
						{

							// return Task.FromException(new Exception("Bla bla bla"));

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


			services.AddCertificateForwarding(options =>
			{
				options.CertificateHeader = "X-ARR-ClientCert";
				options.HeaderConverter = (headerValue) =>
				{
					if (!string.IsNullOrWhiteSpace(headerValue))
					{
						try
						{
							var bytes = StringToByteArray(headerValue);
							return new X509Certificate2(bytes);
						}
						catch (Exception)
						{
							return null;
						}

					}

					return null;
				};
			});

			services.AddAuthorization();
			services.AddControllers();

			services.AddMvc(options =>
			{
				var authorizePolicy = new AuthorizationPolicyBuilder(CertificateAuthenticationDefaults.AuthenticationScheme)
											.RequireAuthenticatedUser()
											.Build();

				options.Filters.Add(new AuthorizeFilter(authorizePolicy));
			})
			.SetCompatibilityVersion(CompatibilityVersion.Version_3_0);
		}

		public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
		{
			app.UseExceptionHandler(configure =>
			{
				configure.Run(async context =>
				{
					context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
					//context.Response.ContentType = "application/json";

					//var contextFeature = context.Features.Get<IExceptionHandlerFeature>();
					//if (contextFeature != null)
					//{
					//await context.Response.WriteAsync(new
					//{
					//	statusCode = context.Response.StatusCode,
					//	message = "Internal Server Error."
					//}.ToString());
					//}
				});
			});

			app.UseRouting();
			app.UseCertificateForwarding();

			app.UseAuthorization();
			app.UseAuthentication();

			app.UseEndpoints(endpoints =>
			{
				endpoints.MapControllers();
			});
		}

		private static byte[] StringToByteArray(string hex)
		{
			var numberChars = hex.Length;
			var bytes = new byte[numberChars / 2];
			for (var i = 0; i < numberChars; i += 2)
			{
				bytes[i / 2] = Convert.ToByte(hex.Substring(i, 2), 16);
			}

			return bytes;
		}
	}
}
