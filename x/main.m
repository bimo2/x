//
//  main.m
//  x
//
//  Created by Bimal Bhagrath on 2023-12-21.
//

#import <Foundation/Foundation.h>
#import "XSError.h"
#import "XSPrint.h"

#define X_JSON "x.json"
#define X_JSON5 "x.json5"

#define BUILD_VERSION "1A"

#ifndef BUILD_NUMBER
#define BUILD_NUMBER 1
#endif

int find(char **url) {
    NSArray *extensions = @[ @X_JSON, @X_JSON5 ];
    NSFileManager *manager = NSFileManager.defaultManager;
    NSString *path = manager.currentDirectoryPath;
    NSString *lastPath;
    NSError *error;
    BOOL isGitPath = NO;
    
    while (!isGitPath && ![path isEqualToString:lastPath]) {
        NSArray *directory = [manager contentsOfDirectoryAtPath:path error:&error];
        
        if (error) return XSPathError;
        
        for (NSString *file in directory) {
            if ([extensions containsObject:file]) {
                NSString *filePath = [path stringByAppendingPathComponent:file];
                
                *url = (char *) malloc((filePath.length + 1) * sizeof(char *));
                strcpy(*url, filePath.UTF8String);
                
                return 0;
            }
            
            isGitPath = isGitPath || [file isEqualToString:@".git"];
        }
        
        lastPath = path;
        path = [path stringByDeletingLastPathComponent];
    }
    
    return 0;
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        char *url = NULL;
        int code = find(&url);
        
        if (code) {
            [XSPrint error:[NSString stringWithFormat:@"(%d)", code] prefix:nil];
            free(url);
            
            return code;
        };
        
        NSString *path;
        
        if (url) {
            path = [NSString stringWithCString:url encoding:NSUTF8StringEncoding];
            free(url);
        }
        
        [XSPrint info:@"github/x" prefix:nil];
        [XSPrint success:@"done" prefix:nil];
        [XSPrint warning:@"not found" prefix:nil];
        [XSPrint error:@"failed" prefix:nil];
        [XSPrint line:[NSString stringWithFormat:@"build %s%d", BUILD_VERSION, BUILD_NUMBER]];
        
        return 0;
    }
}
