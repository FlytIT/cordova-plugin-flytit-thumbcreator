//
//  ThumCreator.m
//  PathPlugin
//
//  Created by Mangai on 22/01/16.
//
//

#import "ThumCreator.h"

@implementation ThumCreator



- (void) cordovaGetFileContents:(CDVInvokedUrlCommand *)command {
    
    NSString *stringFromPath = @"";
    if(command.arguments.count > 0)
    {
        stringFromPath = [command.arguments objectAtIndex:0];
    }
    
    if ([stringFromPath hasPrefix:@"/"]){
        stringFromPath = [NSString stringWithFormat:@"/%@",stringFromPath];
    }
    NSString *stringToPath = @"";
    if(command.arguments.count > 1){
        stringToPath = [command.arguments objectAtIndex:1];
    }
    if ([stringToPath hasPrefix:@"/"]){
        stringToPath = [NSString stringWithFormat:@"/%@",stringToPath];
    }
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=@"";
    NSString *stringCombineBoth=@"";
    if(paths.count>0){
        documentsDirectory = [paths objectAtIndex:0];
        stringCombineBoth = [NSString stringWithFormat:@"%@%@",documentsDirectory,stringFromPath];
    }
    // UIImage *img = [UIImage imageWithContentsOfFile:stringCombineBoth];
    
    
    UIImage *imageResize = [self imageWithImage:[UIImage imageWithContentsOfFile:stringCombineBoth] scaledToSize:CGSizeMake(100, 100)];
    
    NSString *stringThumbFileName = [NSString stringWithFormat:@"_thumb_%@",[stringFromPath lastPathComponent]];
    
    NSString *stringNewFilePath = [NSString stringWithFormat:@"%@%@",stringToPath,stringThumbFileName];
      NSString *stringNewFileFullPath = [NSString stringWithFormat:@"%@%@%@",documentsDirectory,stringToPath,stringThumbFileName];
    
   BOOL success = [UIImagePNGRepresentation(imageResize) writeToFile:stringNewFilePath atomically:YES];
    
    if(success)
    {
        NSDictionary *jsonObj = [ [NSDictionary alloc]initWithObjectsAndKeys :
                                 @"true", @"success",stringNewFileFullPath,stringNewFilePath,
                                 nil];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus : CDVCommandStatus_OK
                                         messageAsDictionary : jsonObj];
       [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    else{
        
        NSDictionary *jsonObj = [ [NSDictionary alloc]initWithObjectsAndKeys :
                                 @"false", @"not_success",
                                 nil];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus : CDVCommandStatus_ERROR                                                      messageAsDictionary : jsonObj];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
    
    
   
}



-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
   
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



@end
