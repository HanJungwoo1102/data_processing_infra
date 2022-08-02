#!/bin/bash
echo "#[START]========================================================================"
sudo yum update -y

echo "#[CLOUD WATCH]=================================================================="
wget https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py
wget https://s3.amazonaws.com/aws-codedeploy-us-east-1/cloudwatch/codedeploy_logs.conf
chmod +x ./awslogs-agent-setup.py
python awslogs-agent-setup.py -n -r ap-northeast-2 -c s3://aws-codedeploy-ap-northeast-2/cloudwatch/awslogs.conf
mkdir -p /var/awslogs/etc/config
cp codedeploy_logs.conf /var/awslogs/etc/config/
service awslogs restart

echo "#[Code Deploy]=================================================================="
sudo yum install ruby -y
sudo yum install wget -y
cd /home/ec2-user
wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent status

echo "#[Docker and Docker Compose]===================================================="
sudo yum install docker -y
wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) 
sudo mv docker-compose-$(uname -s)-$(uname -m) /bin/docker-compose
sudo chmod -v +x /bin/docker-compose
sudo systemctl enable docker.service
sudo systemctl start docker.service
