//
//  Taken with small modifications
//
//  Copyright 2011 Google Inc.
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

#import "AGOtp.h"
#import "AGClock.h"

#import <CommonCrypto/CommonCrypto.h>

@interface AGOtp ()
@property (readwrite, nonatomic, copy) NSData *secret;
@end

@implementation AGOtp

@synthesize secret = secret_;
@synthesize tokenLength = tokenLength_;
@synthesize hashAlg = hashAlg_;

- (id)init {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (id)initWithSecret:(NSData *)secret {
  return [self initWithSecret:secret tokenLength:6 hashAlg:SHA1];
}

- (id)initWithSecret:(NSData *)secret tokenLength:(uint32_t)tokenLength {
  return [self initWithSecret:secret tokenLength:tokenLength hashAlg:SHA1];
}

- (id)initWithSecret:(NSData *)secret tokenLength:(uint32_t)tokenLength hashAlg:(HashAlg)hashAlg {
  if ((self = [super init])) {
    secret_ = [secret copy];
    tokenLength_ = tokenLength;
    hashAlg_ = hashAlg;
  }
  return self;
}

- (void)dealloc {
  self.secret = nil;
}

// Must be overriden by subclass.
- (NSString *)generateOTP {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (NSString *)generateOTPForCounter:(uint64_t)counter {
  CCHmacAlgorithm alg;
  NSUInteger hashLength;
  switch (self.hashAlg) {
    case SHA1:
      alg = kCCHmacAlgSHA1;
      hashLength = CC_SHA1_DIGEST_LENGTH;
      break;
    case SHA256:
      alg = kCCHmacAlgSHA256;
      hashLength = CC_SHA256_DIGEST_LENGTH;
      break;
    case SHA512:
      alg = kCCHmacAlgSHA512;
      hashLength = CC_SHA512_DIGEST_LENGTH;
      break;
    default:
      break;
  }

  NSMutableData *hash = [NSMutableData dataWithLength:hashLength];

  counter = NSSwapHostLongLongToBig(counter);
  NSData *counterData = [NSData dataWithBytes:&counter
                                       length:sizeof(counter)];
  CCHmacContext ctx;
  CCHmacInit(&ctx, alg, [secret_ bytes], [secret_ length]);
  CCHmacUpdate(&ctx, [counterData bytes], [counterData length]);
  CCHmacFinal(&ctx, [hash mutableBytes]);

  const char *ptr = [hash bytes];
  char const offset = ptr[hashLength-1] & 0x0f;
  uint32_t truncatedHash =
    NSSwapBigIntToHost(*((uint32_t *)&ptr[offset])) & 0x7fffffff;
  uint32_t pinValue = truncatedHash % (uint32_t)pow(10.0, self.tokenLength);

  return [NSString stringWithFormat:@"%0*d", self.tokenLength, pinValue];
}

@end
