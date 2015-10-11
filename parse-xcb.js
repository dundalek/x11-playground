var fs = require('fs'),
    xml2js = require('xml2js');

var parser = new xml2js.Parser({/*mergeAttrs: true,*/ explicitChildren: true, explicitArray: true, preserveChildrenOrder: true});
fs.readFile('proto/xcb/src/xproto.xml', function(err, data) {
    parser.parseString(data, function (err, result) {
        fs.writeFileSync('xcb-xproto.json', JSON.stringify(result, null, 2));
        //console.dir(result);
        console.log('Done');
    });
});

fs.readFile('proto/xcb/src/randr.xml', function(err, data) {
    parser.parseString(data, function (err, result) {
        fs.writeFileSync('xcb-randr.json', JSON.stringify(result, null, 2));
        //console.dir(result);
        console.log('Done');
    });
});
