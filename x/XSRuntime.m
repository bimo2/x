//
//  XSRuntime.m
//  x
//
//  Created by Bimal Bhagrath on 2023-12-24.
//

#import <Foundation/Foundation.h>
#import "XSDefine.h"
#import "XSPrint.h"

#import "XSRuntime.h"

@implementation XSRuntime

- (instancetype)initWitPath:(NSString *)path {
    return self;
}

- (void)version {
#if TARGET_CPU_ARM64
    NSString *arch = @"apple";
#else
    NSString *arch = @"intel";
#endif
    
    [XSPrint line:[NSString stringWithFormat:@"x/%@ %s (%s%d)", arch, VERSION, BUILD_VERSION, BUILD_NUMBER]];
}

@end
