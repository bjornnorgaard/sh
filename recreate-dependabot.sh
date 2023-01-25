echo "😎 Will try to recreate PRs from dependabot"

owner=bjornnorgaard

approve_pull_requests_for_repo() {
    repo=$1
    if [ -z "$repo" ]; then
        echo "No repo supplied"
        return
    fi

    pull_request_numbers=$(gh pr list --repo $owner/$repo --search "is:open is:pr status:failure author:app/dependabot" --json number --jq .[].number)

    if [ -z "$pull_request_numbers" ]; then
        echo "👌 No open PRs from dependabot to approve in $owner/$repo"
        return 0
    fi

    echo "Going through repo $repo"

    for number in $pull_request_numbers; do
        gh pr review $number --repo $owner/$repo --comment -b "@dependabot recreate"
    done
}

echo "Fetching list of repositories owned by $owner"
repositories=$(gh repo list --json name --jq .[].name)
#repositories=akita

for repo in $repositories; do 
    approve_pull_requests_for_repo $repo &
done

echo "Waiting for all tasks to complete..."
wait
echo "🚀 Recreates initiated for dependabot PRs"
