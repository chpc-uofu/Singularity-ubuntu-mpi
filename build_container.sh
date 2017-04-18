prg=mpi
rm -f ubuntu_${prg}.img
sudo singularity create --size 2048 ubuntu_${prg}.img
sudo singularity bootstrap ubuntu_${prg}.img Singularity
