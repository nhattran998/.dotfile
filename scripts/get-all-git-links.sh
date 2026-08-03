#!/bin/bash

# Define the output file for storing remote URLs
output_file="git_remote_urls.txt"

# Find all directories (repositories) in the current directory
repositories=$(find . -maxdepth 2 -type d \( ! -name . \) \( -path ./ignore-folder -prune -o -path ./ignore-folder -prune \) -o -print)

# Loop through each repository's Git configuration file and extract remote origin URL
for config_file in $repositories; do
    # Extract the repository directory from the configuration file path
    git_dir="$config_file/.git"
    
    ## Extract remote origin URL
    remote_url=$(git --git-dir="$git_dir" config --get remote.origin.url)
    # Check if the remote origin URL is set
    if [ -n "$remote_url" ]; then
        echo $remote_url >> "$output_file"
    fi
done

echo "Remote origin URLs have been saved to $output_file"
