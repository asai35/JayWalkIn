//
//  NetworkLayerProtocol.h
//  PitneyBowes

#import <Foundation/Foundation.h>
@class AFHTTPSessionManager;

@protocol NetworkLayerProtocol <NSObject>

- (instancetype) initWithSession : (AFHTTPSessionManager*) session;

@end
