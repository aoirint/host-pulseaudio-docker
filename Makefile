ROOT_DIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))
FILE=/audio/One Day_20210315.ogg

build:
	docker build . -t aoirint/pulseaudio

run: build
	docker run --rm -it \
		--group-add "$(shell getent group audio | cut -d: -f3)" \
		-e "PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native" \
		-v "${XDG_RUNTIME_DIR}/pulse/native/:${XDG_RUNTIME_DIR}/pulse/native" \
		-v "${HOME}/.config/pulse/cookie:/pulseaudio/cookie" \
		-e "HOST_UID=$(shell id -u)" \
		-e "HOST_GID=$(shell id -g)" \
		-v "$(ROOT_DIR)/audio:/audio" \
		aoirint/pulseaudio \
		paplay "$(FILE)"

