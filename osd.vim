" Remove nodes
fu! RmNode()
  execute 'normal "ayw"'
  execute '%s/.*' . @a  . '.*//'
endfu

" Add links between nodes
fu! AddLink(color, from, to, from_word, to_word)
  let l:links = 'subgraph clusteropenseadragon.*/'

  " Link from word's node @s to word's node @t
  execute 'g/ "' . a:from . '"//node.* "' . a:from_word . '"/ normal "fye'
  execute 'g/ "' . a:to . '"//node.* "' . a:to_word . '"/ normal "tye'

  " Add links before first link
  execute '%s/' . l:links . @f . ' -> ' . @t . a:color . ';\r\0/'
endfu

" Set link constants
fu! AddLinks(f, t, a, pairs)
  let l:types = {
  \'callback': ' [color="pink" penwidth="4"]',
  \'return': ' [color="blue" penwidth="2"]',
  \'event': ' [color="red" penwidth="4"]'
  \}
  let l:color = get(l:types, a:a, '')
  for i in a:pairs
    let [l:from, l:to] = i

    call AddLink(l:color, a:f, a:t, l:from, l:to)
  endfor
endfu

" Custom settings
normal gg
normal oclusterrank = "global";
normal omclimit = 1000;
normal odpi = 55;
%s/coral/wheat/
%s/concentrate = true/concentrate = false/

" Label ImageJob and ImageRecord
%s/imageloader\.start/imagejob.start/
%s/imageloader\.finish/imagejob.finish/
%s/tilecache\.destroy/imagerecord.destroy/
%s/tilecache\.getImage/imagerecord.getImage/
%s/tilecache\.getRenderedContext/imagerecord.getRenderedContext/
%s/tilecache\.addTile/imagerecord.addTile/
%s/tilecache\.removeTile/imagerecord.removeTile/
%s/tilecache\.getTileCount/imagerecord.getTileCount/

" Remove import and eventsource nodes
g/node[0-9]*.*(runs on import).*/ call RmNode()
g/node[0-9]*.* "eventsource.*"/ call RmNode()

" Remove point nodes
%s/.*clusterpoint\_.\{-}}};//
g/node[0-9]*.* "point.*"/ call RmNode()

" Remove rectangle nodes
%s/.*clusterrectangle\_.\{-}}}};//
g/node[0-9]*.* "rectangle.*"/ call RmNode()

" Remove spring nodes
%s/.*clusterspring\_.\{-}}};//
g/node[0-9]*.* "spring.*"/ call RmNode()

"""
" Calls from Module
call AddLinks("legend", "legend", "return", [
\["OpenSeadragon", "Viewer"],
\["Viewer", "ImageLoader"],
\["Viewer", "TileCache"],
\["Viewer", "Viewport"],
\["Viewer", "Drawer"],
\["Viewer", "World"],
\])

call AddLinks("legend", "Viewer", "return", [
\["Viewer", ".*\.open"],
\])

call AddLinks("legend", "Viewer", "callback", [
\["TileSource", ".*\.processReadyItems"],
\])

call AddLinks("legend", "Viewport", "return", [
\["Viewer", ".*\._setContentBounds"],
\])

call AddLinks("legend", "World", "return", [
\["Viewer", ".*\.getHomeBounds"],
\["Viewer", ".*\.getContentFactor"],
\["World", ".*\._figureSizes"],
\])

"""
" Calls from Drawer
call AddLinks("Drawer", "Viewport", "return", [
\[".*\._calculateCanvasSize", ".*\.getContainerSize"],
\])

call AddLinks("Drawer", "World", "return", [
\[".*\.reset", ".*\.resetItems"],
\])

"""
" Calls from Tile
call AddLinks("Tile", "ImageRecord", "return", [
\[".*\.drawCanvas", ".*\.getRenderedContext"],
\[".*\.getScaleForEdgeSmoothing", ".*\.getRenderedContext"],
\])

"""
" Calls from ImageLoader
call AddLinks("ImageLoader", "ImageJob", "return", [
\["completeJob", ".*\.start"],
\[".*\.addJob", ".*\.start"],
\])

"""
" Calls from ImageJob
call AddLinks("ImageJob", "ImageLoader", "callback", [
\["*.*\.finish", ".*\.addJob\.complete"],
\])

"""
" Calls from TileCache
call AddLinks("TileCache", "ImageRecord", "return", [
\[".*\.cacheTile", ".*\.addTile"],
\[".*\._unloadTile", ".*\.destroy"],
\[".*\._unloadTile", ".*\.removeTile"],
\[".*\._unloadTile", ".*\.getTileCount"],
\])

"""
" Calls from TiledImage
call AddLinks("TiledImage", "Drawer", "return", [
\["drawTiles", ".*\.viewportToDrawerRectangle"],
\["drawTiles", ".*\.restoreContext"],
\["drawTiles", ".*\.saveContext"],
\["drawTiles", ".*\.getCanvasSize"],
\["drawTiles", ".*\.blendSketch"],
\["drawTiles", ".*\.drawTile"],
\["drawTiles", ".*\.setClip"],
\["drawTiles", ".*\._clear"],
\])

call AddLinks("TiledImage", "TileCache", "return", [
\["updateTile", ".*\.getImageRecord"],
\])

call AddLinks("TiledImage", "TiledImage", "return", [
\["updateLevel", ".*\._getCornerTiles"],
\["drawTiles", ".*\.viewportToImageZoom"],
\["setTileLoaded", ".*\.getCompletionCallback"],
\["setTileLoaded", ".*\.completionCallback"],
\])

call AddLinks("TiledImage", "TileSource", "return", [
\[".*\.getTile", ".*\.getTileUrl"],
\[".*\.getTile", ".*\.getTileAjaxHeaders"],
\[".*\._getLevelsInterval", ".*\.getPixelRatio"],
\[".*\._updateViewport", ".*\.getPixelRatio"],
\])

call AddLinks("TiledImage", "World", "event", [
\[".*\.setClip", ".*\._delegatedFigureSizes"],
\[".*\._raiseBoundsChange", ".*\._delegatedFigureSizes"],
\])

"""
" Calls from TileSource
call AddLinks("TileSource", "TileSource", "return", [
\["determineType", ".*\.supports"],
\])

call AddLinks("TileSource", "TileSource", "callback", [
\[".*\.getImageInfo", ".*\.getImageInfo\.callback"],
\])

call AddLinks("TileSource", "Viewer", "event", [
\[".*\.getImageInfo\.callback", ".*\.processReadyItems"],
\[".*\.getImageInfo\.callback", ".*\.raiseAddItemFailed"],
\])

"""
" Calls from Viewer
call AddLinks("Viewer", "legend", "return", [
\[".*\.processReadyItems", "TiledImage"],
\["getTileSourceImplementation", "TileSource"],
\])

call AddLinks("Viewer", "Drawer", "return", [
\["drawWorld", ".*\.clear"],
\[".*\.destroy", ".*\.destroy"],
\[".*\.doOne\.error", ".*\.checkCompletion"],
\[".*\.doOne\.success", ".*\.checkCompletion"],
\])

call AddLinks("Viewer", "ImageLoader", "return", [
\["drawWorld", ".*\.clear"],
\[".*\.close", ".*\.clear"],
\])

call AddLinks("Viewer", "TileSource", "return", [
\["getTileSourceImplementation", ".*\.configure"],
\["getTileSourceImplementation", ".*\.determineType"],
\])

call AddLinks("Viewer", "Viewer", "return", [
\[".*\.open", ".*\.close"],
\[".*\.open", ".*\.open\.doOne"],
\[".*\.open\.doOne", ".*\.addTiledImage"],
\[".*\.waitUntilReady", ".*\.waitUntilReady"],
\[".*\.getTileSourceImplementation", ".*\.waitUntilReady"],
\])

call AddLinks("Viewer", "Viewer", "callback", [
\["scheduleZoom", "doZoom"],
\["scheduleUpdate", "updateMulti"],
\[".*\.waitUntilReady", ".*\.processReadyItems"],
\])

call AddLinks("Viewer", "Viewport", "return", [
\[".*\.processReadyItems", ".*\.goHome"],
\[".*\.checkCompletion", ".*\.goHome"],
\[".*\.checkCompletion", ".*\.update"],
\["updateOnce", ".*\.update"],
\["doZoom", ".*\.applyConstraints"],
\["doZoom", ".*\.zoomBy"],
\])

call AddLinks("Viewer", "World", "return", [
\["drawWorld", ".*\.draw"],
\["updateOnce", ".*\.update"],
\["updateOnce", ".*\.needsDraw"],
\[".*\.close", ".*\.removeAll"],
\[".*\.isOpen", ".*\.getItemCount"],
\[".*\.addTiledImage", ".*\.getItemAt"],
\[".*\.refreshWorld", ".*\.arrange"],
\[".*\.refreshWorld", ".*\.setAutoRefigureSizes"],
\[".*\.processReadyItems", ".*\.addItem"],
\[".*\.processReadyItems", ".*\.removeItem"],
\[".*\.processReadyItems", ".*\.getIndexOfItem"],
\[".*\.getTileSourceImplementation", ".*\.setAutoRefigureSizes"],
\])

"""
" Calls from Viewport
call AddLinks("Viewer", "legend", "return", [
\[".*\.imageToViewportZoom", ".*\.imageToViewportZoom"],
\])

"""
" Calls from World
call AddLinks("World", "TiledImage", "return", [
\[".*\.needsDraw", ".*\.needsDraw"],
\[".*\._figureSizes", ".*\.getContentSize"],
\])

call AddLinks("World", "Viewer", "return", [
\[".*\.removeAll", ".*\._cancelPendingImages"],
\])

call AddLinks("World", "Viewer", "event", [
\[".*addItem", "scheduleUpdate"],
\])

call AddLinks("World", "Viewport", "event", [
\[".*\._figureSizes", ".*\._setContentBounds"],
\])

call AddLinks("World", "World", "return", [
\[".*\._delegatedFigureSizes", ".*\._figureSizes"],
\])

call AddLinks("World", "World", "event", [
\[".*\._figureSizes", ".*\.getHomeBounds"],
\[".*\._figureSizes", ".*\.getContentFactor"],
\[".*\._raiseRemoveItem", ".*\.getItemCount"],
\[".*\._raiseRemoveItem", ".*\.getItemAt"],
\[".*\.addItem", ".*\.getItemAt"],
\])
