//
//  XSRuntime.m
//  x
//
//  Created by Bimal Bhagrath on 2023-12-24.
//

#import <Foundation/Foundation.h>
#import "define.h"
#import "XSCompiler.h"
#import "XSContext.h"
#import "XSError.h"
#import "XSScript.h"

#import "XSRuntime.h"

@interface XSRuntime ()

@property (nonatomic) XSContext *context;

@end

@implementation XSRuntime

- (instancetype)initWitPath:(NSString *)path error:(NSError **)error {
    _path = path;
    
    if (path) _context = [[XSContext alloc] initWithData:[NSData dataWithContentsOfFile:path] error:error];
    
    return self;
}

- (void)docs {
    PRINT_INFO(@"x".UTF8String, ([NSString stringWithFormat:@"(%@)\n-", self.context.repo ?: @"null"]).UTF8String);
    
    if (self.context) {
        for (NSString *name in self.context.scripts.allKeys) {
            PRINT([(XSScript *) self.context.scripts[name] signatureWithName:name].UTF8String);
        }
    } else {
        PRINT(@"<url>            clone git repository".UTF8String);
        PRINT(@"init             create `x.json5` file".UTF8String);
        PRINT(@"--version, -v".UTF8String);
    }
}

- (void)cloneGitRepositoryWithURL:(NSString *)url error:(NSError **)error {
    NSURL *gitURL = [NSURL URLWithString:url];
    
    if (!gitURL || !gitURL.scheme || !gitURL.host) {
        *error = [NSError errorWithCode:XSGitError reason:@"invalid git url"];
        
        return;
    }
    
    NSFileManager *fileManager = NSFileManager.defaultManager;
    NSURL *pathURL = [fileManager.homeDirectoryForCurrentUser URLByAppendingPathComponent:gitURL.host];
    
    [fileManager createDirectoryAtURL:pathURL withIntermediateDirectories:YES attributes:nil error:error];
    [fileManager changeCurrentDirectoryPath:pathURL.path];
    
    NSInteger code = system([NSString stringWithFormat:@"git clone %@", url].UTF8String);
    
    if (code) {
        *error = [NSError errorWithCode:XSGitError reason:[NSString stringWithFormat:@"failed to clone: %@", url]];
        
        return;
    }
    
    PRINT(([NSString stringWithFormat:@"`cd $HOME/%@/%@`", gitURL.host, gitURL.lastPathComponent.stringByDeletingPathExtension]).UTF8String);
}

- (void)createJSON5WithFileManager:(NSFileManager *)fileManager error:(NSError **)error {
    NSString *file = [fileManager.currentDirectoryPath stringByAppendingPathComponent:@X_JSON5];
    NSString *template = [NSString stringWithFormat:@TEMPLATE_JSON5, fileManager.currentDirectoryPath.lastPathComponent];
    
    [template writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:error];
    PRINT(([NSString stringWithFormat:@"`%@` file created, learn more: %@", @X_JSON5, @DOCS_URL]).UTF8String);
}

- (void)version {
#if TARGET_CPU_ARM64
    NSString *arch = @"apple";
#else
    NSString *arch = @"intel";
#endif
    
    PRINT(([NSString stringWithFormat:@"x/%@ %s (%s%d)", arch, VERSION, BUILD, BUILD_NUMBER]).UTF8String);
}

- (void)runScriptWithName:(NSString *)name options:(NSArray *)options error:(NSError **)error {
    if (!self.context) {
        PRINT_STATUS(XSRuntimeError, ([NSString stringWithFormat:@"`%@` not found", @X_JSON5]).UTF8String);
        
        return;
    }
    
    XSScript *script = self.context.scripts[name];
    
    if (!script) {
        *error = [NSError errorWithCode:XSRuntimeError reason:[NSString stringWithFormat:@"undefined script: %@", name]];
        
        return;
    }
    
    NSDate *start = NSDate.date;
    NSArray *lines = [XSCompiler compileScript:script options:options error:error];
    
    if (*error) return;
    
    for (NSString *line in lines) {
        PRINT_INFO(name.UTF8String, line.UTF8String);
        
        NSInteger code = system([NSString stringWithFormat:@"cd %@ && sh -c '%@'", self.path.stringByDeletingLastPathComponent, line].UTF8String);
        
        if (code) {
            *error = [NSError errorWithCode:code reason:[NSString stringWithFormat:@"failed (%li)", code]];
            
            return;
        }
    }
    
    NSNumber *elapsed = [NSNumber numberWithDouble:start.timeIntervalSinceNow * -1];
    
    PRINT_STATUS(0, ([NSString stringWithFormat:@"%.3fs", elapsed.doubleValue]).UTF8String);
}

@end
