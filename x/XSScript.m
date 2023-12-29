//
//  XSScript.m
//  x
//
//  Created by Bimal Bhagrath on 2023-12-29.
//

#import <Foundation/Foundation.h>
#import "XSToken.h"

#import "XSScript.h"

@implementation XSScript

- (instancetype)initWithInfo:(NSString *)info commands:(NSArray *)commands {
    _info = info;
    _commands = [commands copy];
    
    return self;
}

- (NSString *)signatureWithName:(NSString *)name {
    NSMutableArray *tokens = NSMutableArray.array;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(?<=#)((\\w+[!]?)|(\\w+ -> ([^\\s#]+|\"[^#]+\")))(?=#)#" options:NSRegularExpressionCaseInsensitive error:nil];
    
    for (int i = 0; i < self.commands.count; i++) {
        NSString *line = [self.commands objectAtIndex:i];
        NSArray *matches = [regex matchesInString:line options:0 range:NSMakeRange(0, line.length)];
        
        for (NSTextCheckingResult *match in matches) {
            XSToken *token = [[XSToken alloc] initWithTextMatch:match line:line lineNumber:i];
            
            [tokens addObject:token];
        }
    }
    
    NSString *result = [NSString stringWithString:name];
    
    for (XSToken *token in tokens) {
        NSString *format = token.isRequired ? @" <%@!>" : @" <%@>";
        
        result = [result stringByAppendingFormat:format, token.name];
    }
    
    return result;
}

@end
