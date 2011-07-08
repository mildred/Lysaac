redo-ifchange bin/lysaac.cov

cucumber -p wip --color | sed -r 's:^(\[31m)cucumber -p wip features/:\1redo features/:' >&2

