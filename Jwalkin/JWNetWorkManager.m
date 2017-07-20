
#import "JWNetWorkManager.h"
#import "AFNetworking.h"
typedef void(^URLCallback)(NSURLSessionDataTask* task, NSData* responseData, NSURLResponse* response, NSError* error);

@interface JWNetWorkManager()<NSURLSessionTaskDelegate>

@property (nonatomic,strong) NSMutableDictionary* progressStorage;
@property (nonatomic,strong) NSMutableDictionary* completionStorage;

@property (nonatomic,copy) URLCallback urlCallback;

@end


@implementation JWNetWorkManager{
    NSURLSession* m_session;
    NSString* session_token;
    NSString* id_token;
    NSString* access_token;
    NSURL* m_baseUrl;
    NSOperationQueue* m_operationQueue;

}
+ (instancetype) sharedManager{
    static id shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void) logout{
    session_token = nil;
    id_token = nil;
    access_token = nil;
}

- (instancetype) init {
    if (self = [super init]) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        m_baseUrl = [NSURL URLWithString:mainUrl];
        m_session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                  delegate:self
                                             delegateQueue:m_operationQueue];
        _progressStorage = [NSMutableDictionary new];
        _completionStorage = [NSMutableDictionary new];
        
        __weak JWNetWorkManager* weakSelf = self;
        
        _urlCallback = ^(NSURLSessionDataTask* task, NSData* responseData, NSURLResponse* response, NSError* error){
            
            ResponseHandler completion = weakSelf.completionStorage[@(task.taskIdentifier)];
            
            if (completion) {
                
                if (error) {
                    completion(nil, error);
                    return;
                }
                NSHTTPURLResponse* responseHTTP = (NSHTTPURLResponse*)response;
                
                NSError* serialize_error;
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:&serialize_error];
                if (serialize_error) {
                    completion(json, serialize_error);
                }
                if (responseHTTP.statusCode == 400) {
                    completion(json, [NSError errorWithDomain:@"Network" code:0 userInfo:@{}]);
                }
                if (weakSelf.progressStorage[@(task.taskIdentifier)]) {
                    [weakSelf.progressStorage removeObjectForKey:@(task.taskIdentifier)];
                }
                completion(json,nil);
                [weakSelf.completionStorage removeObjectForKey:@(task.taskIdentifier)];
            }
        };
    }
    return self;
}

- (void) setSessionToken:(NSString *)token{
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    [de setObject:token forKey:@"session_token"];
    session_token = token;
}

- (void) setIdToken:(NSString *)token{
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    [de setObject:token forKey:@"id_token"];
    id_token = token;
}

- (void) setAccessToken:(NSString *)token{
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    [de setObject:token forKey:@"access_token"];
    access_token = token;
}

#pragma mark Network methods

- (void) PATCH:(NSString*)path
          data:(NSDictionary*)data
    completion:(ResponseHandler) completion{
    __block NSURLSessionDataTask* task = [m_session dataTaskWithRequest:[self generateRequestWithFormData:@"PATCH"
                                                                                                     path:path
                                                                                                     data:data]
                                                      completionHandler:^(NSData* responseData, NSURLResponse* response, NSError* error) {
                                                          self.urlCallback(task, responseData, response, error);
                                                      }];
    [task resume];
    
    if (completion) {
        self.completionStorage[@(task.taskIdentifier)] = completion;
    }
}

- (void) POST:(NSString*)path
         data:(NSDictionary*)data
   completion:(ResponseHandler) completion{
    [self POST:path data:data progress:nil completion:completion];
}

- (void) POST:(NSString*)path
         data:(NSDictionary*)data
     progress:(ProgressHandler) progressComplition
   completion:(ResponseHandler) completion{
    
    __block NSURLSessionDataTask* task = [m_session dataTaskWithRequest:[self generateRequestWithFormData:@"POST"
                                                                                         path:path
                                                                                         data:data]
                                                      completionHandler:^(NSData* responseData, NSURLResponse* response, NSError* error) {
                                                          self.urlCallback(task, responseData, response, error);
                                                      }];
    [task resume];
    if (progressComplition) {
        self.progressStorage[@(task.taskIdentifier)] = progressComplition;
    }
    if (completion) {
        self.completionStorage[@(task.taskIdentifier)] = completion;
    }
}


- (void) GET:(NSString*)path
        data:(NSDictionary*)data
  completion:(ResponseHandler) completion{
    [self GET:path data:data progress:nil completion:completion];
}

- (void) GET:(NSString*)path
        data:(NSDictionary*)data
    progress:(ProgressHandler) progressComplition
  completion:(ResponseHandler) completion{
    __block NSURLSessionDataTask* task = [m_session dataTaskWithRequest:[self generateRequestWithQueryString:@"GET"
                                                                                                        path:path
                                                                                                        data:data]
                                                      completionHandler:
                                          ^(NSData* responseData, NSURLResponse* response, NSError* error) {
                                              self.urlCallback(task, responseData, response, error);
                                          }];
    [task resume];
    if (progressComplition) {
        self.progressStorage[@(task.taskIdentifier)] = progressComplition;
    }
    if (completion) {
        self.completionStorage[@(task.taskIdentifier)] = completion;
    }
}

- (void) DELETE:(NSString*)path
           data:(NSDictionary*)data
     completion:(ResponseHandler) completion{
    [self DELETE:path data:data progress:nil completion:completion];
}

- (void) DELETE:(NSString*)path
           data:(NSDictionary*)data
       progress:(ProgressHandler) progressComplition
     completion:(ResponseHandler) completion{
    __block  NSURLSessionDataTask* task = [m_session dataTaskWithRequest:[self generateRequest:@"DELETE"
                                                                                          path:path
                                                                                          data:data]
                                                       completionHandler:
                                           ^(NSData* responseData, NSURLResponse* response, NSError* error) {
                                               self.urlCallback(task, responseData, response, error);
                                           }];
    [task resume];
    if (progressComplition) {
        self.progressStorage[@(task.taskIdentifier)] = progressComplition;
    }
    if (completion) {
        self.completionStorage[@(task.taskIdentifier)] = completion;
    }
}

#pragma mark Response


#pragma mark Request

- (NSURLRequest*) generateRequest:(NSString*) method
                             path:(NSString*)path
                             data:(NSDictionary*)data {
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    request.URL = [self urlWithComponent:path];
//    request.HTTPMethod = method;
//    request.timeoutInterval = 20;
//    
//    NSData *postData = [[self postData:data] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    NSString *urlpath = [NSString stringWithFormat:@"%@", [self urlWithComponent:path]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlpath parameters:data error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    if (access_token){
        NSString* tokenRepresentation = [NSString stringWithFormat:@"Bearer %@",access_token];
        [request setValue:tokenRepresentation forHTTPHeaderField:@"Authorization"];
    }else{
    }
    
    return request;
}

- (void) PATH:(NSString*)method data:(NSDictionary*)data handler:(ResponseHandler) handler{
    NSURLRequest* request = [self generateRequestWithFormData:@"POST"
                                                         path:method
                                                         data:data];
    
    __block  NSURLSessionDataTask* task = [m_session dataTaskWithRequest:request
                                                       completionHandler:
                                           ^(NSData* responseData, NSURLResponse* response, NSError* error) {
                                               self.urlCallback(task, responseData, response, error);
                                           }];
    [task resume];
    if (handler) {
        self.completionStorage[@(task.taskIdentifier)] = handler;
    }
}

- (NSURLRequest*) generateRequestWithFormData:(NSString*)method path:(NSString*)path data:(NSDictionary*)data{
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:method URLString:[NSString stringWithFormat:@"%@%@/?a", mainUrl, path] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSString *key in [data allKeys]) {
            NSObject *obj = data[key];
            if ([key isEqualToString:@"image"]) {
                NSDictionary *dict = data[key];
                NSData *data = dict[@"data"];
                NSString *name = dict[@"name"];
                if ([name isEqualToString:@"Photo.png"]) {
                    [formData appendPartWithFileData:data name:@"image" fileName:name mimeType:@"image/jpeg"];
                }else{
                    [formData appendPartWithFileData:data name:@"image_name" fileName:name mimeType:@"image/jpeg"];
                }
            }else if([key isEqualToString:@"videos"]){
                NSDictionary *arr = data[key];
                NSArray *arrData = [arr objectForKey:@"data"];
                NSArray *arrFileName = [arr objectForKey:@"name"];
                NSArray *arrFileType = [arr objectForKey:@"type"];
                for (int i = 0; i <arrData.count; i++)
                {
                    [formData appendPartWithFileData:[arrData objectAtIndex:i] name:[arrFileName objectAtIndex:i] fileName:@"Photo.mp4" mimeType:[arrFileType objectAtIndex:i]];
                }
                
            }else if([key isEqualToString:@"images"]){
                NSDictionary *arr = data[key];
                NSArray *arrData = [arr objectForKey:@"data"];
                NSArray *arrFileName = [arr objectForKey:@"name"];
                for (int i = 0; i <arrData.count; i++)
                {
                    [formData appendPartWithFileData:[arrData objectAtIndex:i] name:[arrFileName objectAtIndex:i] fileName:@"Photo.png" mimeType:@"image/jpeg"];
                }
                
            }else if ([obj isKindOfClass:[NSString class]]) {
                NSString *strValue = (NSString *) obj;
                [formData appendPartWithFormData:[strValue dataUsingEncoding:NSUTF8StringEncoding] name:key];
            }
        }
    } error:nil];
    
    if (access_token){
        NSString* tokenRepresentation = [NSString stringWithFormat:@"Bearer %@", access_token];
        [request setValue:tokenRepresentation forHTTPHeaderField:@"Authorization"];
    }
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    return request;
}

- (NSURLRequest*) generateRequestWithQueryString:(NSString*)method
                                            path:(NSString*)path
                                            data:(NSDictionary*)data{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = method;
    request.timeoutInterval = 20;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[[self urlWithComponent:path] absoluteString]];
    
    NSMutableArray* query = [NSMutableArray new];
    for (NSString* key in data) {
        if([data[key] isKindOfClass:[NSArray class]]){
            for (id vType in data[key]) {
                [query addObject:[NSURLQueryItem queryItemWithName:key value:[NSString stringWithFormat:@"%@",vType]]];
            }
        }else{
            [query addObject:[NSURLQueryItem queryItemWithName:key value:[NSString stringWithFormat:@"%@",data[key]]]];
        }
    }
    components.queryItems = query;
    request.URL = [components URL];
    if(access_token){
        NSString* tokenRepresentation = [NSString stringWithFormat:@"Bearer %@",access_token];
        [request setValue:tokenRepresentation forHTTPHeaderField:@"Authorization"];
    }
    
    
    return request;
}

- (NSString*) postData : (NSDictionary*) dictionary {
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in dictionary) {
        id value = [dictionary objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}

static NSString *urlEncode(id object) {
    NSString *string = toString(object);
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
}

static NSString *toString(id object) {
    return [NSString stringWithFormat: @"%@", object];
}

- (NSURL*) urlWithComponent:(NSString*)component{
    component = [NSString stringWithFormat:@"%@/",component];
    return [m_baseUrl URLByAppendingPathComponent:component];
}

#pragma mark NSURLSessionTaskDelegate


- (void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    ProgressHandler progress = self.progressStorage[@(task.taskIdentifier)];
    if (progress) {
        progress((float) totalBytesSent, (float) totalBytesExpectedToSend);
    }
}


@end
