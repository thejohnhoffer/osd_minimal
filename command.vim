" Use shorthand and clean up
%s/prototype\./this./
%s/;}\(node[0-9]*.*\)/;}\r\1/

" Remove numbers from labels
%s/\(.*label.*"\)[0-9]*: \(.*\)/\1\2/

" Add new links
"%s/\(subgraph clusteropenseadragon.*\)/node2 -> node97 [color="blue" penwidth="2"];\r\1/

" Remove redundant import labeling
g/node[0-9]*\ze.*(runs on import).*/ exe "norm! *dwd"
g/node[0-9]*\ze.*(runs on import).*/d
w
