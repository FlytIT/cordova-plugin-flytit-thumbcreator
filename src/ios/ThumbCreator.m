//
//  ThumbCreator.m
//  PathPlugin


#import "ThumbCreator.h"

@implementation ThumbCreator

- (void)createThumb:(CDVInvokedUrlCommand *)command {
    NSString *stringFromPath = @"";
    NSString *stringToPath = @"";
   
    if(command.arguments.count > 0) {
        stringFromPath = [command.arguments objectAtIndex:0];
        if([stringFromPath hasPrefix:@"file://"]) {
            stringFromPath = [stringFromPath substringFromIndex:6];
        }
    }
    
    if(command.arguments.count > 1) {
        stringToPath = [command.arguments objectAtIndex:1];
        if([stringToPath hasPrefix:@"file://"]) {
            stringToPath = [stringToPath substringFromIndex:6];
        }
    }
    
    //NSString *path = [stringToPath stringByDeletingLastPathComponent];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:stringToPath]) {
        // create the folder
        [fileManager createDirectoryAtPath:stringToPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSError *error = nil;
    
    UIImage *imageResize = [self imageWithImage:[UIImage imageWithContentsOfFile:stringFromPath] scaledToSize:CGSizeMake(100, 100)];
    
    NSString *targetFilePaht = [NSString stringWithFormat:@"%@/Thumb.jpg", stringToPath];

    BOOL success = [UIImageJPEGRepresentation(imageResize, 0.5) writeToFile:targetFilePaht options: NSDataWritingAtomic error:&error];
    
    if(success) {
        NSDictionary* ret = @{
            @"absolutePath": targetFilePaht,
            @"success": @"true"};
        
        NSError *jsonError;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ret options:NSJSONWritingPrettyPrinted error:&jsonError];
        
        
        if(!jsonData) {
            NSLog(@"Got an error %@",jsonError);
        } else {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
           
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                          messageAsString:jsonString];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    } else {
        NSString *message = [error localizedDescription];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];
        
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
