" Custom settings
normal gg
normal oclusterrank = "global";
normal omclimit = 1000;
%s/coral/wheat/

" Remove numbers from labels and redundant nodes
%s/\(.*label.*"\)[0-9]*: \(.*\)/\1\2/
g/node[0-9]*\ze.*(runs on import).*/ normal *dwd
g/node[0-9]*\ze.*(runs on import).*/d

" Add links between nodes
fu! AddLink(from_word, to_word)
  " Link from word's node @s to word's node @t
  execute 'g/ "' . g:from . '"//node.* "' . a:from_word . '"/ normal "fye'
  execute 'g/ "' . g:to . '"//node.* "' . a:to_word . '"/ normal "tye'

  " Add links before first link
  let l:links = 'subgraph clusteropenseadragon.*/'
  execute '%s/' . l:links . @f . ' -> ' . @t . g:color . ';\r\0/'
endfu

" Functions from Module to Module
let g:from = "legend" | let g:to = "legend"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink("OpenSeadragon", "Viewer")
call AddLink("Viewer", "ImageLoader")
call AddLink("Viewer", "TileCache")
call AddLink("Viewer", "Viewport")
call AddLink("Viewer", "Drawer")
call AddLink("Viewer", "World")

" Functions from Module to Viewport
let g:from = "legend" | let g:to = "Viewport"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink("Viewer", ".*\._setContentBounds")

" Functions from Module to world
let g:from = "legend" | let g:to = "World"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink("Viewer", ".*\.getHomeBounds")
call AddLink("Viewer", ".*\.getContentFactor")

" Functions from Viewer to Module
let g:from = "Viewer" | let g:to = "legend"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink(".*\.addTiledImage.processReadyItems", "TiledImage")

" Functions from Viewer to Viewport
let g:from = "Viewer" | let g:to = "Viewport"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink(".*\.addTiledImage.processReadyItems", ".*\.goHome")

" Functions from Viewer to World
let g:from = "Viewer" | let g:to = "World"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink("updateOnce", ".*\.update")
call AddLink("updateOnce", ".*\.needsDraw")
call AddLink(".*\.close", ".*\.removeAll")
call AddLink(".*\.isOpen", ".*\.getItemCount")
call AddLink(".*\.addTiledImage", ".*\.getItemAt")
call AddLink(".*\.addTiledImage.refreshWorld", ".*\.arrange")
call AddLink(".*\.addTiledImage.refreshWorld", ".*\.setAutoRefigureSizes")
call AddLink(".*\.addTiledImage.processReadyItems", ".*\.addItem")
call AddLink(".*\.addTiledImage.processReadyItems", ".*\.removeItem")
call AddLink(".*\.addTiledImage.processReadyItems", ".*\.getIndexOfItem")
call AddLink(".*\.addTiledImage.processReadyItems", ".*\.setAutoRefigureSizes")

" Events from World to World (Through viewer.js)
let g:from = "World" | let g:to = "World"
let g:color = ' [color="red" penwidth="4"]'
call AddLink(".*_figureSizes", ".*\.getHomeBounds")
call AddLink(".*_figureSizes", ".*\.getContentFactor")

" Events from World to Viewport (Through viewer.js)
let g:from = "World" | let g:to = "Viewport"
let g:color = ' [color="red" penwidth="4"]'
call AddLink(".*_figureSizes", ".*\._setContentBounds")

w
