export clusterrank="global"
export mclimit=10000
export ranksep=1
vim osd_src.gv '+:source osd.vim | w! osd.gv | w !dot -Tsvg > osd.svg' '+:q!'
