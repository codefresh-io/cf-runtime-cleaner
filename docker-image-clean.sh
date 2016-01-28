#!/bin/bash

function cleanDockerImages() {
	echo "Analyzing docker images for cleanup from the last ${CLEAN_PERIOD}..."
	image_tag="${IMAGE_TAG}"
	images=$(docker images | tail -n +2 | cut -f 1 -d ' ')
	for image in ${images}; do
		if [ "${image}" == "<none>" ] || [[ "${image}" == "${PROTECTED_IMAGE_PREFIX}"* ]]; then
			echo "${image} ignored."
			continue
		fi
		echo "Checking image: ${image} for events..."
		image_events=$(timeout 5s docker events --filter "image=${image}:${image_tag}" --since "${CLEAN_PERIOD}")
		if [ -z "${image_events}" ]; then
			echo "deleting ${image}:${image_tag}..."
			docker rmi ${image}:${image_tag}
		fi
	done

	# Remove none images
	echo "Trying to delete all <none> images. Images with dependencies will not be deleted."
	docker rmi $(docker images -a | grep -i "<none>" | awk -F" " '{print$3}')
}

export -f cleanDockerImages
	
echo "Starting to clean images every ${CLEAN_INTERVAL}..."

while true
do
    cleanDockerImages
	echo "Going to sleep for ${CLEAN_INTERVAL}..."    
    sleep ${CLEAN_INTERVAL}
done