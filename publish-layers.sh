#!/bin/bash

GEOSERVER_URL=http://10.150.16.88:8084/geoserver
WORKSPACE=sansa-water-staging
USER=admin
PASS=geoserver  # change to your admin password

echo "🔄 Fetching coverage stores from workspace: $WORKSPACE"

# Get all store names
STORES=$(curl -s -u $USER:$PASS \
  "$GEOSERVER_URL/rest/workspaces/$WORKSPACE/coveragestores.json" \
  | python3 -c "
import sys, json
data = json.load(sys.stdin)
stores = data.get('coverageStores', {}).get('coverageStore', [])
for s in stores:
    print(s['name'])
")

echo "Found stores:"
echo "$STORES"
echo ""

# Loop through each store and publish the coverage
for STORE in $STORES; do
  echo "📦 Publishing layer from store: $STORE"

  # Get the coverage name from the store
  COVERAGE=$(curl -s -u $USER:$PASS \
    "$GEOSERVER_URL/rest/workspaces/$WORKSPACE/coveragestores/$STORE/coverages.json" \
    | python3 -c "
import sys, json
data = json.load(sys.stdin)
coverages = data.get('coverages', {}).get('coverage', [])
if isinstance(coverages, list) and coverages:
    print(coverages[0]['name'])
elif isinstance(coverages, dict):
    print(coverages['name'])
" 2>/dev/null)

  if [ -z "$COVERAGE" ]; then
    echo "  ⚠️  No existing coverage found, creating from store: $STORE"

    # Publish new coverage using store name as layer name
    HTTP_CODE=$(curl -s -o /tmp/gs-response.txt -w "%{http_code}" \
      -u $USER:$PASS \
      -X POST \
      -H "Content-Type: application/json" \
      -d "{
        \"coverage\": {
          \"name\": \"$STORE\",
          \"nativeName\": \"$STORE\",
          \"title\": \"$STORE\",
          \"enabled\": true
        }
      }" \
      "$GEOSERVER_URL/rest/workspaces/$WORKSPACE/coveragestores/$STORE/coverages")

    if [ "$HTTP_CODE" = "201" ]; then
      echo "  ✅ Published: $STORE (HTTP $HTTP_CODE)"
    else
      echo "  ❌ Failed: $STORE (HTTP $HTTP_CODE)"
      cat /tmp/gs-response.txt
    fi
  else
    echo "  ℹ️  Already published as: $COVERAGE — skipping"
  fi

  echo ""
done

echo "✅ Bulk publish complete"