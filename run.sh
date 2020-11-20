
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
wget http://www.vlfeat.org/matconvnet/models/beta16/imagenet-vgg-verydeep-19.mat
mkdir bin
wget http://msvocds.blob.core.windows.net/coco2014/train2014.zip
wget http://msvocds.blob.core.windows.net/coco2014/val2014.zip

unzip train2014.zip
unzip val2014.zip

cd ..

#run style transfer on video
python neural_style/neural_style.py train --dataset data --cuda 1 \
--save-model-dir artifacts --checkpoint-model-dir artifacts \ --style-image styles/FlammarionWoodcut-crop.png \
--epochs 2 --checkpoint-interval 2000 \
--content-weight 1e5 --style-weight 1e10

