//
//  LoginManager.m
//  AirPlay
//
//  Created by Aj on 18/08/24.
//

#import "LoginManager.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AirPlay-Swift.h"

@implementation LoginManager

+ (instancetype)sharedInstance {
    static LoginManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LoginManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _session = [NSURLSession sharedSession];
        _accessToken = PreferencesManager.shared.getAccessToken;
    }
    return self;
}

- (void)loginWithCompletion:(void (^)(BOOL success, NSError *error))completion {
    // Implement OAuth 2.0 login flow here
    // On success, cache the token and call the completion handler

    NSString *urlString = @"<OAuth_Login_URL>";
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Assuming you have a request setup
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
        
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(NO, error);
            return;
        }

        // Parse the response and extract the access token
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.accessToken = responseDict[@"access_token"];
        
        // Cache the token
        [PreferencesManager.shared setAccessToken:self.accessToken];
        
        completion(YES, nil);
    }];
    
    [task resume];
}

- (void)silentLoginWithCompletion:(void (^)(BOOL success, NSError *error))completion {
    if (!self.accessToken) {
        completion(NO, [NSError errorWithDomain:@"NoTokenError" code:401 userInfo:nil]);
        return;
    }
    
    // Check network reachability
    if (![self isNetworkReachable]) {
        [self logout];
        completion(NO, [NSError errorWithDomain:@"NetworkError" code:0 userInfo:nil]);
        return;
    }

    NSString *urlString = @"<OAuth_Silent_Login_URL>";
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    // Set the token in the headers
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            [self logout];
            completion(NO, error);
            return;
        }

        // Handle successful response
        completion(YES, nil);
    }];
    
    [task resume];
}

- (void)logout {
    self.accessToken = nil;
    [PreferencesManager.shared clearAllPreferences];
}

- (BOOL)isNetworkReachable {
   
    return [NetworkCheck.shared isConnected];
}

@end
