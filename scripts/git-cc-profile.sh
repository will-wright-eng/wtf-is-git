#!/bin/bash

# Function to get stats of a git repository
get_git_stats() {
    local echo_prefix="--"
    echo "----------------------------------------"
    echo "Stats for Git repository: $1"
    cd $1

    # Total number of commits
    total_commits=$(git rev-list --all --count)
    echo "$echo_prefix Total number of commits: $total_commits"

    # Total number of branches
    total_branches=$(git branch -r | wc -l | tr -d '[:space:]')
    echo "$echo_prefix Total number of branches: $total_branches"

    # Total number of tags
    total_tags=$(git tag | wc -l | tr -d '[:space:]')
    echo "$echo_prefix Total number of tags: $total_tags"

    # Total lines of code
    total_loc=$(git ls-files | wc -l | tail -n 1 | awk '{print $1}')
    echo "$echo_prefix Total lines of code: $total_loc"

    # Total number of files
    total_files=$(git ls-files | wc -l | tr -d '[:space:]')
    echo "$echo_prefix Total number of files: $total_files"

    # Top 10 contributors
    echo "$echo_prefix Top 10 contributors:"
    git shortlog -sn --all | head -10

    # Content of the cookiecutter.json file
    if [ -f "cookiecutter.json" ]; then
        echo "$echo_prefix Content of the cookiecutter.json file:"
        cat cookiecutter.json
        echo
    else
        echo "No cookiecutter.json file found in this repository."
    fi

    # # Content of the pyproject.toml or requirements.txt file
    # for file in $(find . -name 'pyproject.toml' -o -name 'requirements.txt'); do
    #     echo "$echo_prefix Content of the $file file:"
    #     cat $file
    # done

    cd - > /dev/null
    echo "----------------------------------------"
}

# Function to check if a directory is a git repository
is_git_repo() {
    if [ -d "$1/.git" ]; then
        get_git_stats $1
    fi
}

# Function to crawl the current directory and its subdirectories
crawl_directory() {
    for dir in $(find . -type d); do
        is_git_repo $dir
    done
}

# Call the crawl_directory function
crawl_directory
