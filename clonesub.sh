#!/usr/bin/env bash

# Clones a specific subfolder from a Git repository branch using sparse checkout.

# Usage: ./clonesub.sh <repo_url> <branch> <folder_path> [target_dir]
#   <repo_url>: The URL of the Git repository.
#   <branch>: The branch name to clone from.
#   <folder_path>: The path to the subfolder within the repository.
#   [target_dir]: (Optional) The local directory name to clone into. Defaults to the base name of the folder_path.

set -e # Exit immediately if a command exits with a non-zero status.

# --- Configuration ---
REPO_URL="$1"
BRANCH_NAME="$2"
FOLDER_PATH="$3"
TARGET_DIR="${4:-$(basename "$FOLDER_PATH")}" # Use provided target dir or derive from folder path

# --- Input Validation ---
if [ -z "$REPO_URL" ] || [ -z "$BRANCH_NAME" ] || [ -z "$FOLDER_PATH" ]; then
  echo "Usage: $0 <repo_url> <branch> <folder_path> [target_dir]"
  exit 1
fi

# --- Check for Git ---
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed."
    exit 1
fi

# --- Clone Process ---
echo "Cloning folder '$FOLDER_PATH' from branch '$BRANCH_NAME' of '$REPO_URL' into '$TARGET_DIR'..."

# Create target directory and initialize git
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"
git init -q
git remote add origin "$REPO_URL"

# Enable sparse checkout
git config core.sparseCheckout true

# Define the folder to checkout
# Ensure the path doesn't start with / and ends with /* for directories
CLEANED_FOLDER_PATH=$(echo "$FOLDER_PATH" | sed 's#^/*##' | sed 's#/*$##')
echo "$CLEANED_FOLDER_PATH/*" > .git/info/sparse-checkout
# If you need files directly within the folder (not just sub-items), add the folder itself:
# echo "$CLEANED_FOLDER_PATH" >> .git/info/sparse-checkout

echo "Fetching branch '$BRANCH_NAME' (shallow)..."
# Pull only the specified branch, depth 1 for efficiency
git pull --depth=1 origin "$BRANCH_NAME"

# Optional: If you want to remove the .git directory after cloning
# rm -rf .git

echo "Successfully cloned '$FOLDER_PATH' to '$TARGET_DIR'."
cd .. # Go back to the original directory

exit 0
