//
//  XSScript.h
//  x
//
//  Created by Bimal Bhagrath on 2023-12-29.
//

#ifndef XSSCRIPT_H
#define XSSCRIPT_H

@interface XSScript : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *info;
@property (nonatomic, copy, readonly) NSString *shell;
@property (nonatomic, readonly) NSArray *commands;

- (instancetype)initWithName:(NSString *)name info:(NSString *)info shell:(NSString *)shell commands:(NSArray *)commands;

- (NSString *)signature;

@end

#endif // XSSCRIPT_H
