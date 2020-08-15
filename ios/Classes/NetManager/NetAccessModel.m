//
//  NetAccessModel.m
//  FaceSharp
//
//  Created by 阿凡树 on 2017/5/25.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "NetAccessModel.h"
#import "NSString+Additions.h"
#define BASE_URL @"https://aip.baidubce.com"

#define ACCESS_TOEKN_URL [NSString stringWithFormat:@"%@/oauth/2.0/token",BASE_URL]

#define REG_URL [NSString stringWithFormat:@"%@/rest/2.0/face/v3/faceset/user/add",BASE_URL]
#define SEARCH_URL [NSString stringWithFormat:@"%@/rest/2.0/face/v3/search",BASE_URL]

@interface NetAccessModel ()
@property (nonatomic, readwrite, retain) NSString *accessToken;
@property (nonatomic, readwrite, retain) NSString *groupID;
@end
@implementation NetAccessModel

+ (instancetype)sharedInstance {
    static NetAccessModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetAccessModel alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _groupID = [@"这里根据自己的业务选择合适的groupID" md5String];
    }
    return self;
}

- (void)getAccessTokenWithAK:(NSString *)ak SK:(NSString *)sk {
    __weak typeof(self) weakSelf = self;
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    NSLog(@"start = %f",start);
    [[NetManager sharedInstance] postDataWithPath:ACCESS_TOEKN_URL parameters:@{@"grant_type":@"client_credentials",@"client_id":ak,@"client_secret":sk} completion:^(NSError *error, id resultObject) {
        if (error == nil) {
            NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
            NSLog(@"end = %f",end);
            NSLog(@"Token = %f",end - start);
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:resultObject options:NSJSONReadingAllowFragments error:nil];
            weakSelf.accessToken = dict[@"access_token"];
            NSLog(@"%@",dict[@"access_token"]);
        } else {
            NSLog(@"error = %@",error);
        }
    }];
}

- (void)registerFaceWithImageBaseString:(NSString *)imageStr userName:(NSString *)userName completion:(FinishBlockWithObject)completionBlock {
    NSDictionary* parm = @{@"user_id":[userName md5String],
                           @"user_info":userName,
                           @"group_id":self.groupID ?: @"",
                           @"image_type":@"BASE64",
                           @"liveness_control":@"NORMAL",
                           @"quality_control":@"NORMAL",
                           @"image":imageStr};
    [[NetManager sharedInstance] postDataWithPath:[NSString stringWithFormat:@"%@?access_token=%@",REG_URL,self.accessToken] parameters:parm completion:^(NSError *error, id resultObject) {
        completionBlock(error,resultObject);
    }];
}
- (void)searchFaceWithImageBaseString:(NSString *)imageStr userName:(NSString *)userName completion:(FinishBlockWithObject)completionBlock {
    NSMutableDictionary* parm = [@{@"image":imageStr,
                           @"image_type":@"BASE64",
                           @"liveness_control":@"NORMAL",
                           @"quality_control":@"NORMAL",
                           @"group_id_list":self.groupID ?: @""} mutableCopy];
    if (userName != nil) {
        parm[@"user_id"] = [userName md5String];
    }
    [[NetManager sharedInstance] postDataWithPath:[NSString stringWithFormat:@"%@?access_token=%@",SEARCH_URL,self.accessToken] parameters:parm completion:^(NSError *error, id resultObject) {
        completionBlock(error,resultObject);
    }];
}
@end
