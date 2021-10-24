#
# Source: https://github.com/cloud-helpers/cloud-python/tree/master/python-3.10-buster/Dockerfile
# On Docker Hub: https://hub.docker.com/repository/docker/infrahelpers/cloud-python/general
# Usual Docker tag: py310-buster (infrahelpers/cloud-python:py310-buster)
#

# See also:
# * Python 3.10 Debian Buster:
#   + Image on Docker Hub/Cloud: https://hub.docker.com/_/python?tab=tags&page=1&name=3.10-buster
#   + Dockerfile: https://github.com/docker-library/python/blob/master/3.10/buster/Dockerfile
# * The best Docker base image for your Python application, Apr. 2020:
#   https://pythonspeed.com/articles/base-image-python-docker-images/
# * General purpose Debian 10 (Buster) C++/Python development image:
#   + Docker Hub: https://cloud.docker.com/u/infrahelpers/repository/docker/infrahelpers/cpppython
#   + Dockerfile: https://github.com/cpp-projects-showcase/docker-images/tree/master/debian10
# * Python light based on Debian 10 (Buster):
#   + Docker Hub: https://cloud.docker.com/u/infrahelpers/repository/docker/artificialintelligence/python-light
#   + Dockerfile: #   + Dockerfile: https://github.com/machine-learning-helpers/docker-python-light/blob/master/docker/python-3.10-buster/Dockerfile
#
FROM python:3.10-buster

LABEL authors "Denis Arnaud <denis.arnaud_fedora@m4x.org>"

# Environment

## General
ENV container "docker"
ENV HOME "/root"
## Locales
ENV LANGUAGE "en_US:en"
ENV LANG "en_US.UTF-8"
ENV LANG4GEN "en_US.utf8"
ENV LC_ALL "en_US.UTF-8"
## Oracle - Check https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html
ENV container docker
ENV ORCL_CLT_VER_MAJOR "21_1"
ENV ORCL_CLT_VER "211000"
ENV ORCL_CLT_VER_FULL "21.1.0.0.0"
ENV NLS_LANG ".AL32UTF8"
# Pachyderm - Check https://github.com/pachyderm/pachyderm/releases
ENV PACH_VER "1.12.5"

# Update the system
#RUN echo "Europe/Paris" > /etc/timezone
RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90-yes
RUN apt-get -qq update
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends \
	apt-utils apt-transport-https \
	ca-certificates locales locales-all tzdata sudo \
	zip unzip gzip bzip2 xz-utils tar p7zip-full \
	curl wget netcat net-tools aptitude

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
	mariadb-client libmariadbclient-dev \
	postgresql-client \
	libpqxx-dev \
	libicu-dev libprotobuf-dev protobuf-compiler \
	python libpython-dev python3 libpython3-dev \
	python3-django libapache2-mod-wsgi-py3 \
	libgeos++-dev \
	doxygen ghostscript texlive-latex-recommended \
	r-base r-base-dev \
	rake \
	jq
# Dependencies for Azure command-line (CLI)
# Azure - Check https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest
# apt-get -y install gcc libffi-dev libpython3-dev libssl-devel

# Dependencies for Oracle
RUN apt-get -y install libaio1 libaio-dev

# Cleaning
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set up the packaging environment for the `build` user
ADD resources/profile $HOME/.profile
ADD resources/bashrc $HOME/.bashrc
ADD resources/gitconfig $HOME/.gitconfig
ADD resources/vimrc $HOME/.vimrc
RUN chmod 640 $HOME/.bashrc $HOME/.gitconfig $HOME/.vimrc

# yq, the YAML CLI utility like jq, for YAML (https://github.com/mikefarah/yq)
RUN YQ_VER=$(curl -Ls https://api.github.com/repos/mikefarah/yq/releases/latest | grep 'tag_name' | cut -d'v' -f2 | cut -d'"' -f1) && \
	curl -Ls \
         https://github.com/mikefarah/yq/releases/download/v${YQ_VER}/yq_linux_amd64 \
         -o /usr/local/bin/yq && \
    chmod 775 /usr/local/bin/yq

# SOCI (https://github.com/SOCI/soci)
RUN mkdir -p /opt/soci
ADD resources/soci-debian-cmake.patch /opt/soci/soci-debian-cmake.patch
RUN SOCI_VER=$(curl -Ls https://api.github.com/repos/SOCI/soci/tags|jq -r '.[].name'|grep "^v"|sort -r|head -1|cut -d'v' -f2,2) && \
	curl -Ls \
         https://github.com/SOCI/soci/archive/refs/tags/v${SOCI_VER}.tar.gz \
         -o /opt/soci/soci-${SOCI_VER}.tar.gz && cd /opt/soci && \
    tar zxf soci-${SOCI_VER}.tar.gz && rm -f soci-${SOCI_VER}.tar.gz && \
    cd soci-${SOCI_VER} && patch -p1 < ../soci-debian-cmake.patch && \
    mkdir -p build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
          -DSOCI_CXX11=ON -DSOCI_TESTS=OFF .. && \
    make install

# AWS: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
RUN curl -L -s \
         https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
         -o awscliv2.zip && \
    unzip -q awscliv2.zip && \
    rm -f awscliv2.zip && \
    ./aws/install

# SAML-to-AWS (saml2aws)
# https://github.com/Versent/saml2aws
RUN SAML2AWS_VER=$(curl -Ls https://api.github.com/repos/Versent/saml2aws/releases/latest | grep 'tag_name' | cut -d'v' -f2 | cut -d'"' -f1) && \
	curl -Ls \
	https://github.com/Versent/saml2aws/releases/download/v${SAML2AWS_VER}/saml2aws_${SAML2AWS_VER}_linux_amd64.tar.gz -o saml2aws.tar.gz && \
	tar zxf saml2aws.tar.gz && rm -f saml2aws.tar.gz README.md LICENSE.md && \
	mv -f saml2aws /usr/local/bin/ && \
    chmod 775 /usr/local/bin/saml2aws

# Pachyderm
RUN curl -Ls \
      https://github.com/pachyderm/pachyderm/releases/download/v${PACH_VER}/pachctl_${PACH_VER}_linux_amd64.tar.gz \
         -o pachctl_${PACH_VER}_linux_amd64.tar.gz && \
    tar zxf pachctl_${PACH_VER}_linux_amd64.tar.gz && \
    mv pachctl_${PACH_VER}_linux_amd64/pachctl /usr/local/bin/ && \
    rm -f pachctl_${PACH_VER}_linux_amd64.tar.gz

# Cloud helpers Shell scripts (https://github.com/cloud-helpers/k8s-job-wrappers)
RUN KJW_VER=$(curl -Ls https://api.github.com/repos/cloud-helpers/k8s-job-wrappers/tags|jq -r '.[].name'|grep "^v"|sort -r|head -1|cut -d'v' -f2,2) && \
	curl -Ls \
	  https://github.com/cloud-helpers/k8s-job-wrappers/archive/refs/tags/v${KJW_VER}.tar.gz \
         -o k8s-job-wrappers.tar.gz && \
    tar zxf k8s-job-wrappers.tar.gz && rm -f k8s-job-wrappers.tar.gz && \
    mv -f k8s-job-wrappers-${KJW_VER} /usr/local/ && \
    ln -s /usr/local/k8s-job-wrappers-${KJW_VER} /usr/local/k8s-job-wrappers

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
RUN python -mpip install -U pyjq pyyaml
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
