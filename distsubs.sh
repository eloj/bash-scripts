#
# Distribute Subs based on 'standard' scene format, where
# there's a separate Subs directory in which there's one directory
# per video file, named the same as the video file sans the extension,
# which contains the subtitles.
#
#!/bin/bash
for f in ./*.mp4; do
	base=${f%%.mp4}
	subpath=Subs/${base}/
	if [ ! -d ${subpath} ]; then
		echo "WARNING: Subtitle path '${subpath}' not found."
		continue
	fi

	# One day we'll do something nicer. Not today though.
	if [ -e "${subpath}/6_English.srt" ]; then
		cp "${subpath}/6_English.srt" "${base}.srt"
	elif [ -e "${subpath}/5_English.srt" ]; then
		cp "${subpath}/5_English.srt" "${base}.srt"
	elif [ -e "${subpath}/4_English.srt" ]; then
		cp "${subpath}/4_English.srt" "${base}.srt"
	elif [ -e "${subpath}/3_English.srt" ]; then
		cp "${subpath}/3_English.srt" "${base}.srt"
	elif [ -e "${subpath}/2_English.srt" ]; then
		cp "${subpath}/2_English.srt" "${base}.srt"
	else
		echo "WARNING: No subtitles found in ${subpath}!"
	fi
done
