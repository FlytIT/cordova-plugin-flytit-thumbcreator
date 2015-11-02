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
    "thumbCreator"
    ,
    "createThumb",
    args);
}

 var thumb = new ThumbCreator();
 module.exports = thumb;

