

#import <Foundation/Foundation.h>
#import "UrlFile.h"

typedef void(^ResponseHandler)(id data, NSError* error);
typedef void(^ProgressHandler)(float downloaded, float allBytes);

@interface JWNetWorkManager : NSObject

+ (instancetype) sharedManager;

- (void) setSessionToken: (NSString*) token;
- (void) setIdToken: (NSString*) token;
- (void) setAccessToken: (NSString*) token;
- (void) logout;

- (void) PATCH:(NSString*)path
          data:(NSDictionary*)data
    completion:(ResponseHandler) completion;

- (void) POST:(NSString*)path
         data:(NSDictionary*)data
   completion:(ResponseHandler) completion;

- (void) POST:(NSString*)path
         data:(NSDictionary*)data
     progress:(ProgressHandler) progressComplition
   completion:(ResponseHandler) completion;
- (void) GET:(NSString*)path
        data:(NSDictionary*)data
  completion:(ResponseHandler) completion;


- (void) GET:(NSString*)path
        data:(NSDictionary*)data
    progress:(ProgressHandler) progressComplition
  completion:(ResponseHandler) completion;

- (void) DELETE:(NSString*)path
           data:(NSDictionary*)data
     completion:(ResponseHandler) completion;

- (void) DELETE:(NSString*)path
           data:(NSDictionary*)data
       progress:(ProgressHandler) progressComplition
     completion:(ResponseHandler) completion;

- (void) PATH:(NSString*)method data:(NSDictionary*)data handler:(ResponseHandler) handler;




@end
