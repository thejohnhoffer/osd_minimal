" Custom settings
normal gg
execute 'normal oclusterrank = "' . $clusterrank . '"'
execute 'normal oranksep = ' . $ranksep
execute 'normal omclimit = ' .$mclimit
normal ospines = "curved"
normal orankdir = "LR"
normal odpi = 30;

fu! RmNode()
  execute 'normal "ayw"'
  execute '%s/.*' . @a  . '.*//'
endfu

fu! RmLink(f, t, fw, tw)
  " Link from word's node @f to word's node @t
  execute 'g/ "' . a:f . '"//node.* "' . a:fw . '"/ normal "fye'
  execute 'g/ "' . a:t . '"//node.* "' . a:tw . '"/ normal "tye'

  " Remove duplicate link
  execute '%s/.*' . @f . ' -> ' . @t . '.*//e'
endfu

fu! AddLink(a, f, t, fw, tw)
  let l:fw = substitute(a:fw, '\.', '[^.]*.', '')
  let l:tw = substitute(a:tw, '\.', '[^.]*.', '')
  let links = 'subgraph clusteropenseadragon.*/'
  " Styles for function types
  let types = {
  \'callback': ' [color="pink" penwidth="4"]',
  \'return': ' [color="blue" penwidth="2"]',
  \'event': ' [color="red" penwidth="4"]'
  \}
  let color = get(types, a:a, '')

  " Remove duplicate link and yank to @f and @t
  call RmLink(a:f, a:t, l:fw, l:tw)

  " Add links before first link
  execute '%s/' . links . @f . ' -> ' . @t . color . ';\r\0/'
endfu

fu! AddLinks(a, f, t, pairs)
  for i in a:pairs
      if len(i) == 3
        let [l:fw, l:tw, l:a] = i
    	call AddLink(l:a, a:f, a:t, l:fw, l:tw)
      else
        let [l:fw, l:tw] = i
    	call AddLink(a:a, a:f, a:t, l:fw, l:tw)
      endif
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
execute $colorize

"""
" Remove calls
call RmLink("legend", "Viewer", "Viewer", "scheduleUpdate")

"""
" Calls from Module
call AddLinks("return", "legend", "legend", [
\["OpenSeadragon", "Viewer"],
\["Viewer", "ImageLoader"],
\["Viewer", "TileCache"],
\["Viewer", "Viewport"],
\["Viewer", "Drawer"],
\["Viewer", "World"],
\])

call AddLinks("return", "legend", "TileSource", [
\["TileSource", ".getImageInfo", ""],
\])

call AddLinks("return", "legend", "Drawer", [
\["Drawer", "._calculateCanvasSize"],
\])

call AddLinks("return", "legend", "Viewer", [
\["Viewer", ".open", ""],
\])

call AddLinks("callback", "legend", "Viewer", [
\["TileSource", ".addTiledImage.processReadyItems"],
\])

call AddLinks("return", "legend", "Viewport", [
\["Viewer", "._setContentBounds", ""],
\])

call AddLinks("return", "legend", "World", [
\["Viewer", ".getHomeBounds"],
\["Viewer", ".getContentFactor"],
\["World", "._figureSizes", ""],
\])

"""
" Calls from Drawer
call AddLinks("return", "Drawer", "Tile", [
\[".drawTile", ".drawCanvas"],
\])

call AddLinks("return", "Drawer", "Viewport", [
\["._calculateCanvasSize", ".getContainerSize"],
\])

"""
" Calls from Tile
call AddLinks("return", "Tile", "ImageRecord", [
\[".drawCanvas", ".getRenderedContext"],
\[".getScaleForEdgeSmoothing", ".getRenderedContext"],
\])

"""
" Calls from ImageJob
call AddLinks("callback", "ImageJob", "ImageJob", [
\["*.start", ".start.onerror"],
\["*.start", ".start.onload"],
\])

call AddLinks("return", "ImageJob", "ImageJob", [
\[".start.onerror", ".finish", ""],
\[".start.onload", ".finish", ""],
\[".start.abort", ".start.abort", ""],
\])

call AddLinks("callback", "ImageJob", "ImageLoader", [
\["*.finish", ".addJob.complete"],
\])

"""
" Calls from ImageLoader
call AddLinks("return", "ImageLoader", "ImageJob", [
\["completeJob", ".start", ""],
\[".addJob", ".start", ""],
\[".clear", ".start.abort", ""],
\])

call AddLinks("callback", "ImageLoader", "TiledImage", [
\["completeJob", "onTileLoad"],
\])

"""
" Calls from TileCache
call AddLinks("return", "TileCache", "ImageRecord", [
\[".cacheTile", ".addTile", ""],
\["._unloadTile", ".destroy", ""],
\["._unloadTile", ".removeTile", ""],
\["._unloadTile", ".getTileCount"],
\])

call AddLinks("return", "TileCache", "Tile", [
\["._unloadTile", ".unload", ""],
\])

"""
" Calls from TiledImage
call AddLinks("return", "TiledImage", "legend", [
\["getTile", "Tile"],
\])

call AddLinks("return", "TiledImage", "Drawer", [
\["drawTiles", ".viewportToDrawerRectangle"],
\["drawTiles", ".restoreContext", ""],
\["drawTiles", ".saveContext", ""],
\["drawTiles", ".getCanvasSize"],
\["drawTiles", ".blendSketch", ""],
\["drawTiles", ".drawTile", ""],
\["drawTiles", ".setClip"],
\["drawTiles", "._clear", ""],
\])

call AddLinks("return", "TiledImage", "ImageLoader", [
\["loadTile", ".addJob", ""],
\])

call AddLinks("return", "TiledImage", "ImageRecord", [
\["updateTile", ".getImage"],
\["getTile", ".getImage"],
\])

call AddLinks("return", "TiledImage", "Tile", [
\["drawTiles", ".getTranslationForEdgeSmoothing"],
\["drawTiles", ".getScaleForEdgeSmoothing"],
\])

call AddLinks("return", "TiledImage", "TileCache", [
\["updateTile", ".getImageRecord"],
\[".reset", ".clearTilesFor", ""],
\[".completionCallback", ".cacheTile", ""],
\])

call AddLinks("return", "TiledImage", "TiledImage", [
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

call AddLinks("return", "TiledImage", "TileSource", [
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

call AddLinks("return", "TiledImage", "Viewport", [
\["drawTiles", ".viewportToViewerElementRectangle"],
\["positionTile", ".deltaPixelsFromPoints"],
\["._getLevelsInterval", ".deltaPixelsFromPoints"],
\["._updateViewport", ".deltaPixelsFromPoints"],
\["._updateViewport", ".getBoundsWithMargins"],
\])

call AddLinks("event", "TiledImage", "World", [
\[".setClip", "._delegatedFigureSizes"],
\["._raiseBoundsChange", "._delegatedFigureSizes"],
\])

"""
" Calls from TileSource
call AddLinks("return", "TileSource", "TileSource", [
\[".getNumTiles", ".getLevelScale"],
\[".getPixelRatio", ".getLevelScale"],
\[".getTileAtPoint", ".getLevelScale"],
\[".getTileBounds", ".getLevelScale"],
\["determineType", ".supports"],
\])

call AddLinks("callback", "TileSource", "TileSource", [
\[".getImageInfo", ".getImageInfo.callback"],
\])

call AddLinks("event", "TileSource", "Viewer", [
\[".getImageInfo.callback", ".addTiledImage.processReadyItems"],
\[".getImageInfo.callback", ".addTiledImage.raiseAddItemFailed"],
\])

"""
" Calls from Viewer
call AddLinks("return", "Viewer", "legend", [
\[".addTiledImage.processReadyItems", "TiledImage"],
\["getTileSourceImplementation", "TileSource"],
\])

call AddLinks("return", "Viewer", "Drawer", [
\["drawWorld", ".clear", ""],
\])

call AddLinks("return", "Viewer", "ImageLoader", [
\["drawWorld", ".clear", ""],
\[".close", ".clear", ""],
\])

call AddLinks("return", "Viewer", "TileSource", [
\["getTileSourceImplementation", ".configure"],
\["getTileSourceImplementation", ".determineType"],
\])

call AddLinks("return", "Viewer", "Viewer", [
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

call AddLinks("callback", "Viewer", "Viewer", [
\["scheduleZoom", "doZoom"],
\["scheduleUpdate", "updateMulti"],
\[".waitUntilReady", ".addTiledImage.processReadyItems"],
\[".addTiledImage.processReadyItems", ".open.doOne.success"],
\[".addTiledImage.raiseAddItemFailed", ".open.doOne.error"],
\])

call AddLinks("return", "Viewer", "Viewport", [
\[".addTiledImage.processReadyItems", ".goHome", ""],
\[".open.checkCompletion", ".goHome", ""],
\[".open.checkCompletion", ".update", ""],
\["updateOnce", ".update"],
\["doZoom", ".applyConstraints", ""],
\["doZoom", ".zoomBy", ""],
\])

call AddLinks("return", "Viewer", "World", [
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
call AddLinks("return", "Viewport", "Viewport", [
\[".applyConstraints", ".zoomTo", ""],
\[".applyConstraints", ".fitBounds", ""],
\])

"""
" Calls from World
call AddLinks("return", "World", "TiledImage", [
\[".draw", ".draw", ""],
\[".update", ".update"],
\[".arrange", ".setWidth", ""],
\[".arrange", ".setPosition", ""],
\[".removeAll", ".destroy", ""],
\[".removeItem", ".destroy", ""],
\[".needsDraw", ".needsDraw"],
\["._figureSizes", ".getContentSize"],
\])

call AddLinks("return", "World", "Viewer", [
\[".removeAll", "._cancelPendingImages", ""],
\])

call AddLinks("event", "World", "Viewer", [
\[".*addItem", "scheduleUpdate"],
\])

call AddLinks("event", "World", "Viewport", [
\["._figureSizes", "._setContentBounds"],
\])

call AddLinks("return", "World", "World", [
\["._delegatedFigureSizes", "._figureSizes", ""],
\])

call AddLinks("event", "World", "World", [
\["._figureSizes", ".getHomeBounds"],
\["._figureSizes", ".getContentFactor"],
\["._raiseRemoveItem", ".getItemCount"],
\["._raiseRemoveItem", ".getItemAt"],
\[".addItem", ".getItemAt"],
\])
