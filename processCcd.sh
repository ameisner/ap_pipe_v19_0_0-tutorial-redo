eups list lsst_distrib

rm -rf DATA/rerun/processCcdOutputs
processCcd.py DATA --calib DATA/CALIB --rerun processCcdOutputs --id visit=412321 ccdnum=42 filter=g --longlog &> processCcd.log &
