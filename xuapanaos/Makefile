include $(HOME)/proj/monolith/aliases.mk

default: dy.mp4

slab.scm: slab.org
	worgle slab.org

dy.wav dy.h264: slab.scm
	$(MONOLITH) slab.scm

dy.mp3: dy.wav
	lame --preset insane dy.wav

dy.mp4: dy.mp3 dy.h264
	ffmpeg -y -i dy.mp3 -i dy.h264 -vf format=yuv420p dy.mp4

clean:
	$(RM) dy.mp4 dy.mp3 dy.wav dy.h264 slab.scm dy.png
