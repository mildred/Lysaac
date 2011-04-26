
redo-ifchange ../make.lip
find ../src ../lib ../stdlib -name "*.li" -print0 | xargs -0 redo-ifchange

lisaac ../make.lip -partial -o "$3" >&2 || exit 1
mv "$3.c" "$3"

