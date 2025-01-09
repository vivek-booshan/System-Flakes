# # example dir : /opt/homebrew/Caskroom/aerospace/1.z
# echo "Linking Homebrew cask binaries to /run/current-system/sw/bin..." >&2
# caskroom="/opt/homebrew/Caskroom"
# bin_dir="/run/current-system/sw/bin"

# if [ ! -d "$bin_dir" ]; then
#   echo "Error: Directory $bin_dir does not exist" >&2
#   exit 1
# fi  

# for app in "$caskroom"/*; do

#   # Filter version directory
#   version=$(ls -t "$app" | head -n 1)
#   app_path=$app/$version/*.app/Contents/MacOS/*

#   echo "Checking path: $app_path" >&2

#   if [ -f "$app_path" ]; then
#     app_name=$(basename "$app_path")
#     ln -sf "$app_path" "$bin_dir/$app_name"
#   else
#     echo "No binary found for $app at $app_path" >&2
#   fi

# done

#!/bin/bash

echo "Linking Homebrew cask binaries to /run/current-system/sw/bin..." >&2

caskroom="/opt/homebrew/Caskroom"
bin_dir="/run/current-system/sw/bin"

if [ ! -d "$bin_dir" ]; then
  echo "Error: Directory $bin_dir does not exist!" >&2
  exit 1
fi

# Iterate over each application directory in Caskroom
for app in "$caskroom"/*; do
  # Get the latest version of the app
  version=$(ls -t "$app" | head -n 1)
  app_dir="$app/$version"  # Full path to the latest version directory

  # Iterate over all .app directories (this should match the .app directory)
  for app_bundle in "$app_dir"/*.app; do
    if [ -d "$app_bundle" ]; then
      # Now that we have a valid .app directory, look for binaries inside Contents/MacOS
      binary_dir="$app_bundle/Contents/MacOS"
      
      if [ -d "$binary_dir" ]; then
        # Iterate over the binaries inside the Contents/MacOS folder
        for binary in "$binary_dir"/*; do
          if [ -f "$binary" ]; then
            # Extract the binary name
            if [[ "$binary" =~ /Contents/MacOS/([^/]+) ]]; then
              app_name="${BASH_REMATCH[1]}"  # Extract binary name

              # Ensure we are linking the correct file
              if [[ "$binary" != /* ]]; then
                echo "Error: Invalid binary path ($binary). This should be an absolute path." >&2
                continue
              fi

              # Clean the path of any escape characters or weird components
              sanitized_binary=$(echo "$binary" | sed 's/\\//g')  # Remove any escape sequences like \

              echo "Linking $sanitized_binary to $bin_dir/$app_name" >&2
              sudo ln -sf "$sanitized_binary" "$bin_dir/$app_name"
            else
              echo "No valid binary found in $binary" >&2
            fi
          else
            echo "No binary found in $binary_dir" >&2
          fi
        done
      else
        echo "No binary directory found in $app_bundle/Contents/MacOS" >&2
      fi
    else
      echo "No .app directory found for $app_bundle" >&2
    fi
  done
done
