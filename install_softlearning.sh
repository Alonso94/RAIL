#!/bin/bash

git clone https://github.com/rail-berkeley/softlearning.git
cd softlearning
conda RAIL_exp create -f environment.yml
conda activate softlearning
pip install -e .