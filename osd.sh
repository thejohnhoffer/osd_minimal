export clusterrank="global"
export mclimit=500
export ranksep=1
vim osd_src.gv '+:source osd.vim | w! osd.gv | w !dot -Tsvg > docs/osd.svg' '+:q!'
