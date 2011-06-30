redo-ifchange bin/lysaac.cov

if cucumber -f pretty -t @wip features >&2; then
  false
else
  true
fi

