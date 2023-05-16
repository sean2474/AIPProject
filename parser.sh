#!/bin/bash

cd `pwd`/server/SportDataParser
python main.py
cd ..
cd FoodMenuParser
python main.py
cd ../../