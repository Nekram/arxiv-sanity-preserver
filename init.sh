#!/bin/sh
mongod --fork --logpath /var/log/mongod.log
#mongod --fork --logpath /var/log/mongod.log && sleep 30 && nohup python3 /code/serve.py --prod --port 8000