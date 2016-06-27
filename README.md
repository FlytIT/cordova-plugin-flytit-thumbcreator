# cordova-plugin-flytit-thumbcreator
Thumbnail creator plugin for cordova

This plugin defines a global ThumbCreator object.

## Installation
cordova plugin add cordova-plugin-flytit-thumbcreator

# API Reference


* [ThumbCreator](#thumbCreator)
  * [.createThumb(fromUri, folderToSaveThumb, successCallback, errorCallback)](#thumbCreator.createThumb)
  
  <a name="thumbCreator"></a>
## ThumbCreator

### ThumbCreator.createThumb(fromUri, folderToSaveThumb, successCallback, errorCallback)
The createThumb function creates a thumb from the uri in fromUri (ex: '/DCIM/Camera/2015011102020.jpg'), and saves the thumb to the folder specified in folderToSaveThumb (ex: '/YourFolder/thumbs'). 

The return value is sent to the successCallback:
 -  An object containing:
  - absolutePath
  - shortPath (without external storage directory, ex: ('/YourFolder/thumbs/_thumb_2015011102020.jpg')
 