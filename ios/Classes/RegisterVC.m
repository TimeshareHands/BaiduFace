//
//  RegisterVC.m
//  flutter_plugin_baiduface
//
//  Created by 豪锅锅 on 2020/7/13.
//

#import "RegisterVC.h"
#import "DetectionViewController.h"
#import "NetAccessModel.h"
#import "ImageIOSave.h"
#import "MBProgressHUD.h"
@interface RegisterVC ()
@property (strong, nonatomic)UITextField *usernameTextField;
@property (strong, nonatomic)UITextField *passwordTextField;
@property (strong, nonatomic)UIButton *confirmBtn;
@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.usernameTextField =[UITextField new];
    [self.usernameTextField setPlaceholder:@"请输入用户名"];
    [self.usernameTextField.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.usernameTextField.layer setBorderWidth:0.5];
    [self.view addSubview:self.usernameTextField];
    [self.usernameTextField setFrame:CGRectMake(20, 100, self.view.frame.size.width-40, 33)];
    self.confirmBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmBtn setFrame:CGRectMake(20, 150, self.view.frame.size.width-40, 44)];
    [self.confirmBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:self.confirmBtn];
    [self.confirmBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
}

-(void)commit{
    if ([self.usernameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
           return;
       }
       //    if ([self.passwordTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
       //        return;
       //    }
       __weak typeof(self) weakSelf = self;
       DetectionViewController* dvc = [[DetectionViewController alloc] init];
       dvc.completion = ^(NSDictionary* images, UIImage* originImage){
           if (images[@"bestImage"] != nil && [images[@"bestImage"] count] != 0) {
               NSData* data = [[NSData alloc] initWithBase64EncodedString:[images[@"bestImage"] lastObject] options:NSDataBase64DecodingIgnoreUnknownCharacters];
               UIImage* bestImage = [UIImage imageWithData:data];
               NSLog(@"bestImage = %@",bestImage);
               NSString* bestImageStr = [[images[@"bestImage"] lastObject] copy];
               [weakSelf gotoRegister:bestImageStr originImage:originImage];
           }
       };
       [self presentViewController:dvc animated:YES completion:nil];
}
- (void)gotoRegister:(NSString *)bestImageStr originImage:(UIImage *)originImage {
    __weak typeof(self) weakSelf = self;
  //初始化进度框，置于当前的View当中
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     
    [[NetAccessModel sharedInstance] registerFaceWithImageBaseString:bestImageStr userName:self.usernameTextField.text completion:^(NSError *error, id resultObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error == nil) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:resultObject options:NSJSONReadingAllowFragments error:nil];
            NSInteger type = 0;
            NSString* tip = @"验证不成功!";
            if ([dict[@"error_code"] intValue] == 0) {
                NSLog(@"成功了 = %@",dict);
                type = 1;
                tip = @"注册完毕!";
                
                [[NSUserDefaults standardUserDefaults] setObject:weakSelf.passwordTextField.text forKey:weakSelf.usernameTextField.text];
                [[NSUserDefaults standardUserDefaults] synchronize];
                // 保存下成功之后的图片
                [ImageIOSave writeImage:originImage withName:weakSelf.usernameTextField.text];
            } else {
                NSLog(@"失败了 = %@,%@,%@",dict[@"error_code"],dict[@"error_msg"],dict[@"log_id"]);
            }
            if ([self.LocalDelagate respondsToSelector:@selector(sendValue:)]) {
                [self.LocalDelagate sendValue:@{@"image":originImage,@"tip":tip,@"type":@(type),@"goon":@(1),@"name":weakSelf.usernameTextField.text}];
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
            
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}
@end
