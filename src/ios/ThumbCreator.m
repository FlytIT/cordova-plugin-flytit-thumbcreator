//
//  ThumbCreator.m
//  PathPlugin


#import "ThumbCreator.h"

@implementation ThumbCreator

- (void) createThumb:(CDVInvokedUrlCommand *)command {
    
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
    NSError *error = nil;
    
    if(paths.count>0){
        documentsDirectory = [paths objectAtIndex:0];
        stringCombineBoth = [NSString stringWithFormat:@"%@%@",documentsDirectory,stringFromPath];
    }
    // UIImage *img = [UIImage imageWithContentsOfFile:stringCombineBoth];
    
    
    UIImage *imageResize = [self imageWithImage:[UIImage imageWithContentsOfFile:stringCombineBoth] scaledToSize:CGSizeMake(100, 100)];
    
    NSString *stringThumbFileName = [NSString stringWithFormat:@"_thumb_%@",[stringFromPath lastPathComponent]];
    
    NSString *stringNewFilePath = [NSString stringWithFormat:@"%@%@",stringToPath,stringThumbFileName];
    NSString *stringNewFileFullPath = [NSString stringWithFormat:@"%@/%@%@",documentsDirectory,stringToPath,stringThumbFileName];
    NSString *pathForJson =[NSString stringWithFormat:@"file://%@", stringNewFileFullPath];
    
    BOOL success = [UIImagePNGRepresentation(imageResize) writeToFile:stringNewFileFullPath options: NSDataWritingAtomic error:&error];
    
    if(success)
    {
        NSDictionary* ret =@{
                             @"absolutePath": pathForJson,
                             @"shortPath": stringNewFilePath
                             };
        
        
        
        NSDictionary *jsonObj = [ [NSDictionary alloc]initWithObjectsAndKeys :
                                 @"true", @"success",stringNewFileFullPath,stringNewFilePath,
                                 nil];
        
        NSError *jsonError;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ret options:NSJSONWritingPrettyPrinted error:&jsonError];
        
        
        if(!jsonData)
        {
            NSLog(@"Got an error %@",jsonError);
        }
        else{
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            
            
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus : CDVCommandStatus_OK
                                                          messageAsDictionary : jsonString];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }
    else{
        NSLog(@"Skriv til file feilet %@", error);
        NSString *message = [error localizedDescription];
        NSDictionary *jsonObj = [ [NSDictionary alloc]initWithObjectsAndKeys :
                                 @"false", message,
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
