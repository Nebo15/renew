#!/bin/bash

echo "[{ rabbit, [ {loopback_users, []}, {listeners, [ {amqp,5672,\"0.0.0.0\"} ]} ] }]." >> /etc/rabbitmq/rabbitmq.config

service rabbitmq-server stop
service rabbitmq-server start
