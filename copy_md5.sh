#!/bin/bash

#https://superuser.com/questions/302842/resume-rsync-over-ssh-after-broken-connection
#https://unix.stackexchange.com/questions/48298/can-rsync-resume-after-being-interrupted
#https://ss64.com/bash/rsync_options.html

SRC=$1
DST=$2

# check that DST is a directory that exists
if [ -d $DST ]; then
	echo "copying to $DST"
else
	echo "creating directory $DST to copy file to"
	mkdir -p $DST
fi

SRCBASE="$(basename $SRC)"
DSTBASE="$(basename $DST)"
SRCDIR="$(dirname $SRC | xargs realpath)"
DSTDIR="$(realpath $DST)"

# make checksums
SRCSUM="${SRC}.md5"
DSTSUM="${DSTDIR}/${SRCSUM}"
md5sum $SRC > "${SRCSUM}" &
SUMID=$!

cd $SRCDIR

while [ 1 ]
do
	rsync -azv "--partial-dir=.rsync-partial_${DST}" --progress $SRC $DST

	if [ "$?" = "0" ] ; then
		echo "rsync completed normally"
        
		# check checksums
		wait $SUMID
		rsync -av "${SRCSUM}" "${DSTDIR}"
		
		#rm "${SRCSUM}"
		cd $DSTDIR
		md5sum -c "${DSTSUM}" --strict
		if [ "$?" = "0" ]; then
			exit
	
		else
			echo "checksums incorrect!"
			rm "${DST}" "${SRCSUM}" "${DSTSUM}"
			cd "${SRCDIR}"
			copy_md5.sh ${SRC} ${DST}
		fi
		exit
    else
        echo "Rsync failure. Waiting for 60 seconds..."
        sleep 60
        echo "Retrying..."
    fi
done
