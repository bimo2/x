//
//  XSRuntime.h
//  x
//
//  Created by Bimal Bhagrath on 2023-12-24.
//

#ifndef XSRUNTIME_H
#define XSRUNTIME_H

@interface XSRuntime : NSObject

@property (nonatomic, copy) NSString *path;

- (instancetype)initWitPath:(NSString *)path;

- (void)docs;

- (void)cloneGitRepositoryWithURL:(NSString *)url error:(NSError **)error;

- (void)createJSON5WithFileManager:(NSFileManager *)fileManager error:(NSError **)error;

- (void)version;

@end

#endif /* XSRUNTIME_H */
