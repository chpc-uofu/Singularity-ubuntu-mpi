InfiniBand enabled container

This Ubuntu based container packages support for IB at CHPC clusters.

The important addition is
 - installation of IB driver stack in the container, based on 
   https://community.mellanox.com/docs/DOC-2431
 - adjusting LD_LIBRARY_PATH in the container to add /usr/lib/libibverbs, which is where the IB driver libs are

We also mount the CHPC sys branch and use Intel compilers and Intel MPI in the sys branch to compile MPI programs in the container, and then
run on the host.

After the container is built, sudo to the container and build MPI program, e.g.
sudo singularity shell -s /bin/bash -B /uufs ubuntu_mpi.img
source /uufs/chpc.utah.edu/sys/installdir/intel/compilers_and_libraries_2017/linux/bin/compilervars.sh intel64
 -- TODO - explore options to bring in LMod
mpicc latbw.c -o latbw

Then exit the container, submit a job on 2 nodes and run the latbw over IB:
srun -N 2 -n 2 -p ember -A chpc -t 2:00:00 --pty /bin/bash -l
ml intel singularity
mpirun -genv I_MPI_DEBUG 5 -genv I_MPI_FABRICS ofa -np 2 singularity exec  -B /uufs/chpc.utah.edu ubuntu_mpi.img  ./latbw

