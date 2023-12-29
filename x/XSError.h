//
//  XSError.h
//  x
//
//  Created by Bimal Bhagrath on 2023-12-23.
//

#ifndef XSERROR_H
#define XSERROR_H

enum {
    XSObjCError = 100,
    XSPathError,
    XSGitError,
    XSSyntaxError,
    XSRuntimeError,
};

@interface NSError (XSError)

+ (NSError *)errorWithCode:(NSInteger)code reason:(NSString *)reason;

@end

#endif /* XSERROR_H */
