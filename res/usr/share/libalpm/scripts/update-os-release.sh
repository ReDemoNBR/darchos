#!/bin/bash

cp --force /etc/darchos/os-release /usr/lib/os-release
ln --symbolic --force /usr/lib/os-release /etc/os-release