# Documentation
# https://docs.gitlab.com/ce/api/projects.html#list-projects

NAMESPACE="privacyblockchain"
BASE_PATH="https://gitlab.com/"
PROJECT_SELECTION="select(.path_with_namespace | startswith(\"$NAMESPACE\"))"
PROJECT_PROJECTION="{ \"path_with_namespace\": .path_with_namespace, \"path\": .path, \"git\": .ssh_url_to_repo }"

if [ -z "$GITLAB_PRIVATE_TOKEN" ]; then
    echo "Please set the environment variable GITLAB_PRIVATE_TOKEN"
    echo "See ${BASE_PATH}profile/account"
    exit 1
fi

FILENAME="repos.json"

trap "{ rm -f $FILENAME; }" EXIT

curl -s "${BASE_PATH}api/v4/projects?private_token=$GITLAB_PRIVATE_TOKEN&membership=true&per_page=999" \
    | jq --raw-output --compact-output ".[] | $PROJECT_SELECTION | $PROJECT_PROJECTION" > "$FILENAME"

while read repo; do
    THEPATH=$(echo "$repo" | jq -r ".path_with_namespace")
    GIT=$(echo "$repo" | jq -r ".git")
    
    if [ ! -d "$THEPATH" ]; then
    	mkdir -p "$THEPATH"
        echo "Cloning $THEPATH ( $GIT )"
        git clone "$GIT" "$THEPATH" --quiet &
    else
        echo "Pulling $THEPATH"
        (cd "$THEPATH" && git pull --quiet) &
    fi
done < "$FILENAME"

wait