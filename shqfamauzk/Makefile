include $(MONOLITH_HOME)/aliases.mk

#default: test.png
default: vohzul.mp4

test.png: vohzul.janet
	$(JANET) $<

vohzul.scm: vohzul.org
	worgle vohzul.org

vohzul.png vohzul.wav vohzul.h264: vohzul.scm vohzul.janet
	$(MONOLITH) vohzul.scm

vohzul.mp3: vohzul.wav
	lame --preset insane vohzul.wav

vohzul.mp4: vohzul.mp3 vohzul.h264
	ffmpeg -y -i vohzul.mp3 -i vohzul.h264 -vf format=yuv420p vohzul.mp4

clean:
	$(RM) vohzul.mp4
	$(RM) vohzul.mp3
	$(RM) vohzul.wav
	$(RM) vohzul.h264
	$(RM) vohzul.scm
	$(RM) vohzul.png
