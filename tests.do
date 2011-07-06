redo-ifchange bin/lysaac.cov

res=0

redo wip-tests || res=$?

cucumber -f rerun -o reports/failed-features.txt -f html -o reports/features.html -f progress -t '~@wip' -t '~@future' features >&2
[ $? != 0 ] && res=$?

test $res = 0

