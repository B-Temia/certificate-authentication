using System;
using System.Net.Http;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;

namespace ConsoleApp
{
	class Program
	{
		static void Main(string[] args)
		{
			MainAsync().Wait();
			Console.Read();
		}

		static async Task MainAsync()
		{
			var handler = new HttpClientHandler();
			handler.ServerCertificateCustomValidationCallback = (request, cert, chain, errors) =>
			{
				return true;
			};

			using (var certificate = new X509Certificate2(@"..\..\..\..\certificates\keeogotestinter1leaf1.pfx", "1234"))
			{
				using (var client = new HttpClient(handler))
				{
					var request = new HttpRequestMessage()
					{
						RequestUri = new Uri("https://localhost:5001/weatherforecast"),
						Method = HttpMethod.Get,
					};

					request.Headers.Add("X-ARR-ClientCert", certificate.GetRawCertDataString());
					request.Headers.Add("X-Client-Cert", certificate.GetRawCertDataString());
					var response = await client.SendAsync(request);

					if (response.IsSuccessStatusCode)
					{
						Console.WriteLine("******** Success ********");
						var responseContent = await response.Content.ReadAsStringAsync();
						Console.Write(responseContent);
					}
					else
					{
						Console.WriteLine("********* Failed *********");
						var responseContent = await response.Content.ReadAsStringAsync();
						Console.Write(responseContent);
					}
				}
			}
		}
	}
}
