//
//  XSPrinter.h
//  x
//
//  Created by Bimal Bhagrath on 2023-12-23.
//

#ifndef XSPRINT_H
#define XSPRINT_H

@interface XSPrint : NSObject

+ (void)info:(NSString *)log prefix:(NSString *)prefix;

+ (void)success:(NSString *)log prefix:(NSString *)prefix;

+ (void)warning:(NSString *)log prefix:(NSString *)prefix;

+ (void)failure:(NSString *)log prefix:(NSString *)prefix;

+ (void)line:(NSString *)log;

@end

#endif /* XSPRINT_H */
