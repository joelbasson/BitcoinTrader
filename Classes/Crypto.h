//
//  Crypto.h
//  BitcoinTrader
//
//  Code taken from various stackoverflow.com posts.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSString (NSDataAdditions)

+ (NSString *) digest:(NSString*)input; //hash sha512
+ (NSString *) base64StringFromData:(NSData *)data length:(int)length; //decode base64
+ (NSString *) decryptData:(NSData*)ciphertext withKey:(NSString*)key; //decrypt aes256

@end

@interface NSData (NSDataAdditions)

+ (NSData *) base64DataFromString:(NSString *)string; //encode base64
- (NSData *) AES256EncryptWithKey:(NSString *)key;
- (NSData *) AES256DecryptWithKey:(NSString *)key;
+ (NSData *) encryptString:(NSString*)plaintext withKey:(NSString*)key; //encrypt aes256

@end
