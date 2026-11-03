#!/bin/bash

# GitHub Organization Repository Statistics Utility
# Usage: ./git-org-repos.sh [command] [organization_name] [options]

set -euo pipefail

source "$(dirname "$0")/utils.sh"

export_env_vars() {
    local env_file
    env_file=".env"

    if [[ ! -f "$env_file" ]]; then
        print_error "Environment file '$env_file' not found!"
        print_warning "Please create a .env file based on env.example"
        return 1
    fi

    print_success "Loading environment variables from $env_file"

    # Read .env file and export variables
    # This handles comments and empty lines properly
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip empty lines and comments
        if [[ -z "$line" ]] || [[ "$line" =~ ^[[:space:]]*# ]]; then
            continue
        fi

        # Export the variable
        eval "export $line"
        echo "Exported: ${line?}"
    done <"$env_file"

    print_success "Environment variables exported successfully!"
}

show_usage() {
    cat <<EOF
GitHub Organization Repository Statistics Utility

Usage: $0 [command] [organization_name] [options]

Commands:
    list                    List all repositories with basic info
    summary                 Show organization summary statistics
    languages               Analyze programming languages across repos
    activity                Show recent activity and engagement
    size                    Analyze repository sizes

    prs                     Show pull request statistics
    detailed                Show detailed repository information
    export                  Export data to JSON/CSV files
    help                    Show this help message

Options:
    --limit N              Limit number of repositories (default: 100)
    --output-dir DIR       Output directory for exports (default: ./results)
    --format FORMAT        Export format: json, csv (default: json)
    --private-only         Only show private repositories
    --public-only          Only show public repositories
    --sort-by FIELD        Sort by: name, stars, forks, updated, created, size
    --order ORDER          Sort order: asc, desc (default: desc)

Examples:
    $0 list my-org
    $0 summary my-org --limit 50
    $0 languages my-org --sort-by stars
    $0 activity my-org --private-only
    $0 export my-org --format csv --output-dir ./exports

EOF
}

get_repo_data() {
    local org_name="$1"
    local limit="${2:-$DEFAULT_LIMIT}"
    local fields="name,url,isPrivate,updatedAt,createdAt,description,primaryLanguage,stargazerCount,forkCount,issues,isArchived,isFork,isTemplate,defaultBranchRef"

    gh repo list "$org_name" --limit "$limit" --json "$fields"
}

list_repos() {
    local org_name="$1"
    local limit="${2:-$DEFAULT_LIMIT}"

    print_header "Fetching repositories for organization: $org_name"

    get_repo_data "$org_name" "$limit" |
        jq -r '.[] | "\(.name) - \(.url) (\(if .isPrivate then "private" else "public" end)) - \(.primaryLanguage.name // "N/A") - \(.stargazerCount) stars"'
}

show_summary() {
    local org_name="$1"
    local limit="${2:-$DEFAULT_LIMIT}"

    print_header "Organization Summary: $org_name"

    local data
    data=$(get_repo_data "$org_name" "$limit")

    local total_repos
    local public_repos
    local private_repos
    local total_stars
    local total_forks
    local total_issues
    local archived_repos
    local template_repos

    total_repos=$(echo "$data" | jq 'length')
    public_repos=$(echo "$data" | jq '[.[] | select(.isPrivate == false)] | length')
    private_repos=$(echo "$data" | jq '[.[] | select(.isPrivate == true)] | length')
    total_stars=$(echo "$data" | jq 'map(.stargazerCount) | add // 0')
    total_forks=$(echo "$data" | jq 'map(.forkCount) | add // 0')
    total_issues=$(echo "$data" | jq 'map(.issues.totalCount) | add // 0')
    archived_repos=$(echo "$data" | jq '[.[] | select(.isArchived == true)] | length')
    template_repos=$(echo "$data" | jq '[.[] | select(.isTemplate == true)] | length')

    echo "📊 Repository Statistics:"
    echo "   Total repositories: $total_repos"
    echo "   Public repositories: $public_repos"
    echo "   Private repositories: $private_repos"
    echo "   Archived repositories: $archived_repos"
    echo "   Template repositories: $template_repos"
    echo ""
    echo "⭐ Engagement Statistics:"
    echo "   Total stars: $total_stars"
    echo "   Total forks: $total_forks"
    echo "   Open issues: $total_issues"
    echo ""

    # Most starred repos
    echo "🏆 Top 5 Most Starred Repositories:"
    echo "$data" | jq -r 'sort_by(.stargazerCount) | reverse | .[0:5] | .[] | "   \(.name): \(.stargazerCount) stars"'
    echo ""

    # Most forked repos
    echo "🍴 Top 5 Most Forked Repositories:"
    echo "$data" | jq -r 'sort_by(.forkCount) | reverse | .[0:5] | .[] | "   \(.name): \(.forkCount) forks"'
}

analyze_languages() {
    local org_name="$1"
    local limit="${2:-$DEFAULT_LIMIT}"

    print_header "Language Analysis: $org_name"

    local data
    data=$(get_repo_data "$org_name" "$limit")

    echo "📈 Programming Languages Distribution:"
    echo "$data" | jq -r '
        group_by(.primaryLanguage.name) |
        map({language: .[0].primaryLanguage.name, count: length, repos: map(.name)}) |
        sort_by(.count) | reverse |
        .[] |
        "   \(.language // "Unknown"): \(.count) repositories"
    '
    echo ""

    echo "📋 Repositories by Language:"
    echo "$data" | jq -r '
        group_by(.primaryLanguage.name) |
        map({language: .[0].primaryLanguage.name, repos: map(.name)}) |
        sort_by(.language) |
        .[] |
        "   \(.language // "Unknown"): \(.repos | join(", "))"
    '
}

show_activity() {
    local org_name="$1"
    local limit="${2:-$DEFAULT_LIMIT}"

    print_header "Activity Analysis: $org_name"

    local data
    data=$(get_repo_data "$org_name" "$limit")

    echo "🕒 Recently Updated Repositories (last 30 days):"
    local thirty_days_ago
    thirty_days_ago=$(date -d '30 days ago' -u +%Y-%m-%dT%H:%M:%SZ)
    echo "$data" | jq -r --arg date "$thirty_days_ago" '
        .[] |
        select(.updatedAt > $date) |
        "   \(.name): updated \(.updatedAt | fromdateiso8601 | strftime("%Y-%m-%d"))"
    ' | head -10
    echo ""

    echo "📅 Repository Creation Timeline:"
    echo "$data" | jq -r '
        sort_by(.createdAt) |
        .[] |
        "   \(.name): created \(.createdAt | fromdateiso8601 | strftime("%Y-%m-%d"))"
    '
}

analyze_sizes() {
    local org_name="$1"
    local limit="${2:-$DEFAULT_LIMIT}"

    print_header "Repository Size Analysis: $org_name"

    print_warning "Note: Repository size analysis requires additional API calls and may take time."
    echo ""

    # This would require additional API calls to get actual repository sizes
    # For now, we'll show what we can with the available data
    echo "📊 Repository Types:"
    local data
    data=$(get_repo_data "$org_name" "$limit")

    local forks
    local originals
    local templates

    forks=$(echo "$data" | jq '[.[] | select(.isFork == true)] | length')
    originals=$(echo "$data" | jq '[.[] | select(.isFork == false)] | length')
    templates=$(echo "$data" | jq '[.[] | select(.isTemplate == true)] | length')

    echo "   Original repositories: $originals"
    echo "   Forked repositories: $forks"
    echo "   Template repositories: $templates"
}

show_detailed() {
    local org_name="$1"
    local limit="${2:-$DEFAULT_LIMIT}"

    print_header "Detailed Repository Information: $org_name"

    local data
    data=$(get_repo_data "$org_name" "$limit")

    echo "$data" | jq -r '
        .[] |
        "Repository: \(.name)\n" +
        "  URL: \(.url)\n" +
        "  Visibility: \(if .isPrivate then "private" else "public" end)\n" +
        "  Language: \(.primaryLanguage.name // "N/A")\n" +
        "  Stars: \(.stargazerCount)\n" +
        "  Forks: \(.forkCount)\n" +
        "  Issues: \(.issues.totalCount)\n" +
        "  Created: \(.createdAt | fromdateiso8601 | strftime("%Y-%m-%d"))\n" +
        "  Updated: \(.updatedAt | fromdateiso8601 | strftime("%Y-%m-%d"))\n" +
        "  Archived: \(.isArchived)\n" +
        "  Template: \(.isTemplate)\n" +
        "  Fork: \(.isFork)\n" +

        "  Description: \(.description // "No description")\n" +
        "  Default Branch: \(.defaultBranchRef.name // "N/A")\n" +
        "---"
    '
}

export_data() {
    local org_name="$1"
    local limit="${2:-$DEFAULT_LIMIT}"
    local format="${3:-json}"
    local output_dir="${4:-$OUTPUT_DIR}"

    print_header "Exporting Data: $org_name"

    # Create output directory
    mkdir -p "$output_dir"

    local data
    data=$(get_repo_data "$org_name" "$limit")

    if [[ "$format" == "json" ]]; then
        local output_file="$output_dir/${org_name}_repos.json"
        echo "$data" >"$output_file"
        print_success "Data exported to $output_file"
    elif [[ "$format" == "csv" ]]; then
        local output_file="$output_dir/${org_name}_repos.csv"
        echo "$data" | jq -r '
            ["name", "url", "isPrivate", "primaryLanguage", "stargazerCount", "forkCount", "openIssuesCount", "createdAt", "updatedAt", "isArchived", "isTemplate", "isFork", "description"] as $headers |
            $headers,
            (.[] | [
                .name,
                .url,
                .isPrivate,
                (.primaryLanguage.name // ""),
                .stargazerCount,
                .forkCount,
                .issues.totalCount,
                .createdAt,
                .updatedAt,
                .isArchived,
                .isTemplate,
                .isFork,

                (.description // "" | gsub("\n"; " "))
            ]) | @csv
        ' >"$output_file"
        print_success "Data exported to $output_file"
    else
        print_error "Unsupported format: $format"
        exit 1
    fi
}

main() {
    export_env_vars

    local command="${1:-help}"
    local org_name="${2:-$ORG_NAME}"
    local limit="$DEFAULT_LIMIT"
    local format="json"
    local output_dir="$OUTPUT_DIR"

    shift 2 2>/dev/null || true
    while [[ $# -gt 0 ]]; do
        case $1 in
            --limit)
                limit="$2"
                shift 2
                ;;
            --format)
                format="$2"
                shift 2
                ;;
            --output-dir)
                output_dir="$2"
                shift 2
                ;;
            --private-only | --public-only | --sort-by | --order)
                # These would be implemented for filtering/sorting
                shift 2
                ;;
            *)
                print_warning "Unknown option: $1"
                shift
                ;;
        esac
    done

    check_prerequisites

    case "$command" in
        list)
            list_repos "$org_name" "$limit"
            ;;
        summary)
            show_summary "$org_name" "$limit"
            ;;
        languages)
            analyze_languages "$org_name" "$limit"
            ;;
        activity)
            show_activity "$org_name" "$limit"
            ;;
        size)
            analyze_sizes "$org_name" "$limit"
            ;;
        prs)
            print_warning "Pull request analysis not yet implemented"
            ;;
        detailed)
            show_detailed "$org_name" "$limit"
            ;;
        export)
            export_data "$org_name" "$limit" "$format" "$output_dir"
            ;;
        help | --help | -h)
            show_usage
            ;;
        *)
            print_error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

main "$@"
