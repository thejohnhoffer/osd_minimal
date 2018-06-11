" Custom settings
normal gg
execute 'normal oclusterrank = "' . $clusterrank . '"'
execute 'normal oranksep = ' . $ranksep
execute 'normal omclimit = ' .$mclimit
normal ospines = "curved"
normal orankdir = "LR"
normal odpi = 30;
%s/coral/white/

" Highlight nodes
fu! ColorNode(parent, node, color)
  let l:nw = substitute(a:node, '\.', '[^.]*.', '')
  let l:find = '"rounded.*\( label = "' . l:nw .'"\)/'
  let l:style = ' "rounded,filled" fillcolor = "' . a:color . '"\1/'
  execute 'g/ "' . a:parent . '"// "' . l:nw . '"/s/' l:find . l:style
endfu

" Remove nodes
fu! RmNode()
  execute 'normal "ayw"'
  execute '%s/.*' . @a  . '.*//'
endfu

fu! RmLink(from, to, fw, tw)
  " Link from word's node @f to word's node @t
  execute 'g/ "' . a:from . '"//node.* "' . a:fw . '"/ normal "fye'
  execute 'g/ "' . a:to . '"//node.* "' . a:tw . '"/ normal "tye'

  " Remove duplicate link
  execute '%s/.*' . @f . ' -> ' . @t . '.*//e'
endfu

" Add links between nodes
fu! AddLink(color, from, to, from_word, to_word)
  let l:fw = substitute(a:from_word, '\.', '[^.]*.', '')
  let l:tw = substitute(a:to_word, '\.', '[^.]*.', '')
  let links = 'subgraph clusteropenseadragon.*/'

  " Remove duplicate link and yank to @f and @t
  call RmLink(a:from, a:to, l:fw, l:tw)

  " Add links before first link
  execute '%s/' . links . @f . ' -> ' . @t . a:color . ';\r\0/'
endfu

" Set link constants
fu! AddLinks(f, t, a, pairs)
  " Styles for function types
  let types = {
  \'callback': ' [color="pink" penwidth="4"]',
  \'return': ' [color="blue" penwidth="2"]',
  \'event': ' [color="red" penwidth="4"]'
  \}
  for i in a:pairs
      if len(i) == 3
        let [l:from, l:to, l:t] = i
        let color = get(types, l:t, '')
      else
        let [l:from, l:to] = i
        let color = get(types, a:a, '')
      endif

    call AddLink(color, a:f, a:t, l:from, l:to)
  endfor
endfu

" Label ImageJob and ImageRecord
%s/imageloader\.start/imagejob.start/
%s/imageloader\.finish/imagejob.finish/
%s/tilecache\.destroy/imagerecord.destroy/
%s/tilecache\.getRenderedContext/imagerecord.getRenderedContext/
%s/tilecache\.addTile/imagerecord.addTile/
%s/tilecache\.getImage/imagerecord.getImage/
%s/tilecache\.removeTile/imagerecord.removeTile/
%s/tilecache\.getTileCount/imagerecord.getTileCount/

" Remove import, and global helper nodes
g/node[0-9]*.*(runs on import).*/ call RmNode()
g/node[0-9]*.* "cancelAnimationFrame"/ call RmNode()
g/node[0-9]*.* "requestAnimationFrame"/ call RmNode()
g/node[0-9]*.* "getOffsetParent"/ call RmNode()
g/node[0-9]*.* "isPlainObject"/ call RmNode()
g/node[0-9]*.* "isFunction"/ call RmNode()
g/node[0-9]*.* "isWindow"/ call RmNode()
g/node[0-9]*.* "type"/ call RmNode()
g/node[0-9]*.* "extend"/ call RmNode()

" Remove eventsource nodes
g/node[0-9]*.* "EventSource"/ call RmNode()
g/node[0-9]*.* "eventsource\..*"/ call RmNode()

" Remove point nodes
%s/.*clusterpoint\_.\{-}}};//
g/node[0-9]*.* "Point"/ call RmNode()
g/node[0-9]*.* "point\..*"/ call RmNode()

" Remove rectangle nodes
%s/.*clusterrectangle\_.\{-}}}};//
g/node[0-9]*.* "Rect"/ call RmNode()
g/node[0-9]*.* "fromSummits"/ call RmNode()
g/node[0-9]*.* "rectangle\..*"/ call RmNode()

" Remove spring nodes
%s/.*clusterspring\_.\{-}}};//
g/node[0-9]*.* "Spring"/ call RmNode()
g/node[0-9]*.* "transform"/ call RmNode()
g/node[0-9]*.* "spring\..*"/ call RmNode()

"""
" Highlight nodes
call ColorNode("legend", "ImageJob", "palegreen")
call ColorNode("legend", "ImageRecord", "palegreen")
call ColorNode("legend", "Tile", "palegreen")
call ColorNode("Drawer", ".drawTile", "palegreen")
call ColorNode("Drawer", "._clear", "khaki")
call ColorNode("Drawer", ".setClip", "salmon")
call ColorNode("Drawer", "._getContext", "salmon")
call ColorNode("Drawer", ".saveContext", "salmon")
call ColorNode("Drawer", ".blendSketch", "salmon")
call ColorNode("Drawer", ".restoreContext", "salmon")
call ColorNode("ImageJob", ".start", "salmon")
call ColorNode("ImageJob", ".finish", "palegreen")
call ColorNode("ImageLoader", "completeJob", "palegreen")
call ColorNode("ImageRecord", ".destroy", "palegreen")
call ColorNode("ImageRecord", ".getImage", "palegreen")
call ColorNode("ImageRecord", ".getRenderedContext", "salmon")
call ColorNode("Tile", ".unload", "salmon")
call ColorNode("Tile", ".drawCanvas", "salmon")
call ColorNode("Tile", "._hasTransparencyChannel", "salmon")
call ColorNode("Tile", ".getTranslationForEdgeSmoothing", "khaki")
call ColorNode("Tile", ".getScaleForEdgeSmoothing", "khaki")
call ColorNode("TileCache", ".cacheTile", "palegreen")
call ColorNode("TileCache", ".getImageRecord", "palegreen")
call ColorNode("TiledImage", "._updateViewport", "khaki")
call ColorNode("TiledImage", "loadTile", "palegreen")
call ColorNode("TiledImage", "setTileLoaded", "palegreen")
call ColorNode("TiledImage", "getTile", "khaki")
call ColorNode("TiledImage", "drawTiles", "salmon")
call ColorNode("TiledImage", "updateTile", "palegreen")
call ColorNode("TiledImage", "onTileLoad", "palegreen")
call ColorNode("TiledImage", "onTileLoad.finish", "palegreen")
call ColorNode("TiledImage", ".completionCallback", "palegreen")

"""
" Remove calls
call RmLink("legend", "Viewer", "Viewer", "scheduleUpdate")

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

call AddLinks("legend", "TileSource", "return", [
\["TileSource", ".getImageInfo", ""],
\])

call AddLinks("legend", "Drawer", "return", [
\["Drawer", "._calculateCanvasSize"],
\])

call AddLinks("legend", "Viewer", "return", [
\["Viewer", ".open", ""],
\])

call AddLinks("legend", "Viewer", "callback", [
\["TileSource", ".addTiledImage.processReadyItems"],
\])

call AddLinks("legend", "Viewport", "return", [
\["Viewer", "._setContentBounds", ""],
\])

call AddLinks("legend", "World", "return", [
\["Viewer", ".getHomeBounds"],
\["Viewer", ".getContentFactor"],
\["World", "._figureSizes", ""],
\])

"""
" Calls from Drawer
call AddLinks("Drawer", "Tile", "return", [
\[".drawTile", ".drawCanvas"],
\])

call AddLinks("Drawer", "Viewport", "return", [
\["._calculateCanvasSize", ".getContainerSize"],
\])

"""
" Calls from Tile
call AddLinks("Tile", "ImageRecord", "return", [
\[".drawCanvas", ".getRenderedContext"],
\[".getScaleForEdgeSmoothing", ".getRenderedContext"],
\])

"""
" Calls from ImageJob
call AddLinks("ImageJob", "ImageJob", "callback", [
\["*.start", ".start.onerror"],
\["*.start", ".start.onload"],
\])

call AddLinks("ImageJob", "ImageJob", "return", [
\[".start.onerror", ".finish", ""],
\[".start.onload", ".finish", ""],
\[".start.abort", ".start.abort", ""],
\])

call AddLinks("ImageJob", "ImageLoader", "callback", [
\["*.finish", ".addJob.complete"],
\])

"""
" Calls from ImageLoader
call AddLinks("ImageLoader", "ImageJob", "return", [
\["completeJob", ".start", ""],
\[".addJob", ".start", ""],
\[".clear", ".start.abort", ""],
\])

call AddLinks("ImageLoader", "TiledImage", "callback", [
\["completeJob", "onTileLoad"],
\])

"""
" Calls from TileCache
call AddLinks("TileCache", "ImageRecord", "return", [
\[".cacheTile", ".addTile", ""],
\["._unloadTile", ".destroy", ""],
\["._unloadTile", ".removeTile", ""],
\["._unloadTile", ".getTileCount"],
\])

call AddLinks("TileCache", "Tile", "return", [
\["._unloadTile", ".unload", ""],
\])

"""
" Calls from TiledImage
call AddLinks("TiledImage", "legend", "return", [
\["getTile", "Tile"],
\])

call AddLinks("TiledImage", "Drawer", "return", [
\["drawTiles", ".viewportToDrawerRectangle"],
\["drawTiles", ".restoreContext", ""],
\["drawTiles", ".saveContext", ""],
\["drawTiles", ".getCanvasSize"],
\["drawTiles", ".blendSketch", ""],
\["drawTiles", ".drawTile", ""],
\["drawTiles", ".setClip"],
\["drawTiles", "._clear", ""],
\])

call AddLinks("TiledImage", "ImageLoader", "return", [
\["loadTile", ".addJob", ""],
\])

call AddLinks("TiledImage", "ImageRecord", "return", [
\["updateTile", ".getImage"],
\["getTile", ".getImage"],
\])

call AddLinks("TiledImage", "Tile", "return", [
\["drawTiles", ".getTranslationForEdgeSmoothing"],
\["drawTiles", ".getScaleForEdgeSmoothing"],
\])

call AddLinks("TiledImage", "TileCache", "return", [
\["updateTile", ".getImageRecord"],
\[".reset", ".clearTilesFor", ""],
\[".completionCallback", ".cacheTile", ""],
\])

call AddLinks("TiledImage", "TiledImage", "return", [
\[".setWidth", "._setScale", ""],
\["onTileLoad", ".onTileLoad.finish", ""],
\["loadTile", "onTileLoad", ""],
\["updateTile", "setCoverage", ""],
\["blendTile", "setCoverage", ""],
\[".draw", "._updateViewport", ""],
\["updateLevel", "._getCornerTiles"],
\["._updateViewport", "drawTiles", ""],
\["._updateViewport", "._setFullyLoaded", ""],
\["drawTiles", ".viewportToImageZoom"],
\["drawTiles", ".imageToViewportRectangle"],
\["setTileLoaded", ".getCompletionCallback"],
\["setTileLoaded", ".completionCallback", ""],
\])

call AddLinks("TiledImage", "TiledImage", "callback", [
\])

call AddLinks("TiledImage", "TileSource", "return", [
\["getTile", ".tileExists"],
\["getTile", ".getTileUrl"],
\["getTile", ".getTileBounds"],
\["updateLevel", ".getTileBounds"],
\["getTile", ".getTileAjaxHeaders"],
\["._getCornerTiles", ".getTileAtPoint"],
\["onTileLoad.finish", ".getClosestLevel"],
\["._getLevelsInterval", ".getPixelRatio"],
\["._updateViewport", ".getClosestLevel"],
\["._updateViewport", ".getPixelRatio"],
\])

call AddLinks("TiledImage", "Viewport", "return", [
\["drawTiles", ".viewportToViewerElementRectangle"],
\["positionTile", ".deltaPixelsFromPoints"],
\["._getLevelsInterval", ".deltaPixelsFromPoints"],
\["._updateViewport", ".deltaPixelsFromPoints"],
\["._updateViewport", ".getBoundsWithMargins"],
\])

call AddLinks("TiledImage", "World", "event", [
\[".setClip", "._delegatedFigureSizes"],
\["._raiseBoundsChange", "._delegatedFigureSizes"],
\])

"""
" Calls from TileSource
call AddLinks("TileSource", "TileSource", "return", [
\[".getNumTiles", ".getLevelScale"],
\[".getPixelRatio", ".getLevelScale"],
\[".getTileAtPoint", ".getLevelScale"],
\[".getTileBounds", ".getLevelScale"],
\["determineType", ".supports"],
\])

call AddLinks("TileSource", "TileSource", "callback", [
\[".getImageInfo", ".getImageInfo.callback"],
\])

call AddLinks("TileSource", "Viewer", "event", [
\[".getImageInfo.callback", ".addTiledImage.processReadyItems"],
\[".getImageInfo.callback", ".addTiledImage.raiseAddItemFailed"],
\])

"""
" Calls from Viewer
call AddLinks("Viewer", "legend", "return", [
\[".addTiledImage.processReadyItems", "TiledImage"],
\["getTileSourceImplementation", "TileSource"],
\])

call AddLinks("Viewer", "Drawer", "return", [
\["drawWorld", ".clear", ""],
\])

call AddLinks("Viewer", "ImageLoader", "return", [
\["drawWorld", ".clear", ""],
\[".close", ".clear", ""],
\])

call AddLinks("Viewer", "TileSource", "return", [
\["getTileSourceImplementation", ".configure"],
\["getTileSourceImplementation", ".determineType"],
\])

call AddLinks("Viewer", "Viewer", "return", [
\[".open", ".close", ""],
\[".open", ".open", ""],
\["updateMulti", ".isOpen"],
\["updateMulti", "updateOnce", ""],
\[".open", ".open.doOne", ""],
\[".open.doOne", ".addTiledImage", ""],
\[".addTiledImage", ".getTileSourceImplementation", ""],
\[".getTileSourceImplementation", ".waitUntilReady", ""],
\[".open.doOne.success", ".open.checkCompletion", ""],
\[".open.doOne.error", ".open.checkCompletion", ""],
\[".addTiledImage.raiseAddItemFailed", ".addTiledImage.refreshWorld", ""],
\])

call AddLinks("Viewer", "Viewer", "callback", [
\["scheduleZoom", "doZoom"],
\["scheduleUpdate", "updateMulti", ""],
\[".waitUntilReady", ".addTiledImage.processReadyItems"],
\[".addTiledImage.processReadyItems", ".open.doOne.success"],
\[".addTiledImage.raiseAddItemFailed", ".open.doOne.error", ""],
\])

call AddLinks("Viewer", "Viewport", "return", [
\[".addTiledImage.processReadyItems", ".goHome", ""],
\[".open.checkCompletion", ".goHome", ""],
\[".open.checkCompletion", ".update", ""],
\["updateOnce", ".update"],
\["doZoom", ".applyConstraints", ""],
\["doZoom", ".zoomBy", ""],
\])

call AddLinks("Viewer", "World", "return", [
\["drawWorld", ".draw", ""],
\["updateOnce", ".update"],
\["updateOnce", ".needsDraw"],
\[".close", ".removeAll", ""],
\[".isOpen", ".getItemCount"],
\[".addTiledImage", ".getItemAt"],
\[".addTiledImage.refreshWorld", ".arrange", ""],
\[".addTiledImage.refreshWorld", ".setAutoRefigureSizes", ""],
\[".addTiledImage.processReadyItems", ".addItem", ""],
\[".addTiledImage.processReadyItems", ".removeItem", ""],
\[".addTiledImage.processReadyItems", ".getIndexOfItem"],
\])

"""
" Calls from Viewport
call AddLinks("Viewport", "Viewport", "return", [
\[".applyConstraints", ".zoomTo", ""],
\[".applyConstraints", ".fitBounds", ""],
\])

"""
" Calls from World
call AddLinks("World", "TiledImage", "return", [
\[".draw", ".draw", ""],
\[".update", ".update"],
\[".arrange", ".setWidth", ""],
\[".arrange", ".setPosition", ""],
\[".removeAll", ".destroy", ""],
\[".removeItem", ".destroy", ""],
\[".needsDraw", ".needsDraw"],
\["._figureSizes", ".getContentSize"],
\])

call AddLinks("World", "Viewer", "return", [
\[".removeAll", "._cancelPendingImages", ""],
\])

call AddLinks("World", "Viewer", "event", [
\[".*addItem", "scheduleUpdate"],
\])

call AddLinks("World", "Viewport", "event", [
\["._figureSizes", "._setContentBounds"],
\])

call AddLinks("World", "World", "return", [
\["._delegatedFigureSizes", "._figureSizes", ""],
\])

call AddLinks("World", "World", "event", [
\["._figureSizes", ".getHomeBounds"],
\["._figureSizes", ".getContentFactor"],
\["._raiseRemoveItem", ".getItemCount"],
\["._raiseRemoveItem", ".getItemAt"],
\[".addItem", ".getItemAt"],
\])
