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
    id (^block)(NSError **, NSString *) = ^id(NSError **error, NSString *message) {
        *error = [NSError errorWithCode:XSSyntaxError reason:message];
        
        return nil;
    };
    
    NSJSONReadingOptions options = NSJSONReadingJSON5Allowed | NSJSONReadingTopLevelDictionaryAssumed;
    id json = [NSJSONSerialization JSONObjectWithData:data options:options error:error];
    
    if (*error || ![json isKindOfClass:NSDictionary.class]) return block(error, @"invalid JSON5 object");
    
    NSDictionary *object = json;
    id version = object[@"_x"];
    
    if (version && ![version isKindOfClass:NSNumber.class]) return block(error, @"expected JSON5 number: _x");
    
    _version = [version integerValue] ?: COMPILER;
    
    id project = object[@"git"];
    
    if (![project isKindOfClass:NSString.class]) return block(error, @"expected JSON5 string: git");
    
    _project = project;
    
    id binaries = object[@"require"];
    
    if (!binaries) {
        _binaries = NSArray.array;
    } else if (![binaries isKindOfClass:NSArray.class]) {
        return block(error, @"expected JSON5 array: require");
    } else {
        NSMutableArray *array = [NSMutableArray arrayWithArray:binaries];
        NSInteger index = 0;
        
        for (NSObject *item in array) {
            if (![item isKindOfClass:NSString.class]) {
                NSString *message = [NSString stringWithFormat:@"expected JSON5 string: require[%ld]", index];
                
                return block(error, message);
            }
            
            index++;
        }
        
        _binaries = [NSArray arrayWithArray:array];
    }
    
    id scripts = object[@"cli"];
    
    if (!scripts) {
        _scripts = NSArray.array;
    } else if (![scripts isKindOfClass:NSDictionary.class]) {
        return block(error, @"expected JSON5 object: cli");
    } else {
        NSDictionary *object = [NSMutableDictionary dictionaryWithDictionary:scripts];
        NSMutableArray *array = NSMutableArray.array;
        
        for (NSString *key in object.allKeys) {
            if (![object[key] isKindOfClass:NSDictionary.class]) {
                NSString *message = [NSString stringWithFormat:@"expected JSON5 object: cli.%@", key];
                
                return block(error, message);
            }
            
            id info = object[key][@"d"] ?: object[key][@"info"];
            
            if (info && ![info isKindOfClass:NSString.class]) {
                NSString *message = [NSString stringWithFormat:@"expected JSON5 string: cli.%@.d", key];
                
                return block(error, message);
            }
            
            NSString *shell;
            id commands;
            
            if ((commands = object[key][@"zsh"])) {
                shell = @"zsh";
            } else if ((commands = object[key][@"bash"])) {
                shell = @"bash";
            } else if ((commands = object[key][@"csh"])) {
                shell = @"csh";
            } else if ((commands = object[key][@"sh"])) {
                shell = @"sh";
            }
            
            if ([commands isKindOfClass:NSString.class]) {
                XSScript *script = [[XSScript alloc] initWithName:key info:info shell:shell commands:@[ commands ]];
                
                [array addObject:script];
                
                continue;
            }
            
            if ([commands isKindOfClass:NSArray.class]) {
                for (NSObject *item in commands) {
                    if (![item isKindOfClass:NSString.class]) {
                        NSString *message = [NSString stringWithFormat:@"expected JSON5 string: cli.%@.sh", key];
                        
                        return block(error, message);
                    }
                }
                
                XSScript *script = [[XSScript alloc] initWithName:key info:info shell:shell commands:commands];
                
                [array addObject:script];
                
                continue;
            }
            
            NSString *message = [NSString stringWithFormat:@"expected JSON5 string|array: cli.%@.sh", key];
            
            return block(error, message);
        }
        
        _scripts = [NSArray arrayWithArray:array];
    }
    
    return self;
}

@end
