//
//  RNBackgroundFetch.h
//  RNBackgroundFetch
//
//  Created by Christopher Scott on 2016-08-01.
//  Copyright © 2016 Christopher Scott. All rights reserved.
//


#import "RCTEventEmitter.h"

@interface RNBackgroundFetch : RCTEventEmitter

+ (void)gotBackgroundFetch:(void (^)(UIBackgroundFetchResult))completionHandler;

@end
