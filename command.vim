" Use shorthand and clean up
%s/prototype\./this./
%s/;}\(node.*\)/;}\r\1/

" Remove numbers from labels
%s/\(.*label.*"\)[0-9]*: \(.*\)/\1\2/

" Add links between nodes
fu! AddLink(from_word, to_word)
  " Link from word's node @s to word's node @t
  execute 'g/.*"' . a:to_word . '"/ normal "tye'
  execute 'g/.*"' . a:from_word . '"/ normal "fye'

  " Add links before first link
  let l:links = 'subgraph clusteropenseadragon.*/'
  execute '%s/' . l:links . @f . ' -> ' . @t . g:color . ';\r\0/'
endfu

" Define link colors
let blue = ' [color="blue" penwidth="2"]'
let black = ''

" Links for calls that return values
let g:color = blue
call AddLink("OpenSeadragon", "Viewer")

" Remove redundant import labeling
g/node[0-9]*\ze.*(runs on import).*/ normal *dwd
g/node[0-9]*\ze.*(runs on import).*/d
w
