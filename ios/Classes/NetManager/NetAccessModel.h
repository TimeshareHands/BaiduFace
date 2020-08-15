//
//  NetAccessModel.h
//  FaceSharp
//
//  Created by 阿凡树 on 2017/5/25.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetManager.h"

@interface NetAccessModel : NSObject

+ (instancetype)sharedInstance;

/**
 * APP 启动的时候先获取token
 */
- (void)getAccessTokenWithAK:(NSString *)ak SK:(NSString *)sk;

- (void)registerFaceWithImageBaseString:(NSString *)imageStr userName:(NSString *)userName completion:(FinishBlockWithObject)completionBlock;
- (void)searchFaceWithImageBaseString:(NSString *)imageStr userName:(NSString *)userName completion:(FinishBlockWithObject)completionBlock;
@end
