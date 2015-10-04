var x11 = require('x11');

x11.createClient(function(err, display) {
    var X = display.client;
    console.log('number of screens: ' + display.screen.length);
    var root = display.screen[0].root;
    X.require('randr', function(err, Randr) {
        console.log(Randr);
        Randr.QueryVersion(1, 4, console.log);
        Randr.SelectInput(root, Randr.NotifyMask.ScreenChange);
        Randr.GetScreenInfo(root, function(err, info) {
            console.log(info);
        });
        X.on('event', function(ev) {
          console.log(ev);
        });
        
    });
    X.on('error', function(err) { console.log(err); });
});
