#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
Purpose:
MemSQL Pipeline Transform Prototype
Used in MemSQL Pipeline to derive a ML score for each event from Numenta Anomaly Benchmark (NAB) NYC Taxi dataset
https://github.com/numenta/NAB/blob/master/data/realKnownCause/nyc_taxi.csv
For production deployments, modify to pass batch sets to Sagemaker API and deploy one ML endpoint per leaf

Assumptions:
A Random Cut Forest Anomaly Detection ML Model has already been trained and deployed as an Inference Restful API Endpoint.
Here is an AWS Sagemaker Notebook which can be used to deploy the ML Model needed for this Transform:
https://github.com/awslabs/amazon-sagemaker-examples/blob/master/introduction_to_amazon_algorithms/random_cut_forest/random_cut_forest.ipynb

Edits Required:
Add values below for Temporary Work Directory, Model Inference Name, Cloud Region, and AWS Credentials

test usage:
cat nyc_taxi.csv | python score_riders.py

version: 1.0
last updated: 10.25.19
author: mlochbihler
'''

import sys
import os
import uuid
import datetime

inlines = sys.stdin if sys.version_info < (3, 0) else sys.stdin.buffer
outlines = sys.stdout if sys.version_info < (3, 0) else sys.stdout.buffer

# Temporary Work Directory
tmpdir = '<INSERT TEMPORARY DIRECTORY>'

# Model Inference Name - Restful API Endpoint
model_name = '<INSERT NAME OF SAGEMAKER MODEL>'

# Cloud Region
aws_region = '<INSERT AWS REGION>'


# read_in procedure runs ML model for each line in STDIN adding derived score to end of each event
#     Inbound STDIN should be in two fields   
#                     timestamp and number_of_riders
#     STDIN will be converted to three fields   
#                     timestamp  number_of_riders  anomaly_score

def read_in():

  # Create Unique Filenames for temporary work files
  
  dt = datetime.datetime.now() 
  dtnow = dt.strftime("%Y%m%d_%H_%M_%S")
  unique_name = dtnow + str(uuid.uuid4().hex)
  num_riders_temp_file = tmpdir + "num_riders_" + unique_name + ".csv"
  model_scores_temp_file  = tmpdir + "scores_" + unique_name + ".json"

  # Read STDIN
 
  lines = inlines.readlines()
  
  # For each line in STDIN pass number of riders to ML inference to generate model score 

  for i in range(len(lines)):

          # Extract from STDIN num_riders from the current line

          num_riders = float(lines[i][20:]);

          # Write num_riders to temporary work file overwriting previous value if exists

          with open(num_riders_temp_file, "w+") as f1:
              num_riders_data = f1.read()
          with open(num_riders_temp_file, "w") as f1:
              f1.write(str(num_riders)[:-2])
          f1.close()
          
          # Call Sagemaker API endpoint to generate ML score
          #     Payload for ML Inference call can be found in num_riders_temp_file
          #     Output of ML Inference call is placed in model_scores_temp_file

          cmd = 'aws sagemaker-runtime invoke-endpoint --endpoint-name ' + model_name + '  --region ' + aws_region + ' --body file://' + num_riders_temp_file + ' --content-type "text/csv" ' + model_scores_temp_file
          so = os.popen(cmd).read()

          # Open ML output file and extract score

          with open(model_scores_temp_file, "r") as f2:
              score_file_data = f2.read()
          score = float(score_file_data[20:27])
          f2.close()

          # Add ML score to end of current STDIN line

          lines[i] = lines[i].replace('\n','') + ',' + str(score)
      
  return lines


def main():
    # For each event, add derived ML score to end of STDIN, line by line.
    #   Read each line from STDIN
    #      Extract num_riders
    #      Call ML Model API endpoint to generate score
    #      Add derived ML score to current STDIN line
    #           Each line of STDIN batch starts as "timestamp, num_riders\n"
    #           Each line of STDIN become "timestamp, num_riders, score" 
    
    # Create a temporary working directory if it does not already exit
    if not os.path.exists(tmpdir):
       os.mkdir(tmpdir, 0755 );

    # Add AWS Credentials which will be used by memsql id from inside memsql cluster nodes
    os.environ["AWS_ACCESS_KEY_ID"] = "<INSERT AWS ACCESS KEY ID>"
    os.environ["AWS_SECRET_ACCESS_KEY"] = "<INSERT AWS SECRET ACCESS KEY>"
    os.environ["AWS_SECURITY_TOKEN"] = "<INSERT AWS SECURITY TOKEN>"

    # Execute read_in procedure which reads in and processes STDIN
    lines = read_in()

    # Write each line from STDIN to STDOUT
    for i in range(len(lines)):
         # Add new line to each STDOUT line
         outlines.write(lines[i] + '\n');

if __name__ == '__main__':
    main()

