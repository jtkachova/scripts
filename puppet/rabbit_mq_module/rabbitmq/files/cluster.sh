#!/bin/bash
rabbitmqctl stop_app
rabbitmqctl join_cluster --ram rabbit@rabbit1
rabbitmqctl start_app
