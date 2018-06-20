%s/coral/wheat/

" Highlight nodes
fu! ColorNode(parent, node, color)
  let l:nw = substitute(a:node, '\.', '[^.]*.', '')
  let l:find = '"rounded.*\( label = "' . l:nw .'"\)/'
  let l:style = ' "rounded,filled" fillcolor = "' . a:color . '"\1/'
  execute 'g/ "' . a:parent . '"// "' . l:nw . '"/s/' l:find . l:style
endfu

"call ColorNode('legend', 'viewer', 'palegreen')
