FROM jenkins/jenkins:lts
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
RUN mkdir -p /usr/share/jenkins/ref/.ssh && ssh-keyscan -t rsa github.com >> /usr/share/jenkins/ref/.ssh/known_hosts 

