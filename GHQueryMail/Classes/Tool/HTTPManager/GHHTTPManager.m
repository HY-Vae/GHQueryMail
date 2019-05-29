//
//  GHHTTPManager.m
//  Field
//
//  Created by 赵治玮 on 2017/11/8.
//  Copyright © 2017年 赵治玮. All rights reserved.
//

#import "GHHTTPManager.h"
#import "MJExtension.h"

@implementation GHHTTPManager

+ (instancetype)sharedManager {
    
    static GHHTTPManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:@""];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 20;
        [_instance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        _instance = [[self alloc] initWithBaseURL:baseUrl sessionConfiguration:config];
        _instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html",@"text/plain", @"application/x-www-form-urlencoded",@"text/javascript", nil];
        });
    
    return _instance;
}


- (void)queryMailWithNum: (NSString *)num finishedBlock: (FinishedBlock)finishedBlock {
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"no"]= num;
    dict[@"type"]= @"";
    NSString *appcode = @"fb64123b82494f71867c02ca50bde1b4";
    NSString *host = @"https://wuliu.market.alicloudapi.com";
    NSString *path = @"/kdi";
    NSString *method = @"GET";
    NSString *querys = [NSString stringWithFormat:@"?no=%@&type",num];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]  cachePolicy:1  timeoutInterval:  5];
    request.HTTPMethod  =  method;
    [request addValue:  [NSString  stringWithFormat:@"APPCODE %@" ,  appcode]  forHTTPHeaderField:  @"Authorization"];
    NSURLSession *requestSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [requestSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                       NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
                                                       finishedBlock(bodyString.mj_JSONObject,error);
                                                       NSLog(@"bodyString%@",bodyString);
                                                   }];
    
    [task resume];

}

- (void)openFinishedBlock: (FinishedBlock)finishedBlock {
    [[GHHTTPManager sharedManager] GET:@"https://www.easy-mock.com/mock/5cbf288480765e196c613b88/GHQueryMail/phoneNums" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finishedBlock(responseObject,nil);
        NSLog(@"%@",responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);

    }];
}
@end
