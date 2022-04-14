#!/bin/bash
#SBATCH --time=8:00:00
#SBATCH --signal=USR2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem 20000
#SBATCH --output=rstudio-server.job.%j
#SBATCH --mail-user=sco305@csiro.au
#SBATCH --mail-type=BEGIN

set -e

# usage: run_rstudio.sif <container>
# https://www.rocker-project.org/use/singularity/

if [ $# -eq 0 ]; then
	CONT='rocker/verse:latest'
else
	CONT=$1
fi

PORT=8788

# get tag from container
IFS=':'; arrCONT=($CONT); unset IFS;
if [ ${#arrCONT[@]} -eq 1 ]; then
	PULL="$CONT"
	SIF="$(basename $CONT)_latest.sif"
elif [ ${#arrCONT[@]} -eq 2 ]; then
	PULL=$CONT
	CONT=${arrCONT[0]}
	TAG=${arrCONT[1]}
    SIF="$(basename $CONT)_${TAG}.sif"
else
	echo "Didn't understand container name"
	exit 1
fi


echo "running rstudio in container ${SIF}"

# https://www.rocker-project.org/use/singularity/
# https://www.rc.virginia.edu/userinfo/howtos/rivanna/launch-rserver/

module load singularity


if [ ! -e ${SIF} ]; then
	echo "pulling container ${PULL} from docker hub"
	ssh petrichor-login "module load singularity; singularity pull ${PWD}/${SIF} docker://${PULL}"
fi

#TMPDIR=rstudio-tmp # your choice
TMDIR=$(python -c 'import tempfile; print(tempfile.mkdtemp())')

mkdir -p $TMPDIR/tmp/rstudio-server
uuidgen > $TMPDIR/tmp/rstudio-server/secure-cookie-key
chmod 600 $TMPDIR/tmp/rstudio-server/secure-cookie-key
mkdir -p $TMPDIR/var/{lib,run}
touch ${TMPDIR}/var/run/test
mkdir -p ${TMPDIR}/home

printf 'provider=sqlite\ndirectory=/var/lib/rstudio-server\n' > database.conf

echo "running rstudio on ${HOSTNAME} address 127.0.0.4, port ${PORT}"
echo "use ssh -L ${PORT}:127.0.0.4:${PORT} ${HOSTNAME}"

#export SINGULARITYENV_USER=$(id -un)
#export SINGULARITYENV_PASSWORD=$(openssl rand -base64 15)

echo "log in with username ${SINGULARITYENV_USER}, password ${SINGULARITYENV_PASSWORD}"

singularity exec \
    -B $TMPDIR/var/run:/var/run/rstudio-server \
    -B $TMPDIR/var/lib:/var/lib/rstudio-server \
    -B database.conf:/etc/rstudio/database.conf \
    -B $TMPDIR/tmp:/tmp \
    -B ${TMPDIR}/home:${HOME} \
    ${SIF} \
    rserver --www-address=127.0.0.4 --server-user=sco305 --www-port=${PORT}

#rserver --www-port=${PORT} \
#	--auth-none=0 \
#	--auth-pam-helper-path=pam-helper \
#	--auth-stay-signed-in-days=30 \
#	--auth-timeout-minutes=0 

#    rserver --www-address=127.0.0.4 --server-user=sco305 --www-port=${PORT}



