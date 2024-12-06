$branch = "jq/add-base-code"

# Create a new branch
git branch $branch
git checkout $branch

# Stage/Commit/Push
$commitMessage = "Fix git cheat to add merge"
git add .
git commit -m $commitMessage
git push --set-upstream origin $branch

# Direct merge in main
git checkout main
git merge $branch --no-ff
git push main
git branch -D $branch
git push :$branch

# Cleanup
git checkout main
git fetch --prune
git pull
git branch -D $branch
