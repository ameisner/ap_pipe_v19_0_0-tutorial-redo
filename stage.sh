eups list lsst_distrib

# start fresh
chmod -R ug+w DATA flats_biases ; rm -rf DATA flats_biases

# create Butler repo
mkdir DATA
mkdir DATA/CALIB

echo lsst.obs.decam.DecamMapper > DATA/_mapper

# make sure there's no chance of modifying the input DECam data repo
chmod -R ug-w $DATA/ap_verify_hits2015

# mode=link to avoid moving any files out of the as-cloned ap_verify_hits2015 repo
ingestImagesDecam.py DATA --filetype raw $DATA/ap_verify_hits2015/raw/*.fz --mode=link

mkdir flats_biases
rsync -arv $DATA/ap_verify_hits2015/preloaded/DECam/calib/*/cpBias/cpBias*.fits flats_biases
rsync -arv $DATA/ap_verify_hits2015/preloaded/DECam/calib/*/cpFlat/g/*/cpFlat*.fits flats_biases

# based on https://pipelines.lsst.io/v/v19_0_0/modules/lsst.ap.pipe/getting-started.html#ingesting-data-files
# mode=link suggestion comes from https://github.com/lsst/obs_decam/blob/c61c294ec8411b21af064a367e2ecf46119e0989/README.md
ingestCalibs.py DATA --calib DATA/CALIB flats_biases/*.fits --validity 999 --mode=link

# for ingestDefects.py to work, need to use defects that are organized into per-CCD directories and in .ecsv format
# per RFC-595 community forum post https://community.lsst.org/t/changes-to-how-defects-are-handled-implementation-of-rfc-595/3732 (thanks Shenming!)
ingestDefects.py DATA /data0/ameisner/lsst_stack_v19_0_0/stack/miniconda3-4.7.10-4d7b902/Linux64/obs_decam_data/19.0.0/decam/defects --calib DATA/CALIB

mkdir DATA/ref_cats

rsync -arv $DATA/ap_verify_hits2015/preloaded/refcats/gen2/* DATA/ref_cats

chmod -R ug+w DATA/ref_cats

# seems to be needed based on trial and error, may be related to:
# obs_decam/19.0.0+2/config/processCcd.py, particularly the config.calibrate.connections.astromRefCat and config.calibrate.connections.photoRefCat
mv DATA/ref_cats/panstarrs DATA/ref_cats/ps1_pv3_3pi_20170110

# based on https://community.lsst.org/t/reducing-suprime-cam-data/2762/14
cp $DATA/v19_0_0-tutorial/DATA/ref_cats/ps1_pv3_3pi_20170110/master_schema.fits DATA/ref_cats/ps1_pv3_3pi_20170110/master_schema.fits

cp -p $DATA/v19_0_0-tutorial/DATA/ref_cats/ps1_pv3_3pi_20170110/config.py DATA/ref_cats/ps1_pv3_3pi_20170110/

# master_schema.fits and config.py for Gaia reference catalogs
cp -p $DATA/testdata_decam/ingested/ref_cats/gaia/master_schema.fits DATA/ref_cats/gaia
cp -p $DATA/testdata_decam/ingested/ref_cats/gaia/config.py DATA/ref_cats/gaia

mkdir -p DATA/templates/deepCoadd/g/0

rsync -arv $DATA/ap_verify_hits2015/preloaded/templates/deep/deepCoadd/0/*/g/*.fits DATA/templates/deepCoadd/g/0

# can't seem to find much/any documentation on repositoryCfg.yaml
# this version based on : $DATA/v19_0_0-tutorial/DATA/rerun/processCcdOutputs/repositoryCfg.yaml
cp -p repositoryCfg.yaml DATA/templates

chmod -R ug+w DATA

python rename_ps_refcats.py

chmod -R a+rX DATA
