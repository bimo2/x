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
    
    if (path) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        _context = [[XSContext alloc] initWithData:data error:error];
    }
    
    return self;
}

- (void)documentation {
    NSString *header = [NSString stringWithFormat:@"%@\n", self.context.project ?: @"null"];
    
    PRINT_HEADER(header.UTF8String);
    
    if (self.context) {
        NSInteger maxLength = 0;
        NSInteger index = 1;
        NSInteger count = self.context.scripts.count;
        
        for (XSScript *script in self.context.scripts) {
            NSString *signature = script.signature;
            
            if (signature.length > maxLength) maxLength = signature.length;
        }
        
        for (XSScript *script in self.context.scripts) {
            NSString *leading = [script.signature stringByPaddingToLength:maxLength + 4 withString:@" " startingAtIndex:0];
            NSString *line;
            
            if (index == count) {
                line = [NSString stringWithFormat:@"%@%@\n", leading, script.info ?: @""];
            } else {
                line = [leading stringByAppendingString:script.info ?: @""];
            }
            
            PRINT(line.UTF8String);
            index++;
        }
        
        NSArray *errors = self.resolve;
        
        if (errors) {
            for (NSError *error in errors) PRINT_ERROR(error.localizedDescription.UTF8String);
            
            return;
        }
        
        NSString *caption = [NSString stringWithFormat:@"%ld %@", count, count == 1 ? @"script" : @"scripts"];
        
        PRINT(caption.UTF8String);
    } else {
        PRINT(@"<url>            clone git repository".UTF8String);
        PRINT(@"init             create `x.json5` file".UTF8String);
        PRINT(@"--version, -v".UTF8String);
        PRINT(@"\n-".UTF8String);
    }
}

- (void)cloneGitRepositoryAtURL:(NSString *)url error:(NSError **)error {
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
    
    NSString *command = [NSString stringWithFormat:@"cd $HOME/%@/%@", gitURL.host, gitURL.lastPathComponent.stringByDeletingPathExtension];
    
    PRINT_COMMAND(command.UTF8String);
}

- (void)createJSON5WithFileManager:(NSFileManager *)fileManager error:(NSError **)error {
    if (self.context) return;
    
    NSString *file = [fileManager.currentDirectoryPath stringByAppendingPathComponent:@X_JSON5];
    NSString *project = fileManager.currentDirectoryPath.lastPathComponent;
    NSString *template = [NSString stringWithFormat:@TEMPLATE_JSON5, project];
    NSString *caption = [NSString stringWithFormat:@"learn more: %@", @DOCS_URL];
    
    [template writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:error];
    PRINT_HEADER(project.UTF8String);
    PRINT_FILE;
    PRINT(caption.UTF8String);
}

- (void)version {
#if TARGET_CPU_ARM64
    NSString *arch = @"apple";
#else
    NSString *arch = @"intel";
#endif
    
    NSString *string = [NSString stringWithFormat:@"x\\%@ %s (%s%d)", arch, VERSION, BUILD, BUILD_NUMBER];
    
    PRINT(string.UTF8String);
}

- (void)xScriptWithName:(NSString *)name options:(NSArray *)options error:(NSError **)error {
    if (!self.context) {
        *error = [NSError errorWithCode:XSRuntimeError reason:[NSString stringWithFormat:@"not found: `%@`", @X_JSON5]];
        
        return;
    }
    
    XSScript *script;
    
    for (XSScript *object in self.context.scripts) {
        if ([object.name isEqualToString:name]) {
            script = object;
            
            break;
        }
    }
    
    if (!script) {
        *error = [NSError errorWithCode:XSRuntimeError reason:[NSString stringWithFormat:@"undefined: %@", name]];
        
        return;
    }
    
    NSDate *start = NSDate.date;
    NSArray *lines = [XSCompiler compile:script options:options error:error];
    
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
    
    PRINT_TIME(elapsed.doubleValue);
}

- (NSArray *)resolve {
    if (!self.context) return nil;
    
    NSMutableArray *errors = NSMutableArray.array;
    
    for (NSString *bin in self.context.binaries) {
        NSInteger status;
        
        if (bin.isAbsolutePath) {
            status = ![NSFileManager.defaultManager fileExistsAtPath:bin];
        } else {
            NSString *command = [NSString stringWithFormat:@"sh -c 'which -s %@'", bin];
            
            status = system(command.UTF8String);
        }
        
        if (status) {
            NSError *error = [NSError errorWithCode:XSSystemError reason:[NSString stringWithFormat:@"`%@` not found", bin]];
            
            [errors addObject:error];
        }
    }
    
    return errors.count ? [NSArray arrayWithArray:errors] : nil;
}

@end
