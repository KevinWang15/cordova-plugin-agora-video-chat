#import "Agora.h"
#import "AGDChatViewController.h"

@implementation AgoraPlugin

-(CDVPlugin*) pluginInitialize:(UIWebView*)theWebView
{
    //    self = [super initWithWebView:theWebView];
    return self;
}

- (void)setKey:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = [command callbackId];
    NSString* name = [[command arguments] objectAtIndex:0];
    NSString* msg = [NSString stringWithFormat: @"Hello, %@", name];
    
    _key = name;
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:msg];
    
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}


- (void)joinChannelImplementation:(CDVInvokedUrlCommand*)command mode: (BOOL) is_lecture_mode uid:(int) uid
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ChatView" bundle:nil];
    AGDChatViewController* chat = (AGDChatViewController*)[sb instantiateViewControllerWithIdentifier:@"ChatViewController"];
    //[chat setKey:@"7358d38eb1714f7c9d8cc937fcdc4c73"];
    [chat setKey: _key];
    [chat setChn:@"1"];
    [chat setCallback:__completionHandler];
    [chat setLecture:is_lecture_mode];
    [chat setUid:uid];
    _chat_instance = chat;
    [self.viewController presentViewController:chat animated:YES completion:nil];
}

-(void) joinChannel:(CDVInvokedUrlCommand *)command
{
    [self joinChannelImplementation:command mode:false uid:0];
}

-(void) startLecture:(CDVInvokedUrlCommand *)command
{
    [self joinChannelImplementation:command mode:true uid:10000];
}

-(void) joinLecture:(CDVInvokedUrlCommand *)command
{
    [self joinChannelImplementation:command mode:true uid:0];
}

-(void) listenForEvents:(CDVInvokedUrlCommand *)command
{
    NSString* callbackId = [command callbackId];
    void (^handler)(NSString*) = ^(NSString* message){
        CDVPluginResult* res = [CDVPluginResult
                                resultWithStatus:CDVCommandStatus_OK
                                messageAsString:message];
        //    [self success: res callbackId:callbackID];
        NSLog(message);
        [self.commandDelegate sendPluginResult:res callbackId:callbackId];
    };
    __completionHandler = handler;
}

@end
