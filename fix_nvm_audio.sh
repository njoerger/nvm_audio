#!/bin/bash

if [ "$1" == -i ]; then
	echo "Attempting to use supplied file"
	if [[ -e "$2" && -f "$2" && -r "$2" && -s "$2" ]]; then
		# get hash and save to /tmp/audio_hash
		shasum -a 512 $2 | awk '{print $1}' > /tmp/audio_hash
		# cp file to /tmp/audio_hash
		cp $2 /tmp/audio.mp3
	else
		(>&2 echo "usage: ./fix_nvm_audio.sh or ./fix_nvm_audio.sh -i /path/to/audio")
		(>&2 echo "Either the file does not exist, is not readable or is not executable")
		exit -97
	fi 
else
	echo "Downloading audio file"
	$(curl -s https://raw.githubusercontent.com/njoerger/nvm_audio/master/nvm_audio.mp3 --output /tmp/audio.mp3)
	$(curl -s https://raw.githubusercontent.com/njoerger/nvm_audio/master/audio_hash --output /tmp/audio_hash)
fi

chmod 600 /tmp/audio.mp3

echo "Checking the audio file is correct"
if [[ $(shasum -a 512 /tmp/audio.mp3 | awk '{print $1}') == $(cat /tmp/audio_hash) ]]; then
	echo "Audio file was correct. Placing audio file in the right location"
	cp /tmp/audio.mp3 ~/Library/Application\ Support/Google/Chrome/Default/Extensions/jahbgfelgdkpjhbcggnkfglaldkhodmi/$(ls ~/Library/Application\ Support/Google/Chrome/Default/Extensions/jahbgfelgdkpjhbcggnkfglaldkhodmi | tail -n 1)/dist/mp3/primaryRingtone.mp3
	cp /tmp/audio.mp3 ~/Library/Application\ Support/Google/Chrome/Default/Extensions/jahbgfelgdkpjhbcggnkfglaldkhodmi/$(ls ~/Library/Application\ Support/Google/Chrome/Default/Extensions/jahbgfelgdkpjhbcggnkfglaldkhodmi | tail -n 1)/dist/mp3/secondaryRingtone.mp3

	if [[ $(shasum -a 512 ~/Library/Application\ Support/Google/Chrome/Default/Extensions/jahbgfelgdkpjhbcggnkfglaldkhodmi/$(ls ~/Library/Application\ Support/Google/Chrome/Default/Extensions/jahbgfelgdkpjhbcggnkfglaldkhodmi/ | tail -n 1)/dist/mp3/primaryRingtone.mp3 | awk '{print $1}') == $(cat /tmp/audio_hash) && $(shasum -a 512 ~/Library/Application\ Support/Google/Chrome/Default/Extensions/jahbgfelgdkpjhbcggnkfglaldkhodmi/$(ls ~/Library/Application\ Support/Google/Chrome/Default/Extensions/jahbgfelgdkpjhbcggnkfglaldkhodmi/ | tail -n 1)/dist/mp3/secondaryRingtone.mp3 | awk '{print $1}') == $(cat /tmp/audio_hash)  ]]; then
		echo "Move was successful. Please restart the extension"
		exit 0
	else
		(>&2 echo "The files did not copy right, please try again")
		exit -98
	fi

else
	(>&2 echo "File hash wrong, please make sure there are no upstream issues or process on this machine affecting the download")
	exit -99
fi
