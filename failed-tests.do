redo-ifchange bin/lysaac.cov
redo-ifchange reports/failed-features.txt

cucumber @reports/failed-features.txt --color -f pretty features >&2

