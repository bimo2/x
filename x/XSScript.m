//
//  XSScript.m
//  x
//
//  Created by Bimal Bhagrath on 2023-12-29.
//

#import <Foundation/Foundation.h>

#import "XSScript.h"

@implementation XSScript

- (instancetype)initWithInfo:(NSString *)info commands:(NSArray *)commands {
    _info = info;
    _commands = [commands copy];
    
    return self;
}

@end
