#
# Source: https://github.com/cloud-helpers/cloud-python/tree/main/pyspark-coretto-8-emr-dbs/Dockerfile
# On Docker Hub: https://hub.docker.com/repository/docker/infrahelpers/cloud-python/general
# Usual Docker tag: pyspark-emr-dbs (infrahelpers/cloud-python:pyspark-emr-dbs)
#
# Inspired by:
# * EMR: https://aws.amazon.com/blogs/big-data/simplify-your-spark-dependency-management-with-docker-in-emr-6-0-0
# * DataBricks: https://github.com/databricks/containers
#
# AWS Coretto / EMR
# ===================
#  + https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/what-is-corretto-8.html
#  + https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/docker-install.html
# The underlying operating system (OS) is Amazon Linux 2, i.e., based on a
# RedHat Linux 7 with some Amazon specific additions.
# The Python version is 3.7.10, installed with the Linux distribution.
# Note that, up to at least version 6.4.0 of EMR, only Java 8 is supported.
# With Java 11+, it generates errors like https://confluence.atlassian.com/confkb/unrecognized-jvm-gc-options-when-using-java-11-1002472841.html
#
# DataBricks
# ==========
#  + Base image Dockerfile: https://github.com/databricks/containers/tree/master/ubuntu/standard
#  + Base image on Docker Hub: https://hub.docker.com/r/databricksruntime/standard
#     - Usual Docker tag: latest
#
# The underlying operating system (OS) is Ubuntu 18.04 LTS (Bionic Beaver).
# The Python installation is a virtual environment in /databricks/python3,
# and the version is 3.8.0. The main Python (3.8.13) is installed with PyEnv.
#
FROM amazoncorretto:8

LABEL authors "Denis Arnaud <denis.arnaud_fedora@m4x.org>"

# Environment
ENV container="docker"
ENV HOME="/root"
ENV HOMEUSR="/home/ubuntu"
ENV PYVERSION="3.8.15"
ENV PYSPARK_PYTHON="/databricks/python3/bin/python3"
ENV PYSPARK_DRIVER_PYTHON="python3"

# Update the OS and install a few packages useful for software development
# (needed for some Python modules like SHAP)
RUN yum -y update && \
	yum -y install yum-utils && \
	yum -y groupinstall development && \
	yum clean all

# Install a few more utilities, including pre-requisites for Python
RUN yum -y install procps net-tools hostname iproute coreutils \
	openssl-devel less htop passwd which sudo man vim git tar tree \
	wget curl file bash-completion keyutils zlib-devel bzip2-devel gzip \
	autoconf automake libtool m4 gcc gcc-c++ cmake cmake3 libffi-devel \
	readline-devel sqlite-devel jq fuse fuse-libs && \
	yum clean all

# 
RUN yum -y install passwd fuse fuse-libs iproute net-tools procps coreutils \
	gcc openssl-devel gzip bzip2-devel libffi-devel zlib-devel && \
	yum clean all

# System Python (3.7.10)
RUN yum -y install python3 python3-devel python3-pip

#
WORKDIR $HOME

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

# Copy configuration in the user home, for the root user
ADD bashrc $HOME/.bashrc

# Check the version of Python
RUN python -V && python3 -V

# Install a few Python libraries with the system Python (3.7.10)
RUN python3 -mpip install -U pip virtualenv
RUN python3 -mpip install -U six ipython numpy pandas pyarrow matplotlib jinja2
#RUN python3 -mpip install -U awsume pyjq pyyaml seaborn imageio shap \
#	scikit-learn graphviz opentraveldata neobase OpenTrepWrapper vaex dask
#RUN python3 -mpip install -U pytorch-forecasting
#RUN python3 -mpip install pystan==2.19.1.1 fbprophet==0.7.1

# Check that all the Python modules have been successfully installed
RUN python3 -c "import numpy as np; import pandas as pd"
#RUN python3 -c "import shap; import fbprophet; import pytorch_forecasting"

# Python, PyEnv and pipenv (https://www.python.org/downloads/)
RUN git clone --depth 1 https://github.com/pyenv/pyenv.git $HOME/.pyenv
ENV PATH $HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH
RUN pyenv install $PYVERSION && \
    pyenv global $PYVERSION && \
    python3 -mpip install -U pip virtualenv

# Install a few Python libraries with the PyEnv Python ($PYVERSION)
RUN python3 -mpip install -U six ipython numpy pandas pyarrow matplotlib jinja2

# Create an ubuntu user
RUN useradd ubuntu && \
	echo "ubuntu  ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu && \
	chmod 0440 /etc/sudoers.d/ubuntu && \
	mkdir -p /databricks/python3 && chown -R ubuntu:ubuntu /databricks

# Merge of DataBricks specifities (based on Ubuntu)
ENV PATH $HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH
RUN source $HOME/.bashrc && \
	virtualenv -p python3.8 --system-site-packages /databricks/python3 && \
	/databricks/python3/bin/python3 -mpip install -U pip && \
	/databricks/python3/bin/python3 -mpip install -U six ipython numpy pandas \
	pyarrow matplotlib jinja2

# Revert to system Python (3.7.10) for the global environment
RUN pyenv global system

