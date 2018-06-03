%s/prototype\./this./
%s/;}\(node[0-9]*.*\)/;}\r\1/
g/node[0-9]*\ze.*(runs on import).*/ exe "norm! *dwd"
g/node[0-9]*\ze.*(runs on import).*/d
w
