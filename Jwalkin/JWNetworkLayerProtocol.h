//
//  AFHTTPSessionManager
//  Jwalkin
//
//  Created by Asai on 4/6/17.
//  Copyright © 2017 fox. All rights reserved.
//
#import <Foundation/Foundation.h>
@class AFHTTPSessionManager;

@protocol NetworkLayerProtocol <NSObject>

- (instancetype) initWithSession : (AFHTTPSessionManager*) session;

@end
