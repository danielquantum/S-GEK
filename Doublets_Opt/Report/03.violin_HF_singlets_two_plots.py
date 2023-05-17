#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 16 22:58:27 2023

@author: danielquantum
"""

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Load the CSV file into a pandas DataFrame
df = pd.read_csv('iterations.csv')

# Specify the columns you want to use for the violin plot
col1 = 'HF/qNRC2DIIS'
col2 = 'HF/RS-RFO'
col3 = 'HF/S-GEK'

col4 = 'B3LYP/qNRC2DIIS'
col5 = 'B3LYP/RS-RFO'
col6 = 'B3LYP/S-GEK'

# Create a figure with two subplots
fig, (ax1, ax2) = plt.subplots(ncols=2, figsize=(10,5))

# Create a violin plot for the first column in the first subplot
sns.violinplot(data=df[[col1, col2, col3]], inner='quartile', ax=ax1)
ax1.set_title('HF/cc-pVDZ')

# Create a violin plot for the first column in the second subplot
sns.violinplot(data=df[[col4, col5, col6]], inner='quartile', ax=ax2)
ax2.set_title('B3LYP/cc-pVDZ')

# Rotate the x-axis tick labels on the second subplot
plt.setp(ax1.get_xticklabels(), rotation=15)
plt.setp(ax2.get_xticklabels(), rotation=15)

# Set the x-axis label to vertical
#plt.xlabel('X-axis label', rotation=45)

# Set the overall title for the figure
fig.suptitle('Doublets_opt')

plt.savefig('violin_doublets_opt.png', dpi=300)

# Display the plot
plt.show()