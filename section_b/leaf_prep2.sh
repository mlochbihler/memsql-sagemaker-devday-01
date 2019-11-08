#!/bin/sh
sudo pip install aws-google-auth==0.0.32
sudo pip install virtualenv
sudo mkdir /home/memsql
sudo chown memsql:memsql /home/memsql
sudo su memsql
cd ~
pwd
mkdir aws
