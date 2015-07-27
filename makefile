name = 3trees
contents = gfx lib sfx src vfx *.lua
output = bin
details = -v "1.1" -a "Sven Freiberg" -e "mail@svenfreiberg.de" -u "svenfreiberg.de/projects" -d "Little game based on the monty hall problem."

all: repack run

clean:
	rm -r "$(output)"/*

repack:
	zip -9qr "$(output)/$(name).love" $(contents)

run:
	love "$(output)/$(name).love"

release: release-win release-mac release-deb

release-win:
	love-release -W -t "$(name)" $(details) -r "$(output)" $(contents)

release-mac:
	love-release -M -t "$(name)" $(details) -r "$(output)" $(contents)

release-deb:
	love-release -D -t "$(name)" $(details) -r "$(output)" $(contents)
