#!/bin/bash
set -e

PROD_USER=ingqambuza    
PROD_HOST=10.150.16.133
PROD_DATA=/home/ingqambuza/GEOSERVER/geoserver_data
LOCAL_DATA=~/GEOSERVER/geoserver_data

echo "🔄 Syncing GeoServer data from production..."

rsync -avz --progress \
  --exclude='logs/' \
  --exclude='tmp/' \
  --exclude='gwc-layers/' \
  --exclude='security/' \
  ${PROD_USER}@${PROD_HOST}:${PROD_DATA}/ \
  ${LOCAL_DATA}/

echo "🔄 Restarting GeoServer..."
cd ~/GEOSERVER
docker compose restart geoserver

echo "✅ Sync complete"