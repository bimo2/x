//
//  XSToken.h
//  x
//
//  Created by Bimal Bhagrath on 2023-12-29.
//

#ifndef XSTOKEN_H
#define XSTOKEN_H

@interface XSToken : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, readonly) BOOL isRequired;
@property (nonatomic, copy, readonly) NSString *defaultValue;
@property (nonatomic, readonly) NSInteger lineNumber;
@property (nonatomic, readonly) NSRange range;

- (instancetype)initWithTextMatch:(NSTextCheckingResult *)textMatch line:(NSString *)line lineNumber:(NSInteger)lineNumber;

@end

#endif // XSTOKEN_H
