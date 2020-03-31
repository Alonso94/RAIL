#!/bin/bash

git clone https://github.com/rail-berkeley/softlearning.git
cd softlearning
conda rail create -f environment.yml
conda activate softlearning
pip install -e .