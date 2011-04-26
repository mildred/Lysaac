
redo-ifchange ../make.lip
find ../src ../lib ../stdlib -name "*.li" -print0 | xargs -0 redo-ifchange


mkdir -p cov
cd cov
lisaac ../../make.lip -coverage -o "`pwd`/lysaac" >&2 || exit 1
cd - >/dev/null
mv cov/lysaac "$3"

