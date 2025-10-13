#
# Source: https://github.com/cloud-helpers/cloud-python/tree/master/python-3.11-trixie/Dockerfile
# On Docker Hub: https://hub.docker.com/repository/docker/infrahelpers/cloud-python/general
# Usual Docker tag: py311-trixie (infrahelpers/cloud-python:py311-trixie)
#

# See also:
# * Python 3.11 Debian Trixie:
#   + Image on Docker Hub/Cloud: https://hub.docker.com/_/python?tab=tags&page=1&name=3.11-trixie
#   + Dockerfile: https://github.com/docker-library/python/blob/master/3.11/trixie/Dockerfile
# * The best Docker base image for your Python application, June 2023:
#   https://pythonspeed.com/articles/base-image-python-docker-images/
# * General purpose Debian 12 (Trixie) C++/Python development image:
#   + Docker Hub: https://hub.docker.com/repository/docker/infrahelpers/cpppython/general
#   + Dockerfile: https://github.com/cpp-projects-showcase/docker-images/tree/master/debian12
# * Python light based on Debian 12 (Trixie):
#   + Docker Hub: https://hub.docker.com/repository/docker/infrahelpers/python-light/general
#   + Dockerfile: https://github.com/machine-learning-helpers/docker-python-light/blob/master/docker/python-3.11-trixie/Dockerfile
#
FROM python:3.11-trixie

LABEL authors="Denis Arnaud <denis.arnaud_github at m4x dot org>"

# Environment

## General
ENV container="docker"
ENV HOME="/root"

## Locales
ENV LANGUAGE="en_US:en"
ENV LANG="en_US.UTF-8"
ENV LANG4GEN="en_US.utf8"
ENV LC_ALL="en_US.UTF-8"

## Oracle - Check https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html
ENV ORCL_CLT_VER_MAJOR="23_9"
ENV ORCL_CLT_VER="2390000"
ENV ORCL_CLT_VER_FULL="23.9.0.25.07"
ENV NLS_LANG=".AL32UTF8"

# Update the system
#RUN echo "Europe/Paris" > /etc/timezone
RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90-yes
RUN apt-get -qq update && apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends \
	apt-utils apt-transport-https \
	ca-certificates locales locales-all tzdata sudo \
	zip unzip gzip bzip2 xz-utils tar p7zip-full \
	curl wget netcat-traditional net-tools aptitude

# Generate the locales
RUN locale-gen $LANG && \
    update-locale LANG=$LANG LANGUAGE=$LANGUAGE LC_ALL=$LC_ALL

# Configure the time-zone
RUN dpkg-reconfigure -f noninteractive tzdata

# Basic, C++ and Python packages
RUN apt-get -qq update && \
    apt-get -y install procps less htop screen \
	git keychain gettext-base gawk \
	bash-completion vim-nox emacs-nox apt-utils keyutils ftp \
	zlib1g-dev libbz2-dev \
	lsb-release libgmp-dev \
	gcc g++ cppcheck clang cmake manpages patch pkg-config \
	m4 autoconf automake libtool libltdl-dev build-essential \
	flex bison \
	libboost-all-dev libxapian-dev \
	libreadline-dev libncurses5-dev \
	libzmq5-dev libczmq-dev libssl-dev libffi-dev \
	swig graphviz libopenblas-dev
RUN apt-get -y install libmpich-dev libopenmpi-dev \
	sqlite3 libsqlite3-dev \
	mariadb-client default-libmysqlclient-dev \
	postgresql-client \
	libpqxx-dev \
	libicu-dev libprotobuf-dev protobuf-compiler \
	python3 libpython3-dev \
	libgeos++-dev \
	doxygen ghostscript texlive-latex-recommended \
	r-base r-base-dev \
	rake \
	jq

# Dependencies for Azure command-line (CLI)
# Azure - Check https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest
# apt-get -y install gcc libffi-dev libpython3-dev libssl-devel

# Dependencies for Oracle
RUN apt-get -y install libaio1t64 libaio-dev

# Cleaning
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set up the packaging environment for the `build` user
ADD resources/profile $HOME/.profile
ADD resources/bashrc $HOME/.bashrc
ADD resources/gitconfig $HOME/.gitconfig
ADD resources/vimrc $HOME/.vimrc
RUN chmod 640 $HOME/.bashrc $HOME/.gitconfig $HOME/.vimrc

# yq, the YAML CLI utility like jq, for YAML (https://github.com/mikefarah/yq)
RUN YQ_VER=$(curl -Ls https://api.github.com/repos/mikefarah/yq/releases/latest | grep 'tag_name' | cut -d'v' -f2,2 | cut -d'"' -f1,1) && \
	architecture=$(uname -m|sed 's/x86_/amd/') && \
	echo "YQ_VER=${YQ_VER} - architecture=${architecture}" && \
	curl -Ls \
	    https://github.com/mikefarah/yq/releases/download/v${YQ_VER}/yq_linux_${architecture} -o /usr/local/bin/yq && \
	chmod +x /usr/local/bin/yq

# SOCI (https://github.com/SOCI/soci)
RUN mkdir -p /opt/soci
RUN SOCI_VER=$(curl -Ls https://api.github.com/repos/SOCI/soci/tags|jq -r '.[].name'|grep "^v"|sort -r|head -1|cut -d'v' -f2,2) && \
	curl -Ls \
         https://github.com/SOCI/soci/archive/refs/tags/v${SOCI_VER}.tar.gz \
         -o /opt/soci/soci-${SOCI_VER}.tar.gz && cd /opt/soci && \
    tar zxf soci-${SOCI_VER}.tar.gz && rm -f soci-${SOCI_VER}.tar.gz && \
    cd soci-${SOCI_VER} && mkdir -p build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
          -DSOCI_TESTS=OFF .. && \
    make install

# Cloud helpers Shell scripts (https://github.com/cloud-helpers/k8s-job-wrappers)
RUN KJW_VER=$(curl -Ls https://api.github.com/repos/cloud-helpers/k8s-job-wrappers/releases/latest | grep 'tag_name' | cut -d'v' -f2,2 | cut -d'"' -f1,1) && \
        echo "KJW_VER=${KJW_VER}" && \
        curl -Ls \
        https://github.com/cloud-helpers/k8s-job-wrappers/archive/refs/tags/v${KJW_VER}.tar.gz -o k8s-job-wrappers.tar.gz && \
    tar zxf k8s-job-wrappers.tar.gz && rm -f k8s-job-wrappers.tar.gz && \
    mv -f k8s-job-wrappers-${KJW_VER} /usr/local/ && \
    ln -s /usr/local/k8s-job-wrappers-${KJW_VER} /usr/local/k8s-job-wrappers

# AWS: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
RUN architecture=$(uname -m) && \
        echo "architecture=${architecture}" && \
        curl -Ls https://awscli.amazonaws.com/awscli-exe-linux-${architecture}.zip -o awscliv2.zip && \
        unzip -q awscliv2.zip && rm -f awscliv2.zip && \
	./aws/install && aws --version && rm -rf ./aws

# Oracle instant clients
RUN mkdir -p /opt/oracle/archives && \
    curl -L -s https://download.oracle.com/otn_software/linux/instantclient/${ORCL_CLT_VER}/instantclient-basic-linux.x64-${ORCL_CLT_VER_FULL}.zip \
         -o /opt/oracle/archives/instantclient-basic-linux.x64-${ORCL_CLT_VER_FULL}.zip && \
    curl -L -s https://download.oracle.com/otn_software/linux/instantclient/${ORCL_CLT_VER}/instantclient-sqlplus-linux.x64-${ORCL_CLT_VER_FULL}.zip \
         -o /opt/oracle/archives/instantclient-sqlplus-linux.x64-${ORCL_CLT_VER_FULL}.zip && \
    curl -L -s https://download.oracle.com/otn_software/linux/instantclient/${ORCL_CLT_VER}/instantclient-sdk-linux.x64-${ORCL_CLT_VER_FULL}.zip \
         -o /opt/oracle/archives/instantclient-sdk-linux.x64-${ORCL_CLT_VER_FULL}.zip && \
    curl -L -s https://download.oracle.com/otn_software/linux/instantclient/${ORCL_CLT_VER}/instantclient-jdbc-linux.x64-${ORCL_CLT_VER_FULL}.zip \
         -o /opt/oracle/archives/instantclient-jdbc-linux.x64-${ORCL_CLT_VER_FULL}.zip && \
    curl -L -s https://download.oracle.com/otn_software/linux/instantclient/${ORCL_CLT_VER}/instantclient-odbc-linux.x64-${ORCL_CLT_VER_FULL}.zip \
         -o /opt/oracle/archives/instantclient-odbc-linux.x64-${ORCL_CLT_VER_FULL}.zip && \
    curl -L -s https://download.oracle.com/otn_software/linux/instantclient/${ORCL_CLT_VER}/instantclient-tools-linux.x64-${ORCL_CLT_VER_FULL}.zip \
         -o /opt/oracle/archives/instantclient-tools-linux.x64-${ORCL_CLT_VER_FULL}.zip && \
    unzip -q /opt/oracle/archives/instantclient-basic-linux.x64-${ORCL_CLT_VER_FULL}.zip \
          -d /opt/oracle && \
    unzip -q /opt/oracle/archives/instantclient-sqlplus-linux.x64-${ORCL_CLT_VER_FULL}.zip \
          -d /opt/oracle && \
    unzip -q /opt/oracle/archives/instantclient-sdk-linux.x64-${ORCL_CLT_VER_FULL}.zip \
          -d /opt/oracle && \
    unzip -q /opt/oracle/archives/instantclient-jdbc-linux.x64-${ORCL_CLT_VER_FULL}.zip \
          -d /opt/oracle && \
    unzip -q /opt/oracle/archives/instantclient-odbc-linux.x64-${ORCL_CLT_VER_FULL}.zip \
          -d /opt/oracle && \
    unzip -q /opt/oracle/archives/instantclient-tools-linux.x64-${ORCL_CLT_VER_FULL}.zip \
          -d /opt/oracle
# Configure Oracle clients for the root user
RUN echo "" >> /root/.bashrc && \
    echo "# Oracle Instant clients: ${ORCL_CLT_VER_FULL}" >> /root/.bashrc && \
    echo "export PATH=\"\${PATH}:/opt/oracle/instantclient_${ORCL_CLT_VER_MAJOR}\"" >> /root/.bashrc && \
    echo "export LD_LIBRARY_PATH=\"\${LD_LIBRARY_PATH}:/opt/oracle/instantclient_${ORCL_CLT_VER_MAJOR}\"" >> /root/.bashrc

# Git prompt
RUN git clone https://github.com/magicmonty/bash-git-prompt.git \
              $HOME/.bash-git-prompt --depth=1

# Install a few Python modules for data science
WORKDIR $HOME
RUN python -mpip install -U pip
RUN python -mpip install -U psutil dill joblib
RUN python -mpip install -U setuptools wheel build scikit-build
RUN python -mpip install -U pytest tox twine
#RUN python -mpip install -U pyjq pyyaml
RUN python -mpip install -U numpy pandas pandas-datareader
RUN python -mpip install -U scikit-learn
RUN python -mpip install -U matplotlib seaborn
RUN python -mpip install -U dash connexion requests
RUN python -mpip install -U flask flask_restful
RUN python -mpip install -U fastapi
RUN python -mpip install -U ipython
RUN python -mpip install -U jupyterlab
RUN python -mpip install -U opentraveldata OpenTrepWrapper Neobase
RUN python -mpip install -U elasticsearch kafka-python
RUN python -mpip install -U psycopg2
RUN python -mpip install -U boto3 awsume
RUN python -mpip install -U databricks-cli
RUN python -mpip install -U azure-cli

#
CMD ["/bin/bash"]

