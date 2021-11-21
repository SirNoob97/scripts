#!/bin/bash

function __help {
  echo "\
Usage of $0:
  $0 -u <user> -h <host> -p <port> -d <database>

Options:
  -u, --user      Database User(default: postgres).
  -p, --port      Database port(default: 5432).
  -h, --host      Database host IP(default: localhost).
  -d, --database  Database to connect.
  -I, --help      Display help message."
}

if [ $# -eq 0 ]; then
  __help
  exit 1
fi

tmp_opts=$(getopt -o 'u:p:D:d:h:I?' -l 'user:,port:,host:,date:,database:,help' -n "$0" -- "$@")
if [ $? -ne 0 ]; then
  __help
  echo 'Terminating...' >&2
  exit 1
fi

eval set -- "$tmp_opts"
unset tmp_opts

user='postgres'
host='localhost'
port=5432

while true; do
  case "$1" in
    '-u'|'--user') user=$2; shift 2; continue;;
    '-p'|'--port') port=$2; shift 2; continue;;
    '-h'|'--host') host=$2; shift 2; continue;;
    '-d'|'--database') database=${2:?'database is required'}; shift 2; continue;;
    '-I'|'?'|'--help') __help; exit 0;;
    '--') break;;
    *) echo "Invalid option '$1'" >&2; exit 1;;
  esac
done

psql --username=$user --host=$host --port=$port --pset="footer=off" --file=./info-server.sql --quiet $database
