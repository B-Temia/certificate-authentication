del *.pfx
del *.cer
del *.key
del *.pem

$password = "1234"
$securePassword = ConvertTo-SecureString -String $password -Force -AsPlainText

# b-temia Root Certificate
$rootCert = New-SelfSignedCertificate -DnsName "B-Temia", "b-temia.com" -CertStoreLocation "cert:\LocalMachine\My" -NotAfter (Get-Date).AddYears(20) -FriendlyName "B-Temia Root CA" -KeyUsageProperty All -KeyUsage CertSign, CRLSign, DigitalSignature
Write-Host "B-Temia Root Cert Thumbprint " + $rootCert.Thumbprint
$rootCert | Export-PfxCertificate -FilePath .\btemia_root_ca.pfx -Password $securePassword
$rootCert | Export-Certificate -FilePath .\btemia_root_ca.cer
openssl pkcs12 -in .\btemia_root_ca.pfx -clcerts -nokeys -out btemia_root_ca.pem -passin pass:$password
openssl pkcs12 -in .\btemia_root_ca.pfx -nocerts -nodes -out btemia_root_ca.key -passin pass:$password



# Keeogo
$keeogoCert = New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname "B-Temia Keeogo", "keeogo.b-temia.com" -Signer $rootCert -NotAfter (Get-Date).AddYears(20) -FriendlyName "B-Temia Keeogo" -KeyUsageProperty All -KeyUsage CertSign, CRLSign, DigitalSignature -TextExtension @("2.5.29.19={text}CA=1&pathlength=1") 
Write-Host "B-Temia Keeogo Cert Thumbprint " + $keeogoCert.Thumbprint
$keeogoCert | Export-PfxCertificate -FilePath .\keeogo.pfx -Password $securePassword
$keeogoCert | Export-Certificate -FilePath .\keeogo.cer
openssl pkcs12 -in .\keeogo.pfx -clcerts -nokeys -out keeogo.pem -passin pass:$password
openssl pkcs12 -in .\keeogo.pfx -nocerts -nodes -out keeogo.key -passin pass:$password


# Proof of possession certificate
# $signerCert = ( Get-ChildItem -Path cert:\LocalMachine\My\The Signer Thumbprint)
# $proofCert = New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname "The proof of possession string requested" -Signer $signerCert -NotAfter (Get-Date).AddYears(20) -FriendlyName "B-Temia Keeogo Proof of possession"
# $proofCertThumbprint = $proofCert.Thumbprint
# $proofCert | Export-PfxCertificate -FilePath .\proof.pfx -Password $securePassword
# $proofCert | Export-Certificate -FilePath .\proof.cer
# Export-Certificate -Cert cert:\localMachine\my\$proofCertThumbprint -FilePath .\proof.pem


# Keoogo Quebec Intermediate Certificate
$keeogQCCert = New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname "B-Temia Keeogo Quebec", "quebec.keeogo.b-temia.com" -Signer $keeogoCert -NotAfter (Get-Date).AddYears(20) -FriendlyName "B-Temia Keeogo Quebec" -KeyUsageProperty All -KeyUsage CertSign, CRLSign, DigitalSignature -TextExtension @("2.5.29.19={text}CA=1&pathlength=1") 
Write-Host "B-Temia Keeogo Quebec Cert Thumbprint " + $keeogQCCert.Thumbprint
$keeogQCCert | Export-PfxCertificate -FilePath .\keeogo-qc.pfx -Password $securePassword
$keeogQCCert | Export-Certificate -FilePath .\keeogo-qc.cer
openssl pkcs12 -in .\keeogo-qc.pfx -clcerts -nokeys -out keeogo-qc.pem -passin pass:$password
openssl pkcs12 -in .\keeogo-qc.pfx -nocerts -nodes -out keeogo-qc.key -passin pass:$password

# Keeogo 0001 From Keoogo Quebec Factory
$keeogoQC00001Cert = New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname "B-Temia Keeogo Quebec 00001", "00001.quebec.keeogo.b-temia.com", "keeogoQC00001" -Signer $keeogQCCert -NotAfter (Get-Date).AddYears(20) -FriendlyName "B-Temia Keeogo Quebec 00001"
Write-Host "B-Temia Keeogo Quebec 00001 Cert Thumbprint " + $keeogoQC00001Cert.Thumbprint
$keeogoQC00001Cert | Export-PfxCertificate -FilePath .\keeogo-qc-00001.pfx -Password $securePassword
$keeogoQC00001Cert | Export-Certificate -FilePath .\keeogo-qc-00001.cer
openssl pkcs12 -in .\keeogo-qc-00001.pfx -clcerts -nokeys -out keeogo-qc-00001.pem -passin pass:$password
openssl pkcs12 -in .\keeogo-qc-00001.pfx -nocerts -nodes -out keeogo-qc-00001.key -passin pass:$password

# Keeogo 0002 From Keoogo Quebec Factory
$keeogoQC00002Cert = New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname "B-Temia Keeogo Quebec 00002", "00002.quebec.keeogo.b-temia.com", "keeogoQC00002" -Signer $keeogQCCert -NotAfter (Get-Date).AddYears(20) -FriendlyName "B-Temia Keeogo Quebec 00002"
Write-Host "B-Temia Keeogo Quebec 00002 Cert Thumbprint " + $keeogoQC00002Cert.Thumbprint
$keeogoQC00002Cert | Export-PfxCertificate -FilePath .\keeogo-qc-00002.pfx -Password $securePassword
$keeogoQC00002Cert | Export-Certificate -FilePath .\keeogo-qc-00002.cer
openssl pkcs12 -in .\keeogo-qc-00002.pfx -clcerts -nokeys -out keeogo-qc-00002.pem -passin pass:$password
openssl pkcs12 -in .\keeogo-qc-00002.pfx -nocerts -nodes -out keeogo-qc-00002.key -passin pass:$password

# Keoogo Taiwan Intermediate Certificate
$keeogTWCert = New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname "B-Temia Keeogo Taiwan", "taiwan.keeogo.b-temia.com" -Signer $keeogoCert -NotAfter (Get-Date).AddYears(20) -FriendlyName "B-Temia Keeogo Taiwan" -KeyUsageProperty All -KeyUsage CertSign, CRLSign, DigitalSignature -TextExtension @("2.5.29.19={text}CA=1&pathlength=1") 
Write-Host "B-Temia Keeogo Taiwan Cert Thumbprint " + $keeogTWCert.Thumbprint
$keeogTWCert | Export-PfxCertificate -FilePath .\keeogo-tw.pfx -Password $securePassword
$keeogTWCert | Export-Certificate -FilePath .\keeogo-tw.cer
openssl pkcs12 -in .\keeogo-tw.pfx -clcerts -nokeys -out keeogo-tw.pem -passin pass:$password
openssl pkcs12 -in .\keeogo-tw.pfx -nocerts -nodes -out keeogo-tw.key -passin pass:$password

# Keeogo 0001 From Keoogo Taiwan Factory
$keeogoTW00001Cert = New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname "B-Temia Keeogo Taiwan 00001", "00001.taiwan.keeogo.b-temia.com", "keeogoTW00001" -Signer $keeogTWCert -NotAfter (Get-Date).AddYears(20) -FriendlyName "B-Temia Keeogo Taiwan 00001"
Write-Host "B-Temia Keeogo Taiwan 00001 Cert Thumbprint " + $keeogoTW00001Cert.Thumbprint
$keeogoTW00001Cert | Export-PfxCertificate -FilePath .\keeogo-tw-00001.pfx -Password $securePassword
$keeogoTW00001Cert | Export-Certificate -FilePath .\keeogo-tw-00001.cer
openssl pkcs12 -in .\keeogo-tw-00001.pfx -clcerts -nokeys -out keeogo-tw-00001.pem -passin pass:$password
openssl pkcs12 -in .\keeogo-tw-00001.pfx -nocerts -nodes -out keeogo-tw-00001.key -passin pass:$password

# Keeogo 0002 From Keoogo Taiwan Factory
$keeogoTW00002Cert = New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname "B-Temia Keeogo Taiwan 00002", "00002.taiwan.keeogo.b-temia.com", "keeogoTW00002" -Signer $keeogTWCert -NotAfter (Get-Date).AddYears(20) -FriendlyName "B-Temia Keeogo Taiwan 00002"
Write-Host "B-Temia Keeogo Taiwan 00002 Cert Thumbprint " + $keeogoTW00002Cert.Thumbprint
$keeogoTW00002Cert | Export-PfxCertificate -FilePath .\keeogo-tw-00002.pfx -Password $securePassword
$keeogoTW00002Cert | Export-Certificate -FilePath .\keeogo-tw-00002.cer
openssl pkcs12 -in .\keeogo-tw-00002.pfx -clcerts -nokeys -out keeogo-tw-00002.pem -passin pass:$password
openssl pkcs12 -in .\keeogo-tw-00002.pfx -nocerts -nodes -out keeogo-tw-00002.key -passin pass:$password

# localhost From Root
$localhostCert = New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname "B-Temia Test localhost", "127.0.0.1", "localhost" -Signer $keeogoCert -NotAfter (Get-Date).AddYears(20) -FriendlyName "B-Temia Keeogo localhost"
$localhostCertThumbprint = $localhostCert.Thumbprint
$localhostCert | Export-PfxCertificate -FilePath .\localhost.pfx -Password $securePassword
$localhostCert | Export-Certificate -FilePath .\localhost.cer
Export-Certificate -Cert cert:\localMachine\my\$localhostCertThumbprint -FilePath .\localhost.pem

Write-Host -ForegroundColor Green "Move the 'B-Temia Root CA' from cert:\localmachine\my to 'Trusted Root Certification Authorities' (Local Computer)"
Write-Host -ForegroundColor Green "Remvoe everything else from cert:\localmachine\my exept the one uses for the https (B-Temia Test localhost)"
