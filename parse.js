
var fs = require('fs');
var PEG = require("pegjs");

var grammar = fs.readFileSync('proto.pegjs', 'utf-8');
var input = fs.readFileSync('proto/randrproto/randrproto.txt', 'utf-8');
// var input = fs.readFileSync('proto.example.txt', 'utf-8');

var parser = PEG.buildParser(grammar);

var result = parser.parse(input);

var d = result.filter(x => x.t !== 'Para' && x.t !== 'Header');
console.log('Number of definitions: ' + input.match(/┌───\s/g).length);
console.log('Matched definitions: ' + d.length);
console.log(d.map(x => x.name + ' - ' + x.t).sort())

var troublemakers = result.filter(x => x.t === 'Para' && x.c.match(/┌───\s/));
console.log('Troublemakers: ' + troublemakers.length);
console.log(troublemakers);


// console.log(result);
fs.writeFileSync('out.json', JSON.stringify(result, null, 2));
