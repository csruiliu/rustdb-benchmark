#!/bin/bash

bash launch-benchmark.sh
sleep 1
python3 ./generate_html/gen_html_report.py
sleep 1
cp ./index.html /var/www/html/