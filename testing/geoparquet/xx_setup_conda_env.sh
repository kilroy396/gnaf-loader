#!/usr/bin/env bash

# --------------------------------------------------------------------------------------------------------------------

PYTHON_VERSION="3.10"

# --------------------------------------------------------------------------------------------------------------------

echo "-------------------------------------------------------------------------"
echo "Creating new Conda Environment 'gdal'"
echo "-------------------------------------------------------------------------"

# update Conda platform
conda update -y conda

# WARNING - removes existing environment
conda env remove --name gdal

# Create Conda environment
conda create -y -n gdal python=${PYTHON_VERSION}

# activate and setup env
conda activate gdal
conda config --env --add channels conda-forge
conda config --env --set channel_priority strict

# reactivate for env vars to take effect
conda activate gdal

# install packages for sedona only
conda install -y -c conda-forge gdal psycopg2 boto3

conda activate gdal

# --------------------------
# extra bits
# --------------------------

## activate env
#conda activate gdal

## shut down env
#conda deactivate

## delete env permanently
#conda env remove --name gdal
