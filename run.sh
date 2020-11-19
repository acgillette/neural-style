APT_PACKAGES="apt-utils wget"
apt-install() {
	export DEBIAN_FRONTEND=noninteractive
	apt-get update -q
	apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" $APT_PACKAGES
	return $?
}

#install ffmpeg to container
apt-install || exit 1

#create folders
#! /bin/bash
mkdir data
cd data
mkdir bin
wget http://msvocds.blob.core.windows.net/coco2014/train2014.zip
unzip train2014.zip
cd ..


python neural_style/neural_style.py train --dataset data --cuda 1 \
  --save-model-dir artifacts --checkpoint-model-dir storage/checkpoints-flammarion \
  --style-image styles/FlammarionWoodcut-crop.png  \
  --epochs 2 --batch-size 14 --checkpoint-interval 2000 \
  --content-weight 1e5 --style-weight 1e10