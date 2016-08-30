//
//  RNBackgroundFetch.m
//  RNBackgroundFetch
//
//  Created by Christopher Scott on 2016-08-01.
//  Copyright © 2016 Christopher Scott. All rights reserved.
//

#import "RNBackgroundFetch.h"
#import <UIKit/UIKit.h>

#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "RCTUtils.h"
#import "RCTLog.h"

NSString *const RNBackgroundFetchGotNotification = @"RNBackgroundFetchGotNotification";


@implementation RNBackgroundFetch {
    void (^_done) (BOOL);
    int count;
}


RCT_EXPORT_MODULE();

- (void)startObserving
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleBackgroundFetch:)
                                                 name:RNBackgroundFetchGotNotification
                                               object:nil];

}

- (void)stopObserving
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"backgroundFetch"];
}

-(id)init {
    self = [super init];
    if (self) {
        self->_done = nil;
        self->count = 0;
    }
    return self;
}

+ (void)gotBackgroundFetch:(void (^)(UIBackgroundFetchResult))completionHandler {
    
 
    NSDictionary *payload = @{@"callback": completionHandler};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RNBackgroundFetchGotNotification
                                                        object:self
                                                        userInfo: payload];

}


RCT_EXPORT_METHOD(getCount:(RCTResponseSenderBlock)callback)
{
    callback(@[[NSNumber numberWithInt: self->count]]);
}


RCT_EXPORT_METHOD(done:(BOOL)gotData)
{
    if (self->_done) {
        self->_done(gotData);
        self->_done = nil;
    }
}

- (void)handleBackgroundFetch:(NSNotification *)notification {

    void (^completionHandler) (UIBackgroundFetchResult);


    completionHandler = [[notification userInfo] objectForKey:@"callback"];
    
    self->_done = ^(BOOL hasData){
        RCTLogInfo(@"Completing background fetch");
        if (hasData) {
            completionHandler(UIBackgroundFetchResultNewData);
        } else {
            completionHandler(UIBackgroundFetchResultNoData);
        }
    };
    
    
    self->count++;
    completionHandler(UIBackgroundFetchResultNewData);
    
    //[self sendEventWithName:@"backgroundFetch" body:nil];
}

@end
