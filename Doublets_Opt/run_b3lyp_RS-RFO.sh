#!/bin/bash
#SBATCH --mail-type=END
#SBATCH --mail-user=daniel.sethio@kemi.uu.se
#SBATCH --exclusive

#SBATCH -J B3LYP-DZ-doublets_opt-RS-RFO
#SBATCH -A naiss2023-5-143
#SBATCH -t 0-20:00:00
#SBATCH -N 1
#SBATCH --mem=95GB

mkdir Logs_B3LYP_DZ_RS-RFO
mkdir tmp5


module load buildenv-intel/2018a-eb
module load Python/3.6.7-env-nsc1-gcc-2018a-eb
module load HDF5/1.8.19-nsc1-intel-2018a-eb


export MOLCAS=/home/x_danse/OpenMolcas/build/
export MOLCAS_NPROCS=32
export MOLCAS_MEM=92000


rm -f report_doublets_opt_B3LYP_DZ_RS-RFO
#rm -f slurm*
rm Logs_B3LYP_DZ_RS-RFO/*

export BASIS="cc-pVDZ"
#export Opt=""
export Opt="RS-RFO"
#export Opt="S-GEK"
export SCFTYPE="Choinput
                NOLK
                End of Choinput
                Spin=2
                KSDFT=B3LYP"
#export SCFTYPE="KSDFT=B3LYP"


echo 'Convergence statistics' > report_doublets_opt_B3LYP_DZ_RS-RFO
echo '' >> report_doublets_opt_B3LYP_DZ_RS-RFO
echo 'Basis set: ' $BASIS >> report_doublets_opt_B3LYP_DZ_RS-RFO
echo 'SCF input: ' $SCFTYPE >> report_doublets_opt_B3LYP_DZ_RS-RFO
echo 'SCF input: ' $Opt >> report_doublets_opt_B3LYP_DZ_RS-RFO

for mol in Coordinates/{00..234}*.xyz ; do
  cp $mol tmp5/.

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
  cd tmp5
  pymolcas ../scf_dft.input -oe ../Logs_B3LYP_DZ_RS-RFO/${Project}.log -b 1
  line1=$(grep -i 'convergence after ' ../Logs_B3LYP_DZ_RS-RFO/${Project}.log)
  line2=$(grep -i 'Occupied orbitals ' ../Logs_B3LYP_DZ_RS-RFO/${Project}.log)
  line3=$(grep -i 'Secondary orbitals ' ../Logs_B3LYP_DZ_RS-RFO/${Project}.log)
  line4=$(grep -i 'Total KS-DFT energy ' ../Logs_B3LYP_DZ_RS-RFO/${Project}.log)
  line5=$(grep -i 'Timing: ' ../Logs_B3LYP_DZ_RS-RFO/${Project}.log)
  echo '' >> ../report_doublets_opt_B3LYP_DZ_RS-RFO
  echo $Project ":" >> ../report_doublets_opt_B3LYP_DZ_RS-RFO
  echo $line1 >> ../report_doublets_opt_B3LYP_DZ_RS-RFO
  echo $line2 >> ../report_doublets_opt_B3LYP_DZ_RS-RFO
  echo $line3 >> ../report_doublets_opt_B3LYP_DZ_RS-RFO
  echo $line4 >> ../report_doublets_opt_B3LYP_DZ_RS-RFO
  echo $line5 >> ../report_doublets_opt_B3LYP_DZ_RS-RFO
  rm -r *
  cd -
done
