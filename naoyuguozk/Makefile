include $(HOME)/proj/monolith/aliases.mk

#default: test.png
default: zhidaico.mp4

test.png: zhidaico.janet
	$(JANET) $<

zhidaico.scm: zhidaico.org
	worgle zhidaico.org

zhidaico.png zhidaico.wav zhidaico.h264: zhidaico.scm zhidaico.janet zhidaico.db
	$(MONOLITH) zhidaico.scm

zhidaico.mp3: zhidaico.wav
	lame --preset insane zhidaico.wav

zhidaico.mp4: zhidaico.mp3 zhidaico.h264
	ffmpeg -y -i zhidaico.mp3 -i zhidaico.h264 -c:v libx264 \
	 -crf 18 -preset veryslow -vf format=yuv420p -c:a copy zhidaico.mp4 

save: zhidaico.sqlite
zhidaico.sqlite:
	printf ".dump" | sqlite3 $< > $@

zhidaico.db: zhidaico.sqlite
	sqlite3 $@ < $<

clean:
	$(RM) zhidaico.mp4
	$(RM) zhidaico.mp3
	$(RM) zhidaico.wav
	$(RM) zhidaico.h264
	$(RM) zhidaico.scm
	$(RM) zhidaico.png
