gcloud compute instances create reddit-app  \
--boot-disk-size=10GB   \
--image=reddit-full-1522092062   \
--machine-type=g1-small   \
--tags puma-server   \
--restart-on-failure \

