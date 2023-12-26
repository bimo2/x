//
//  testing.m
//  tests
//
//  Created by Bimal Bhagrath on 2023-12-21.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import "XSDefine.h"

#import "testing.h"

@interface Tests : XCTestCase

@property (nonatomic) NSBundle *bundle;
@property (nonatomic) NSFileManager *manager;

@end

@implementation Tests

- (void)setUp {
    _bundle = [NSBundle bundleForClass:self.class];
    _manager = NSFileManager.defaultManager;
}

- (void)test_findConfigurationFile_json {
    NSURL *url = [self.bundle URLForResource:@"x" withExtension:@"json"];
    NSString *json = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSString *file = [self.manager.currentDirectoryPath stringByAppendingPathComponent:@X_JSON];
    
    [json writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // find config file in:
    // - /
    //   - x.json
    //   > sh ./x
    char *xpath = NULL;
    
    find(&xpath);
    
    XCTAssertEqualObjects(@"x.json", [NSString stringWithCString:xpath encoding:NSUTF8StringEncoding].lastPathComponent);
    
    __weak Tests *weakSelf = self;
    
    [self addTeardownBlock:^{
        [weakSelf.manager removeItemAtPath:file error:nil];
        free(xpath);
    }];
}

- (void)test_findConfigurationFile_json5 {
    NSURL *url = [[NSBundle bundleForClass:self.class] URLForResource:@"x" withExtension:@"json5"];
    NSString *json = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSString *file = [[NSFileManager.defaultManager currentDirectoryPath] stringByAppendingPathComponent:@X_JSON5];
    
    [json writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // find config file in:
    // - /
    //   - x.json5
    //   > sh ./x
    char *xpath = NULL;
    
    find(&xpath);
    
    XCTAssertEqualObjects(@"x.json5", [NSString stringWithCString:xpath encoding:NSUTF8StringEncoding].lastPathComponent);
    
    __weak Tests *weakSelf = self;
    
    [self addTeardownBlock:^{
        [weakSelf.manager removeItemAtPath:file error:nil];
        free(xpath);
    }];
}

- (void)test_findConfigurationFile_recursive {
    NSURL *url = [[NSBundle bundleForClass:self.class] URLForResource:@"x" withExtension:@"json5"];
    NSString *json = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSString *directory = [self.manager.currentDirectoryPath stringByAppendingPathComponent:@"/folder"];
    NSString *file = [self.manager.currentDirectoryPath stringByAppendingPathComponent:@X_JSON5];
    
    [self.manager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    [json writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [self.manager changeCurrentDirectoryPath:directory];
    
    // find config file in:
    // - /
    //   - x.json5
    //   - folder/
    //     > sh ./x
    char *xpath = NULL;
    
    find(&xpath);
    
    XCTAssertEqualObjects(@"x.json5", [NSString stringWithCString:xpath encoding:NSUTF8StringEncoding].lastPathComponent);
    
    __weak Tests *weakSelf = self;
    
    [self addTeardownBlock:^{
        [weakSelf.manager removeItemAtPath:file error:nil];
        free(xpath);
    }];
}

- (void)test_findConfigurationFile_git {
    NSURL *url = [[NSBundle bundleForClass:self.class] URLForResource:@"x" withExtension:@"json5"];
    NSString *json = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSString *directory = [self.manager.currentDirectoryPath stringByAppendingPathComponent:@"/folder"];
    NSString *file = [self.manager.currentDirectoryPath stringByAppendingPathComponent:@X_JSON5];
    NSString *gitFile = [directory stringByAppendingPathComponent:@".git"];
    
    [self.manager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    [json writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [self.manager createFileAtPath:gitFile contents:nil attributes:nil];
    [self.manager changeCurrentDirectoryPath:directory];
    
    // find config file in:
    // - /
    //   - x.json5
    //   - folder/
    //     - .git
    //     > sh ./x
    char *xpath = NULL;
    
    find(&xpath);
    
    if (xpath) XCTAssert(false);
    
    __weak Tests *weakSelf = self;
    
    [self addTeardownBlock:^{
        [weakSelf.manager removeItemAtPath:file error:nil];
        [weakSelf.manager removeItemAtPath:gitFile error:nil];
        free(xpath);
    }];
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
