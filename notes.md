
http://cgit.freedesktop.org/xorg/proto/randrproto/

http://www.x.org/releases/X11R7.6/doc/randrproto/randrproto.txt
https://github.com/sidorares/node-x11/blob/master/lib/ext/randr.js

http://cgit.freedesktop.org/xorg/app/xrandr

http://hackage.haskell.org/package/pandoc-types-1.12.4.7/docs/Text-Pandoc-Definition.html

```javascript
var x11 = require('x11');
var Randr, X, root;

x11.createClient(function(err, display) {
    X = display.client;
    root = display.screen[0].root;
    X.require('randr', function(err, r) {
      Randr = r;
      Randr.QueryVersion(1, 4, function() {
        console.log('randr ready');
      });
    });
});
```


> Randr.GetScreenResources(root, console.log)
undefined
> null { timestamp: 82936,
  config_timestamp: 47078,
  modeinfos: 
   [ { id: 73,
       width: 1600,
       height: 900,
       dot_clock: 107800000,
       h_sync_start: 1648,
       h_sync_end: 1680,
       h_total: 1940,
       h_skew: 0,
       v_sync_start: 903,
       v_sync_end: 908,
       v_total: 926,
       modeflags: 10,
       name: '1600x900' },
     { id: 235,
       width: 1440,
       height: 900,
       dot_clock: 106500000,
       h_sync_start: 1520,
       h_sync_end: 1672,
       h_total: 1904,
       h_skew: 0,
       v_sync_start: 903,
       v_sync_end: 909,
       v_total: 934,
       modeflags: 6,
       name: '1440x900' } ],
  crtcs: [ 64, 63, 65, 66 ],
  outputs: [ 67, 68, 69, 70, 71 ] }




  { rotations: 63,
    root: 214,
    timestamp: 82936,
    config_timestamp: 47078,
    sizeID: 0,
    rotation: 1,
    rate: 60,
    rates: 
     [ 2,
       60,
       50,
       1,
       60,
       1,
       60,
       1,
       60,
       1,
       60,
       1,
       60,
       1,
       60,
       2,
       60,
       50,
       1,
       60,
       2,
       60,
       56,
       1,
       50,
       1,
       60,
       1,
       60 ],
    screens: 
     [ { px_width: 1920, px_height: 1080, mm_width: 521, mm_height: 293 },
       { px_width: 1600, px_height: 1200, mm_width: 521, mm_height: 293 },
       { px_width: 1680, px_height: 1050, mm_width: 521, mm_height: 293 },
       { px_width: 1280, px_height: 1024, mm_width: 521, mm_height: 293 },
       { px_width: 1440, px_height: 900, mm_width: 521, mm_height: 293 },
       { px_width: 1280, px_height: 960, mm_width: 521, mm_height: 293 },
       { px_width: 1280, px_height: 800, mm_width: 521, mm_height: 293 },
       { px_width: 1280, px_height: 720, mm_width: 521, mm_height: 293 },
       { px_width: 1024, px_height: 768, mm_width: 521, mm_height: 293 },
       { px_width: 800, px_height: 600, mm_width: 521, mm_height: 293 },
       { px_width: 720, px_height: 576, mm_width: 521, mm_height: 293 },
       { px_width: 720, px_height: 480, mm_width: 521, mm_height: 293 },
       { px_width: 640, px_height: 480, mm_width: 521, mm_height: 293 } ] }
