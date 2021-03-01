#!/bin/bash

bash launch-benchmark.sh
python3 ./generate_html/gen_html_report.py

cp ./index.html /var/www/html/