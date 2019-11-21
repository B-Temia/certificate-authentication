using System;
using System.IO;
using System.Net.Http;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;

namespace ConsoleApp
{
	class Program
	{
		static void Main(string[] args)
		{
			var taskAuthorize = MainAuthorizeAsync();
			// var taskAnonymous = MainAnonymousAsync();

			taskAuthorize.Wait();

			// Task.WaitAll(MainAuthorizeAsync(), MainAuthorizeAsync(), MainAuthorizeAsync(), MainAuthorizeAsync());

			Console.Read();
		}

		static async Task MainAuthorizeAsync()
		{
			using (var certificate = new X509Certificate2(@"..\..\..\..\certificates\keeogo_qc_00001.pfx", "1234"))
			{
				using (var client = new HttpClient())
				{
					var request = new HttpRequestMessage()
					{
						RequestUri = new Uri("https://localhost:5001/authorize"),
						Method = HttpMethod.Post,
					};

					request.Headers.Add("X-ARR-ClientCert", certificate.GetRawCertDataString());
					var response = await client.SendAsync(request);
					if (response.IsSuccessStatusCode)
					{
						Console.WriteLine("******** Success ********");
						var responseContent = await response.Content.ReadAsStringAsync();
						Console.WriteLine(responseContent);
					}
					else
					{
						Console.WriteLine("********* Failed *********");
						Console.WriteLine(response.ReasonPhrase);
					}
				}
			}
		}

		static async Task MainAnonymousAsync()
		{
				using (var client = new HttpClient())
				{
					var request = new HttpRequestMessage()
					{
						RequestUri = new Uri("https://localhost:5001/anonymous"),
						Method = HttpMethod.Get,
					};

					var response = await client.SendAsync(request);
					if (response.IsSuccessStatusCode)
					{
						Console.WriteLine("******** Success ********");
						var responseContent = await response.Content.ReadAsStringAsync();
						Console.WriteLine(responseContent);
					}
					else
					{
						Console.WriteLine("********* Failed *********");
						var responseContent = await response.Content.ReadAsStringAsync();
						Console.WriteLine(responseContent);
					}
				}
		}
	}
}
