//
//  RegisterVC.h
//  flutter_plugin_baiduface
//
//  Created by 豪锅锅 on 2020/7/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol  RegisterVCDelegate<NSObject>

-(void)sendValue:(NSDictionary *)message;

@end

@interface RegisterVC : UIViewController
@property(nonatomic, weak)id<RegisterVCDelegate> LocalDelagate;
@end

NS_ASSUME_NONNULL_END
