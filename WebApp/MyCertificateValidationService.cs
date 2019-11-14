using System.Diagnostics;
using System.IO;
using System.Security.Cryptography.X509Certificates;

namespace WebApp
{
	public class MyCertificateValidationService
	{
		public bool ValidateCertificate(X509Certificate2 clientCertificate)
		{
			Debugger.Break();

			var cert = new X509Certificate2(Path.Combine("..", "certificates", "btemiatestroot.pfx"), "1234");
			var inter1 = new X509Certificate2(Path.Combine("..", "certificates", "keeogotestinter1.pfx"), "1234");

			//if (clientCertificate.Issuer == rootCertificate.Issuer)
			//{
				return true;
			//}

			//return false;
		}
	}
}