//
//  XSContext.h
//  x
//
//  Created by Bimal Bhagrath on 2023-12-28.
//

#ifndef XSCONTEXT_H
#define XSCONTEXT_H

@interface XSContext : NSObject

@property (nonatomic) NSInteger version;
@property (nonatomic, copy) NSString *repo;

- (instancetype)initWithData:(NSData *)data error:(NSError **)error;

@end

#endif /* XSCONTEXT_H */
