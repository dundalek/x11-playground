
var fs = require('fs');
var PEG = require("pegjs");

var grammar = fs.readFileSync('proto.pegjs', 'utf-8');
var input = fs.readFileSync('proto/randrproto/randrproto.txt', 'utf-8');
// var input = fs.readFileSync('proto.example.txt', 'utf-8');

var parser = PEG.buildParser(grammar);

var result = parser.parse(input);
console.log(result);
fs.writeFileSync('out.json', JSON.stringify(result, null, 2));
