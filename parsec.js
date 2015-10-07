
var fs = require('fs');
var PEG = require("pegjs");

var grammar = fs.readFileSync('headerc.pegjs', 'utf-8');
var input = fs.readFileSync('proto/randrproto/randrproto.h', 'utf-8');
// var input = fs.readFileSync('example.h', 'utf-8');

try {
  var parser = PEG.buildParser(grammar);
} catch (e) {
  console.log('grammar', e);
}

try {
  var result = parser.parse(input);
} catch (e) {
  console.log('input', e);
}

console.log(result.map(x => x.type + ' - ' + x.name).sort())

// console.log(result);
fs.writeFileSync('header.json', JSON.stringify(result, null, 2));
