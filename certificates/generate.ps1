$mypwd = ConvertTo-SecureString -String "1234" -Force -AsPlainText

# Root
$rootCert = New-SelfSignedCertificate -DnsName "B-Temia Test Root CA" -CertStoreLocation "cert:\LocalMachine\My" -NotAfter (Get-Date).AddYears(20) -FriendlyName "B-Temia Test Root CA" -KeyUsageProperty All -KeyUsage CertSign, CRLSign, DigitalSignature
$rootThumbprint = $rootCert.Thumbprint
$rootCert | Export-PfxCertificate -FilePath .\btemiatestroot.pfx -Password $mypwd
Export-Certificate -Cert cert:\localMachine\my\$rootThumbprint -FilePath btemiatestroot.crt

# Intermediate 1
$inter1Cert = New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname "B-Temia Test Inter 1" -Signer $rootCert -NotAfter (Get-Date).AddYears(20) -FriendlyName "B-Temia Test Inter 1" -KeyUsageProperty All -KeyUsage CertSign, CRLSign, DigitalSignature -TextExtension @("2.5.29.19={text}CA=1&pathlength=1") 
$inter1Thumbprint = $inter1Cert.Thumbprint
$inter1Cert | Export-PfxCertificate -FilePath .\keeogotestinter1.pfx -Password $mypwd
Export-Certificate -Cert cert:\localMachine\my\$inter1Thumbprint -FilePath keeogotestinter1.crt

# Child 1 From Intermediate 1
$leaf1Cert = New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname "B-Temia Test Inter 1 Leaf 1" -Signer $inter1Cert -NotAfter (Get-Date).AddYears(20) -FriendlyName "B-Temia Test Inter 1 Leaf 1"
$leaf1CertThumbprint = $leaf1Cert.Thumbprint
$leaf1Cert | Export-PfxCertificate -FilePath .\keeogotestinter1leaf1.pfx -Password $mypwd
Export-Certificate -Cert cert:\localMachine\my\$leaf1CertThumbprint -FilePath .\keeogotestinter1leaf1.crt

# Child 2 From Intermediate 1
$leaf2Cert = New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname "B-Temia Test Inter 1 Leaf 2" -Signer $inter1Cert -NotAfter (Get-Date).AddYears(20) -FriendlyName "B-Temia Test Inter 1 Leaf 2"
$leaf2CertThumbprint = $leaf2Cert.Thumbprint
$leaf2Cert | Export-PfxCertificate -FilePath .\keeogotestinter1leaf2.pfx -Password $mypwd
Export-Certificate -Cert cert:\localMachine\my\$leaf2CertThumbprint -FilePath .\keeogotestinter1leaf2.crt

Write-Host -ForegroundColor Green "Move the 'B-Temia Test Root CA' in the 'Trusted Root Certification Authorities' (Local Computer)"
