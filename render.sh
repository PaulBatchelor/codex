function render {
cd $1
if [[ $? -ne 0 ]]
then
    exit 1
fi
sh render.sh
if [[ $? -ne 0 ]]
then
    cd ..
    exit 1
fi
cd ..
}

render xuapanaos
render shqfamauzk
render naoyuguozk
render xaothuthizk
render xodayjao
render fogozue
render magopau
render siigolue
render taogoryxs
render qipacal
