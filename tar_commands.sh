# extract specific files from .tar.zstd using 3 CPUs
tar -I "zstd -T10 -3" -xvf <archive> <files>

# list files in in .tar.zstd using 3 cpus
tar -I "zstd -T10 -3" -tvf <archive>
