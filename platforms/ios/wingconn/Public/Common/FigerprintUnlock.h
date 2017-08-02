//
//  FigerprintUnlock.h
//  wingconn
//
//  Created by gaomneng on 2017/7/13.
//
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface FigerprintUnlock : NSObject
+(void)userFigerprintAuthenticationTisWithStr:(NSString *)tips success:(void(^)(BOOL success))block faild:(void(^)(NSInteger code))faild;

@end
