var exec = require('cordova/exec');

function ThumbCreator() {
 console.log("ThumbCreator.js: is created");
}

ThumbCreator.prototype.createThumb = function (fromPath, toPath, successCallback, errorCallback) {
    
    var args = [fromPath, toPath];

 exec(function(result){
         successCallback(JSON.parse(result));
     },
    function (result) {
        errorCallback(result);
        /*alert("Error" + reply);*/
    },
    "ThumbCreator"
    ,
    "createThumb",
    args);
}

 var thumbCreator = new ThumbCreator();
 module.exports = thumbCreator;

