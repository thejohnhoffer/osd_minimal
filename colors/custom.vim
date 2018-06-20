%s/coral/white/

" Highlight nodes
fu! ColorNode(parent, node, color)
  let l:nw = substitute(a:node, '\.', '[^.]*.', '')
  let l:find = '"rounded.*\( label = "' . l:nw .'"\)/'
  let l:style = ' "rounded,filled" fillcolor = "' . a:color . '"\1/'
  execute 'g/ "' . a:parent . '"// "' . l:nw . '"/s/' l:find . l:style
endfu

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

