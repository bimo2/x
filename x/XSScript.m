//
//  XSScript.m
//  x
//
//  Created by Bimal Bhagrath on 2023-12-29.
//

#import <Foundation/Foundation.h>
#import "XSCompiler.h"
#import "XSToken.h"

#import "XSScript.h"

@implementation XSScript

- (instancetype)initWithName:(NSString *)name info:(NSString *)info shell:(NSString *)shell commands:(NSArray *)commands {
    _name = name;
    _info = info;
    _shell = shell;
    _commands = [commands copy];
    
    return self;
}

- (NSString *)signature {
    NSString *result = [NSString stringWithString:self.name];
    NSArray *tokens = [XSCompiler tokenize:self];
    
    for (XSToken *token in tokens) {
        NSString *format = token.isRequired ? @" <%@!>" : @" <%@>";
        
        result = [result stringByAppendingFormat:format, token.name];
    }
    
    return result;
}

@end
