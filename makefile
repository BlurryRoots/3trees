name = 3Doors

all: repack run

repack:
	rm -f bin/$(name).love
	zip -9qr bin/$(name).love gfx lib sfx src vfx *.lua

run:
	love bin/$(name).love
