" Use shorthand and clean up
%s/prototype\./this./
%s/;}\(node.*\)/;}\r\1/

" Remove numbers from labels and redundant nodes
%s/\(.*label.*"\)[0-9]*: \(.*\)/\1\2/
g/node[0-9]*\ze.*(runs on import).*/ normal *dwd
g/node[0-9]*\ze.*(runs on import).*/d

" Add links between nodes
fu! AddLink(from_word, to_word)
  " Link from word's node @s to word's node @t
  execute 'g/.* "' . a:to_word . '"/ normal "tye'
  execute 'g/.* "' . a:from_word . '"/ normal "fye'

  " Add links before first link
  let l:links = 'subgraph clusteropenseadragon.*/'
  execute '%s/' . l:links . @f . ' -> ' . @t . g:color . ';\r\0/'
endfu

"
" Links for calls that return values
"
let g:color = ' [color="blue" penwidth="2"]'

call AddLink("OpenSeadragon", "Viewer")
call AddLink("Viewer", "Viewport")
call AddLink("Viewer", "World")

w
