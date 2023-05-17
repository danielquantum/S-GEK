#!/bin/bash
#SBATCH --mail-type=END
#SBATCH --mail-user=daniel.sethio@kemi.uu.se
#SBATCH --exclusive

#SBATCH -J B3LYP-DZ-triplets-qNRC2DIIS
#SBATCH -A snic2022-1-27
#SBATCH -t 1-00:00:00
#SBATCH -N 1
#SBATCH --mem=95GB

mkdir Logs_B3LYP_DZ_qNRC2DIIS
mkdir tmp4


module load buildenv-intel/2018a-eb
module load Python/3.6.7-env-nsc1-gcc-2018a-eb
module load HDF5/1.8.19-nsc1-intel-2018a-eb


export MOLCAS=/home/x_danse/OpenMolcas/build/
export MOLCAS_NPROCS=32
export MOLCAS_MEM=92000


rm -f report_triplets_B3LYP_DZ_qNRC2DIIS
#rm -f slurm*
rm Logs_B3LYP_DZ_qNRC2DIIS/*

export BASIS="cc-pVDZ"
export Opt=""
#export Opt="RS-RFO"
#export Opt="S-GEK"
export SCFTYPE="Choinput
                NOLK
                End of Choinput
                Spin=3
                KSDFT=B3LYP"
#export SCFTYPE="KSDFT=B3LYP"


echo 'Convergence statistics' > report_triplets_B3LYP_DZ_qNRC2DIIS
echo '' >> report_triplets_B3LYP_DZ_qNRC2DIIS
echo 'Basis set: ' $BASIS >> report_triplets_B3LYP_DZ_qNRC2DIIS
echo 'SCF input: ' $SCFTYPE >> report_triplets_B3LYP_DZ_qNRC2DIIS
echo 'SCF input: ' $Opt >> report_triplets_B3LYP_DZ_qNRC2DIIS

for mol in Coordinates/{00..264}*.xyz ; do
  cp $mol tmp4/.

  prefix="Coordinates/"
  mol=${mol#"$prefix"}

  export Project=$(basename ${mol} .xyz)
  export XYZ=${mol}
  export SCF=${SCFTYPE}

  echo 
  echo 'Project:  ' $Project
  echo 'Basis set:' $BASIS
  echo 'SCF input:' SCF " " $Opt
  echo 'xyz file :' $XYZ
  echo 
  cd tmp4
  pymolcas ../scf_dft.input -oe ../Logs_B3LYP_DZ_qNRC2DIIS/${Project}.log -b 1
  line1=$(grep -i 'convergence after ' ../Logs_B3LYP_DZ_qNRC2DIIS/${Project}.log)
  line2=$(grep -i 'Occupied orbitals ' ../Logs_B3LYP_DZ_qNRC2DIIS/${Project}.log)
  line3=$(grep -i 'Secondary orbitals ' ../Logs_B3LYP_DZ_qNRC2DIIS/${Project}.log)
  line4=$(grep -i 'Total KS-DFT energy ' ../Logs_B3LYP_DZ_qNRC2DIIS/${Project}.log)
  line5=$(grep -i 'Timing: ' ../Logs_B3LYP_DZ_qNRC2DIIS/${Project}.log)
  echo '' >> ../report_triplets_B3LYP_DZ_qNRC2DIIS
  echo $Project ":" >> ../report_triplets_B3LYP_DZ_qNRC2DIIS
  echo $line1 >> ../report_triplets_B3LYP_DZ_qNRC2DIIS
  echo $line2 >> ../report_triplets_B3LYP_DZ_qNRC2DIIS
  echo $line3 >> ../report_triplets_B3LYP_DZ_qNRC2DIIS
  echo $line4 >> ../report_triplets_B3LYP_DZ_qNRC2DIIS
  echo $line5 >> ../report_triplets_B3LYP_DZ_qNRC2DIIS
  rm -r *
  cd -
done
