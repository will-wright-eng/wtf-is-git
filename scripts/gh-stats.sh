#!/bin/bash

# Usage function to display help
usage() {
    echo "Usage: $0 [--dry-run] <owner1> [owner2] [...]"
    exit 1
}

# Check for dry run option
DRY_RUN=0
if [ "$1" == "--dry-run" ]; then
    DRY_RUN=1
    shift # Remove the first argument
fi

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    usage
fi

# Create a directory for results if it doesn't exist
mkdir -p "gh-stats-results"

# Loop through each provided owner
for OWNER in "$@"; do
    echo "Processing owner: $OWNER"
    OWNER_FILE="gh-stats-results/$OWNER-metadata.json"
    echo "[" > "$OWNER_FILE"  # Start JSON array

    # Fetch all repositories for the owner
    REPOS=$(gh repo list -L 200 $OWNER --json name --jq '.[].name')
    FIRST_REPO=1  # Flag to check if it's the first repository

    # Loop through each repository and fetch metadata
    for REPO in $REPOS; do
        echo "Fetching metadata for $REPO..."
        METADATA=$(gh repo view "$OWNER/$REPO" --json name,description,stargazerCount,forkCount,issues,pullRequests,createdAt,updatedAt,licenseInfo --jq '. | {name,description,stargazerCount,forkCount,issues,pullRequests,createdAt,updatedAt,licenseInfo}')

        # Check if dry run is enabled
        if [ $DRY_RUN -eq 1 ]; then
            echo "$METADATA"
        else
            # Append metadata to the owner's file
            if [ $FIRST_REPO -eq 0 ]; then
                echo "," >> "$OWNER_FILE"  # Prepend a comma if not the first repo
            else
                FIRST_REPO=0  # Set flag to 0 after processing the first repo
            fi
            echo "$METADATA" >> "$OWNER_FILE"
        fi
    done

    echo "]" >> "$OWNER_FILE"  # End JSON array
    if [ $DRY_RUN -eq 0 ]; then
        echo "Metadata for all repositories of $OWNER has been saved to $OWNER_FILE"
    fi
done