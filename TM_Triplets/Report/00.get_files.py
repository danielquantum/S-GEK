#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb 28 22:54:10 2023

@author: danielquantum
"""
import glob
files = glob.glob('report*')
files.sort()         # List is mutable in python, it will modify list directly
print(files)