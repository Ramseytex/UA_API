#!/bin/bash

###
## colors!
#

CLEAR='\x1B[0m'
WHITE='\x1B[37m'
B_WHITE='\x1B[1;37m'
YELLOW='\x1B[31m'
B_YELLOW='\x1B[1;31m'
RED='\x1B[31m'
B_RED='\x1B[1;31m'

###
## general util shit
#

PLATFORM=`uname`

IAM=`basename "$0"`
TMPDIR=`mktemp -d /tmp/vpn.XXXXXXX`
SENDTO="security@urbanairship.com"

trap "cleanup; exit;" SIGHUP SIGINT SIGTERM

if [ $PLATFORM == "Darwin" ]; then
    VPNDIR=vpn.tblk
    CONFIGNAME=config.ovpn
    CERTS="
ca   ca.crt
cert client.crt
key  client.key
"
else
    VPNDIR=.openvpn
    CONFIGNAME=UA.conf
    CERTS="
ca   /home/`whoami`/$VPNDIR/ca.crt
cert /home/`whoami`/$VPNDIR/client.crt
key  /home/`whoami`/$VPNDIR/client.key
"
fi


mkdir "$TMPDIR/$VPNDIR"

confirm() {
    while [ -z "$OKRESP" ]; do
        prompt "Is this ok? [y/n]"
        read OKRESP
        [ "$OKRESP" = "n" ] && die Aborting
        [ "$OKRESP" = "n" ] && break
    done
}
prompt () {
    printf "${B_WHITE}$@: ${CLEAR}"
}
cleanup () {
    rm -rf $TMPDIR
}
info () {
    printf "${B_WHITE}Info: ${CLEAR}$@\n"
}
warn () {
    printf "${B_YELLOW}Warning: ${CLEAR}$@\n"
}
error () {
    printf "${B_RED}Error: ${CLEAR}$@\n"
}
die () {
    error "$@"
    cleanup
    exit 1
}

cat > "$TMPDIR/openssl.cnf" <<EOF
HOME                    = .
RANDFILE                = \$ENV::HOME/.rnd
[openssl_init]
oid_section = new_oids
alg_section = algs

[ new_oids ]

[ algs ]
fips_mode = no

[ req ]
default_bits            = 4096
default_md              = sha1
default_keyfile         = client.key
distinguished_name      = req_distinguished_name
attributes              = req_attributes
x509_extensions = v3_req # The extentions to add to the self signed cert
string_mask = MASK:0x2002

[ req_attributes ]

[ req_distinguished_name ]
countryName                     = Country Name (2 letter code)
countryName_default             = US
countryName_min                 = 2
countryName_max                 = 2

stateOrProvinceName             = State or Province Name (full name)
stateOrProvinceName_default     = Oregon

localityName                    = Locality Name (eg, city)
localityName_default            = Portland

0.organizationName              = Organization Name (eg, company)
0.organizationName_default      = Urban Airship, Inc.

organizationalUnitName          = Organizational Unit Name (eg, section)
organizationalUnitName_default  = Users

commonName                      = Common Name (Your full name)
commonName_default              = \$ENV::CN
commonName_max                  = 64

emailAddress                    = Email Address
emailAddress_default            = \$ENV::EMAIL
emailAddress_max                = 64

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
EOF

cat > "$TMPDIR/$VPNDIR/ca.crt" <<EOF
-----BEGIN CERTIFICATE-----
MIIG6DCCBNCgAwIBAgIJANuv3ecJ+ZqvMA0GCSqGSIb3DQEBBQUAMIGoMQswCQYD
VQQGEwJVUzEPMA0GA1UECBMGT3JlZ29uMREwDwYDVQQHEwhQb3J0bGFuZDEcMBoG
A1UEChMTVXJiYW4gQWlyc2hpcCwgSW5jLjETMBEGA1UECxMKT3BlcmF0aW9uczEZ
MBcGA1UEAxMQVXJiYW4gQWlyc2hpcCBDQTEnMCUGCSqGSIb3DQEJARYYZW5nLW9w
c0B1cmJhbmFpcnNoaXAuY29tMB4XDTEyMDQyMTAzMjMwMFoXDTIyMDQxOTAzMjMw
MFowgagxCzAJBgNVBAYTAlVTMQ8wDQYDVQQIEwZPcmVnb24xETAPBgNVBAcTCFBv
cnRsYW5kMRwwGgYDVQQKExNVcmJhbiBBaXJzaGlwLCBJbmMuMRMwEQYDVQQLEwpP
cGVyYXRpb25zMRkwFwYDVQQDExBVcmJhbiBBaXJzaGlwIENBMScwJQYJKoZIhvcN
AQkBFhhlbmctb3BzQHVyYmFuYWlyc2hpcC5jb20wggIiMA0GCSqGSIb3DQEBAQUA
A4ICDwAwggIKAoICAQCvoopNBBd1C1gLeDjJleS4F2B0C9HlHjHgUU1ey2FU1gm/
y8Wew1gMTqW9kwMCfMOkXejOpq3kT5JSwoE1cK5drKFiHOs5fdGGieWf+pqMDp1e
Ur07wF8WUwVzK09v1yTkQE+Pv4hDCbGi33NUyVBEYqjsQ33/yiWa0TODd4gNCgal
fxvdy2wkSpyztrTs2enqnjw49Dma1Pi2cDOswV0epUZeJy70bSE/HEd5bUSSLDG/
efH2+HSHztD3Y77Lek2WSbYz2MsqzWqgs1vFdwiP4M4ap1xTh4a3h2DZMi6u6gGK
9pZWb4gwQ7eB/kkiC6DFS0SzMEAHpyvORqedkfT5IvtYv0zbQF96OPB/CI6kFmv9
P07owuBt8lTxJA0UKi1PbUYdMFVnHdbB/PSjGuyYdIUoaisZviwQOcx+fWqnL3zm
6veQjYHtPell1SMVNGPjzgeiYE9IBCAEYBvNvj4kQ2dNAq/kF0VcGlvlEQaCRvYb
5ZQW30PQPY7hVD7aB2nxAi5EAkL9A/sgoa5vq65RsWnffXoEl7zQiQXNUfR8V4qz
ttFVJePai89IW6ZU7upaB7rOsE1v+fC/u3TnAJWVbKkHyI/Z9beT3HzVYj6tSwYF
42mQzgtDAp/OJJBeYF//8cMDpSxNomwSges21T5LwtQcxoekQ8yi2Mz4lAYQowID
AQABo4IBETCCAQ0wHQYDVR0OBBYEFLtW6bYLml+GleDa8weF5V8RqVCrMIHdBgNV
HSMEgdUwgdKAFLtW6bYLml+GleDa8weF5V8RqVCroYGupIGrMIGoMQswCQYDVQQG
EwJVUzEPMA0GA1UECBMGT3JlZ29uMREwDwYDVQQHEwhQb3J0bGFuZDEcMBoGA1UE
ChMTVXJiYW4gQWlyc2hpcCwgSW5jLjETMBEGA1UECxMKT3BlcmF0aW9uczEZMBcG
A1UEAxMQVXJiYW4gQWlyc2hpcCBDQTEnMCUGCSqGSIb3DQEJARYYZW5nLW9wc0B1
cmJhbmFpcnNoaXAuY29tggkA26/d5wn5mq8wDAYDVR0TBAUwAwEB/zANBgkqhkiG
9w0BAQUFAAOCAgEAY4H/zyNIiGCSqIFjInwu0i+zBQ5EOZk5yj1P8VHNJDKENljI
gojBlHKhzZtLv7+3pUFxg5hzVNobqhTapRQwgKh2bU74x9XRyqzhWZ8S8IW9LwS6
1+qiN2o8mi2S6G4cuZRJiaWUO6jyedWajVkIg3O+fD43Wiv4YTdK9t5gdS4sVQy/
uEWr3vcKCWaQALCEgSc/6d9/DFQy/hw0sk2tQmDWUO4FbjKW8bAQY124k8yv7Y+1
UNl9f3S6XV34kaU+oKpYCcCX5VC1E7/+LLSj1zhihlQRyJ/9hmUp6ytPjnvPB1z+
Cc0kMMGBXs7isdQmC5KjAVQc8gQg3T5hQ+sVAu2+/AUMKsf2e9h1CQTfpyKXkuMe
XHBfXUXqPFKhZcCZrKgOaB/j+H5U6dknZKvfnSg/4j2jkwVBlaarojdo0cwXpD9R
OR6DpeJAkiGgAYhM780jWjwkhSwvwuX0VYXEUcs1Kp3E3tF1PsWpQu0+h7hzd4HH
huVrlG0hA6mIkF+sNdWGAj5lTH6qRq4R0RmNvXPxXZRYjAmRX8qaWwFU34HnY7GU
2QtFud8cU8HW+fMrLDIEO6SMorqwxFVu3a4LI+tn++Low//2d/zflDLc7cHFU5Zr
RhGz+9x3rIYhhH59LwcIOwi4sKc2hAgGjNg9fPiW1HB9pNh1y7nI10UJ3ZI=
-----END CERTIFICATE-----

-----BEGIN CERTIFICATE-----
MIIGozCCBIugAwIBAgIBCjANBgkqhkiG9w0BAQUFADCBqDELMAkGA1UEBhMCVVMx
DzANBgNVBAgTBk9yZWdvbjERMA8GA1UEBxMIUG9ydGxhbmQxHDAaBgNVBAoTE1Vy
YmFuIEFpcnNoaXAsIEluYy4xEzARBgNVBAsTCk9wZXJhdGlvbnMxGTAXBgNVBAMT
EFVyYmFuIEFpcnNoaXAgQ0ExJzAlBgkqhkiG9w0BCQEWGGVuZy1vcHNAdXJiYW5h
aXJzaGlwLmNvbTAeFw0xMjA5MDIxOTU0MjNaFw0yMjA4MzExOTU0MjNaMGwxCzAJ
BgNVBAYTAlVTMQ8wDQYDVQQIEwZPcmVnb24xHDAaBgNVBAoTE1VyYmFuIEFpcnNo
aXAsIEluYy4xDjAMBgNVBAsTBVVzZXJzMR4wHAYDVQQDExVVcmJhbiBBaXJzaGlw
IFVzZXIgQ0EwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCu5jZsaDN7
6aPyzZEB40/JROhGSgjpSfsKhjnOzuaCWOvW69Qa/mzMu0W/oQ5uM/0knGgJvcs3
8H/OsFSSZNVsm90nEsvDFkKQFJBayMrF1VYaJiZDDOsH6ib5reBY56+3UfwTXR/z
q/NBmivfsJ88dAr8/Q+lOEt4iglpN4IkAerCfok+FvF/noOaGSpcIbjeYs/HSnYu
wiQT+Vfu1gLSkhzB8iom1SJS0X/NlWAiHgruk6Hbu8/0XngQJ1jGxovncXmNMDNB
0xydJCWfPRtJ7TnBERhzl5mJ/0En4B/3twNrVR6kQaBz6O5zXbOirOLfYPaT2kdo
qVBXaIHhifWlPQ2/GwfrQN4U8n8qCT7WpwDJYpYkeDZBur7fCmMNPG75DgR3fTfl
yZHiAVYEIXuZTVhTIcZtScnpNr7SrUphg0nrfuvppdePE01rtSaY4JST/CQY3p25
lUL9ZIXHQcEWeTsWFnI91TPXvbQ70Goz9XE94zB58JVfLFsVfepqvGShZY1Silg8
I68GUErp+RwXx55GnzpctRVjuQQepfb7jnl7eFzMXlaZD/S5wAoAiXl6lvU70ecO
XXTYUhH1V3FwdxSVMG4+F7P6pU3+NnN4Fip4PXFxcW9SIvYWgfnsY5KoocJ25UHF
/JUytMYZN2Dd3bC4ETrZbfgRm8+9q8eiewIDAQABo4IBETCCAQ0wHQYDVR0OBBYE
FBdfgn2eugtWzAed032P4vu4yBkfMIHdBgNVHSMEgdUwgdKAFLtW6bYLml+GleDa
8weF5V8RqVCroYGupIGrMIGoMQswCQYDVQQGEwJVUzEPMA0GA1UECBMGT3JlZ29u
MREwDwYDVQQHEwhQb3J0bGFuZDEcMBoGA1UEChMTVXJiYW4gQWlyc2hpcCwgSW5j
LjETMBEGA1UECxMKT3BlcmF0aW9uczEZMBcGA1UEAxMQVXJiYW4gQWlyc2hpcCBD
QTEnMCUGCSqGSIb3DQEJARYYZW5nLW9wc0B1cmJhbmFpcnNoaXAuY29tggkA26/d
5wn5mq8wDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQUFAAOCAgEAqiXJnOk93hO1
GfEwjd1TlEAtvWEz04YO0eYswoKX6SP1fhzA8AMiz1Ljd0vZKhiBV4mhs44k9nsB
poHBVhbqfJTY1M2M/FXQJGXDVmTCxC8UOX/pqsVcwF6AEa5Un8eeDpfs/MqphUEF
GtRbGheQBATTx5QKG7MqbC5a5rCb9+Ilz4ZdoQL1LCdAz/eqrtPoebPo0Oxzfnzl
3FfOkj++C712mHEAu3cxlyCVh/ve5amy90i5X1UWr3mWEC6FJ7/xOcMT8Z62J3il
UoSeGTLkm0kySBXWjdbL2UwSlLO1AwKp3SDoDWxc7VLfI6ZYtyV3sX6WdEb8h6lQ
7iF0TAU/mSgKkWDy63N/x5pmKgJluwLPqaiRk1L9OrSA5b+GVDYQJyM5uGXRIM3i
v3e90afybTYKKV9UXMm4pVU2QztxyqXVp7KtykklXIBuC1BAmcT0NKepvXDfsx1n
VR2/bTnOgX0z3WhOwZ5xTDVqDOc3o9vY/GO7KY+H+duetcX6wpfGY6nvAuWoZRpR
roo0f/Jhrqzk626Gj1J7CnL+PsSqRLn4HHEUR0XhNQCp0q5cqVfm6SCXONiFI3gJ
3CVK70sGIuLhGxPlkZIMptEv5zDYFFilFn3X2zX3lJicoHzRe//SqsNxVaO51PaV
oOWDRt7S/wlPJ8fvoUvIcjbVnCISELw=
-----END CERTIFICATE-----
EOF

cat > "$TMPDIR/$VPNDIR/$CONFIGNAME" <<EOF
client
dev tun
proto udp
remote 174.140.145.66 7010
resolv-retry infinite 
nobind
auth-nocache
script-security 2
persist-key
persist-tun
ns-cert-type server
comp-lzo
verb 3
$CERTS
EOF

###
## main
#

# check if a cert already exists
test -e ~/$VPNDIR && die "A vpn config dir already exists at ~/$VPNDIR - If you would\nlike to generate another certificate, please delete this manually."

while [ -z "$CN" ]; do
    prompt "Full Name"
    read CN
done

while [ -z "$EMAIL" ]; do
    prompt "email Address"
    read EMAIL
done

SHORTNAME=$(echo $EMAIL | cut -f1 -d\@)

export CN
export EMAIL

confirm "Is this correct?"

openssl req -batch -config "$TMPDIR/openssl.cnf" -new -keyout \
  "$TMPDIR/$VPNDIR/client.key" -out "$TMPDIR/$SHORTNAME.csr"
chmod 600 "$TMPDIR/$VPNDIR/client.key"

`which sendmail 2>/dev/null 1>/dev/null`
if [ $? -eq 0 ]; then
    cat > "$TMPDIR/email_header" <<EOF
From: $EMAIL
To: ${SENDTO}
Subject: Please sign my VPN CSR

EOF

    info "Sending CSR to ${SENDTO} for signing"
    cat "$TMPDIR/email_header" "$TMPDIR/$SHORTNAME.csr" > "$TMPDIR/email_data"
    /usr/sbin/sendmail -t <"$TMPDIR/email_data"
else
    info "Please copy the following and paste it into the body of an email to $SENDTO"
    cat "$TMPDIR/$SHORTNAME.csr"
fi

info "A copy of this csr is located at ~/$SHORTNAME.csr"

info "Once you receive your certificate, place it at ~/$VPNDIR/client.crt"

if [ $PLATFORM == "Darwin" ]; then
    info "You may then doubleclick ~/$VPNDIR to create your VPN profile"
else
    info "You may then import ~/$VPNDIR/$CONFIGNAME using nm-connection-editor"
fi

mv    "$TMPDIR/$VPNDIR" ~/
mv -i "$TMPDIR/$SHORTNAME.csr" ~/

cleanup
