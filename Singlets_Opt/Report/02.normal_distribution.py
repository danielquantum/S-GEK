#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 16 17:10:11 2023

@author: daniel.immanuel
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from scipy.stats import norm

# load the data from the CSV file
data = pd.read_csv('iterations.csv')

# extract the three columns
col1 = data['HF/qNRC2DIIS']
col2 = data['HF/RS-RFO']
col3 = data['HF/S-GEK']

# calculate the mean and standard deviation for each column
mu1, std1 = norm.fit(col1)
mu2, std2 = norm.fit(col2)
mu3, std3 = norm.fit(col3)

# create the normal distribution curve for each column
#x = np.linspace(min(min(col1), min(col2), min(col3)), max(max(col1), max(col2), max(col3)), 1000)
x = np.linspace(0, 30, 1000)
y1 = norm.pdf(x, mu1, std1)
y2 = norm.pdf(x, mu2, std2)
y3 = norm.pdf(x, mu3, std3)

# plot the normal distribution curves
plt.plot(x, y1, 'r-', linewidth=2, label='qNRC2DIIS')
plt.plot(x, y2, 'b-', linewidth=2, label='RS-RFO')
plt.plot(x, y3, 'g-', linewidth=2, label='S-GEK')

# set the plot title and labels
plt.title('HF/cc-pVDZ for a singlets_opt data set')
plt.xlabel('Number of iterations')
plt.ylabel('Frequency')

# set the plot limits
#plt.xlim(min(min(col1), min(col2), min(col3)), max(max(col1), max(col2), max(col3)))
plt.xlim(5,30)
plt.ylim(0, max(max(y1), max(y2), max(y3))+0.05)

# add the legend
plt.legend()

plt.savefig('normal_distribution_HF_singlets.png', dpi=300)


plt.show()
