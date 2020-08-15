//
//  FaceSigninViewController.m
//  FaceLogin
//
//  Created by 阿凡树 on 2017/11/20.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "FaceSigninViewController.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import "MBProgressHUD+LFYAdd.h"
#import "NetAccessModel.h"
#import "UIImage+Additions.h"

@interface FaceSigninViewController ()
@property (nonatomic, readwrite, assign) BOOL isFinishing;
@end

@implementation FaceSigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置超时时间
    [[FaceSDKManager sharedInstance] setConditionTimeout:1000];
//    [self startAnimation];
}
- (void)faceProcesss:(UIImage *)image {
    if (self.isFinishing) {
        return;
    }

    // SDK默认的而是无限重试，业务上建议3次之后，返回失败。
    __weak typeof(self) weakSelf = self;
    [[IDLFaceDetectionManager sharedInstance] detectStratrgyWithImage:image previewRect:self.previewRect detectRect:self.detectRect completionHandler:^(NSDictionary *images, DetectRemindCode remindCode) {
        switch (remindCode) {
            case DetectRemindCodeOK: {
                weakSelf.isFinishing = YES;
                if (images[@"bestImage"] != nil && [images[@"bestImage"] count] != 0) {
                    NSData* data = [[NSData alloc] initWithBase64EncodedString:[images[@"bestImage"] lastObject] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    UIImage* bestImage = [UIImage imageWithData:data];
                    NSLog(@"bestImage = %@",bestImage);
                }
                [weakSelf warningStatus:CommonStatus warning:@"非常好"];
                [weakSelf startAnimation];
                
                NSString* tempString = [images[@"bestImage"] lastObject];
                if (images[@"landMarks"] != nil && [images[@"landMarks"] count] >= 57) {
                    CGPoint nose = [images[@"landMarks"][57] CGPointValue];
                    //默认是竖屏情况，所以选择以鼻子为中心，边长为图片宽的正方形来做压缩
                    CGRect rect = CGRectMake(0, MAX(nose.y-image.size.width/2.0, 0), image.size.width, image.size.width);
                    UIImage* tempImage = [[image subImageAtRect:rect] resizedToSize:CGSizeMake(200, 200)];
                    tempString = [[tempImage dataWithCompress:0.8] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                }
                
                [[NetAccessModel sharedInstance] searchFaceWithImageBaseString:tempString userName:nil completion:^(NSError *error, id resultObject) {
                    [weakSelf stopAnimation];
                    if (error == nil) {
                        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:resultObject options:NSJSONReadingAllowFragments error:nil];
                        if ([dict[@"error_code"] intValue] == 0) {
                            NSDictionary* result = dict[@"result"];
                            if ([result[@"user_list"] count] > 0) {
                                NSDictionary* d = result[@"user_list"][0];
                                if (d[@"score"] != nil && [d[@"score"] floatValue] > 80 ) {
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        if (weakSelf.signinCompletion) {
                                            weakSelf.signinCompletion(@{@"image":image,@"tip":@"识别成功",@"name":[NSString stringWithFormat:@"%@\n\n相似度分值:%0.2f",d[@"user_info"],[d[@"score"] floatValue]],@"goon":@(0)},@"Login2Success");
                                        }
                                        [weakSelf closeAction];
                                        [weakSelf stopCapture];
                                    });
                                } else {
                                    [MBProgressHUD showTip:[NSString stringWithFormat:@"识别失败，请重试(%0.1f)",[d[@"score"] floatValue]] time:1.5f];
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        weakSelf.isFinishing = NO;
                                    });
                                }
                            } else {
                                 [MBProgressHUD showTip:dict[@"error_msg"]?:@"网络请求错误" time:1.5f];
                               
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    weakSelf.isFinishing = NO;
                                });
                            }
                        } else {
                             [MBProgressHUD showTip:dict[@"error_msg"]?:@"网络请求错误" time:1.5f];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                weakSelf.isFinishing = NO;
                            });
                        }
                    } else {
                         [MBProgressHUD showTip:@"网络请求错误" time:1.5f];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            weakSelf.isFinishing = NO;
                        });
                    }
                }];
                [weakSelf singleActionSuccess:true];
                break;
            }
            case DetectRemindCodePitchOutofDownRange:
                [weakSelf warningStatus:PoseStatus warning:@"建议略微抬头"];
                [weakSelf singleActionSuccess:false];
                break;
            case DetectRemindCodePitchOutofUpRange:
                [weakSelf warningStatus:PoseStatus warning:@"建议略微低头"];
                [weakSelf singleActionSuccess:false];
                break;
            case DetectRemindCodeYawOutofLeftRange:
                [weakSelf warningStatus:PoseStatus warning:@"建议略微向右转头"];
                [weakSelf singleActionSuccess:false];
                break;
            case DetectRemindCodeYawOutofRightRange:
                [weakSelf warningStatus:PoseStatus warning:@"建议略微向左转头"];
                [weakSelf singleActionSuccess:false];
                break;
            case DetectRemindCodePoorIllumination:
                [weakSelf warningStatus:CommonStatus warning:@"光线再亮些"];
                [weakSelf singleActionSuccess:false];
                break;
            case DetectRemindCodeNoFaceDetected:
                [weakSelf warningStatus:CommonStatus warning:@"把脸移入框内"];
                [weakSelf singleActionSuccess:false];
                break;
            case DetectRemindCodeImageBlured:
                [weakSelf warningStatus:CommonStatus warning:@"请保持不动"];
                [weakSelf singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionLeftEye:
                [weakSelf warningStatus:occlusionStatus warning:@"左眼有遮挡"];
                [weakSelf singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionRightEye:
                [weakSelf warningStatus:occlusionStatus warning:@"右眼有遮挡"];
                [weakSelf singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionNose:
                [weakSelf warningStatus:occlusionStatus warning:@"鼻子有遮挡"];
                [weakSelf singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionMouth:
                [weakSelf warningStatus:occlusionStatus warning:@"嘴巴有遮挡"];
                [weakSelf singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionLeftContour:
                [weakSelf warningStatus:occlusionStatus warning:@"左脸颊有遮挡"];
                [weakSelf singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionRightContour:
                [weakSelf warningStatus:occlusionStatus warning:@"右脸颊有遮挡"];
                [weakSelf singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionChinCoutour:
                [weakSelf warningStatus:occlusionStatus warning:@"下颚有遮挡"];
                [weakSelf singleActionSuccess:false];
                break;
            case DetectRemindCodeTooClose:
                [weakSelf warningStatus:CommonStatus warning:@"手机拿远一点"];
                [weakSelf singleActionSuccess:false];
                break;
            case DetectRemindCodeTooFar:
                [weakSelf warningStatus:CommonStatus warning:@"手机拿近一点"];
                [weakSelf singleActionSuccess:false];
                break;
            case DetectRemindCodeBeyondPreviewFrame:
                [weakSelf warningStatus:CommonStatus warning:@"把脸移入框内"];
                [weakSelf singleActionSuccess:false];
                break;
            case DetectRemindCodeVerifyInitError:
                [weakSelf warningStatus:CommonStatus warning:@"验证失败"];
                break;
            case DetectRemindCodeVerifyDecryptError:
                [weakSelf warningStatus:CommonStatus warning:@"验证失败"];
                break;
            case DetectRemindCodeVerifyInfoFormatError:
                [weakSelf warningStatus:CommonStatus warning:@"验证失败"];
                break;
            case DetectRemindCodeVerifyExpired:
                [weakSelf warningStatus:CommonStatus warning:@"验证失败"];
                break;
            case DetectRemindCodeVerifyMissRequiredInfo:
                [weakSelf warningStatus:CommonStatus warning:@"验证失败"];
                break;
            case DetectRemindCodeVerifyInfoCheckError:
                [weakSelf warningStatus:CommonStatus warning:@"验证失败"];
                break;
            case DetectRemindCodeVerifyLocalFileError:
                [weakSelf warningStatus:CommonStatus warning:@"验证失败"];
                break;
            case DetectRemindCodeVerifyRemoteDataError:
                [weakSelf warningStatus:CommonStatus warning:@"验证失败"];
                break;
            case DetectRemindCodeTimeout: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"remind" message:@"超时" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* action = [UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"知道啦");
                    }];
                    [alert addAction:action];
                    UIViewController* fatherViewController = weakSelf.presentingViewController;
                    [weakSelf dismissViewControllerAnimated:YES completion:^{
                        [fatherViewController presentViewController:alert animated:YES completion:nil];
                    }];
                });
                break;
            }
            case DetectRemindCodeConditionMeet: {
                weakSelf.circleView.conditionStatusFit = true;
            }
                break;
            default:
                break;
        }
        if (remindCode == DetectRemindCodeConditionMeet || remindCode == DetectRemindCodeOK) {
            weakSelf.circleView.conditionStatusFit = true;
        }else {
            weakSelf.circleView.conditionStatusFit = false;
        }
    }];
}
@end
