//
//  main.m
//  x
//
//  Created by Bimal Bhagrath on 2023-12-21.
//

#import <Foundation/Foundation.h>

#ifndef BUILD_NUMBER
#define BUILD_NUMBER 1
#endif

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"x build#%d", BUILD_NUMBER);
    }

    return 0;
}
