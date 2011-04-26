redo-ifchange bin/lysaac.cov

cucumber -f rerun -o reports/failed-features.txt -f html -o reports/features.html -f progress features >&2

