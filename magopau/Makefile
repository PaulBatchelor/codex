include $(MONOLITH_HOME)/aliases.mk

IDENTITY=cuw

.PHONY: test
test:
	$(JANET) cuw.janet

#default: $(IDENTITY).mp4
#
#test.png: $(IDENTITY).janet
#	$(JANET) $<
#
#$(IDENTITY).scm: $(IDENTITY).org
#	worgle $(IDENTITY).org
#
#$(IDENTITY).png $(IDENTITY).wav $(IDENTITY).h264: $(IDENTITY).scm $(IDENTITY).janet
#	$(MONOLITH) $(IDENTITY).scm
#
#$(IDENTITY).mp3: $(IDENTITY).wav
#	lame --preset insane $(IDENTITY).wav
#
#$(IDENTITY).mp4: $(IDENTITY).mp3 $(IDENTITY).h264
#	ffmpeg -y -i $(IDENTITY).mp3 -i $(IDENTITY).h264 -c:v libx264 \
#	 -crf 18 -preset veryslow -vf format=yuv420p -c:a copy $(IDENTITY).mp4 
#
#clean:
#	$(RM) $(IDENTITY).mp4
#	$(RM) $(IDENTITY).mp3
#	$(RM) $(IDENTITY).wav
#	$(RM) $(IDENTITY).h264
#	$(RM) $(IDENTITY).scm
#	$(RM) $(IDENTITY).png
