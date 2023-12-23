//
//  XSError.m
//  x
//
//  Created by Bimal Bhagrath on 2023-12-23.
//

#import <Foundation/Foundation.h>
#import "XSError.h"

@implementation NSError (XSError)

+ (NSError *)errorWithCode:(NSInteger)code reason:(NSString *)reason {
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: reason,
    };
    
    return [NSError errorWithDomain:@"com.github.x" code:code userInfo:userInfo];
}

@end
