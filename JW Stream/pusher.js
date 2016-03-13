
function load(){

var pusher = new Pusher('24773002f566532b3c3d', {
encrypted: true
});
    
var channel = pusher.subscribe(uuid);
channel.bind('code_confirmed', function(data) {
messageFromPusher(data.message)
});

Pusher.log = function(message) {
//messageFromPusher(message)
};

}



/*console.log=function(log) {
messageFromPusher('[Error]'+log)
};
console.debug=function(log) {
messageFromPusher('[Debug]'+log)
};
console.info=function(log) {
messageFromPusher('[Info]'+log)
};
console.warn=function(log) {
messageFromPusher('[Warning]'+log)
};
console.error=function(log) {
messageFromPusher('[Error]'+log)
};*/
