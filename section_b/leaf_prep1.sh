#!/bin/sh
sudo yum -y install git
git clone https://github.com/mlochbihler/memsql-sagemaker-devday-01
sudo chmod -R 755 /home/ec2-user
sudo usermod -s /bin/bash memsql
sudo curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python get-pip.py
sudo pip install awscli
