cd xuapanaos; sh render.sh; cd ..
cd shqfamauzk; sh render.sh; cd ..
cd naoyuguozk; sh render.sh; cd ..
cd xaothuthizk; sh render.sh; cd ..
cd xodayjao; sh render.sh; cd ..
cd fogozue; sh render.sh; cd ..

mkdir -p artifacts
rsync -Rrvt \
      xuapanaos/dy.png xuapanaos/dy.mp4 \
      shqfamauzk/vohzul.png shqfamauzk/vohzul.mp4 \
      naoyuguozk/zhidaico.png naoyuguozk/zhidaico.mp4 \
      xaothuthizk/memiv.png xaothuthizk/memiv.mp4 \
      xodayjao/vubeegok.png xodayjao/vubeegok.mp4 \
      fogozue/heesh.png fogozue/heesh.mp4 \
      artifacts
