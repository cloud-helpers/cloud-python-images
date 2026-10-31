#
# Source: https://github.com/cloud-helpers/cloud-python/tree/main/cloud-python/Dockerfile
# On Docker Hub: https://hub.docker.com/repository/docker/infrahelpers/cloud-python/general
# Usual Docker tag: py${PYTHON_MINOR_VERSION}-${DEBIAN_RELEASE} (infrahelpers/cloud-python:py${PYTHON_MINOR_VERSION}-${DEBIAN_RELEASE})
#

# See also:
# * Python ${PYTHON_MINOR_VERSION} Debian ${DEBIAN_RELEASE}:
#   * Image on Docker Hub/Cloud: https://hub.docker.com/_/python?tab=tags&page=1&name=3.12-trixie
#   * Dockerfile: https://github.com/docker-library/python/blob/master/3.12/trixie/Dockerfile
# * The best Docker base image for your Python application, June 2023:
#   https://pythonspeed.com/articles/base-image-python-docker-images/
# * General purpose Debian C++/Python development image:
#   * Docker Hub: https://hub.docker.com/repository/docker/infrahelpers/cpppython/general
#   * Dockerfile: https://github.com/cpp-projects-showcase/docker-images/tree/main/debian13
# * Data processing pipeline (DPP), using Python light based on Debian:
#   * Docker Hub: https://hub.docker.com/repository/docker/infrahelpers/dpp/general
#   * Dockerfile: https://github.com/data-engineering-helpers/dpp-images/blob/main/python-slim/Dockerfile
#
# Base image: Debian-based slim Python
# * Docker Hub:
#   * General: https://hub.docker.com/_/python
#   * Python 3.11 Trixie: https://hub.docker.com/layers/library/python/3.11-slim-trixie
# * Dockerfile:
#  * General: https://github.com/docker-library/python
#  * Python 3.11 Trixie: https://github.com/docker-library/python/blob/master/3.11/slim-trixie/Dockerfile
#
# Debian releases: https://www.debian.org/releases/
#
ARG DEBIAN_RELEASE="trixie"
ARG PYTHON_MINOR_VERSION="3.12"
FROM python:${PYTHON_MINOR_VERSION}-slim-${DEBIAN_RELEASE}

LABEL authors="Denis Arnaud <denis.arnaud_fedora@m4x.org>"

# https://docs.docker.com/reference/dockerfile/#understand-how-arg-and-from-interact
ARG DEBIAN_RELEASE
ARG PYTHON_MINOR_VERSION

# Environment

## General
ENV container="docker"
ENV HOME="/root"

## Locales
ENV LANGUAGE="en_US:en"
ENV LANG="en_US.UTF-8"
ENV LANG4GEN="en_US.utf8"
ENV LC_ALL="en_US.UTF-8"

## SOCI (https://github.com/SOCI/soci)
ENV DEF_SOCI_VER="4.1.4"

## Oracle - Check https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html
ENV ORCL_CLT_VER_MAJOR="23_9"
ENV ORCL_CLT_VER="2390000"
ENV ORCL_CLT_VER_FULL="23.9.0.25.07"
ENV NLS_LANG=".AL32UTF8"

# Update the system
#RUN echo "Europe/Paris" > /etc/timezone
RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90-yes
RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends \
        apt-transport-https ca-certificates locales tzdata \
	gpg libcap2-bin \
        zip unzip gzip bzip2 xz-utils tar p7zip-full \
        curl wget netcat-traditional net-tools bind9-host \
	procps less htop gawk bash-completion vim-nox emacs-nox keyutils \
	checkinstall lsb-release patch pkg-config jq && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Generate the locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    printf '%s\n' LANG=$LANG LC_ALL=$LC_ALL LANGUAGE=$LANGUAGE \
		   > /etc/default/locale && \
    locale-gen $LANG && \
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
        architecture=$(uname -m|sed 's/x86_/amd/'|sed 's/aarch/arm/') && \
        echo "YQ_VER=${YQ_VER} - architecture=${architecture}" && \
        curl -Ls \
            https://github.com/mikefarah/yq/releases/download/v${YQ_VER}/yq_linux_${architecture} -o /usr/local/bin/yq && \
        chmod +x /usr/local/bin/yq && yq --version

# usql, the universal CLI tool for databases (https://github.com/xo/usql)
RUN USQL_VER=$(curl -Ls https://api.github.com/repos/xo/usql/releases/latest | grep 'tag_name' | cut -d'v' -f2,2 | cut -d'"' -f1,1) && \
        architecture=$(uname -m|sed 's/x86_/amd/'|sed 's/aarch/arm/') && \
        echo "USQL_VER=${USQL_VER} - architecture=${architecture}" && \
        curl -Ls \
        https://github.com/xo/usql/releases/download/v${USQL_VER}/usql-${USQL_VER}-linux-${architecture}.tar.bz2 -o usql.tar.bz2 && \
        tar jxf usql.tar.bz2 && rm -f usql.tar.bz2 LICENSE && \
        mv usql /usr/local/bin/usql && chmod +x /usr/local/bin/usql && usql --version

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

# HashiCorp Vault (https://developer.hashicorp.com/vault/install)
# See also the setcap issue in Docker: https://github.com/hashicorp/vault/issues/10924
RUN deb_release="$(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs)" && \
    architecture="$(dpkg --print-architecture)" && \
    echo "deb_release=${deb_release} - architecture=${architecture}" && \
    wget -O - https://apt.releases.hashicorp.com/gpg | \
    	 gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [arch=${architecture} signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com ${deb_release} main" | \
    	 tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get -qq update && apt-get -y install vault && \
    chmod +x /usr/bin/vault && setcap -r /usr/bin/vault && vault --version && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# SOCI (https://github.com/SOCI/soci)
RUN mkdir -p /opt/soci
RUN SOCI_JSON=$(curl -Ls https://api.github.com/repos/SOCI/soci/tags) && \
    SOCI_VER=$(echo "$SOCI_JSON" | jq -r ".[].name" 2>/dev/null | grep "^v" | sort -r | head -1 | cut -d"v" -f2,2 || true); \
    if [ -z "${SOCI_VER}" ]; then \
      echo "Warning: Could not determine SOCI version from GitHub, using default one (${DEF_SOCI_VER})"; \
      SOCI_VER="${DEF_SOCI_VER}"; \
    fi && \
	curl -Ls "https://github.com/SOCI/soci/archive/refs/tags/v${SOCI_VER}.tar.gz" \
	  -o /opt/soci/soci-${SOCI_VER}.tar.gz && cd /opt/soci && \
	tar zxf soci-${SOCI_VER}.tar.gz && rm -f soci-${SOCI_VER}.tar.gz && \
	cd soci-${SOCI_VER} && mkdir -p build && cd build && \
	cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
	  -DSOCI_TESTS=OFF .. && \
    make install

# Oracle instant clients: https://www.oracle.com/database/technologies/instant-client/downloads.html
# * Linux AMD64: https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html
# * Linux ARM4 (aarch64): https://www.oracle.com/database/technologies/instant-client/linux-arm-aarch64-downloads.html
RUN mkdir -p /opt/oracle/archives && \
	architecture=$(uname -m|sed 's/x86_/x/'|sed 's/aarch/arm/') && \
    echo "ORCL_CLT_VER=${ORCL_CLT_VER} - ORCL_CLT_VER_FULL=${ORCL_CLT_VER_FULL} - architecture=${architecture}" && \
    curl -kLs https://download.oracle.com/otn_software/linux/instantclient/${ORCL_CLT_VER}/instantclient-basic-linux.${architecture}-${ORCL_CLT_VER_FULL}.zip \
          -o /opt/oracle/archives/instantclient-basic-linux.${architecture}-${ORCL_CLT_VER_FULL}.zip && \
    curl -kLs https://download.oracle.com/otn_software/linux/instantclient/${ORCL_CLT_VER}/instantclient-sqlplus-linux.${architecture}-${ORCL_CLT_VER_FULL}.zip \
         -o /opt/oracle/archives/instantclient-sqlplus-linux.${architecture}-${ORCL_CLT_VER_FULL}.zip && \
    curl -kLs https://download.oracle.com/otn_software/linux/instantclient/${ORCL_CLT_VER}/instantclient-sdk-linux.${architecture}-${ORCL_CLT_VER_FULL}.zip \
         -o /opt/oracle/archives/instantclient-sdk-linux.${architecture}-${ORCL_CLT_VER_FULL}.zip && \
    curl -kLs https://download.oracle.com/otn_software/linux/instantclient/${ORCL_CLT_VER}/instantclient-jdbc-linux.${architecture}-${ORCL_CLT_VER_FULL}.zip \
         -o /opt/oracle/archives/instantclient-jdbc-linux.${architecture}-${ORCL_CLT_VER_FULL}.zip && \
    curl -kLs https://download.oracle.com/otn_software/linux/instantclient/${ORCL_CLT_VER}/instantclient-odbc-linux.${architecture}-${ORCL_CLT_VER_FULL}.zip \
         -o /opt/oracle/archives/instantclient-odbc-linux.${architecture}-${ORCL_CLT_VER_FULL}.zip && \
    curl -kLs https://download.oracle.com/otn_software/linux/instantclient/${ORCL_CLT_VER}/instantclient-tools-linux.${architecture}-${ORCL_CLT_VER_FULL}.zip \
	-o /opt/oracle/archives/instantclient-tools-linux.${architecture}-${ORCL_CLT_VER_FULL}.zip && \
	for zipfile in /opt/oracle/archives/*.zip; do \
	echo "zipfile: ${zipfile}" && \
	unzip -o -q ${zipfile} -d /opt/oracle && rm -f ${zipfile}; done

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
#RUN python -mpip install -U numpy pandas pandas-datareader
#RUN python -mpip install -U scikit-learn
#RUN python -mpip install -U matplotlib seaborn
#RUN python -mpip install -U dash connexion requests
#RUN python -mpip install -U flask flask_restful
#RUN python -mpip install -U fastapi
RUN python -mpip install -U ipython
RUN python -mpip install -U jupyterlab
RUN python -mpip install -U opentraveldata OpenTrepWrapper Neobase
#RUN python -mpip install -U elasticsearch kafka-python
#RUN python -mpip install -U psycopg
#RUN python -mpip install -U boto3 awsume
#RUN python -mpip install -U databricks-cli
#RUN python -mpip install -U azure-cli

#
CMD ["/bin/bash"]

