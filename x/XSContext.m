//
//  XSContext.m
//  x
//
//  Created by Bimal Bhagrath on 2023-12-28.
//

#import <Foundation/Foundation.h>
#import "define.h"
#import "XSError.h"
#import "XSScript.h"

#import "XSContext.h"

@implementation XSContext

- (instancetype)initWithData:(NSData *)data error:(NSError **)error {
    NSJSONReadingOptions options = NSJSONReadingJSON5Allowed | NSJSONReadingTopLevelDictionaryAssumed;
    id json = [NSJSONSerialization JSONObjectWithData:data options:options error:error];
    
    if (*error || ![json isKindOfClass:NSDictionary.class]) {
        *error = [NSError errorWithCode:XSSyntaxError reason:@"invalid JSON5 object"];
        
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
    
    _repo = repo;
    
    id dependencies = object[@"dependencies"];
    
    if (!dependencies) {
        _dependencies = NSDictionary.dictionary;
    } else if (![dependencies isKindOfClass:NSDictionary.class]) {
        *error = [NSError errorWithCode:XSSyntaxError reason:@"expected JSON5 object: dependencies"];
        
        return nil;
    } else {
        NSMutableDictionary *copy = [NSMutableDictionary dictionaryWithDictionary:dependencies];
        
        for (NSString *key in copy.allKeys) {
            if ([copy[key] isKindOfClass:NSString.class]) {
                if ([(NSString *) copy[key] length] == 0) {
                    *error = [NSError errorWithCode:XSSyntaxError reason:[NSString stringWithFormat:@"expected JSON5 string: dependencies.%@", key]];
                    
                    return nil;
                }
                
                NSArray *array = @[[NSString stringWithString:copy[key]]];
                
                [copy setObject:array forKey:key];
                
                continue;
            } else if ([copy[key] isKindOfClass:NSArray.class]) {
                NSArray *array = dependencies[key];
                
                if (!array.count) {
                    *error = [NSError errorWithCode:XSSyntaxError reason:[NSString stringWithFormat:@"expected JSON5 array: dependencies.%@", key]];
                    
                    return nil;
                }
                
                for (NSObject *item in array) {
                    if (![item isKindOfClass:NSString.class]) {
                        *error = [NSError errorWithCode:XSSyntaxError reason:[NSString stringWithFormat:@"expected JSON5 string: dependencies.%@", key]];
                        
                        return nil;
                    }
                }
                
                continue;
            }
            
            *error = [NSError errorWithCode:XSSyntaxError reason:[NSString stringWithFormat:@"expected JSON5 string|array: dependencies.%@", key]];
            
            return nil;
        }
        
        _dependencies = [NSDictionary dictionaryWithDictionary:copy];
    }
    
    id scripts = object[@"scripts"];
    
    if (!scripts) {
        _scripts = NSDictionary.dictionary;
    } else if (![scripts isKindOfClass:NSDictionary.class]) {
        *error = [NSError errorWithCode:XSSyntaxError reason:@"expected JSON5 object: scripts"];
        
        return nil;
    } else {
        NSMutableDictionary *copy = [NSMutableDictionary dictionaryWithDictionary:scripts];
        
        for (NSString *key in copy.allKeys) {
            if (![copy[key] isKindOfClass:NSDictionary.class]) {
                *error = [NSError errorWithCode:XSSyntaxError reason:[NSString stringWithFormat:@"expected JSON5 object: scripts.%@", key]];
                
                return nil;
            }
            
            id info = scripts[key][@"info"];
            id commands = scripts[key][@"run"];
            
            if (info && ![info isKindOfClass:NSString.class]) {
                *error = [NSError errorWithCode:XSSyntaxError reason:[NSString stringWithFormat:@"expected JSON5 string: scripts.%@.info", key]];
                
                return nil;
            }
            
            if ([commands isKindOfClass:NSString.class]) {
                XSScript *script = [[XSScript alloc] initWithInfo:info commands:@[ commands ]];
                
                [copy setObject:script forKey:key];
                
                continue;
            }
            
            if ([commands isKindOfClass:NSArray.class]) {
                for (NSObject *item in commands) {
                    if (![item isKindOfClass:NSString.class]) {
                        *error = [NSError errorWithCode:XSSyntaxError reason:[NSString stringWithFormat:@"expected JSON5 string: scripts.%@.run", key]];
                        
                        return nil;
                    }
                }
                
                XSScript *script = [[XSScript alloc] initWithInfo:info commands:commands];
                
                [copy setObject:script forKey:key];
                
                continue;
            }
            
            *error = [NSError errorWithCode:XSSyntaxError reason:[NSString stringWithFormat:@"expected JSON5 string|array: scripts.%@.run", key]];
            
            return nil;
        }
        
        _scripts = [NSDictionary dictionaryWithDictionary:copy];
    }
    
    return self;
}

@end
