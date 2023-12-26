//
//  main.m
//  x
//
//  Created by Bimal Bhagrath on 2023-12-21.
//

#import <Foundation/Foundation.h>
#import "XSDefine.h"
#import "XSError.h"
#import "XSPrint.h"
#import "XSRuntime.h"

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

int sev(int code) {
    [XSPrint failure:[NSString stringWithFormat:@"(%d)", code] prefix:nil];
    
    return code;
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        char *url = NULL;
        int code = find(&url);
        
        if (code) {
            free(url);
            
            return sev(code);
        };
        
        NSString *path;
        
        if (url) {
            path = [NSString stringWithCString:url encoding:NSUTF8StringEncoding];
            free(url);
        }
        
        XSRuntime *app = [[XSRuntime alloc] initWitPath:path];
        
        if (!app) return sev(XSObjCError);
        
        [app version];
        
        return 0;
    }
}
