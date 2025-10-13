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
(the latest stable release being, as of end-2025,
[Debian 13, also known as Trixie](https://www.debian.org/releases/trixie/)).

These Python OCI images are aimed at deploying Data Science applications
on operational environments such as cloud-based Kubernetes
clusters or services (_e.g._,
[AWS EKS](https://aws.amazon.com/eks),
[Azure AKS](https://azure.microsoft.com/en-us/services/kubernetes-service/),
[IBM/RedHat OpenShift v4](https://docs.redhat.com/en/documentation/openshift_container_platform) or
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
* [Python 3.14](https://github.com/docker-library/python/tree/master/3.14/)
  * [Python 3.14 - Debian Trixie](https://github.com/docker-library/python/tree/master/3.14/trixie)
* [Python 3.13](https://github.com/docker-library/python/tree/master/3.13/)
  * [Python 3.13 - Debian Trixie](https://github.com/docker-library/python/tree/master/3.13/trixie)
* [Python 3.12](https://github.com/docker-library/python/tree/master/3.12/)
  * [Python 3.12 - Debian Trixie](https://github.com/docker-library/python/tree/master/3.12/trixie)
* [Python 3.11](https://github.com/docker-library/python/tree/master/3.11/)
  * [Python 3.11 - Debian Trixie](https://github.com/docker-library/python/tree/master/3.11/trixie)

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
  * GitHub:
    https://github.com/cpp-projects-showcase/docker-images/tree/master/debian12
  * Docker Cloud:
    https://cloud.docker.com/u/infrahelpers/repository/docker/infrahelpers/cpppython
* General purpose light Python/Debian OCI images:
  * GitHub: https://github.com/machine-learning-helpers/docker-python-light
  * Docker Cloud:
    https://cloud.docker.com/u/infrahelpers/repository/docker/artificialintelligence/python-light
* [Native Python OCI images](https://github.com/docker-library/python):
  * [Python 3.14](https://github.com/docker-library/python/tree/master/3.14)
    * https://github.com/docker-library/python/tree/master/3.14/trixie
  * [Python 3.13](https://github.com/docker-library/python/tree/master/3.13)
    * https://github.com/docker-library/python/tree/master/3.13/trixie
  * [Python 3.12](https://github.com/docker-library/python/tree/master/3.12)
    * https://github.com/docker-library/python/tree/master/3.12/trixie
  * [Python 3.11](https://github.com/docker-library/python/tree/master/3.11)
    * https://github.com/docker-library/python/tree/master/3.11/trixie
* [Debian releases](https://wiki.debian.org/DebianReleases)
  * [Debian 13 Trixie](https://wiki.debian.org/DebianTrixie)

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
  * Python 3.14 - `py314-trixie` tag: Debian Trixie / Python 3.14:
```bash
$ docker build -t infrahelpers/cloud-python:py314-trixie python-3.14-trixie
```
  * Python 3.13 - `py313-trixie` tag: Debian Trixie / Python 3.13:
```bash
$ docker build -t infrahelpers/cloud-python:py313-trixie python-3.13-trixie
```
  * Python 3.12 - `py312-trixie` tag: Debian Trixie / Python 3.12:
```bash
$ docker build -t infrahelpers/cloud-python:py312-trixie python-3.12-trixie
```
  * Python 3.11 - `py311-trixie` tag: Debian Trixie / Python 3.11:
```bash
$ docker build -t infrahelpers/cloud-python:py311-trixie python-3.11-trixie
```

* Deprecated. Use images for Data Processing Pipelines (DPP) instead
  * [DPP images on Docker Hub](https://hub.docker.com/repository/docker/infrahelpers/dpp/general)
  * [DPP images on GitHub](https://github.com/data-engineering-helpers/dpp-images)

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
$ docker push infrahelpers/cloud-python:py314-trixie
$ docker push infrahelpers/cloud-python:py313-trixie
$ docker push infrahelpers/cloud-python:py312-trixie
$ docker push infrahelpers/cloud-python:py311-trixie
```

* Choose which image should be the latest, tag it and upload it to Docker Hub:
```bash
$ docker push infrahelpers/cloud-python:py314-trixie
```

* (Optional) Push the newly built images to Quay.io.
  That step is usually not needed, as the images are automatically
  built everytime there is
  [a change on GitHub](https://github.com/cloud-helpers/cloud-python-images/commits/master))
	* Login to Quay:
```bash
$ docker login quay.io
```
	* Python 3.14:
```bash
$ docker tag infrahelpers/cloud-python:py314-trixie quay.io/infrahelpers/cloud-python:py314-trixie
$ docker push quay.io/infrahelpers/cloud-python:py314-trixie
```
	* Python 3.13:
```bash
$ docker tag infrahelpers/cloud-python:py313-trixie quay.io/infrahelpers/cloud-python:py313-trixie
$ docker push quay.io/infrahelpers/cloud-python:py313-trixie
```
	* Python 3.12:
```bash
$ docker tag infrahelpers/cloud-python:py312-trixie quay.io/infrahelpers/cloud-python:py312-trixie
$ docker push quay.io/infrahelpers/cloud-python:py312-trixie
```
	* Python 3.11:
```bash
$ docker tag infrahelpers/cloud-python:py311-trixie quay.io/infrahelpers/cloud-python:py311-trixie
$ docker push quay.io/infrahelpers/cloud-python:py311-trixie
```

* Shutdown the Docker image:
```bash
$ docker ps
CONTAINER ID IMAGE                    COMMAND                   CREATED        STATUS        PORTS                  NAMES
7b69efc9dc9a ai/cloud-python        "/bin/sh -c 'python …"    48 seconds ago Up 47 seconds 0.0.0.0:9000->8050/tcp vigilant_merkle
$ docker kill vigilant_merkle
vigilant_merkle
$ docker ps
CONTAINER ID IMAGE                    COMMAND                   CREATED        STATUS        PORTS                  NAMES
```

