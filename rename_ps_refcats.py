#!/usr/bin/env python 

import os
import glob


flist = glob.glob('DATA/ref_cats/ps1_pv3_3pi_20170110/panstarrs*.fits')

for f in flist:
    fname_new = f.replace('/panstarrs_', '/')
    fname_new = fname_new.replace('_refcats_gen2', '')

    print(f, fname_new)
    os.rename(f, fname_new)
