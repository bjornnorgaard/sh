echo "😎 Will approved succeeding PRs from dependabot"

dry_run=false
owner=bjornnorgaard

approve_pull_requests_for_repo() {
    repo=$1
    if [ -z "$repo" ]; then
        echo "No repo supplied"
        return
    fi

    pull_request_numbers=$(gh pr list --repo $owner/$repo --search "is:open is:pr -status:failure -review:approved author:app/dependabot" --json number --jq .[].number)

    if [ -z "$pull_request_numbers" ]; then
        echo "👌 No open PRs from dependabot to approve in $owner/$repo"
        return 0
    fi

    echo "Going through repo $repo"

    for number in $pull_request_numbers; do
        if [ "$dry_run" = false ]; then
            gh pr review $number --repo $owner/$repo --approve --body "@dependabot squash and merge"
        else
            echo "Would have approved $owner/$repo PR #$number"
        fi
    done
}
      
if [ "$dry_run" = true ]; then
    echo "Dry run enabled, no actions will be executed"
fi

echo "Fetching list of repositories owned by $owner"
repositories=$(gh repo list --json name --jq .[].name)
#repositories=akita

for repo in $repositories; do 
    approve_pull_requests_for_repo $repo &
done

echo "🚀 Done approving PRs from dependabot"
sleep 5s
