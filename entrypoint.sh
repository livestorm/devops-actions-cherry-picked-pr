#!/bin/sh -l

git_setup() {
  cat <<- EOF > $HOME/.netrc
		machine github.com
		login $GITHUB_ACTOR
		password $GITHUB_TOKEN
		machine api.github.com
		login $GITHUB_ACTOR
		password $GITHUB_TOKEN
EOF
  chmod 600 $HOME/.netrc

  git config --global user.email "$GITBOT_EMAIL"
  git config --global user.name "$GITHUB_ACTOR"
}

PR_BRANCH="production-$GITHUB_SHA"
MESSAGE=$(git log -1 $GITHUB_SHA | grep "AUTO" | wc -l)

if [[ $MESSAGE -gt 0 ]]; then
  echo "Autocommit, NO ACTION"
  exit 0
fi

PR_TITLE=$(git log -1 --format="%s" $GITHUB_SHA)
# Remove the PR ID suffix from the title
PR_TITLE_CLEANED=$(echo $PR_TITLE | sed 's/ (\#[0-9]*)//')

git_setup
git remote update
git fetch --all
git checkout -b "${PR_BRANCH}" origin/"${INPUT_PR_BRANCH}"
git cherry-pick "${GITHUB_SHA}"
git push -u origin "${PR_BRANCH}"
hub pull-request -b "${INPUT_PR_BRANCH}" -h "${PR_BRANCH}" -l "${INPUT_PR_LABELS}" -a "${GITHUB_ACTOR}" -m "\"${PR_TITLE_CLEANED}\""
