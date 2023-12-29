//
//  XSCompiler.m
//  x
//
//  Created by Bimal Bhagrath on 2023-12-29.
//

#import <Foundation/Foundation.h>
#import "XSError.h"
#import "XSToken.h"

#import "XSCompiler.h"

@implementation XSCompiler

+ (NSArray *)compileScript:(XSScript *)script options:(NSArray *)options error:(NSError **)error {
    NSMutableArray *lines = [NSMutableArray arrayWithArray:script.commands];
    NSMutableArray *tokens = NSMutableArray.array;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(?<=#)((\\w+[!]?)|(\\w+ -> ([^\\s#]+|\"[^#]+\")))(?=#)#" options:NSRegularExpressionCaseInsensitive error:nil];
    
    for (NSInteger i = 0; i < lines.count; i++) {
        NSString *line = [lines objectAtIndex:i];
        NSArray *matches = [regex matchesInString:line options:0 range:NSMakeRange(0, line.length)];
        
        for (NSTextCheckingResult *match in matches) {
            XSToken *token = [[XSToken alloc] initWithTextMatch:match line:line lineNumber:i];
            
            [tokens addObject:token];
        }
    }
    
    for (NSInteger i = 0; i < tokens.count; i++) {
        NSInteger index = tokens.count - (i + 1);
        XSToken *token = [tokens objectAtIndex:index];
        NSString *option = options.count > index ? [options objectAtIndex:index] : @"-";
        
        if (![option isEqualToString:@"-"]) {
            NSString *string = [option containsString:@" "] ? [NSString stringWithFormat:@"\"%@\"", option] : option;
            NSString *update = [lines[token.lineNumber] stringByReplacingCharactersInRange:token.range withString:string];
            
            [lines replaceObjectAtIndex:token.lineNumber withObject:update];
            
            continue;
        }
        
        if (token.isRequired) {
            *error = [NSError errorWithCode:XSRuntimeError reason:[NSString stringWithFormat:@"expected token: %@", token.name]];
            
            return nil;
        }
        
        if (token.defaultValue) {
            NSString *update = [lines[token.lineNumber] stringByReplacingCharactersInRange:token.range withString:token.defaultValue];
            
            [lines replaceObjectAtIndex:token.lineNumber withObject:update];
            
            continue;
        }
        
        NSString *update = [lines[token.lineNumber] stringByReplacingCharactersInRange:token.range withString:@""];
        
        [lines replaceObjectAtIndex:token.lineNumber withObject:update];
    }
    
    NSRegularExpression *whitespaceRegex = [NSRegularExpression regularExpressionWithPattern:@"\\s\\s+(?=(?:[^\"]*(\")[^\"]*\\1)*[^\"]*$)" options:NSRegularExpressionCaseInsensitive error:nil];
    
    for (NSMutableString *line in lines) {
        [whitespaceRegex replaceMatchesInString:line options:0 range:NSMakeRange(0, line.length) withTemplate:@" "];
    }
    
    return [NSArray arrayWithArray:lines];
}

@end
