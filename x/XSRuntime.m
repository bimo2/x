//
//  XSRuntime.m
//  x
//
//  Created by Bimal Bhagrath on 2023-12-24.
//

#import <Foundation/Foundation.h>
#import "XSContext.h"
#import "XSDefine.h"
#import "XSError.h"
#import "XSPrint.h"
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
    [XSPrint info:[NSString stringWithFormat:@"(%@)\n-", self.context.repo ?: @"null"] prefix:nil];
    
    if (self.context) {
        for (NSString *name in self.context.scripts.allKeys) {
            [XSPrint line:[(XSScript *) self.context.scripts[name] signatureWithName:name]];
        }
    } else {
        [XSPrint line:@"<url>            clone git repository"];
        [XSPrint line:@"init             create `x.json5` file"];
        [XSPrint line:@"--version, -v"];
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
    
    [XSPrint line:[NSString stringWithFormat:@"`cd $HOME/%@/%@`", gitURL.host, gitURL.lastPathComponent.stringByDeletingPathExtension]];
}

- (void)createJSON5WithFileManager:(NSFileManager *)fileManager error:(NSError **)error {
    NSString *file = [fileManager.currentDirectoryPath stringByAppendingPathComponent:@X_JSON5];
    NSString *template = [NSString stringWithFormat:@TEMPLATE_JSON5, fileManager.currentDirectoryPath.lastPathComponent];
    
    [template writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:error];
    [XSPrint line:[NSString stringWithFormat:@"`%@` file created, learn more: %@", @X_JSON5, @X_DOCS_URL]];
}

- (void)version {
#if TARGET_CPU_ARM64
    NSString *arch = @"apple";
#else
    NSString *arch = @"intel";
#endif
    
    [XSPrint line:[NSString stringWithFormat:@"x/%@ %s (%s%d)", arch, VERSION, BUILD_VERSION, BUILD_NUMBER]];
}

@end
