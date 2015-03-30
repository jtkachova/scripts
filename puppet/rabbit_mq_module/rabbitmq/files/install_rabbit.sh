#!/bin/bash
echo "deb http://www.rabbitmq.com/debian/ testing main" >> /etc/apt/sources.list
cd /home
wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
apt-key add rabbitmq-signing-key-public.asc
apt-get update

