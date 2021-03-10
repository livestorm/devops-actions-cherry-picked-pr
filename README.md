# Github Action: Cherry-Pick & Create PR

## Inputs

#### `pr_branch`

**Required** The branch name of on which PR should be created from the cherry-pick commit.

#### `pr_labels`

CSV Labels to apply on the PR created. Default: `PRODUCTION`

## Example usage

In this example, all the merges to the branch `master` will create a PR on `production` branch too.

```
name: PR for release branch
on:
  push:
    branches:
      - master
jobs:
  release_pull_request:
    runs-on: ubuntu-latest
    name: release_pull_request
    steps:
    - name: checkout
      uses: actions/checkout@v1
    - name: Create PR to branch
      uses: livestorm/devops-actions-cherry-picked-pr@master
      with:
        pr_branch: 'production'
        pr_label: 'PRODUCTION'
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        GITBOT_EMAIL: <BOT_EMAIL>
        DRY_RUN: false
```
