#!/bin/bash

$(curl https://raw.githubusercontent.com/njoerger/nvm_audio/master/nvm_audio.mp3 --output /tmp/audio.mp3)
$(curl https://raw.githubusercontent.com/njoerger/nvm_audio/master/audio_hash --output /tmp/audio_hash)

shasum -a 512 /tmp/audio.mp3 | awk '{print $1}'

if [[ $(shasum -a 512 /tmp/audio.mp3 | awk '{print $1}') == $(cat /tmp/audio_hash) ]]; then
	cp /tmp/audio.mp3 ~/Library/Application\ Support/Google/Chrome/Default/Extensions/jahbgfelgdkpjhbcggnkfglaldkhodmi/$(ls ~/Library/Application\ Support/Google/Chrome/Default/Extensions/jahbgfelgdkpjhbcggnkfglaldkhodmi | tail -n 1)/dist/mp3/primaryRingtone.mp3
	cp /tmp/audio.mp3 ~/Library/Application\ Support/Google/Chrome/Default/Extensions/jahbgfelgdkpjhbcggnkfglaldkhodmi/$(ls ~/Library/Application\ Support/Google/Chrome/Default/Extensions/jahbgfelgdkpjhbcggnkfglaldkhodmi | tail -n 1)/dist/mp3/secondaryRingtone.mp3

	if [[ $(shasum -a 512 ~/Library/Application\ Support/Google/Chrome/Default/Extensions/jahbgfelgdkpjhbcggnkfglaldkhodmi/$(ls ~/Library/Application\ Support/Google/Chrome/Default/Extensions/jahbgfelgdkpjhbcggnkfglaldkhodmi/ | tail -n 1)/dist/mp3/primaryRingtone.mp3 | awk '{print $1}') == $(cat /tmp/audio_hash) && $(shasum -a 512 ~/Library/Application\ Support/Google/Chrome/Default/Extensions/jahbgfelgdkpjhbcggnkfglaldkhodmi/$(ls ~/Library/Application\ Support/Google/Chrome/Default/Extensions/jahbgfelgdkpjhbcggnkfglaldkhodmi/ | tail -n 1)/dist/mp3/secondaryRingtone.mp3 | awk '{print $1}') == $(cat /tmp/audio_hash)  ]]; then
		echo "Please restart the extensions"
		exit 0
	else
		(>&2 echo "The files did not copy right, please try again")
		exit -99
	fi

else
	(>&2 echo "File hash wrong")
	exit -99
fi
