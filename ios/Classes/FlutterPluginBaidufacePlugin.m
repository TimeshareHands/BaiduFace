#import "FlutterPluginBaidufacePlugin.h"
#import "AFNetworking/AFNetworking/AFNetworking.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import "FaceParameterConfig.h"
#import "NetAccessModel.h"
#import "RegisterVC.h"
#import "DetectionViewController.h"
#import "NetAccessModel.h"
#import "ImageIOSave.h"
#import "MBProgressHUD.h"
#import "FaceSigninViewController.h"
@interface FlutterPluginBaidufacePlugin()<RegisterVCDelegate>
@property(nonatomic,strong)UITextField *passwordTextField;
@property(copy, nonatomic) FlutterResult result;
@end
@implementation FlutterPluginBaidufacePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    // 设置鉴权

     NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
     NSAssert([[NSFileManager defaultManager] fileExistsAtPath:licensePath], @"license文件路径不对，请仔细查看文档");
     [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
     NSLog(@"canWork = %d",[[FaceSDKManager sharedInstance] canWork]);
     [[NetAccessModel sharedInstance] getAccessTokenWithAK:FACE_API_KEY SK:FACE_SECRET_KEY];

      FlutterMethodChannel* channel = [FlutterMethodChannel
          methodChannelWithName:@"flutter_plugin_baiduface"
                binaryMessenger:[registrar messenger]];
      FlutterPluginBaidufacePlugin* instance = [[FlutterPluginBaidufacePlugin alloc] init];
      [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if([@"BaiduFaceToRegister" isEqualToString:call.method]){
      RegisterVC *registerVC =[RegisterVC new];
      [registerVC setLocalDelagate:self];
      [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:registerVC animated:YES completion:^{

      }];
      NSLog(@"iosRegister");
      self.result =result;
  }else if([@"BaiduFaceToLogin" isEqualToString:call.method]){
      FaceSigninViewController* fvc = [[FaceSigninViewController alloc] init];
      __weak typeof(self) weakSelf = self;
      fvc.signinCompletion = ^(NSDictionary* dict, NSString* message) {
//          [weakSelf performSegueWithIdentifier:message sender:dict];
          NSLog(@"dict==%@,message==%@",dict,message);
          [self loginRecongSuccess:dict[@"name"]];
      };
      self.result=result;
      [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:fvc animated:YES completion:nil];
  }else {
      result(FlutterMethodNotImplemented);
  }
}
-(void)loginRecongSuccess:(NSString *)suc{
    self.result(@{@"message":suc});
}
-(void)sendValue:(NSDictionary *)message{

    self.result(@{@"message":message[@"tip"]});

}
@end
