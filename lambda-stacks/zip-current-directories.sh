#!/bin/bash

# Loop through subdirectories and create a zip file for each
for dir in */ ; do
  # Remove trailing slash
  dir=${dir%/}

  if [ -d "$dir" ]; then
    zip_file="${dir}.zip"

    # Create zip file
    echo "Creating zip file for $dir..."
    (cd $dir && zip -qr ../$zip_file .)
  fi
done

echo "Zipping completed."
