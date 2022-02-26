eups list lsst_distrib

rm -rf ppdb
rm -rf DATA/rerun/processed

mkdir ppdb/
make_ppdb.py -c ppdb.isolation_level=READ_UNCOMMITTED -c ppdb.db_url="sqlite:///ppdb/association.db"
ap_pipe.py DATA --calib DATA/CALIB --rerun processed -c ppdb.isolation_level=READ_UNCOMMITTED -c ppdb.db_url="sqlite:///ppdb/association.db" --id visit=411858 ccdnum=42 filter=g --template DATA/templates --longlog &> ap_26.log &
