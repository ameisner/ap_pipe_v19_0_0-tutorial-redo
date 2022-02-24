eups list lsst_distrib

rm -rf DATA/rerun/processCcdOutputs
processCcd.py DATA --calib DATA/CALIB --rerun processCcdOutputs --id --longlog -j20 &> processCcd-all-j20.log &
