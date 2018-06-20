export clusterrank="global"
export mclimit=500
export ranksep=1

export colorize="source colors/gitter.vim"
vim osd_src.gv '+:source osd.vim | w !dot -Tsvg > docs/gitter.svg' '+:q!'
export colorize="source colors/custom.vim"
vim osd_src.gv '+:source osd.vim | w !dot -Tsvg > docs/custom.svg' '+:q!'


export clusterrank="local"
export mclimit=500
export ranksep=3

export colorize="source colors/gitter.vim"
vim osd_src.gv '+:source osd.vim | w !dot -Tsvg > docs/gitter_class.svg' '+:q!'
export colorize="source colors/custom.vim"
vim osd_src.gv '+:source osd.vim | w !dot -Tsvg > docs/custom_class.svg' '+:q!'
