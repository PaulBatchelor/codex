mitireez.mp4: mitireez.scm translate.scm score.db
	../codex mitireez.scm
	../combine.sh mitireez_tmp.mp4 mitireez.wav mitireez.mp4
	convert mitireez.ppm mitireez.png

score.db: score.txt
	mnotil txt2cdb $< $@

clean:
	$(RM) mitireez.mp4 mitireez.h264 mitireez.wav mitireez.png mitireez_tmp.mp4
