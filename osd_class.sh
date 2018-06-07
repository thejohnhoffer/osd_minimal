export clusterrank="local"
export mclimit=500
export ranksep=3
vim osd_src.gv '+:source osd.vim | w! osd_class.gv | w !dot -Tsvg > docs/osd_class.svg' '+:q!'
