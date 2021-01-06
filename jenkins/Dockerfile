FROM jenkins/jenkins

USER root

ARG uid=1000
ARG gid=1000

RUN usermod -u ${uid} -g ${gid} jenkins \
 && chown -R jenkins ${REF}

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
 && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
 && add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable" \
 && apt-get update \
 && apt-get install -y docker-ce-cli \
 && rm -fr /var/lib/apt/lists/*

USER jenkins

COPY plugins.txt ${REF}/init.groovy.d/plugins.txt
RUN install-plugins.sh < ${REF}/init.groovy.d/plugins.txt

WORKDIR $JENKINS_HOME
