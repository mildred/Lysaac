redo-ifchange bin/lysaac.cov

rm -rf tmp

redo wip-tests
res1=$?

(
  cucumber -p tests --color
  res2=$?
  #| sed -r 's:^(\[31m)cucumber -p tests features/:\1redo features/:'

  test $res1 = 0 >&2 && test $res2 = 0 >&2

) >&2


