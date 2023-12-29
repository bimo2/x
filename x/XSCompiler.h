//
//  XSCompiler.h
//  x
//
//  Created by Bimal Bhagrath on 2023-12-29.
//

#ifndef XSCOMPILER
#define XSCOMPILER

#import "XSScript.h"

@interface XSCompiler : NSObject

+ (NSArray *)compileScript:(XSScript *)script options:(NSArray *)options error:(NSError **)error;

@end

#endif /* XSCOMPILER */
