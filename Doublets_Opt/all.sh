#!/bin/bash

dir="run_qNRC2DIIS.sh run_RS-RFO.sh run_S-GEK.sh run_b3lyp_qNRC2DIIS.sh run_b3lyp_RS-RFO.sh run_b3lyp_S-GEK.sh"

for i in $dir
  do
    #sed -i "s/doublets/doublets_opt/g" $i
    #sed -i "s/snic2022-22-976/snic2022-1-27/g" $i
    sbatch $i
  done
