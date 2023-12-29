//
//  XSScript.h
//  x
//
//  Created by Bimal Bhagrath on 2023-12-29.
//

#ifndef XSSCRIPT_H
#define XSSCRIPT_H

@interface XSScript : NSObject

@property (nonatomic, copy) NSString *info;
@property (nonatomic) NSArray *commands;

- (instancetype)initWithInfo:(NSString *)info commands:(NSArray *)commands;

- (NSString *)signatureWithName:(NSString *)name;

@end

#endif // XSSCRIPT_H
