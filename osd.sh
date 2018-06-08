export clusterrank="global"
export mclimit=500
export ranksep=1
vim osd_src.gv '+:source osd.vim | w !dot -Tsvg > docs/osd.svg' '+:q!'
vim osdgl_src.gv '+:source osd.vim | w !dot -Tsvg > docs/osdgl.svg' '+:q!'


export clusterrank="local"
export mclimit=500
export ranksep=3
vim osd_src.gv '+:source osd.vim | w !dot -Tsvg > docs/osd_class.svg' '+:q!'
vim osdgl_src.gv '+:source osd.vim | w !dot -Tsvg > docs/osdgl_class.svg' '+:q!'
