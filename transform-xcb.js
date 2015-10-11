
var _ = require('lodash');

var spec = require('./xcb-xproto.json');

// function mapType(type) {
//     return 'L';
// }
// 
// function reqPack(spec, req) {
//    // first check for lists and fillin sizes
//     var template = [];
//     var data = [];
//     var length = 4;
//     spec.field.forEach(function(field, i) {
//         var type = mapType(field.$.type);
//         template.push(type);
//         length += typeLengts[type];
//         data.push(req[i]);
//     });
//     return [
//         'CCS' + template.join(''),
//         [ext.majorOpcode, spec.$.opcode, length/4].concat(data)
//     ];
// }
// 
// function reqPack(spec, buf) {
//     
// }

// reqs.forEach(function(spec) {
//     ext[spec.$.name] = function() {
//         X.seq_num++;
//         var req = [].slice.call(arguments, 0, -1);
//         var cb = arguments[argmuments.length - 1];
//         var packed = reqPack(spec, req);
//         X.pack_stream.pack(packed[0], packed[1]);
//         X.replies[X.seq_num] = [
//             function(buf, opt) {
//                 return reqUnpack(spec, buf);
//             }
//         ];
//         X.pack_stream.flush();
//     }
// });

// console.log(spec.xcb.union);

// var requests = 'SetScreenConfig SelectInput GetScreenInfo GetScreenResources GetCrtcInfo'.split(' ');
// 
// var reqs = spec.xcb.request.filter(x => requests.indexOf(x.$.name) !== -1);
// 
// reqs = _(reqs).map(x => [x.$.name, x]).zipObject().value();
// 
// console.log(reqs.GetCrtcInfo);

// console.log(Object.keys(spec.xcb));

function importHeader(name) {
  
}

var typeLengts = {
    C: 1,
    S: 2,
    L: 4
};

// TODO handle namespaces
var types = {
  'CARD8': 'C',
  'CARD16': 'S',
  'CARD32': 'L'
};

// import
(spec.xcb.import||[]).forEach(importHeader);

// typedef
spec.xcb.typedef.forEach(function(x) {
  types[x.$.newname] = x.$.oldname;
});

// xidtype
spec.xcb.xidtype.forEach(function(x) {
  types[x.$.name] = 'CARD32';
});

// struct
spec.xcb.struct.forEach(function(x) {
  var ret = types[x.$.name] = x.$$.map(function(node) {
    switch (node['#name']) {
      case 'field': return node.$;
        // name
        // type
        // enum
        // altenum
        // mask
        // altmask
      case 'pad': return {
        bytes: parseInt(node.$.bytes),
        align: parseInt(node.$.align)        
      };
      case 'list': return node;
      case 'fd': throw 'not yet implemented';
    }
  });
});

// request


// there can be 'switch'

// event
// eventcopy
// error
// errorcopy
// union
// xidunion
// enum
