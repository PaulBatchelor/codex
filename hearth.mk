IDENTITY_FILES= \
	$(IDENTITY).mp4 \
	$(IDENTITY).mp3 \
	$(IDENTITY).wav \
	$(IDENTITY).h264 \
	$(IDENTITY).scm \
	$(IDENTITY).png

$(IDENTITY).scm: $(IDENTITY).org
	worgle $(IDENTITY).org

$(IDENTITY).png $(IDENTITY).wav $(IDENTITY).h264: $(IDENTITY).scm $(IDENTITY).janet
	$(MONOLITH) $(IDENTITY).scm

$(IDENTITY).mp3: $(IDENTITY).wav
	lame --preset insane $(IDENTITY).wav

$(IDENTITY).mp4: $(IDENTITY).mp3 $(IDENTITY).h264
	ffmpeg -y -i $(IDENTITY).mp3 -i $(IDENTITY).h264 -c:v libx264 \
	 -crf 18 -preset veryslow -vf format=yuv420p -c:a copy $(IDENTITY).mp4 
