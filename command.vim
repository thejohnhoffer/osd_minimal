" Use shorthand and clean up
%s/prototype\./this./
%s/;}\(node.*\)/;}\r\1/

" Remove numbers from labels
%s/\(.*label.*"\)[0-9]*: \(.*\)/\1\2/

" Set end of links, special link color
let links = 'subgraph clusteropenseadragon.*/'
let blue = ' [color="blue" penwidth="2"]'

" Openseadragon calls Viewer
g/.*"OpenSeadragon"/ normal "aye
g/.*"Viewer"/ normal "bye
execute '%s/' . links . @a . ' -> ' . @b . blue . ';\r\0/'

" Remove redundant import labeling
g/node[0-9]*\ze.*(runs on import).*/ exe "norm! *dwd"
g/node[0-9]*\ze.*(runs on import).*/d
w
