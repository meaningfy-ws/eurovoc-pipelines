#!/bin/bash
echo Killing Executor
kill `ps ax | grep /executor.jar | grep -v grep | awk '{print $1}'`
echo Killing Executor-monitor
kill `ps ax | grep /executor-monitor.jar | grep -v grep | awk '{print $1}'`
echo Killing Frontend
kill `ps ax | grep node | grep -v grep | awk '{print $1}'`
echo Killing Storage
kill `ps ax | grep /storage.jar | grep -v grep | awk '{print $1}'`

rm -rf ./logs
rm -rf ./data/logs
