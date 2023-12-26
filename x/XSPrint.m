//
//  XSPrint.m
//  x
//
//  Created by Bimal Bhagrath on 2023-12-23.
//

#import <Foundation/Foundation.h>
#import "XSPrint.h"

@implementation XSPrint

+ (void)info:(NSString *)log prefix:(NSString *)prefix {
    printf("\033[1m%s\033[0m %s\n", [prefix ?: @"x" UTF8String], log.UTF8String);
}

+ (void)success:(NSString *)log prefix:(NSString *)prefix {
    printf("\033[1;92m%s\033[0;92m %s\033[0m\n", [prefix ?: @"\u2713" UTF8String], log.UTF8String);
}

+ (void)warning:(NSString *)log prefix:(NSString *)prefix {
    printf("\033[1;93m%s\033[0;93m %s\033[0m\n", [prefix ?: @"!" UTF8String], log.UTF8String);
}

+ (void)failure:(NSString *)log prefix:(NSString *)prefix {
    printf("\033[1;91m%s\033[0;91m %s\033[0m\n", [prefix ?: @"\u2717" UTF8String], log.UTF8String);
}

+ (void)line:(NSString *)log {
    printf("%s\n", log.UTF8String);
}

@end
