#!/usr/bin/env bash
mkdir -p /var/log
mkdir -p /data/lp/etl/storage/pipelines
mkdir -p /data/lp/etl/working
mkdir -p /data/lp/etl/working/data
mkdir -p /data/lp/etl/log
mkdir -p /data/lp/etl/services
chmod -R uga+rwx /data
chmod -R uga+rwx /var/log
chmod -R uga+rwx /etl
/usr/bin/supervisord