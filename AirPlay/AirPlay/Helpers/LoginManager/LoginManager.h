//
//  LoginManager.h
//  AirPlay
//
//  Created by Aj on 18/08/24.
//

#import <Foundation/Foundation.h>


@interface LoginManager : NSObject

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSURLSession *session;

+ (instancetype)sharedInstance;
- (void)loginWithCompletion:(void (^)(BOOL success, NSError *error))completion;
- (void)silentLoginWithCompletion:(void (^)(BOOL success, NSError *error))completion;
- (void)logout;

@end

