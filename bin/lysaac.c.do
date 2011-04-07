
redo-ifchange ../make.lip
find ../src ../lib -name "*.li" -print0 | xargs -0 redo-ifchange

lisaac ../make.lip -partial -o "$3" >&2
mv "$3.c" "$3"

