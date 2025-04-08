# git-bot dev notes

## ideal state workflow

1. `git bot init`: generate repo data in repo root and add csv names to .gitignore
2. `git bot ask`: ask git-bot questions about the repo with data context

## flags

### init

- include options for combinations of data tables to include as context

### ask

- pass `sgpt` flags

*OR*

- fork `sgpt` and add git-bot features


## notes

```bash
cp **/*.csv data/
```

# gh-stats

## bash

```bash
gh org list
bash scripts/gh-stats.sh will-wright-eng < org > < org > < org >
```

## gh metadata fields

```bash
export OWNER=will-wright-eng
export REPO=wtf-is-git
gh repo view "$OWNER/$REPO" --json name,description,stargazerCount,forkCount,issues,pullRequests,createdAt,updatedAt,licenseInfo --jq '. | {name,description,stargazerCount,forkCount,issues,pullRequests,createdAt,updatedAt,licenseInfo}' > tmp

Available fields:
  assignableUsers
  codeOfConduct
  contactLinks
  createdAt
  defaultBranchRef
  deleteBranchOnMerge
  description
  diskUsage
  forkCount
  fundingLinks
  hasDiscussionsEnabled
  hasIssuesEnabled
  hasProjectsEnabled
  hasWikiEnabled
  homepageUrl
  id
  isArchived
  isBlankIssuesEnabled
  isEmpty
  isFork
  isInOrganization
  isMirror
  isPrivate
  isSecurityPolicyEnabled
  isTemplate
  isUserConfigurationRepository
  issueTemplates
  issues
  labels
  languages
  latestRelease
  licenseInfo
  mentionableUsers
  mergeCommitAllowed
  milestones
  mirrorUrl
  name
  nameWithOwner
  openGraphImageUrl
  owner
  parent
  primaryLanguage
  projects
  projectsV2
  pullRequestTemplates
  pullRequests
  pushedAt
  rebaseMergeAllowed
  repositoryTopics
  securityPolicyUrl
  squashMergeAllowed
  sshUrl
  stargazerCount
  templateRepository
  updatedAt
  url
  usesCustomOpenGraphImage
  viewerCanAdminister
  viewerDefaultCommitEmail
  viewerDefaultMergeMethod
  viewerHasStarred
  viewerPermission
  viewerPossibleCommitEmails
  viewerSubscription
  visibility
  watchers
```
