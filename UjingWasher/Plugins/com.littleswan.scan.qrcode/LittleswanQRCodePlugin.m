/*
 Copyright 2009-2011 Urban Airship Inc. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.

 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#import "LittleswanQRCodePlugin.h"
#import "RootViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@interface LittleswanQRCodePlugin()

@property CDVInvokedUrlCommand *command;
@property (strong,nonatomic) NSMutableDictionary* parameter;

@end

@implementation LittleswanQRCodePlugin


- (void) pluginInitialize
{
    [self initData];
}

- (void) initData
{
    NSLog(@"initData");
}

-(void) scanQRCode:(CDVInvokedUrlCommand*)command
{
    cdVInvokedUrlCommand = command;

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        [self passValue:@"-1"];
        return;
    }
    NSArray *arguments = [command arguments];
    NSString *connectWifi = [arguments objectAtIndex:0];

    RootViewController * rt = [[RootViewController alloc]init];
    rt.flag = [self isNullString:connectWifi] ? 0 : [connectWifi intValue];
    rt.delegate = self;
    [self.viewController presentViewController:rt animated:YES completion:^{

    }];
}

- (BOOL) isNullString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

- (void)saveImageDataToLibrary:(CDVInvokedUrlCommand*)command
{
  cdVInvokedUrlCommand = command;
   NSData* imageData = [[NSData alloc] initWithBase64EncodedString:[command.arguments objectAtIndex:0] options:0];
   UIImage* image = [[UIImage alloc] initWithData:imageData];
   UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

 - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
 {
     // Was there an error?
     if (error != NULL) {
         // Show error message...
         NSLog(@"ERROR: %@",error);
         [self failWithMessage: @"saveImageDataToLibrary" withError: error withCommand: cdVInvokedUrlCommand];
     } else {  // No errors
       // Show message image successfully saved
       NSLog(@"IMAGE SAVED!");
       [self successWithMessage: cdVInvokedUrlCommand messageAsString: @"Image saved"];
     }
 }


-(void) passValue:(NSString *)value
{
    NSLog(@"get backcall value=%@",value);
    [self successWithMessage:cdVInvokedUrlCommand messageAsString:value];
}

//返回值
- (void) successWithMessage:(CDVInvokedUrlCommand*)command messageAsInt:(int) message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt: message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:command.callbackId];
}

- (void) successWithMessage:(CDVInvokedUrlCommand*)command messageAsDictionary: (NSDictionary*)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:command.callbackId];
}

- (void) successWithMessage:(CDVInvokedUrlCommand*)command messageAsArray: (NSArray*)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:command.callbackId];
}

- (void) successWithMessage:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:commandResult callbackId:command.callbackId];
}

- (void) successWithMessage:(CDVInvokedUrlCommand*)command messageAsString: (NSString *) message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:command.callbackId];
}

-(void) failWithMessage:(NSString *)method withError:(NSError *)error withCommand: (CDVInvokedUrlCommand*)command
{
    NSMutableDictionary * errorMessage = [NSMutableDictionary dictionaryWithCapacity:3];
    [errorMessage setObject:method forKey:@"method"];
    if(error != nil) {
        [errorMessage setObject:[NSString stringWithFormat:@"%ld",(long)[error code]] forKey:@"errorCode"];
        [errorMessage setObject:[error localizedDescription] forKey:@"errorMsg"];
    }
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorMessage];
    [self.commandDelegate sendPluginResult:commandResult callbackId:command.callbackId];
}

@end
