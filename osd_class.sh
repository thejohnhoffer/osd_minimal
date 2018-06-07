export clusterrank="local"
export mclimit=10000
export ranksep=3
vim osd_src.gv '+:source osd.vim | w! osd_class.gv | w !dot -Tsvg > osd_class.svg' '+:q!'
