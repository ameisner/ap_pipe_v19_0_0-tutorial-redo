mkdir DATA
mkdir DATA/CALIB

echo lsst.obs.decam.DecamMapper > DATA/_mapper

# mode=link to avoid moving any files out of the as-cloned ap_verify_hits2015 repo
ingestImagesDecam.py DATA --filetype raw /data0/ameisner/ap_verify_hits2015/raw/*.fz --mode=link

mkdir flats_biases
rsync -arv /data0/ameisner/ap_verify_hits2015/preloaded/DECam/calib/*/cpBias/cpBias*.fits flats_biases
rsync -arv /data0/ameisner/ap_verify_hits2015/preloaded/DECam/calib/*/cpFlat/g/*/cpFlat*.fits flats_biases

# based on https://pipelines.lsst.io/v/v19_0_0/modules/lsst.ap.pipe/getting-started.html#ingesting-data-files
# mode=link suggestion comes from https://github.com/lsst/obs_decam/blob/c61c294ec8411b21af064a367e2ecf46119e0989/README.md
ingestCalibs.py DATA --calib DATA/CALIB flats_biases/*.fits --validity 999 --mode=link

# go with a 2015 version of defects
ingestDefects.py DATA /data0/ameisner/ap_verify_hits2015/preloaded/DECam/calib/curated/20150105T011500Z/defects --calib=DATA/CALIB

mkdir DATA/ref_cats

rsync -arv ../ap_verify_hits2015/preloaded/refcats/gen2/* DATA/ref_cats

chmod -R ug+w DATA/ref_cats

# not really sure why this is necessary but it seems to be needed based on trial and error
mv DATA/ref_cats/panstarrs DATA/ref_cats/ps1_pv3_3pi_20170110

# based on https://community.lsst.org/t/reducing-suprime-cam-data/2762/14
cp /data0/ameisner/v19_0_0-tutorial/redo/DATA/ref_cats/ps1_pv3_3pi_20170110/master_schema.fits DATA/ref_cats/ps1_pv3_3pi_20170110/master_schema.fits

cp -p /data0/ameisner/v19_0_0-tutorial/redo/DATA/ref_cats/ps1_pv3_3pi_20170110/config.py DATA/ref_cats/ps1_pv3_3pi_20170110/

# master_schema.fits and config.py for Gaia reference catalogs
cp -p /data0/ameisner/testdata_decam/ingested/ref_cats/gaia/master_schema.fits DATA/ref_cats/gaia
cp -p /data0/ameisner/testdata_decam/ingested/ref_cats/gaia/config.py DATA/ref_cats/gaia

mkdir DATA/templates

rsync -arv /data0/ameisner/ap_verify_hits2015/preloaded/templates/deep/deepCoadd DATA/templates

chmod -R ug+w DATA

# can't seem to find much/any documentation on repositoryCfg.yaml
# this version based on : /data0/ameisner/v19_0_0-tutorial/redo/DATA/rerun/processCcdOutputs/repositoryCfg.yaml
cp -p repositoryCfg.yaml DATA/templates
