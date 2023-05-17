#!/bin/bash

dir="run_qNRC2DIIS.sh run_RS-RFO.sh run_S-GEK.sh run_b3lyp_qNRC2DIIS.sh run_b3lyp_RS-RFO.sh run_b3lyp_S-GEK.sh"

for i in $dir
  do
    #sed -i "s/singlets/singlets_opt/g" $i
    sbatch $i
  done

