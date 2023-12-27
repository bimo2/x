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

@interface XSRuntime ()

@property (nonatomic, copy) NSString *path;

@end

@implementation XSRuntime

- (instancetype)initWitPath:(NSString *)path {
    _path = path;
    
    return self;
}

- (void)docs {
    [XSPrint info:[NSString stringWithFormat:@"%@\n-", nil] prefix:nil];
    [XSPrint line:@"<url>            clone git repository"];
    [XSPrint line:@"init             create `x.json5` file"];
    [XSPrint line:@"--version, -v"];
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
