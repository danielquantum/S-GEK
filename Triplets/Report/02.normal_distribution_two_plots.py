#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 16 22:12:37 2023

@author: danielquantum
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

col4 = data['B3LYP/qNRC2DIIS']
col5 = data['B3LYP/RS-RFO']
col6 = data['B3LYP/S-GEK']

# create the figure and subplots
fig, (ax1, ax2) = plt.subplots(nrows=1, ncols=2, figsize=(10, 5))

# set the plot titles and labels for each subplot
ax1.set_title('HF/cc-pVDZ')
ax1.set_xlabel('Iterations')
ax1.set_ylabel('Frequency')

ax2.set_title('B3LYP/cc-pVDZ')
ax2.set_xlabel('Iterations')
ax2.set_ylabel('Frequency')

# calculate the mean and standard deviation for each column
mu1, std1 = norm.fit(col1)
mu2, std2 = norm.fit(col2)
mu3, std3 = norm.fit(col3)

mu4, std4 = norm.fit(col4)
mu5, std5 = norm.fit(col5)
mu6, std6 = norm.fit(col6)

# create the normal distribution curve for each column
#x1 = np.linspace(min(min(col1), min(col2), min(col3)), max(max(col1), max(col2), max(col3)), 1000)
x1 = np.linspace(0, 50, 1000)
y1 = norm.pdf(x1, mu1, std1)
y2 = norm.pdf(x1, mu2, std2)
y3 = norm.pdf(x1, mu3, std3)

#x2 = np.linspace(min(min(col4), min(col5), min(col6)), max(max(col4), max(col5), max(col6)), 1000)
x2 = np.linspace(0, 50, 1000)
y4 = norm.pdf(x2, mu4, std4)
y5 = norm.pdf(x2, mu5, std5)
y6 = norm.pdf(x2, mu6, std6)

# plot the normal distribution curves
ax1.plot(x1, y1, 'r-', linewidth=2, label='qNRC2DIIS')
ax1.plot(x1, y2, 'b-', linewidth=2, label='RS-RFO')
ax1.plot(x1, y3, 'g-', linewidth=2, label='S-GEK')

ax2.plot(x2, y4, 'r-', linewidth=2, label='qNRC2DIIS')
ax2.plot(x2, y5, 'b-', linewidth=2, label='RS-RFO')
ax2.plot(x2, y6, 'g-', linewidth=2, label='S-GEK')

# add a title for the entire figure
#fig.suptitle('Normal distributions a singlets data set')
fig.suptitle('Triplets')

# set the plot limits
#ax1.set_xlim(min(min(col1), min(col2), min(col3)), max(max(col1), max(col2), max(col3)))
ax1.set_xlim(5,50)
ax1.set_ylim(0, max(max(y1), max(y2), max(y3))+0.05)

#ax2.set_xlim(min(min(col4), min(col5), min(col6)), max(max(col4), max(col5), max(col6)))
ax2.set_xlim(5,50)
ax2.set_ylim(0, max(max(y4), max(y5), max(y6))+0.05)

# add the legend
plt.legend()

plt.savefig('normal_distribution_triplets.png', dpi=300)


plt.show()