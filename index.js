const getTileUrl = function(l, x, y) {
  const level = this.maxLevel - l;
  const url = "minerva-test-images.s3.amazonaws.com/png_tiles";
	const name = "C0-T0-Z0-L" + level + "-Y" + y + "-X" + x + ".png";

  return "https://" + url + '/' + name;
} 

window.addEventListener('load', function() {

		OpenSeadragon({
				id: "minimal",
				tileSources:   {
						getTileUrl: getTileUrl,
						tileSize: 1024,
						height: 4080,
						width: 7220,
						minLevel: 0,
						maxLevel: 3
				}
		});
});
