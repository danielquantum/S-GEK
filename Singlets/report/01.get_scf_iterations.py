#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 16 15:08:28 2023

@author: daniel.immanuel

Collect SCF iterations and make a plot
"""

### Collect all files and sort it
#import glob
#files = glob.glob('report*')
#files.sort()         # List is mutable in python, it will modify list directly
#print(files)

### Variables
files = ['report_singlets_HF_DZ_qNRC2DIIS', 'report_singlets_HF_DZ_RS-RFO', 'report_singlets_HF_DZ_S-GEK', 'report_singlets_B3LYP_DZ_qNRC2DIIS', 'report_singlets_B3LYP_DZ_RS-RFO', 'report_singlets_B3LYP_DZ_S-GEK']

### Collect all iteration data
global_iterations = []
global_energies = []
for file in files:
    iterations = []
    energies = []
    with open(file, 'r') as f:
        for line in f:
            if 'Iterations' in line:
                linesplit = line.split()
                iter = linesplit[2]
                iterations.append(iter)
            if 'energy' in line:
                linesplit = line.split()
                ener = linesplit[-1]
                energies.append(ener)
        global_iterations.append(iterations)
        global_energies.append(energies)
#print(global_iterations)
#print(global_energies)


### Write it to csv files
import csv
with open('iterations.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['HF/qNRC2DIIS', 'HF/RS-RFO', 'HF/S-GEK', 'B3LYP/qNRC2DIIS', 'B3LYP/RS-RFO', 'B3LYP/S-GEK'])
    for i in range(len(global_iterations[0])):
        column = [row[i] for row in global_iterations]
        writer.writerow(column)

with open('energies.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['HF/qNRC2DIIS', 'HF/RS-RFO', 'HF/S-GEK', 'B3LYP/qNRC2DIIS', 'B3LYP/RS-RFO', 'B3LYP/S-GEK'])
    for i in range(len(global_energies[0])):
        column = [row[i] for row in global_energies]
        writer.writerow(column)
        
###