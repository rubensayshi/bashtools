#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo must supply image to remove;
    exit 1;
fi;

get_image_children ()
{
    ret=()
    for i in $(docker image ls -a --no-trunc -q); do
        #>&2 echo processing image "$i";
        #>&2 echo parent is $(docker image inspect --format '{{.Parent}}' "$i")
        if [[ "$(docker image inspect --format '{{.Parent}}' "$i")" == "$1" ]]; then
            ret+=("$i");
        fi;
    done;
    echo "${ret[@]}";
}

realid=$(docker image inspect --format '{{.Id}}' "$1")
if [[ -z "$realid" ]]; then
    echo "$1 is not a valid image.";
    exit 2;
fi;
images_to_remove=("$realid");
images_to_process=("$realid");
while [[ "${#images_to_process[@]}" -gt 0 ]]; do
    children_to_process=();
    for i in "${!images_to_process[@]}"; do
        children=$(get_image_children "${images_to_process[$i]}");
        if [[ ! -z "$children" ]]; then
            # allow word splitting on the children.
            children_to_process+=($children);
        fi;
    done;
    if [[ "${#children_to_process[@]}" -gt 0 ]]; then
        images_to_process=("${children_to_process[@]}");
        images_to_remove+=("${children_to_process[@]}");
    else
        #no images have any children. We're done creating the graph.
        break;
    fi;
done;
echo images_to_remove = "$(printf %s\n "${images_to_remove[@]}")";
indices=(${!images_to_remove[@]});
for ((i="${#indices[@]}" - 1; i >= 0; --i)) ; do
    image_to_remove="${images_to_remove[indices[i]]}"
    if [[ "${image_to_remove:0:7}" == "sha256:" ]]; then
        image_to_remove="${image_to_remove:7}";
    fi
    echo removing image "$image_to_remove";
    docker rmi "$image_to_remove";
done

