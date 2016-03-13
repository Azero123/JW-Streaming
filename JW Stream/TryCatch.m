//
//  TryCatch.m
//  JW Broadcasting
//
//  Created by Austin Zelenka on 11/22/15.
//  Copyright © 2015 xquared. All rights reserved.
//

#import "TryCatch.h"
@implementation TryCatch


//+ (void)try:void(^)())try catch:void(^)(NSException*exception))catch finally:void(^)())finally;

+(void)realTry:(void (^)())try withCatch:(void (^)())catch{
    @try {
        try ? try() : nil;
    }
    @catch (NSException *exception) {
        catch ? catch(exception) : nil;
    }
    @finally {
        //finally ? finally() : nil;
    }
}
/*
- (void)test{
    PTPusherChannel *channel = [client subscribeToChannelNamed:@"my-channel"];
    [channel bindToEventNamed:@"my-event" handleWithBlock:^(PTPusherEvent
                                                            *channelEvent) {
        NSString *message = [channelEvent.data objectForKey:@"text"];
        NSLog(@"message received: %@", message);
    }];
}*/

@end
