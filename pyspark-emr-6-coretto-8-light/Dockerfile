#
# Source: https://github.com/cloud-helpers/cloud-python/tree/main/pyspark-emr-6-coretto-8-light/Dockerfile
# On Docker Hub: https://hub.docker.com/repository/docker/infrahelpers/cloud-python/general
# Usual Docker tag: pyspark-emr6-light (infrahelpers/cloud-python:pyspark-emr6-light)
#
# Inspired by: https://aws.amazon.com/blogs/big-data/simplify-your-spark-dependency-management-with-docker-in-emr-6-0-0
#
# See also:
#  + https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/what-is-corretto-8.html
#  + https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/docker-install.html
# The underlying operating system (OS) is Amazon Linux 2, i.e., based on a
# RedHat Linux 7 with some Amazon specific additions.
# Note that, up to at least version 6.4.0 of EMR, only Java 8 is supported.
# With Java 11+, it generates errors like https://confluence.atlassian.com/confkb/unrecognized-jvm-gc-options-when-using-java-11-1002472841.html
#
FROM amazoncorretto:8

LABEL authors "Denis Arnaud <denis.arnaud_fedora@m4x.org>"

# Environment
ENV container="docker"
ENV HOME="/root"

# Update the OS and install a few packages useful for software development
# (needed for some Python modules like SHAP)
RUN yum -y update && \
	yum -y install yum-utils && \
	yum -y groupinstall development && \
	yum clean all

# Install a few more utilities
RUN yum -y install procps less htop net-tools hostname which sudo man vim git \
	wget curl file bash-completion keyutils zlib-devel bzip2-devel gzip tar \
	autoconf automake libtool m4 \
	gcc gcc-c++ cmake cmake3 libffi-devel \
	readline-devel sqlite-devel python3-devel jq && \
	yum clean all

#
WORKDIR /root
RUN echo "alias dir='ls -laFh'" >> /root/.bashrc

# Cloud helpers Shell scripts (https://github.com/cloud-helpers/k8s-job-wrappers)
RUN KJW_VER=$(curl -Ls https://api.github.com/repos/cloud-helpers/k8s-job-wrappers/tags|jq -r '.[].name'|grep "^v"|sort -r|head -1|cut -d'v' -f2,2) && \
	curl -Ls \
	  https://github.com/cloud-helpers/k8s-job-wrappers/archive/refs/tags/v${KJW_VER}.tar.gz \
         -o k8s-job-wrappers.tar.gz && \
    tar zxf k8s-job-wrappers.tar.gz && rm -f k8s-job-wrappers.tar.gz && \
    mv -f k8s-job-wrappers-${KJW_VER} /usr/local/ && \
    ln -s /usr/local/k8s-job-wrappers-${KJW_VER} /usr/local/k8s-job-wrappers

# AWS: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
RUN curl -Ls https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
         -o awscliv2.zip && \
    unzip -q awscliv2.zip && rm -f awscliv2.zip && ./aws/install && \
	rm -rf ./aws

# SAML-to-AWS (saml2aws)
# https://github.com/Versent/saml2aws
RUN SAML2AWS_VER=$(curl -Ls https://api.github.com/repos/Versent/saml2aws/releases/latest | grep 'tag_name' | cut -d'v' -f2 | cut -d'"' -f1) && \
	curl -Ls \
	https://github.com/Versent/saml2aws/releases/download/v${SAML2AWS_VER}/saml2aws_${SAML2AWS_VER}_linux_amd64.tar.gz -o saml2aws.tar.gz && \
	tar zxf saml2aws.tar.gz && rm -f saml2aws.tar.gz README.md LICENSE.md && \
	mv -f saml2aws /usr/local/bin/ && \
    chmod 775 /usr/local/bin/saml2aws

# Install Python
#RUN yum list python3*
RUN yum -y install python3 python3-dev python3-pip python3-virtualenv && \
	yum clean all

# Check the version of Python
RUN python -V && python3 -V

#
ENV PYSPARK_DRIVER_PYTHON python3
ENV PYSPARK_PYTHON python3

# Update pip
RUN python3 -mpip install -U pip
