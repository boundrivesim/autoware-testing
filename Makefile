cgalactic:
	docker build -t ghcr.io/bouncmpe/autoware-testing:galactic docker/galactic

cruntime:
	 DOCKER_BUILDKIT=1 docker build -t ghcr.io/bouncmpe/autoware-runtime:galactic docker/autoware-runtime

install:
	ansible-galaxy install -r requirements.yml --force

build: install
	ansible-playbook bouncmpe.autoware.build

.PHONY: install build