#!/bin/bash
#SBATCH --mail-type=END
#SBATCH --mail-user=daniel.sethio@kemi.uu.se
#SBATCH --exclusive

#SBATCH -J HF-DZ-TM_triplets-S-GEK
#SBATCH -A naiss2023-5-143
#SBATCH -t 7-00:00:00
#SBATCH -N 1
#SBATCH --mem=95GB

#mkdir Logs_HF_DZ_S-GEK
#mkdir tmp3


module load buildenv-intel/2018a-eb
module load Python/3.6.7-env-nsc1-gcc-2018a-eb
module load HDF5/1.8.19-nsc1-intel-2018a-eb


export MOLCAS=/home/x_danse/OpenMolcas/build/
export MOLCAS_NPROCS=32
export MOLCAS_MEM=92000


#rm -f report_TM_triplets_HF_DZ_S-GEK
#rm -f slurm*
#rm Logs_HF_DZ_S-GEK/*

export BASIS="ANO-R1"
#export Opt=""
#export Opt="RS-RFO"
export Opt="S-GEK"
export SCFTYPE="Choinput
                NOLK
                End of Choinput
                UHF
                Spin=3"
#export SCFTYPE="KSDFT=B3LYP"


echo 'Convergence statistics' > report_TM_triplets_HF_DZ_S-GEK
echo '' >> report_TM_triplets_HF_DZ_S-GEK
echo 'Basis set: ' $BASIS >> report_TM_triplets_HF_DZ_S-GEK
echo 'SCF input: ' $SCFTYPE >> report_TM_triplets_HF_DZ_S-GEK
echo 'SCF input: ' $Opt >> report_TM_triplets_HF_DZ_S-GEK

for mol in Coordinates/{168..274}.xyz ; do
  cp $mol tmp3/.

  prefix="Coordinates/"
  mol=${mol#"$prefix"}

  export Project=$(basename ${mol} .xyz)
  export XYZ=${mol}
  export SCF=${SCFTYPE}

  ProjectInt=$((10#$Project)) # Convert $Project to an integer, in base 10

  if (( ProjectInt <= 95 )); then
    export Charge="Charge = -1"
  elif (( ProjectInt >= 96 && ProjectInt <= 265 )); then
    export Charge="Charge = 0"
  elif (( ProjectInt >= 266 && ProjectInt <= 274 )); then
    export Charge="Charge = 1"
  fi

  echo 
  echo 'Project:  ' $Project
  echo 'Basis set:' $BASIS
  echo 'SCF input:' SCF " " $Opt " " $Charge
  echo 'xyz file :' $XYZ
  echo 
  cd tmp3
  pymolcas ../scf.input -oe ../Logs_HF_DZ_S-GEK/${Project}.log -b 1
  line1=$(grep -i 'convergence after ' ../Logs_HF_DZ_S-GEK/${Project}.log)
  line2=$(grep -i 'Occupied orbitals ' ../Logs_HF_DZ_S-GEK/${Project}.log)
  line3=$(grep -i 'Secondary orbitals ' ../Logs_HF_DZ_S-GEK/${Project}.log)
  line4=$(grep -i 'Total SCF energy ' ../Logs_HF_DZ_S-GEK/${Project}.log)
  line5=$(grep -i 'Timing: ' ../Logs_HF_DZ_S-GEK/${Project}.log)
  echo '' >> ../report_TM_triplets_HF_DZ_S-GEK
  echo $Project ":" >> ../report_TM_triplets_HF_DZ_S-GEK
  echo $line1 >> ../report_TM_triplets_HF_DZ_S-GEK
  echo $line2 >> ../report_TM_triplets_HF_DZ_S-GEK
  echo $line3 >> ../report_TM_triplets_HF_DZ_S-GEK
  echo $line4 >> ../report_TM_triplets_HF_DZ_S-GEK
  echo $line5 >> ../report_TM_triplets_HF_DZ_S-GEK
  rm -r *
  cd -
done
