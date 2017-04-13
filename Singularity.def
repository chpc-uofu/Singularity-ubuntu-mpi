# Defines a Singularity container with IB stack 
#



BootStrap: docker
From: ubuntu:16.10
#Include: rpm2cpio


%runscript


%setup
    # Runs from outside the container during Bootstrap



%post
    # Runs within the container during Bootstrap


    # Install the necessary packages (from repo)
    apt-get update && apt-get install -y --no-install-recommends \
        apt-utils \
        build-essential \
        curl \
        git \
        libopenblas-dev \
        libcurl4-openssl-dev \
        libfreetype6-dev \
        libpng-dev \
        libzmq3-dev \
        python-pip \
        pkg-config \
        python-dev \
        python-setuptools \
        rsync \
        software-properties-common \
        unzip \
        vim \
        zip \
        zlib1g-dev
    apt-get clean

    # Set up some required environment defaults
    #MC issue with locale (LC_ALL, LANGUAGE), to get it right:
    locale-gen "en_US.UTF-8" 
    dpkg-reconfigure locales 
    export LANGUAGE="en_US.UTF-8"
    echo 'LANGUAGE="en_US.UTF-8"' >> /etc/default/locale
    echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale

    # Update to the latest pip (newer than repo)
    pip install --no-cache-dir --upgrade pip
    
    # Install other commonly-needed packages
    pip install --no-cache-dir --upgrade \
        future \
        matplotlib \
        scipy 

    # need to create mount point for home dir
    mkdir /uufs
    mkdir /scratch
    
    # IB stuff, based on https://community.mellanox.com/docs/DOC-2431
    apt-get install -y dkms infiniband-diags libibverbs* ibacm librdmacm* libmlx4* libmlx5* mstflint libibcm.* libibmad.* libibumad* opensm srptools libmlx4-dev librdmacm-dev rdmacm-utils ibverbs-utils perftest vlan ibutils
    apt-get install -y libtool autoconf automake build-essential ibutils ibverbs-utils rdmacm-utils infiniband-diags perftest librdmacm-dev libibverbs-dev libmlx4-1 numactl libnuma-dev autoconf automake gcc g++ git libtool pkg-config
    apt-get install -y libnl-3-200 libnl-route-3-200 libnl-route-3-dev libnl-utils

    # git, wget
    apt-get install -y git wget

    # path to mlx IB libraries in Ubuntu
    echo "export LD_LIBRARY_PATH=/usr/lib/libibverbs:$LD_LIBRARY_PATH" >> /environment

    # LMod
    apt-get install -y liblua5.1-0 liblua5.1-0-dev lua-filesystem-dev lua-filesystem lua-posix-dev lua-posix lua5.1

#   Singularity inherits hosts environment = all LMod environment variables
#   to get LMod in the container, we have to build it using the container
#   in the sys branch, and then user has to have this in ~/.custom.sh
#   make sure the lines below are at the end of ~/.custom.sh, otherwise the %test section will fail
#export OSVER=`lsb_release -r | awk '{ print $2; }'`
#export OSREL=`lsb_release -i | awk '{ print $3; }'`
#
#if [ -n "$SINGULARITY_CONTAINER" ] && [ -n "$SINGULARITY_MOD" ]; then
#  if [ $OSREL == "CentOS" ]; then # assume only CentOS7
#    source /uufs/chpc.utah.edu/sys/installdir/lmod/7.1.6-c7/init/bash
#  elif [ $OSREL == "Ubuntu" ]; then # assume only Ubuntu 16
#    source /uufs/chpc.utah.edu/sys/modulefiles/scripts/clear_lmod.sh
#    source /uufs/chpc.utah.edu/sys/installdir/lmod/7.4-u16/init/profile
#  fi
#fi
    echo "
export SINGULARITY_MOD=1
    " >> /environment
%test
    # Sanity check that the container is operating
    # none of this will work because sys branch is not bound at bootstrap
#    /uufs/chpc.utah.edu/sys/installdir/intel/compilers_and_libraries_2017.0.098/linux/mpi/intel64/bin/mpirun -np 2 /uufs/chpc.utah.edu/sys/installdir/intel/compilers_and_libraries_2017.0.098/linux/mpi/intel64/bin/IMB-MPI1
#    source /uufs/chpc.utah.edu/sys/modulefiles/scripts/clear_lmod.sh
#    source /uufs/chpc.utah.edu/sys/installdir/lmod/7.4-u16/init/profile
   # ml intel
