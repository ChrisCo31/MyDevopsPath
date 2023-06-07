#!/bin/bash

# Steps 1 : Retrieve pods name
pods=$(oc get pods --no-headers | awk '{print $1}')

echo "Pods list before restart :"
echo "$pods"

# List of pods to exclude
excluded_pods=("pod1" "pod2")

# Step 2 : Creation of table with all pods
IFS=$'\n' read -rd '' -a pod_array <<< "$pods"

# Step 3 : Filter pods array exclusions
filtered_pods=("${pod_array[@]/"${excluded_pods[@]}"}")

# Step 4 : Shuffle filtered array elements randomly
shuffled_pods=($(shuf -e "${filtered_pods[@]}"))

# Variable to store names of restarted pods
restarted_pods=""

# Step 5 : Loop to restart all pods except exclude
for pod in "${shuffled_pods[@]}"; do
  oc rollout restart deployment/"$pod"
  restarted_pods+= " $pod"
done

# Display list of restarted pods
echo "list of restarted pods"
echo "$restarted_pods"
