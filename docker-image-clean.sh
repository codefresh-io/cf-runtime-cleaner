#!/bin/bash

function cleanDockerImages() {
	echo "Analyzing docker images for cleanup from the last ${CLEAN_PERIOD}..."
	images=$(docker images | tail -n +2 | cut -f 1 -d ' ' | sort | uniq)
	for image in ${images}; do
		if [ "${image}" == "<none>" ] || [[ "${image}" == "${PROTECTED_IMAGE_PREFIX}"* ]]; then
			echo "${image} ignored."
			continue
		fi

		tags=$(docker images ${image} | tail -n +2 | awk -F" " '{print$2}')
		for tag in ${tags}; do			
			echo "Checking image: ${image}:${tag} for events..."
			image_events=$(timeout 5s docker events --filter "image=${image}:${tag}" --since "${CLEAN_PERIOD}")
			if [ -z "${image_events}" ]; then
				echo "deleting ${image}:${tag}..."
				docker rmi ${image}:${tag}
			fi
		done
	done

	# Remove none images
	echo "Deleting all dangling images."
	docker rmi $(docker images -q --filter "dangling=true")
}

export -f cleanDockerImages
	
echo "Starting to clean images every ${CLEAN_INTERVAL}..."

while true
do
    cleanDockerImages
	echo "Going to sleep for ${CLEAN_INTERVAL}..."    
    sleep ${CLEAN_INTERVAL}
done