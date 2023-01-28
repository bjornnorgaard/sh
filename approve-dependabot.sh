echo "😎 Will approved succeeding PRs from dependabot"

owner=bjornnorgaard

approve_pull_requests_for_repo() {
    repo=$1
    if [ -z "$repo" ]; then
        echo "❌ No repo supplied, exiting"
        return
    fi

    pull_request_numbers=$(gh pr list --repo $owner/$repo --search "is:open is:pr -status:failure -review:approved author:app/dependabot" --json number --jq .[].number)

    if [ -z "$pull_request_numbers" ]; then
        return 0
    fi

    echo "👀 Checking PRs of $repo"

    for number in $pull_request_numbers; do
            gh pr review $number --repo $owner/$repo --approve --body "@dependabot squash and merge" &>/dev/null
            echo "✅ Approved $owner/$repo #$number"
    done
}

echo "Fetching list of repositories owned by $owner"
repositories=$(gh repo list --json name --jq .[].name)
#repositories=akita

for repo in $repositories; do 
    approve_pull_requests_for_repo $repo &
done

wait

echo "🚀 Done approving PRs from dependabot"
