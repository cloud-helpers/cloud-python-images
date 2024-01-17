Container images focusing on Python tasks in the cloud
======================================================

[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/infrahelpers/cloud-python)](https://hub.docker.com/repository/docker/infrahelpers/cloud-python/general)

# Overview
[That project](https://github.com/cloud-helpers/cloud-python-images)
produces [OCI](https://opencontainers.org/)
[(Docker-compliant) images](https://hub.docker.com/repository/docker/infrahelpers/cloud-python/tags),
which provide Python environments, ready to use and to be deployed on the
cloud, be it private or public (_e.g._, AWS, Azure, GCP).
These images are based on the
[latest Python-ready Linux distributions](https://hub.docker.com/_/python).

As well explained in
[a PythonSpeed article from June 2023](https://pythonspeed.com/articles/base-image-python-docker-images/),
the best light images for Python production operations are based on Debian
(the latest stable release being, as of end-2023,
[Debian 12, also known as Bookworm](https://www.debian.org/releases/bookworm/)).

These Python OCI images are aimed at deploying Data Science applications
on operational environments such as cloud-based Kubernetes
clusters or services (_e.g._,
[AWS EKS](https://aws.amazon.com/eks),
[Azure AKS](https://azure.microsoft.com/en-us/services/kubernetes-service/),
[IBM/RedHat OpenShift v4](https://www.redhat.com/en/openshift-4) or
[Google GKE](https://cloud.google.com/kubernetes-engine)).
Examples of Python deployments are API applications, typically with one
of [Flask](https://flask.palletsprojects.com/),
[FastAPI](https://fastapi.tiangolo.com/)
or [WSGI](https://en.wikipedia.org/wiki/Web_Server_Gateway_Interface).

The author of this repository also maintains Data Science Python OCI images
for every day development purposes in a
[dedicated GitHub repository](https://github.com/machine-learning-helpers/docker-python-jupyter/)
and
[Docker Hub space](https://hub.docker.com/repository/docker/artificialintelligence/python-jupyter).
Thanks to
[Docker multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/),
one can easily have in the same Docker specification files two images, one for
every day data science work, and the other one to deploy the corresponding
applications onto production environments.

The Docker images of this repository just add various utilities to make it
work out of the box with databases (_e.g._, Oracle, MySQL/MariaDB, PostgreSQL)
cloud vendors (_e.g._, Azure and AWS command-line utilities) and cloud-native
tools (_e.g._, Pachyderm), on top of the native images
maintained by the
[Docker Python project](https://github.com/docker-library/python)
* [Python 3.12](https://github.com/docker-library/python/tree/master/3.12/)
  + [Python 3.12 - Debian Bookworm](https://github.com/docker-library/python/tree/master/3.12/bookworm)
* [Python 3.11](https://github.com/docker-library/python/tree/master/3.11/)
  + [Python 3.11 - Debian Bookworm](https://github.com/docker-library/python/tree/master/3.11/bookworm)
* [Python 3.10](https://github.com/docker-library/python/tree/master/3.10/)
  + [Python 3.10 - Debian Bookworm](https://github.com/docker-library/python/tree/master/3.10/bookworm)
* [Python 3.9](https://github.com/docker-library/python/tree/master/3.9/)
  + [Python 3.9 - Debian Bookworm](https://github.com/docker-library/python/tree/master/3.9/bookworm)
* [Python 3.8](https://github.com/docker-library/python/tree/master/3.8/)
  + [Python 3.8 - Debian Bookworm](https://github.com/docker-library/python/tree/master/3.8/bookworm)

In the OCI image, Python packages are installed by the `pip` utility.
For testing purposes, outside of the container, Python virtual environments
may be installed thanks to Pyenv and `pipenv`, as detailed in the
[dedicated procedure](http://github.com/machine-learning-helpers/induction-python/tree/master/installation/virtual-env)
on the
[Python induction notebook sub-project](http://github.com/machine-learning-helpers/induction-python).

Any additional Python module may be installed either:
* With `pip` and some `requirements.txt` dependency specification file:
```bash
$ python3 -mpip install -r requirements.txt
```
* In a dedicated virtual environment, controlled by `pipenv` through
  local `Pipfile` (and potentially `Pipfile.lock`) files,
  which should be versioned:
```bash
$ pipenv --rm; pipenv install; pipenv install --dev
```

On the other hand, the OCI images install those modules globally.

The Docker images of this repository are intended to run any API applications.

## See also
* [Images on Docker Cloud](https://cloud.docker.com/u/infrahelpers/repository/docker/infrahelpers/cloud-python)
* [Images on Quay.io (TBD)](https://quay.io/repository/infrahelpers/cloud-python)
* General purpose C++ and Python with Debian OCI images:
  + GitHub:
    https://github.com/cpp-projects-showcase/docker-images/tree/master/debian12
  + Docker Cloud:
    https://cloud.docker.com/u/infrahelpers/repository/docker/infrahelpers/cpppython
* General purpose light Python/Debian OCI images:
  + GitHub: https://github.com/machine-learning-helpers/docker-python-light
  + Docker Cloud:
    https://cloud.docker.com/u/infrahelpers/repository/docker/artificialintelligence/python-light
* [Native Python OCI images](https://github.com/docker-library/python):
  + [Python 3.12](https://github.com/docker-library/python/tree/master/3.12)
    - https://github.com/docker-library/python/tree/master/3.12/bookworm
  + [Python 3.11](https://github.com/docker-library/python/tree/master/3.11)
    - https://github.com/docker-library/python/tree/master/3.11/bookworm
  + [Python 3.10](https://github.com/docker-library/python/tree/master/3.10)
    - https://github.com/docker-library/python/tree/master/3.10/bookworm
  + [Python 3.9](https://github.com/docker-library/python/tree/master/3.9)
    - https://github.com/docker-library/python/tree/master/3.9/bookworm
  + [Python 3.8](https://github.com/docker-library/python/tree/master/3.8)
    - https://github.com/docker-library/python/tree/master/3.8/bookworm
* [Debian releases](https://wiki.debian.org/DebianReleases)
  + [Debian 12 Bookworm](https://wiki.debian.org/DebianBookworm)

# Simple use
* Download the Docker image:
```bash
$ docker pull infrahelpers/cloud-python
```

* Launch Dash or Flask within the Docker image (where `<port>` corresponds
  to the local port on which Dash or Flask is launched; the default is `8050`):
```bash
$ docker run -it infrahelpers/cloud-python
```

# Build your own container image
* Clone the
  [Git repository](https://github.com/cloud-helpers/cloud-python):
```bash
$ mkdir -p ~/dev/infra && cd ~/dev/infra
$ git clone https://github.com/cloud-helpers/cloud-python.git
$ cd cloud-python
```

* Build the OCI images (here with Docker, but any other tool may be used):
  + Python 3.12
    - `py312-bookworm` tag: Debian Bookworm / Python 3.12:
```bash
$ docker build -t infrahelpers/cloud-python:py312-bookworm python-3.12-bookworm
```
  + Python 3.11
    - `py311-bookworm` tag: Debian Bookworm / Python 3.11:
```bash
$ docker build -t infrahelpers/cloud-python:py311-bookworm python-3.11-bookworm
```
  + Python 3.10
    - `py310-bookworm` tag: Debian Bookworm / Python 3.10:
```bash
$ docker build -t infrahelpers/cloud-python:py310-bookworm python-3.10-bookworm
```
  + Python 3.9
    - `py39-bookworm` tag: Debian Bookworm / Python 3.9:
```bash
$ docker build -t infrahelpers/cloud-python:py39-bookworm python-3.9-bookworm
```
  + Python 3.8
    - `py38-bookworm` tag: Debian Bookworm / Python 3.8:
```bash
$ docker build -t infrahelpers/cloud-python:py38-bookworm python-3.8-bookworm
```

* Deprecated. Use images for Data Processing Pipelines (DPP) instead
  ([DPP images on Docker Hub](https://hub.docker.com/repository/docker/infrahelpers/dpp/general)
  and
  [DPP images on GitHub](https://github.com/data-engineering-helpers/dpp-images))
  + Amazon Linux 2 for Elastic Map Reduce (EMR) 6 (system Python 3.7.15)
    and DataBricks (PyEnv-based Python 3.8), with JDK 8:
```bash
$ docker build -t infrahelpers/cloud-python:pyspark-emr-dbs pyspark-corretto-8-emr-dbs
```
  + Amazon Linux 2 for Elastic Map Reduce (EMR) 6, Python 3.7.15, with JDK 8:
```bash
$ docker build -t infrahelpers/cloud-python:pyspark-emr6 pyspark-emr-6-corretto-8
```
  + Amazon Linux 2 for Elastic Map Reduce (EMR) 6, Python 3.7.10,
    lighter image, with JDK 8:
```bash
$ docker build -t infrahelpers/cloud-python:pyspark-emr6-light pyspark-emr-6-corretto-8-light
```
  + [WIP] Amazon Linux 2 for Elastic Map Reduce (EMR), usually with
    Python 3.7.15 (as of end 2022), with JDK 11:
```bash
$ docker build -t infrahelpers/cloud-python:pyspark-emr-jdk11 pyspark-emr-corretto-11
```

* In addition to what the Docker Hub builds, the CI/CD (GitHub Actions)
  pipeline also builds the
  `infrahelpers/cloud-python:pyspark-emr-6-light-multi-platform` image,
  from the `pyspark-emr-6-corretto-11-light/` directory,
  on two CPU architectures, namely the classical AMD64 and the newer ARM64

* (Optional) Push the newly built images to Docker Hub.
  That step is usually not needed, as the images are automatically
  built everytime there is
  [a change on GitHub](https://github.com/cloud-helpers/cloud-python/commits/master))
```bash
$ docker login
$ docker push infrahelpers/cloud-python:pyspark-emr-dbs
$ docker push infrahelpers/cloud-python:pyspark-emr-jdk11
$ docker push infrahelpers/cloud-python:pyspark-emr6
$ docker push infrahelpers/cloud-python:pyspark-emr6-light
$ docker push infrahelpers/cloud-python:py311-bookworm
$ docker push infrahelpers/cloud-python:py310-bookworm
$ docker push infrahelpers/cloud-python:py39-bookworm
$ docker push infrahelpers/cloud-python:py38-bookworm
```

* Choose which image should be the latest, tag it and upload it to Docker Hub:
```bash
$ docker push infrahelpers/cloud-python:py311-bookworm
```

* (Optional) Push the newly built images to Quay.io.
  That step is usually not needed, as the images are automatically
  built everytime there is
  [a change on GitHub](https://github.com/cloud-helpers/cloud-python-images/commits/master))
	+ Login to Quay:
```bash
$ docker login quay.io
```
	+ Python 3.12:
```bash
$ docker tag infrahelpers/cloud-python:py312-bookworm quay.io/infrahelpers/cloud-python:py312-bookworm
$ docker push quay.io/infrahelpers/cloud-python:py312-bookworm
```
	+ Python 3.11:
```bash
$ docker tag infrahelpers/cloud-python:py311-bookworm quay.io/infrahelpers/cloud-python:py311-bookworm
$ docker push quay.io/infrahelpers/cloud-python:py311-bookworm
```
	+ Python 3.10:
```bash
$ docker tag infrahelpers/cloud-python:py310-bookworm quay.io/infrahelpers/cloud-python:py310-bookworm
$ docker push quay.io/infrahelpers/cloud-python:py310-bookworm
```
	+ Python 3.9:
```bash
$ docker tag infrahelpers/cloud-python:py39-bookworm quay.io/infrahelpers/cloud-python:py39-bookworm
$ docker push quay.io/infrahelpers/cloud-python:py39-bookworm
```
	+ Python 3.8:
```bash
$ docker tag infrahelpers/cloud-python:py38-bookworm quay.io/infrahelpers/cloud-python:py38-bookworm
$ docker push quay.io/infrahelpers/cloud-python:py38-bookworm
```

* Shutdown the Docker image
```bash
$ docker ps
CONTAINER ID IMAGE                    COMMAND                   CREATED        STATUS        PORTS                  NAMES
7b69efc9dc9a ai/cloud-python        "/bin/sh -c 'python …"    48 seconds ago Up 47 seconds 0.0.0.0:9000->8050/tcp vigilant_merkle
$ docker kill vigilant_merkle
vigilant_merkle
$ docker ps
CONTAINER ID IMAGE                    COMMAND                   CREATED        STATUS        PORTS                  NAMES
```

