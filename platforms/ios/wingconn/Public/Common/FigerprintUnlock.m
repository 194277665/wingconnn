//
//  FigerprintUnlock.m
//  wingconn
//
//  Created by gaomneng on 2017/7/13.
//
//

#import "FigerprintUnlock.h"

@implementation FigerprintUnlock
+(void)userFigerprintAuthenticationTisWithStr:(NSString *)tips success:(void(^)(BOOL success))block faild:(void(^)(NSInteger code))faild{
    
    
    LAContext *context = [[LAContext alloc]init];
    NSError *err = nil;
    
    //判断设备是否支持指纹解锁
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err])
    {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:tips reply:^(BOOL success, NSError * _Nullable error) {
            if (success)
            {
                
                block(YES);
                
            }else
            {
                //验证失败的几种情况
                 faild(error.code);
//                switch (err.code) {
                
//                    case LAErrorAuthenticationFailed:
//                        NSLog(@"LAErrorSystemCancel");
//                        
//                        break;
//                        //用户取消
//                    case LAErrorUserCancel:
//                        NSLog(@"LAErrorUserCancel");
//                        
//                        
//                        break;
//                        //验证失败
//                    case LAErrorUserFallback:
//                        NSLog(@"LAErrorUserFallback");
//                        
//                        
//                        break;
//                    case LAErrorSystemCancel:
//                        
//                        NSLog(@"LAErrorAppCancel");
//                        
//                        break;
//                        
//                    case LAErrorPasscodeNotSet:
//                        NSLog(@"LAErrorSystemCancel");
//                        
//                        break;
//                        //用户取消
//                    case LAErrorTouchIDNotAvailable:
//                        NSLog(@"LAErrorUserCancel");
//                        
//                        
//                        break;
//                        //验证失败
//                    case LAErrorTouchIDNotEnrolled:
//                        NSLog(@"LAErrorUserFallback");
//                        
//                        
//                        break;
//                    case LAErrorTouchIDLockout:
//                        
//                        NSLog(@"LAErrorAppCancel");
//                        
//                        break;
//                    case LAErrorAppCancel:
//                        
//                        NSLog(@"LAErrorAppCancel");
//                        
//                        break;
//                        
//                        
//                    case LAErrorInvalidContext:
//                        
//                        NSLog(@"LAErrorAppCancel");
//                        
//                        break;
                        
//                    default:
//                        break;
//                }
            }
            
        }];

    }else{
        faild(-1);
    }

}

@end
