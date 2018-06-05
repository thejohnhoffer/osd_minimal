" Custom settings
normal gg
normal oclusterrank = "global";
normal omclimit = 1000;
%s/coral/wheat/
%s/concentrate = true/concentrate = false/

" Remove nodes
fu! RmNode()
  execute 'normal "ayw"'
  execute '%s/.*' . @a  . '.*//'
endfu

" Remove import and eventsource nodes
g/node[0-9]*.*(runs on import).*/ call RmNode()
g/node[0-9]*.* "eventsource.*"/ call RmNode()

" Remove rectangle nodes
%s/.*clusterrectangle\_.\{-}}}};//
g/node[0-9]*.* "rectangle.*"/ call RmNode()

" Remove point nodes
%s/.*clusterpoint\_.\{-}}};//
g/node[0-9]*.* "point.*"/ call RmNode()

" Add links between nodes
fu! AddLink(from_word, to_word)
  " Link from word's node @s to word's node @t
  execute 'g/ "' . g:from . '"//node.* "' . a:from_word . '"/ normal "fye'
  execute 'g/ "' . g:to . '"//node.* "' . a:to_word . '"/ normal "tye'

  " Add links before first link
  let l:links = 'subgraph clusteropenseadragon.*/'
  execute '%s/' . l:links . @f . ' -> ' . @t . g:color . ';\r\0/'
endfu

"""
" Functions from Module to Module
let g:from = "legend" | let g:to = "legend"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink("OpenSeadragon", "Viewer")
call AddLink("Viewer", "ImageLoader")
call AddLink("Viewer", "TileCache")
call AddLink("Viewer", "Viewport")
call AddLink("Viewer", "Drawer")
call AddLink("Viewer", "World")

" Functions from Module to Viewer
let g:from = "legend" | let g:to = "Viewer"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink("Viewer", ".*\.open")

" Callbacks from Module to Viewer
let g:from = "legend" | let g:to = "Viewer"
let g:color = ' [color="pink" penwidth="4"]'
call AddLink("TileSource", ".*\.processReadyItems")

" Functions from Module to Viewport
let g:from = "legend" | let g:to = "Viewport"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink("Viewer", ".*\._setContentBounds")

" Functions from Module to world
let g:from = "legend" | let g:to = "World"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink("Viewer", ".*\.getHomeBounds")
call AddLink("Viewer", ".*\.getContentFactor")
call AddLink("World", ".*\._figureSizes")

"""
" Events from TiledImage to World
let g:from = "TiledImage" | let g:to = "World"
let g:color = ' [color="red" penwidth="4"]'
call AddLink(".*\.setClip", ".*\._delegatedFigureSizes")
call AddLink(".*\._raiseBoundsChange", ".*\._delegatedFigureSizes")


"""
" Functions from TileSource to TileSource
let g:from = "TileSource" | let g:to = "TileSource"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink("determineType", ".*\.supports")

" Callbacks from TileSource to TileSource
let g:from = "TileSource" | let g:to = "TileSource"
let g:color = ' [color="pink" penwidth="4"]'
call AddLink(".*\.getImageInfo", ".*\.getImageInfo\.callback")

" Events from TileSource to Viewer
let g:from = "TileSource" | let g:to = "Viewer"
let g:color = ' [color="red" penwidth="4"]'
call AddLink(".*\.getImageInfo\.callback", ".*\.processReadyItems")
call AddLink(".*\.getImageInfo\.callback", ".*\.raiseAddItemFailed")

"""
" Functions from Viewer to Module
let g:from = "Viewer" | let g:to = "legend"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink(".*\.processReadyItems", "TiledImage")
call AddLink("getTileSourceImplementation", "TileSource")

" Functions from Viewer to Drawer
let g:from = "Viewer" | let g:to = "Drawer"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink("drawWorld", ".*\.clear")
call AddLink(".*\.destroy", ".*\.destroy")
call AddLink(".*\.doOne\.error", ".*\.checkCompletion")
call AddLink(".*\.doOne\.success", ".*\.checkCompletion")

" Functions from Viewer to ImageLoader
let g:from = "Viewer" | let g:to = "ImageLoader"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink("drawWorld", ".*\.clear")
call AddLink(".*\.close", ".*\.clear")

" Functions from Viewer to TileSource
let g:from = "Viewer" | let g:to = "TileSource"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink("getTileSourceImplementation", ".*\.configure")
call AddLink("getTileSourceImplementation", ".*\.determineType")

" Functions from Viewer to Viewer
let g:from = "Viewer" | let g:to = "Viewer"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink(".*\.open", ".*\.close")
call AddLink(".*\.open", ".*\.open\.doOne")
call AddLink(".*\.open\.doOne", ".*\.addTiledImage")
call AddLink(".*\.waitUntilReady", ".*\.waitUntilReady")
call AddLink(".*\.getTileSourceImplementation", ".*\.waitUntilReady")

" Callbacks from Viewer to Viewer
let g:from = "Viewer" | let g:to = "Viewer"
let g:color = ' [color="pink" penwidth="4"]'
call AddLink("scheduleZoom", "doZoom")
call AddLink("scheduleUpdate", "updateMulti")
call AddLink(".*\.waitUntilReady", ".*\.processReadyItems")

" Functions from Viewer to Viewport
let g:from = "Viewer" | let g:to = "Viewport"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink(".*\.processReadyItems", ".*\.goHome")
call AddLink(".*\.checkCompletion", ".*\.goHome")
call AddLink(".*\.checkCompletion", ".*\.update")
call AddLink("updateOnce", ".*\.update")
call AddLink("doZoom", ".*\.applyConstraints")
call AddLink("doZoom", ".*\.zoomBy")

" Functions from Viewer to World
let g:from = "Viewer" | let g:to = "World"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink("drawWorld", ".*\.draw")
call AddLink("updateOnce", ".*\.update")
call AddLink("updateOnce", ".*\.needsDraw")
call AddLink(".*\.close", ".*\.removeAll")
call AddLink(".*\.isOpen", ".*\.getItemCount")
call AddLink(".*\.addTiledImage", ".*\.getItemAt")
call AddLink(".*\.refreshWorld", ".*\.arrange")
call AddLink(".*\.refreshWorld", ".*\.setAutoRefigureSizes")
call AddLink(".*\.processReadyItems", ".*\.addItem")
call AddLink(".*\.processReadyItems", ".*\.removeItem")
call AddLink(".*\.processReadyItems", ".*\.getIndexOfItem")
call AddLink(".*\.getTileSourceImplementation", ".*\.setAutoRefigureSizes")

"""
" Functions from World to World
let g:from = "World" | let g:to = "World"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink(".*\._delegatedFigureSizes", ".*\._figureSizes")

" Events from World to World
let g:from = "World" | let g:to = "World"
let g:color = ' [color="red" penwidth="4"]'
call AddLink(".*\._figureSizes", ".*\.getHomeBounds")
call AddLink(".*\._figureSizes", ".*\.getContentFactor")
call AddLink(".*\._raiseRemoveItem", ".*\.getItemCount")
call AddLink(".*\._raiseRemoveItem", ".*\.getItemAt")
call AddLink(".*\.addItem", ".*\.getItemAt")

" Functions from World to Viewer
let g:from = "World" | let g:to = "Viewer"
let g:color = ' [color="blue" penwidth="2"]'
call AddLink(".*\.removeAll", ".*\._cancelPendingImages")

" Events from World to Viewer
let g:from = "World" | let g:to = "Viewer"
let g:color = ' [color="red" penwidth="4"]'
call AddLink(".*addItem", "scheduleUpdate")

" Events from World to Viewport
let g:from = "World" | let g:to = "Viewport"
let g:color = ' [color="red" penwidth="4"]'
call AddLink(".*\._figureSizes", ".*\._setContentBounds")

w
