#!/usr/bin/env sh

clickhouse-client -nm --user default < "/docker-entrypoint-initdb.d/init.dump"
