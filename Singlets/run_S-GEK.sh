#!/bin/bash
#SBATCH --mail-type=END
#SBATCH --mail-user=daniel.sethio@kemi.uu.se
#SBATCH --exclusive

#SBATCH -J HF-DZ-singlets-S-GEK
#SBATCH -A naiss2023-5-143
#SBATCH -t 0-06:00:00
#SBATCH -N 1
#SBATCH --mem=95GB

mkdir Logs_HF_DZ_S-GEK
mkdir tmp3


module load buildenv-intel/2018a-eb
module load Python/3.6.7-env-nsc1-gcc-2018a-eb
module load HDF5/1.8.19-nsc1-intel-2018a-eb


export MOLCAS=/home/x_danse/OpenMolcas/build/
export MOLCAS_NPROCS=32
export MOLCAS_MEM=92000


rm -f report_singlets_HF_DZ_S-GEK
#rm -f slurm*
rm Logs_HF_DZ_S-GEK/*

export BASIS="cc-pVDZ"
#export Opt=""
#export Opt="RS-RFO"
export Opt="S-GEK"
export SCFTYPE="Choinput
                NOLK
                End of Choinput
                Spin=1"
#export SCFTYPE="KSDFT=B3LYP"


echo 'Convergence statistics' > report_singlets_HF_DZ_S-GEK
echo '' >> report_singlets_HF_DZ_S-GEK
echo 'Basis set: ' $BASIS >> report_singlets_HF_DZ_S-GEK
echo 'SCF input: ' $SCFTYPE >> report_singlets_HF_DZ_S-GEK
echo 'SCF input: ' $Opt >> report_singlets_HF_DZ_S-GEK

for mol in Coordinates/{00..264}*.xyz ; do
  cp $mol tmp3/.

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
  cd tmp3
  pymolcas ../scf.input -oe ../Logs_HF_DZ_S-GEK/${Project}.log -b 1
  line1=$(grep -i 'convergence after ' ../Logs_HF_DZ_S-GEK/${Project}.log)
  line2=$(grep -i 'Occupied orbitals ' ../Logs_HF_DZ_S-GEK/${Project}.log)
  line3=$(grep -i 'Secondary orbitals ' ../Logs_HF_DZ_S-GEK/${Project}.log)
  line4=$(grep -i 'Total SCF energy ' ../Logs_HF_DZ_S-GEK/${Project}.log)
  line5=$(grep -i 'Timing: ' ../Logs_HF_DZ_S-GEK/${Project}.log)
  echo '' >> ../report_singlets_HF_DZ_S-GEK
  echo $Project ":" >> ../report_singlets_HF_DZ_S-GEK
  echo $line1 >> ../report_singlets_HF_DZ_S-GEK
  echo $line2 >> ../report_singlets_HF_DZ_S-GEK
  echo $line3 >> ../report_singlets_HF_DZ_S-GEK
  echo $line4 >> ../report_singlets_HF_DZ_S-GEK
  echo $line5 >> ../report_singlets_HF_DZ_S-GEK
  rm -r *
  cd -
done
