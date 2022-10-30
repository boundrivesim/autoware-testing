galactic:
	docker build -t ghcr.io/bouncmpe/autoware-testing:galactic docker/galactic

prebuilt:
	docker build -t ghcr.io/bouncmpe/autoware-prebuilt:galactic docker/autoware-prebuilt

runtime:
	 DOCKER_BUILDKIT=1 docker build -t ghcr.io/bouncmpe/autoware-runtime:galactic docker/autoware-runtime
