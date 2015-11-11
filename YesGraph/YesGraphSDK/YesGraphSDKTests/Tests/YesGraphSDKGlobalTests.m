//
//  YesGraphSDKGlobalTests.m
//  YesGraphSDK
//
//  Created by Nejc Vivod on 26/10/15.
//  Copyright © 2015 YesGraph. All rights reserved.
//

@import XCTest;
#import "YSGConstants.h"
#import "YSGLogging.h"

@interface YesGraphSDKGlobalTests : XCTestCase

@end

@implementation YesGraphSDKGlobalTests

- (void)testErrorWithErrorCode
{
    // NOTE: this loop can fail if the values in the enum are not sequential!
    for (NSInteger errorCode = YSGErrorCodeNetwork; errorCode < YSGErrorCodeCacheWriteFailure; ++errorCode)
    {
        NSString *expectedErrorDescription;
        switch (errorCode) {
            case YSGErrorCodeInviteMessageUnavailable:
                expectedErrorDescription = @"Native Message Composer is unable to send text messages.";
                break;
            case YSGErrorCodeInviteMailUnavailable:
                expectedErrorDescription = @"Native Mail Composer is unable to send text messages.";
                break;
            default:
                expectedErrorDescription = @"Unknown error";
                break;
        }
        NSString *localizedErrorDescription = YSGLocalizedErrorDescriptionForErrorCode(errorCode);
        XCTAssert([localizedErrorDescription isEqualToString:expectedErrorDescription], @"Expected error description for code '%ld' to be '%@' not '%@'", (long)errorCode, expectedErrorDescription, localizedErrorDescription);
        NSError *errorWithCode = YSGErrorWithErrorCode(errorCode);
        XCTAssertNotNil(errorWithCode, @"Error with code '%ld' shouldn't be nil", (long)errorCode);
        XCTAssertEqual(errorWithCode.code, errorCode, @"Error code '%ld' in error not the same as '%ld'", (long)errorWithCode.code, (long)errorCode);
        XCTAssert([errorWithCode.domain isEqualToString:YSGErrorDomain], @"Error domain expected to be '%@' not '%@'", YSGErrorDomain, errorWithCode.domain);
        NSString *localizedDescriptionInfo = errorWithCode.userInfo[NSLocalizedDescriptionKey];
        XCTAssert([localizedDescriptionInfo isEqualToString:expectedErrorDescription], @"User info should contain the expected localized error description '%@' not '%@'", expectedErrorDescription, localizedDescriptionInfo);
        XCTAssertNil(errorWithCode.userInfo[NSUnderlyingErrorKey], @"Underlying error should be nil");
        
        NSError *underlying = [NSError errorWithDomain:@"Custom domain" code:-22 userInfo:@{ @"Custom error key": @"Custom error value" }];
        
        NSError *customErrorWithCode = YSGErrorWithErrorCodeWithError(errorCode, underlying);
        XCTAssert([customErrorWithCode.userInfo[NSUnderlyingErrorKey] isEqual:underlying], @"Underlying error '%@' not the same as expected '%@'", customErrorWithCode.userInfo[NSUnderlyingErrorKey], underlying);
    }
}

- (void)testLogging
{
    XCTAssertNotNil(YSGLogLevelString(YSGLogLevelNone), @"Should not be nil");
    XCTAssertNotNil(YSGLogLevelString(YSGLogLevelError), @"Should not be nil");
    XCTAssertNotNil(YSGLogLevelString(YSGLogLevelWarning), @"Should not be nil");
    XCTAssertNotNil(YSGLogLevelString(YSGLogLevelInfo), @"Should not be nil");
    XCTAssertNotNil(YSGLogLevelString(YSGLogLevelDebug), @"Should not be nil");
    XCTAssertNotNil(YSGLogLevelString(YSGLogLevelTrace), @"Should not be nil");
}

@end
