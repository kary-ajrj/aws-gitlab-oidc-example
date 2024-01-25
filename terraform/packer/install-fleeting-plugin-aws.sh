#!/bin/bash

sudo su -
wget https://gitlab.com/gitlab-org/fleeting/fleeting-plugin-aws/-/releases/v0.4.0/downloads/fleeting-plugin-aws-linux-amd64
mv fleeting-plugin-aws-linux-amd64 fleeting-plugin-aws
chmod 744 fleeting-plugin-aws
sudo mv fleeting-plugin-aws /usr/local/bin/
