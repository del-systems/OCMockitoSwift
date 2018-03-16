//
//  Copyright © 2018 Aleksander Zubala. All rights reserved.
//

#import "OCMockitoSwiftAdapter.h"
#import <OCMockito/OCMockito.h>

static const NSUInteger invocationArgumentOffset = 2; //Indices 0 and 1 indicate the hidden arguments self and _cmd, respectively;

static const char *charType = "c";
static const char *intType = "i";
static const char *shortType = "s";
static const char *longType = "l";
static const char *longLongType = "q";

static const char *unsignedCharType = "C";
static const char *unsignedIntType = "I";
static const char *unsignedShortType = "S";
static const char *unsignedLongType = "L";
static const char *unsignedLongLongType = "Q";

static const char *floatType = "f";
static const char *doubleType = "d";
static const char *boolType = "bool";

static const char *voidType = "v";
static const char *objectType = "@";
static const char *classType = "#";
static const char *selectorType = ":";

@implementation OCMockitoSwiftAdapter

#pragma mark - Public methods

+ (id)mock:(Class)class {
    return mock(class);
}

+ (id)mockProtocol:(Protocol *)protocol {
    return mockProtocol(protocol);
}

+ (void)verify:(id)mock selector:(SEL)selector arguments:(NSArray *)arguments {
    verify(mock);
    NSInvocation *invocation = [self invocationFromMock:mock
                                            forSelector:selector
                                          withArguments:arguments];
    [invocation invoke];
}

+ (void)given:(id)mock selector:(SEL)selector arguments:(NSArray *)arguments willReturn:(id)returnValue {
    NSInvocation *invocation = [self invocationFromMock:mock
                                            forSelector:selector
                                          withArguments:arguments];
    [invocation invoke];
    id invocationReturnValue = nil;
    [invocation getReturnValue:&invocationReturnValue];
    [given(invocationReturnValue) willReturn:returnValue];
}

+ (void)given:(id)mock selector:(SEL)selector arguments:(NSArray *)arguments willReturnInt:(NSInteger)returnValue {
    NSInvocation *invocation = [self invocationFromMock:mock
                                            forSelector:selector
                                          withArguments:arguments];
    [invocation invoke];
    id invocationReturnValue = nil;
    [invocation getReturnValue:&invocationReturnValue];
    [given(invocationReturnValue) willReturnInt:(int) returnValue];
}

+ (void)given:(id)mock selector:(SEL)selector arguments:(NSArray *)arguments willReturnBool:(BOOL)returnValue {
    NSInvocation *invocation = [self invocationFromMock:mock
                                            forSelector:selector
                                          withArguments:arguments];
    [invocation invoke];
    id invocationReturnValue = nil;
    [invocation getReturnValue:&invocationReturnValue];
    [given(invocationReturnValue) willReturnBool:returnValue];
}

#pragma mark - Private methods

+ (NSInvocation *)invocationFromMock:(id)mock forSelector:(SEL)selector withArguments:(NSArray *)arguments {
    NSMethodSignature *signature = [mock methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:mock];
    [invocation setSelector:selector];
    for (NSUInteger i = 0; i < arguments.count; ++i) {
        id argument = arguments[i];
        NSUInteger argumentIndex = i + invocationArgumentOffset;
        [self setArgument:argument forInvocation:invocation withSignature:signature atIndex:argumentIndex];
    }
    return invocation;
}

+ (void)setArgument:(id)argument
      forInvocation:(NSInvocation *)invocation
      withSignature:(NSMethodSignature *)signature
            atIndex:(NSUInteger)index {
    const char *argumentType = [signature getArgumentTypeAtIndex:index];

    if (strcmp(argumentType, charType) == 0) {
        char primitiveArgument = [argument charValue];
        [invocation setArgument:&primitiveArgument atIndex:index];
    } else if (strcmp(argumentType, intType) == 0) {
        int primitiveArgument = [argument intValue];
        [invocation setArgument:&primitiveArgument atIndex:index];
    } else if (strcmp(argumentType, shortType) == 0) {
        short primitiveArgument = [argument shortValue];
        [invocation setArgument:&primitiveArgument atIndex:index];
    } else if (strcmp(argumentType, longType) == 0) {
        long primitiveArgument = [argument longValue];
        [invocation setArgument:&primitiveArgument atIndex:index];
    } else if (strcmp(argumentType, longLongType) == 0) {
        long long primitiveArgument = [argument longLongValue];
        [invocation setArgument:&primitiveArgument atIndex:index];
    } else if (strcmp(argumentType, unsignedCharType) == 0) {
        unsigned char primitiveArgument = [argument unsignedCharValue];
        [invocation setArgument:&primitiveArgument atIndex:index];
    } else if (strcmp(argumentType, unsignedIntType) == 0) {
        unsigned int primitiveArgument = [argument unsignedIntValue];
        [invocation setArgument:&primitiveArgument atIndex:index];
    } else if (strcmp(argumentType, unsignedShortType) == 0) {
        unsigned short primitiveArgument = [argument unsignedShortValue];
        [invocation setArgument:&primitiveArgument atIndex:index];
    } else if (strcmp(argumentType, unsignedLongType) == 0) {
        unsigned long primitiveArgument = [argument unsignedLongValue];
        [invocation setArgument:&primitiveArgument atIndex:index];
    } else if (strcmp(argumentType, unsignedLongLongType) == 0) {
        unsigned long long primitiveArgument = [argument unsignedLongLongValue];
        [invocation setArgument:&primitiveArgument atIndex:index];
    } else if (strcmp(argumentType, floatType) == 0) {
        float primitiveArgument = [argument floatValue];
        [invocation setArgument:&primitiveArgument atIndex:index];
    } else if (strcmp(argumentType, doubleType) == 0) {
        double primitiveArgument = [argument doubleValue];
        [invocation setArgument:&primitiveArgument atIndex:index];
    } else if (strcmp(argumentType, boolType) == 0) {
        BOOL primitiveArgument = [argument boolValue];
        [invocation setArgument:&primitiveArgument atIndex:index];
    } else if (strcmp(argumentType, selectorType) == 0) {
        SEL primitiveArgument = NSSelectorFromString(argument);
        [invocation setArgument:&primitiveArgument atIndex:index];
    } else {
        [invocation setArgument:&argument atIndex:index];
    }
}

@end
