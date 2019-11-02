#!/bin/bash

#cd deploy
mkdir logs
mkdir data
./executor.sh > ./logs/executor.log &
./executor-monitor.sh >> ./logs/executor-monitor.log &
./storage.sh > ./logs/storage.log &
./frontend.sh > ./logs/frontend.log &
