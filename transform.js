
var fs = require('fs');
var _ = require('lodash');

var spec = require('./out.json');
var header = require('./header.json');

//var d = spec.filter(x => x.t !== 'Para' && x.t !== 'Header');
//console.log(d.map(x => x.name + ' - ' + x.t).sort())

//console.log(header.map(x => x.type + ' - ' + x.name).sort());

header.forEach(x => x.name = (x.name||'').replace(/^x|^sz_x/, '').replace(/Req$|Reply$|Event$/, ''));

var all = spec.concat(header);

var groups = _.groupBy(all, 'name');

//console.log(groups);

// remove appendix
var idx = _.findIndex(spec, {
  "t": "Para",
  "c": "Appendix A. Protocol Encoding\n"
});
spec = spec.slice(0, idx);

var nl2br = x => x.replace(/\n/g, '<br>');
var yamlQuote = x => "'" + x.replace(/'/g, "''") + "'";

var result = spec.map(function(node) {
  if (node.t === 'Para') {
    return nl2br(node.c);
  } else if (node.t === 'Header') {
    return new Array(node.c[0]+1).join('#') + ' ' + node.c[2];
  } else if (node.name) {
    return node.name + '\n:' + yamlQuote(nl2br(JSON.stringify(groups[node.name], null, 2)));
  }
  console.log('unknown', node);
})

result.splice(3, 0, 'contents\n:', yamlQuote(Object.keys(groups).join(' <br> ')));

result = result.join('\n\n');

fs.writeFileSync('../kmdoc/kb/x11-randr-protocol/index.md', result);
