var exec = require('cordova/exec');

function thumbCreator() {
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

 var thumb = new thumbCreator();
 module.exports = thumb;

