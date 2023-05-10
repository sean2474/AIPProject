#!/bin/bash

cd `pwd`/server/foodParser
python main.py
cd ..
cd SportsParser
python main.py
cd ../../