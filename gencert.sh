mkdir tls
openssl genrsa -out tls/ca.key 4096
openssl req -x509 -new -sha512 -noenc \
  -key tls/ca.key -days 3653 \
  -config tls/ca.conf \
  -out tls/ca.crt

certs=(
  "server" "client"
)

for i in ${certs[*]}; do
  openssl genrsa -out "tls/${i}.key" 4096

  openssl req -new -key "tls/${i}.key" -sha256 \
    -config "tls/ca.conf" -section ${i} \
    -out "tls/${i}.csr"

  openssl x509 -req -days 3653 -in "tls/${i}.csr" \
    -copy_extensions copyall \
    -sha256 -CA "tls/ca.crt" \
    -CAkey "tls/ca.key" \
    -CAcreateserial \
    -out "tls/${i}.crt"

  openssl x509 -in "tls/${i}.crt" -text -noout
done
