build: Dockerfile static/
	docker build --platform=linux/amd64 --tag corefast:latest .

run: build
	docker run \
  --platform=linux/amd64 \
  --rm \
  -ti \
  -v "$$(pwd)":"/site" \
  corefast:latest \
  bash render.sh

preview: run
	python -m http.server --cgi 8080 -d _site
