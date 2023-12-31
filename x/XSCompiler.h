//
//  XSCompiler.h
//  x
//
//  Created by Bimal Bhagrath on 2023-12-29.
//

#ifndef XSCOMPILER_H
#define XSCOMPILER_H

#import "XSScript.h"

@interface XSCompiler : NSObject

+ (NSArray *)compileScript:(XSScript *)script options:(NSArray *)options error:(NSError **)error;

@end

#endif // XSCOMPILER_H
