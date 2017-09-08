InfiniBand enabled container

This Ubuntu based container packages support for IB at CHPC clusters.

The important addition is
 - installation of IB driver stack in the container, based on 
   https://community.mellanox.com/docs/DOC-2431
 - adjusting LD_LIBRARY_PATH in the container to add /usr/lib/libibverbs, which is where the IB driver libs are

We also mount the CHPC sys branch and use Intel compilers and Intel MPI in the sys branch to compile MPI programs in the container, and then run on the host.

From our tests, MPICH compatible MPIs of recent vintage (MPICH 3.2 tested) integrate correctly with Singularity. Haven't done much testing with OpenMPI but some basic tests on the most recent OMPI seem to work.

After the container is built, sudo to the container and build MPI program, e.g.
```
sudo singularity shell -s /bin/bash -B /uufs ubuntu_mpi.img
source /uufs/chpc.utah.edu/sys/installdir/intel/compilers_and_libraries_2017/linux/bin/compilervars.sh intel64
(or wherever your Intel stack may be).
```

We also install Lua and libraries for LMod modules that we have in our NFS mounted sys branch (with specific LMod installation for Ubuntu), so that we can use LMod in the container to load our modules. Then we can simply
```
ml intel impi
```

In the container shell, then we compile the OSU labwc.c program:
```
mpicc latbw.c -o latbw
```

Then exit the container, submit a job on 2 nodes and run the latbw over IB:
```
srun -N 2 -n 2 -p ember -A chpc -t 2:00:00 --pty /bin/bash -l
ml intel singularity
mpirun -genv I_MPI_DEBUG 5 -genv I_MPI_FABRICS ofa -np 2 singularity exec  -B /uufs/chpc.utah.edu ubuntu_mpi.img  ./latbw
```
