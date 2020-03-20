FROM centos:7

MAINTAINER Daniel Standage <daniel.standage@nbacc.dhs.gov>

ENV LANG=en_US.UTF-8
ENV PATH /opt/conda/bin:$PATH

# System package setup
RUN yum -y update
RUN yum install -y wget bzip2 git gzip less tar gcc gcc-c++ kernel-devel make which file
RUN yum install -y epel-release && yum -y update && yum install -y singularity-runtime singularity

# Conda setup
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh && \
    /bin/bash Anaconda3-2020.02-Linux-x86_64.sh -b -p /opt/conda && \
    conda init bash && \
    conda update -n base conda && \
    conda create --name ci python=3.7
ADD ./default.condarc /opt/conda/.condarc

# Build Singularity base image
ADD ./base.def /opt/singularity/base.def
RUN singularity build --force /opt/singularity/base.sif /opt/singularity/base.def
RUN mv Anaconda3-2020.02-Linux-x86_64.sh /opt/conda/

CMD /bin/bash
