$password = "1234"

# B-Temia Root
openssl req -x509 -sha256 -days 7300 -newkey rsa:3072 -config btemia_root_ca_csr.conf -keyout btemia_root_ca.key -out btemia_root_ca.crt
openssl pkcs12 -inkey btemia_root_ca.key -in btemia_root_ca.crt -export -out btemia_root_ca.pfx
openssl x509 -in btemia_root_ca.crt -text -noout


# Localhost certificate
openssl req -new -config localhost-csr.conf -out localhost.csr -keyout localhost.key
openssl ca -config localhost.conf -days 365 -create_serial -in localhost.csr -out localhost.crt -extensions leaf_ext -notext
openssl pkcs12 -inkey localhost.key -in localhost.crt -export -out localhost.pfx

# BTemia proof
openssl req -new -config btemia_proof_csr.conf -out btemia_proof.csr -keyout btemia_proof.key
openssl ca -config btemia_proof.conf -days 365 -create_serial -in btemia_proof.csr -out btemia_proof.crt -extensions leaf_ext -notext




# Keeogo
openssl req -new -config keeogo_csr.conf -out keeogo.csr -keyout keeogo.key
openssl ca -config keeogo_ca.conf -days 7300 -create_serial -in keeogo.csr -out keeogo.crt -extensions ca_ext -notext
openssl pkcs12 -inkey keeogo.key -in keeogo.crt -export -out keeogo.pfx

# Keeogo Proof
openssl req -new -config keeogo_proof_csr.conf -out keeogo_proof.csr -keyout keeogo_proof.key
openssl ca -config keeogo_proof.conf -days 365 -create_serial -in keeogo_proof.csr -out keeogo_proof.crt -extensions leaf_ext -notext



# Keoogo QC
openssl req -new -config keeogo_qc_csr.conf -out keeogo_qc.csr -keyout keeogo_qc.key
openssl ca -config keeogo_qc.conf -days 7300 -create_serial -in keeogo_qc.csr -out keeogo_qc.crt -extensions ca_ext -notext
openssl pkcs12 -inkey keeogo_qc.key -in keeogo_qc.crt -export -out keeogo_qc.pfx


# Keoogo QC 00001
openssl req -new -config keeogo_qc_00001_csr.conf -out keeogo_qc_00001.csr -keyout keeogo_qc_00001.key
openssl ca -config keeogo_qc_00001.conf -days 365 -create_serial -in keeogo_qc_00001.csr -out keeogo_qc_00001.crt -extensions leaf_ext -notext
openssl pkcs12 -inkey keeogo_qc_00001.key -in keeogo_qc_00001.crt -export -out keeogo_qc_00001.pfx



openssl req -new -x509 -nodes -new -config keeogo_qc_00001_csr.conf ec:<(openssl ecparam -name secp384r1) -keyout cert.key -out cert.crt -days 3650





# Keoogo QC 00002
openssl req -new -config keeogo_qc_00002_csr.conf -out keeogo_qc_00002.csr -keyout keeogo_qc_00002.key
openssl ca -config keeogo_qc_00002.conf -days 365 -create_serial -in keeogo_qc_00002.csr -out keeogo_qc_00002.crt -extensions leaf_ext -notext
openssl pkcs12 -inkey keeogo_qc_00002.key -in keeogo_qc_00002.crt -export -out keeogo_qc_00002.pfx





# Keoogo TW
openssl req -new -config keeogo_tw_csr.conf -out keeogo_tw.csr -keyout keeogo_tw.key
openssl ca -config keeogo_tw.conf -days 7300 -create_serial -in keeogo_tw.csr -out keeogo_tw.crt -extensions ca_ext -notext
openssl pkcs12 -inkey keeogo_tw.key -in keeogo_tw.crt -export -out keeogo_tw.pfx