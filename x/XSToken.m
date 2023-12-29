//
//  XSToken.m
//  x
//
//  Created by Bimal Bhagrath on 2023-12-29.
//

#import <Foundation/Foundation.h>

#import "XSToken.h"

@implementation XSToken

- (instancetype)initWithTextMatch:(NSTextCheckingResult *)textMatch line:(NSString *)line lineNumber:(NSInteger)lineNumber {
    NSRegularExpression *nameRegex = [NSRegularExpression regularExpressionWithPattern:@"\\w+[!]?" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *nameMatch = [nameRegex firstMatchInString:line options:0 range:textMatch.range];
    NSString *name = [line substringWithRange:nameMatch.range];
    
    if ([name hasSuffix:@"!"]) {
        _name = [name substringToIndex:name.length - 1];
        _isRequired = YES;
        _defaultValue = nil;
    } else {
        _name = name;
        _isRequired = NO;
        
        NSRegularExpression *valueRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<= -> )(.*?)(?=#)" options:NSRegularExpressionCaseInsensitive error:nil];
        NSTextCheckingResult *valueMatch = [valueRegex firstMatchInString:line options:0 range:textMatch.range];
        
        _defaultValue = valueMatch.range.length > 0 ? [line substringWithRange:valueMatch.range] : nil;
    }
    
    _lineNumber = lineNumber;
    _range = textMatch.range;
    
    return self;
}

@end
