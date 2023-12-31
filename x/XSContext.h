//
//  XSContext.h
//  x
//
//  Created by Bimal Bhagrath on 2023-12-28.
//

#ifndef XSCONTEXT_H
#define XSCONTEXT_H

@interface XSContext : NSObject

@property (nonatomic, readonly) NSInteger version;
@property (nonatomic, copy, readonly) NSString *project;
@property (nonatomic, readonly) NSArray *binaries;
@property (nonatomic, readonly) NSArray *scripts;

- (instancetype)initWithData:(NSData *)data error:(NSError **)error;

@end

#endif // XSCONTEXT_H
