#!/bin/sh

# Welcome message
echo "The most amazing audio file splitter!"

# Check whether SoX is installed
command -v sox >/dev/null 2>&1 || { echo >&2 "This script requires SoX. Please install it and try again."; exit 1; }

# Check whether all the necessary arguments are provided
if [ "$#" -lt 5 ] || [ "$1" != "-s" ] || [ "$3" != "-d" ]; then
    echo >&2 "Usage: split -s STEP -d OUTDIR FILES"
    exit 1
fi

step="$2"
outdir=$(dirname "$4")"/"$(basename "$4") # Works whether there is a / in the end or not

# Create the output directory if it does not exist
if [ ! -d "$outdir" ]; then
  mkdir "$outdir"
fi

# Prepare variables for outputting percentage 
let nfiles="$#"-4
let current=0

printf "Splitting... 0%%\r"

# Generate the splits for each file
for file in "${@:5}"; do
    filename=$(basename "$file")
    extension="${filename##*.}"
    filename="${filename%.*}"

    sox "$file" "$outdir""/""$filename""_.""$extension" trim 0 "$step" : newfile : restart > /dev/null 2>&1 # So that the EOF warning does not show up

    let current="$current"+1
    let percentage=100*"$current"/"$nfiles"

    printf "Splitting... $percentage%%\r"
done

# Termination messages
echo "Splitting... 100%"
echo "Done!"
