#SLURM
alias squeue="date; squeue -u $USER"

# scripts
export PATH="/home/sco305/scripts:$PATH"

# Makes the prompt much more user friendly
export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\$ '

#IGV
#alias igv="java -Xmx750m -jar /apps/igv/2.4.14/igv.jar"


# google cloud requires python 2.7 or 3.5+
export CLOUDSDK_PYTHON=/usr/bin/python


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/datasets/work/hb-viralint/work/google-cloud-sdk/path.bash.inc' ]; then . '/datasets/work/hb-viralint/work/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/datasets/work/hb-viralint/work/google-cloud-sdk/completion.bash.inc' ]; then . '/datasets/work/hb-viralint/work/google-cloud-sdk/completion.bash.inc'; fi




# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/scratch1/sco305/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/scratch1/sco305/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/scratch1/sco305/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/scratch1/sco305/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

