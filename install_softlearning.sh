#!/bin/bash

git clone https://github.com/rail-berkeley/softlearning.git
cd softlearning
conda env create -f environment.yml
conda activate softlearning
pip install -e .