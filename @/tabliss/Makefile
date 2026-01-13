build: icons
	python3 -m tabliss

icons: data/icons.json
	python3 -m tabliss.generate-icons

data/icons.json:
	curl -L \
		-H "Accept: application/vnd.github.object" \
		-H "X-GitHub-Api-Version: 2022-11-28" \
		https://api.github.com/repos/feathericons/feather/contents/icons > icons.json
