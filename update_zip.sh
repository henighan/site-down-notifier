#!/bin/bash
pip install --target ./package -r requirements.txt
cd package
zip -r ../lambda_code.zip .
cd ..
zip -g lambda_code.zip smsme.py
