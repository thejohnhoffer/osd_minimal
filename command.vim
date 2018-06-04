%s/prototype\./this./
%s/;}\(node[0-9]*.*\)/;}\r\1/
%s/node\([0-9]*\)\(.*label.*"\)[0-9]*\(:.*\)/node\1\2\1\3/
g/node[0-9]*\ze.*(runs on import).*/ exe "norm! *dwd"
g/node[0-9]*\ze.*(runs on import).*/d
w
