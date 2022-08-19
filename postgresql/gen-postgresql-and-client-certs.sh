#!/bin/env bash

set -eu

echo 'BEFORE START!!!'
echo '1) Verify the certificates subjects.'
echo '2) This script can only be run by the root or postgres user, because access to the postgresql data directory is required.'
echo '3) This script will not write into any configuration file please see the step at the bottom of the file.'
echo '4) Comment or delete this echos and the exit command below.'
exit 0

curr_user=$(whoami)

if [ $curr_user != 'root' ]; then
  if [ $curr_user != 'postgres' ]; then
    echo "This script can only be run by the root or postgres user!!"
    exit 1
  fi
fi

function __help {
  echo "\
Usage of $0:
  $0 -d <postgresql data directory: /var/lib/postgresql/{postgres version}/main>

Options:
  -d, --datadir   PostgreSQL data directory.
  -h, --help      Display help message."
}

if [ $# -eq 0 ]; then
  __help
  exit 1
fi

tmp_opts=$(getopt -o 'd:h?' -l ',datadir:,help' -n "$0" -- "$@")
if [ $? -ne 0 ]; then
  __help
  echo 'Terminating...' >&2
  exit 1
fi

eval set -- "$tmp_opts"
unset tmp_opts

datadir=
while true; do
  case "$1" in
    '-d'|'--datadir') datadir=${2:?'postgresql data directory is required'}; shift 2; continue;;
    '-h'|'?'|'--help') __help; exit 0;;
    '--') break;;
    *) echo "Invalid option '$1'" >&2; exit 1;;
  esac
done

openssl genrsa -aes256 -out ca.key 4096
openssl req -new -x509 -sha256 -days 1825 -key ca.key -out ca.crt -subj "/C=two firsts letter of your county/ST=your state/L=your location/O=name of your company/CN=root-ca"

openssl genrsa -aes256 -out server-intermediate.key 4096
openssl req -new -sha256 -days 1825 -key server-intermediate.key -out server-intermediate.csr -subj "/C=two firsts letter of your county/ST=your state/L=your location/O=name of your company/CN=server-im-ca"
openssl x509 -extfile /etc/ssl/openssl.cnf -extensions v3_ca -req -days 1825 -CA ca.crt -CAkey ca.key -CAcreateserial -in server-intermediate.csr -out server-intermediate.crt

openssl genrsa -aes256 -out client-intermediate.key 4096
openssl req -new -sha256 -days 1825 -key client-intermediate.key -out client-intermediate.csr -subj "/C=two firsts letter of your county/ST=your state/L=your location/O=name of your company/CN=client-im-ca"
openssl x509 -extfile /etc/ssl/openssl.cnf -extensions v3_ca -req -days 1825 -CA ca.crt -CAkey ca.key -CAcreateserial -in client-intermediate.csr -out client-intermediate.crt

openssl req -nodes -new -newkey rsa:4096 -sha256 -keyout server.key -out server.csr -subj "/C=two firsts letter of your county/ST=your state/L=your location/O=name of your company/CN=dbhost.your.domain"
openssl x509 -extfile /etc/ssl/openssl.cnf -extensions usr_cert -req -days 1825 -CA server-intermediate.crt -CAkey server-intermediate.key -CAcreateserial -in server.csr -out server.crt

openssl req -nodes -new -newkey rsa:4096 -sha256 -keyout client.key -out client.csr -subj "/C=two firsts letter of your county/ST=your state/L=your location/O=name of your company/CN=pguser"
openssl x509 -extfile /etc/ssl/openssl.cnf -extensions usr_cert -req -days 1825 -CA client-intermediate.crt -CAkey client-intermediate.key -CAcreateserial -in client.csr -out client.crt


cp ca.crt $datadir/ca.crt
cp server.key $datadir/server.key
cat server.crt server-intermediate.crt ca.crt > $datadir/server.crt

chown postgres:postgres $datadir/ca.crt $datadir/server.crt $datadir/server.key
chmod 600 ca.crt server.crt server.key

# Set this options in postgresql.conf
# files paths can be absolute or relative to PGDATA(/var/lib/postgresql/{postgresql-version}/main/...)
# ssl = on
# ssl_ca_file = 'ca.crt'
# ssl_cert_file = 'server.crt'
# ssl_key_file = 'server.key'

# Set the correct rules to the pg_hba.conf
# hostssl    databases             pgusername              address        cert clientcert=verify-full or verify-ca


# Now send the certificates and the key to the client
# cat client.crt client-intermediate.crt ca.crt > postgresql.crt

# send the "ca.crt" to be stored as "~/.postgresql/root.crt" by the client if you need to store the file in another location you need to set the PGSSLROOTCERT='/custom/path'
# send the "client.key" to be stored as "~/.postgresql/postgresql.key" for another location set the PGSSLKEY='/custom/path'
# send the "postgresql.crt" to "~/.postgresql/postgresql.crt" for another location set the PGSSLCERT='/custom/path'

# then set the permisions
# chmod 600 ~/.postgresql/ca.crt ~/.postgresql/postgresql.crt ~/.postgresql/postgresql.key
