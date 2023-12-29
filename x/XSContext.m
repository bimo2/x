//
//  XSContext.m
//  x
//
//  Created by Bimal Bhagrath on 2023-12-28.
//

#import <Foundation/Foundation.h>
#import "XSDefine.h"
#import "XSError.h"

#import "XSContext.h"

@implementation XSContext

- (instancetype)initWithData:(NSData *)data error:(NSError **)error {
    NSJSONReadingOptions options = NSJSONReadingJSON5Allowed | NSJSONReadingTopLevelDictionaryAssumed;
    id json = [NSJSONSerialization JSONObjectWithData:data options:options error:error];
    
    if (*error) return nil;
    
    if (![json isKindOfClass:NSDictionary.class]) {
        *error = [NSError errorWithCode:XSSyntaxError reason:@"expected JSON5 object"];
        
        return nil;
    }
    
    NSDictionary *object = json;
    id version = object[@"_x"];
    
    if (version && ![version isKindOfClass:NSNumber.class]) {
        *error = [NSError errorWithCode:XSSyntaxError reason:@"expected JSON5 number: _x"];
        
        return nil;
    }
    
    _version = [version integerValue] ?: COMPILER_VERSION;
    
    id repo = object[@"repo"];
    
    if (repo && ![repo isKindOfClass:NSString.class]) {
        *error = [NSError errorWithCode:XSSyntaxError reason:@"expected JSON5 string: repo"];
        
        return nil;
    }
    
    _repo = repo ?: @"";
    
    return self;
}

@end
