#!/bin/bash
apt update -y
apt install python3 -y
apt install python3-pip -y
echo "print('Backend VM Running')" > /home/azureadmin/app.py