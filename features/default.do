cd ..
redo-ifchange bin/lysaac.cov

cucumber --color -r features "features/$1" | sed -r 's:^(\[31m)cucumber features/:\1redo features/:' >&2

