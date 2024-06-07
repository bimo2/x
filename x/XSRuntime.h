//
//  XSRuntime.h
//  x
//
//  Created by Bimal Bhagrath on 2023-12-24.
//

#ifndef XSRUNTIME_H
#define XSRUNTIME_H

@interface XSRuntime : NSObject

@property (nonatomic, copy, readonly) NSString *path;

- (instancetype)initWitPath:(NSString *)path error:(NSError **)error;

- (void)documentation;

- (void)cloneGitRepositoryAtURL:(NSString *)url error:(NSError **)error;

- (void)createJSON5WithFileManager:(NSFileManager *)fileManager error:(NSError **)error;

- (void)version;

- (void)executeWithName:(NSString *)name options:(NSArray *)options error:(NSError **)error;

@end

#endif // XSRUNTIME_H
