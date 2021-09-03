#!/usr/bin/env bash

# set environment to enable OGR (part of GDAL)
conda activate geo

# create an array of state names
declare -a STATES=("ACT" "NSW" "NT" "OT" "QLD" "SA" "TAS" "VIC" "WA")

# how many iterations of each test
TEST_COUNT=5

#echo "----------------------------------------------------------------------------------------------------------------"
#echo " Start Shapefile to Postgres - OGR test"
#echo " Start time : $(date)"
#echo "----------------------------------------------------------------------------------------------------------------"
#
#SECONDS=0*
#
#for i in $(seq 1 ${TEST_COUNT});
#do
#  echo " ROUND ${i} OF ${TEST_COUNT} - total time : ${SECONDS}s"
#
#  for STATE in "${STATES[@]}"
#  do
#    SHP_PATH="/Users/s57405/Downloads/AUG21_Admin_Boundaries_ESRIShapefileorDBFfile/Localities_AUG21_GDA94_SHP/Localities/Localities AUGUST 2021/Standard/${STATE}_localities.shp"
#
#    if [[ ${STATE} == "ACT" ]]
#    then
#      echo -n "  - importing ${STATE}"
#      ogr2ogr -f "PostgreSQL" -overwrite -nln "testing.locality_ogr_${i}" PG:"host=localhost port=5432 dbname=geo user=postgres password=password" "${SHP_PATH}"
#    else
#      echo -n ", ${STATE}"
#      ogr2ogr -f "PostgreSQL" -append -update -nln "testing.locality_ogr_${i}" PG:"host=localhost port=5432 dbname=geo user=postgres password=password" "${SHP_PATH}"
#    fi
#  done
#
#  echo ""
#done
#
#DURATION=${SECONDS}
#
#echo "-------------------------------------------------------------------------"
#echo " End time : $(date)"
#echo " OGR Test took ${DURATION}s"
#echo "----------------------------------------------------------------------------------------------------------------"



echo "----------------------------------------------------------------------------------------------------------------"
echo " Start Shapefile to Postgres - SHP2PGSQL test"
echo " Start time : $(date)"
echo "----------------------------------------------------------------------------------------------------------------"

SECONDS=0*

for i in $(seq 1 ${TEST_COUNT});
do
  echo " ROUND ${i} OF ${TEST_COUNT} - total time : ${SECONDS}s"

  for STATE in "${STATES[@]}"
  do
    SHP_PATH="/Users/s57405/Downloads/AUG21_Admin_Boundaries_ESRIShapefileorDBFfile/Localities_AUG21_GDA94_SHP/Localities/Localities AUGUST 2021/Standard/${STATE}_localities.shp"

    if [[ ${STATE} == "ACT" ]]
    then
      echo -n "  - importing ${STATE}"
      /Applications/Postgres.app/Contents/Versions/13/bin/shp2pgsql -f "PostgreSQL" -overwrite -nln "testing.locality_shp2pgsql_${i}" PG:"host=localhost port=5432 dbname=geo user=postgres password=password" "${SHP_PATH}"
    else
      echo -n ", ${STATE}"
      /Applications/Postgres.app/Contents/Versions/13/bin/shp2pgsql -f "PostgreSQL" -append -update -nln "testing.locality_shp2pgsql_${i}" PG:"host=localhost port=5432 dbname=geo user=postgres password=password" "${SHP_PATH}"
    fi
  done

  echo ""
done

DURATION=${SECONDS}

echo "-------------------------------------------------------------------------"
echo " End time : $(date)"
echo " OGR Test took ${DURATION}s"
echo "----------------------------------------------------------------------------------------------------------------"

