export clusterrank="global"
export mclimit=500
export ranksep=1

export colorize="source colors/gitter.vim"
vim osd_src.gv '+:source osd.vim | w !dot -Tsvg > docs/gitter.svg' '+:q!'
export colorize="source colors/osd.vim"
vim osd_src.gv '+:source osd.vim | w !dot -Tsvg > docs/osd.svg' '+:q!'
export colorize="source colors/osdgl.vim"
vim osdgl_src.gv '+:source osd.vim | w !dot -Tsvg > docs/osdgl.svg' '+:q!'


export clusterrank="local"
export mclimit=500
export ranksep=3

export colorize="source colors/gitter.vim"
vim osd_src.gv '+:source osd.vim | w !dot -Tsvg > docs/gitter_class.svg' '+:q!'
export colorize="source colors/osd.vim"
vim osd_src.gv '+:source osd.vim | w !dot -Tsvg > docs/osd_class.svg' '+:q!'
export colorize="source colors/osdgl.vim"
vim osdgl_src.gv '+:source osd.vim | w !dot -Tsvg > docs/osdgl_class.svg' '+:q!'
