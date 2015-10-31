var exec = require('cordova/exec');

function ThumbCreator() {
 console.log("ThumbCreator.js: is created");
}

ThumbCreator.prototype.createThumb = function(path){
 console.log("path", path);

 exec(function(result){
     /*alert("OK" + reply);*/
    },
    function(result){
    /*alert("Error" + reply);*/
    },
    "ThumbCreator"
    ,
    path,
    []);
}

 var thumbCreator = new ThumbCreator();
 module.exports = thumbCreator;

