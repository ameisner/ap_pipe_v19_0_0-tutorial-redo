eups list lsst_distrib

rm -rf DATA/rerun/processCcdOutputs
#processCcd.py DATA --calib DATA/CALIB --rerun processCcdOutputs --id visit=412321 ccdnum=42 filter=g --longlog &> processCcd.log &

# config options based on: https://community.lsst.org/t/processccd-with-obs-decam-no-locations-for-get/3474
processCcd.py DATA --calib DATA/CALIB --rerun processCcdOutputs --id visit=412321 ccdnum=42 filter=g --longlog --config calibrate.doPhotoCal=False calibrate.doAstrometry=False &> processCcd.log &
