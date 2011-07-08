redo-ifchange bin/lysaac.cov

res=0

redo wip-tests || res=$?

cucumber -p tests --color | sed -r 's:^(\[31m)cucumber -p tests features/:\1redo features/:' >&2
[ $? != 0 ] && res=$?

test $res = 0

