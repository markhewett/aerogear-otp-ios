//
//  Copyright 2014 Mark Hewett
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

#import <SenTestingKit/SenTestingKit.h>
#import "AGOtp.h"

@interface AGOtpTests : SenTestCase

@end

@implementation AGOtpTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRFC6238SHA1 {
    
    const char bytes[] = "12345678901234567890";
    AGOtp *generator = [[AGOtp alloc] initWithSecret:[NSData dataWithBytes:bytes length:20] tokenLength:8];
    STAssertEqualObjects(@"94287082", [generator generateOTPForCounter:0x0000000000000001], @"Incorrect OTP");
    STAssertEqualObjects(@"07081804", [generator generateOTPForCounter:0x00000000023523EC], @"Incorrect OTP");
    STAssertEqualObjects(@"14050471", [generator generateOTPForCounter:0x00000000023523ED], @"Incorrect OTP");
    STAssertEqualObjects(@"89005924", [generator generateOTPForCounter:0x000000000273EF07], @"Incorrect OTP");
    STAssertEqualObjects(@"69279037", [generator generateOTPForCounter:0x0000000003F940AA], @"Incorrect OTP");
    STAssertEqualObjects(@"65353130", [generator generateOTPForCounter:0x0000000027BC86AA], @"Incorrect OTP");
    
}

- (void)testRFC6238SHA256 {
    
    const char bytes[] = "12345678901234567890123456789012";
    AGOtp *generator = [[AGOtp alloc] initWithSecret:[NSData dataWithBytes:bytes length:32] tokenLength:8 hashAlg:SHA256];
    STAssertEqualObjects(@"46119246", [generator generateOTPForCounter:0x0000000000000001], @"Incorrect OTP");
    STAssertEqualObjects(@"68084774", [generator generateOTPForCounter:0x00000000023523EC], @"Incorrect OTP");
    STAssertEqualObjects(@"67062674", [generator generateOTPForCounter:0x00000000023523ED], @"Incorrect OTP");
    STAssertEqualObjects(@"91819424", [generator generateOTPForCounter:0x000000000273EF07], @"Incorrect OTP");
    STAssertEqualObjects(@"90698825", [generator generateOTPForCounter:0x0000000003F940AA], @"Incorrect OTP");
    STAssertEqualObjects(@"77737706", [generator generateOTPForCounter:0x0000000027BC86AA], @"Incorrect OTP");
    
}

- (void)testRFC6238SHA512 {
    
    const char bytes[] = "1234567890123456789012345678901234567890123456789012345678901234";
    AGOtp *generator = [[AGOtp alloc] initWithSecret:[NSData dataWithBytes:bytes length:64] tokenLength:8 hashAlg:SHA512];
    STAssertEqualObjects(@"90693936", [generator generateOTPForCounter:0x0000000000000001], @"Incorrect OTP");
    STAssertEqualObjects(@"25091201", [generator generateOTPForCounter:0x00000000023523EC], @"Incorrect OTP");
    STAssertEqualObjects(@"99943326", [generator generateOTPForCounter:0x00000000023523ED], @"Incorrect OTP");
    STAssertEqualObjects(@"93441116", [generator generateOTPForCounter:0x000000000273EF07], @"Incorrect OTP");
    STAssertEqualObjects(@"38618901", [generator generateOTPForCounter:0x0000000003F940AA], @"Incorrect OTP");
    STAssertEqualObjects(@"47863826", [generator generateOTPForCounter:0x0000000027BC86AA], @"Incorrect OTP");
    
}

@end
