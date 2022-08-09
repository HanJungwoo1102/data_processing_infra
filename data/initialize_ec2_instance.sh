#!/bin/bash
echo "#[START]========================================================================\n"
sudo yum update -y
sudo yum install ruby -y
sudo yum install wget -y

echo "\n#[CLOUD WATCH]==================================================================\n"
echo " "
echo "This for amazon linux ami"
ISSUE_PATH="/etc/issue"
origin_issue=`sudo cat $ISSUE_PATH`
new_issue="Amazon Linux AMI$origin_issue"
sudo rm -rf $ISSUE_PATH
sudo echo $new_issue >> $ISSUE_PATH
sudo cat $ISSUE_PATH
echo " "
echo " "
wget https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py
wget https://s3.amazonaws.com/aws-codedeploy-us-east-1/cloudwatch/codedeploy_logs.conf
chmod +x ./awslogs-agent-setup.py
python awslogs-agent-setup.py -n -r ap-northeast-2 -c s3://aws-codedeploy-us-east-1/cloudwatch/awslogs.conf
mkdir -p /var/awslogs/etc/config
cp codedeploy_logs.conf /var/awslogs/etc/config/
sudo service awslogs restart

echo "\n#[Docker and Docker Compose]====================================================\n"
sudo yum install docker -y
wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) 
sudo mv docker-compose-$(uname -s)-$(uname -m) /bin/docker-compose
sudo chmod -v +x /bin/docker-compose
sudo systemctl enable docker.service
sudo systemctl start docker.service

echo "\n#[Java Install]=================================================================\n"
wget https://download.oracle.com/java/17/archive/jdk-17.0.4_linux-x64_bin.tar.gz
tar xvf jdk-17.0.4_linux-x64_bin.tar.gz
sudo mv jdk-17.0.4 /opt/
sudo tee /etc/profile.d/jdk.sh << EOF
export JAVA_HOME=/opt/jdk-17.0.4
export PATH=\$PATH:\$JAVA_HOME/bin
EOF
source /etc/profile.d/jdk.sh

echo "\n#[Gradle Install]===============================================================\n"
wget https://services.gradle.org/distributions/gradle-7.5-bin.zip
sudo unzip gradle-*.zip -d /opt/gradle
sudo tee /etc/profile.d/gradle.sh << EOF
export GRADLE_HOME=/opt/gradle/gradle-7.5
export PATH=\$PATH:\$GRADLE_HOME/bin
EOF
source /etc/profile.d/gradle.sh

echo "\n#[Git Install]===============================================================\n"
sudo yum install git -y

echo "\n#[Code Deploy]==================================================================\n"
echo "code deploy have to be excuted after code deploy"
cd /home/ec2-user
wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent status
