# wtf-is-git

## git from scratch

- [Scripting with Go: a 400-line Git client that can create a repo and push itself to GitHub](https://benhoyt.com/writings/gogit/)
- [pygit: Just enough of a Git client to create a repo, commit, and push itself to GitHub](https://benhoyt.com/writings/pygit/)

## features

- [Learn to use email with git!](https://git-send-email.io/)
- [Organizing multiple Git identities | Garrit's Notes](https://garrit.xyz/posts/2023-10-13-organizing-multiple-git-identities)
- [TIL: man {gittutorial,giteveryday,gitglossary,gitworkflows} | Hacker News](https://news.ycombinator.com/item?id=38124845)
- [My favourite Git commit | dhwthompson.com](https://dhwthompson.com/2019/my-favourite-git-commit)

## analyses

- [What is in that .git directory?](https://blog.meain.io/2023/what-is-in-dot-git/)
- [In a git repository, where do your files live?](https://jvns.ca/blog/2023/09/14/in-a-git-repository--where-do-your-files-live-/)
- [Committing without git | Matheus Tavares](https://matheustavares.gitlab.io/posts/committing-without-git)

## creative projects

- [Dotfiles Management - mitxela.com](https://mitxela.com/projects/dotfiles_management)
- [Using Git offline](https://www.gibbard.me/using_git_offline/)

## extending git

- [Extending Git functionality - Stack Overflow](https://stackoverflow.com/questions/10978257/extending-git-functionality)
- [How To Use Git Hooks To Automate Development and Deployment Tasks | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-use-git-hooks-to-automate-development-and-deployment-tasks)
- [tummychow/git-absorb: git commit --fixup, but automatic](https://github.com/tummychow/git-absorb)

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
