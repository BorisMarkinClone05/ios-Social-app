/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/

#import "CLFCredentialsStorage.h"
#import "CLFCredentials.h"
#import <Security/Security.h>

static const UInt8 sKeyChainItemIdentifier[] = "com.closefriends.credentials\0";

@interface CLFCredentialsStorage () {
    NSDictionary *_keychainQueryTemplateForAttributes;
    NSDictionary *_keychainItemAttributesTemplate;
    
    CLFCredentials *_storedCredential;
}

@end

@implementation CLFCredentialsStorage

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        
        CFTypeRef outType = NULL;
        
        OSStatus keychainErr = SecItemCopyMatching((__bridge CFDictionaryRef)[self queryTemplateForData], &outType);
        if(keychainErr == noErr) {
            if(outType != NULL && CFGetTypeID(outType) == CFDataGetTypeID()) {
                _storedCredential = [self credentialsFromData:(__bridge NSData *)outType];
            } else {
                _storedCredential = nil;
            }
        } else if(keychainErr == errSecItemNotFound){
            _storedCredential = nil;
        } else {
            NSAssert(NO, @"Serious keychain error");
        }
        
        if(outType != nil) {
            CFRelease(outType);
        }
    }
    return self;
}

- (CLFCredentials *)storedCredentials {
    return [_storedCredential copy];
}

- (BOOL)storeCredentials:(CLFCredentials *)credentials {
    BOOL result = NO;
    
    credentials = [self credentialsMergedWithStoredCredentials:credentials];
    
    CFTypeRef outType = NULL;
    OSType keychainErr = SecItemCopyMatching((__bridge CFDictionaryRef)[self queryTemplateForAttributes], &outType);
    if(keychainErr == noErr) {
        if(outType != NULL && CFGetTypeID(outType) == CFDictionaryGetTypeID()) {
            NSMutableDictionary *attributes = [(__bridge_transfer NSDictionary *)outType mutableCopy];
            [attributes setObject:[[self attributesTemplate] objectForKey:(__bridge id)kSecClass] forKey:(__bridge id)kSecClass];
            if(credentials != nil) {
                NSData *data = [self dataFromCredential:credentials];
                if(data != nil) {
                    NSDictionary *values = @{(__bridge id)kSecValueData : data};
                    if(SecItemUpdate((__bridge CFDictionaryRef)attributes, (__bridge CFDictionaryRef)values) != noErr) {
                        NSAssert(NO, @"Keychain error when updating item");
                    } else {
                        result = YES;
                    }
                } else {
                    NSAssert(NO, @"Keychain error when updating item");
                }
            } else {
                if(SecItemDelete((__bridge CFDictionaryRef)attributes) != noErr) {
                    NSAssert(NO, @"Keychain error when deleting item");
                } else {
                    result = YES;
                }
            }
        } else {
            NSAssert(NO, @"Serious keychain error");
        }
    } else if(keychainErr == errSecItemNotFound) {
        if(credentials != nil) {
            NSData *data = [self dataFromCredential:credentials];
            if(data != nil) {
                NSMutableDictionary *attributes = [[self attributesTemplate] mutableCopy];
                [attributes setObject:data forKey:(__bridge id)kSecValueData];
                if(SecItemAdd((__bridge CFDictionaryRef)attributes, NULL) != noErr) {
                    NSAssert(NO, @"Keychain error when storing item first time");
                } else {
                    result = YES;
                }
            } else {
                NSAssert(NO, @"Keychain error when storing item first time");
            }
        } else {
            result = YES;
        }
    } else {
        NSAssert(NO, @"Serious keychain error");
    }
    
    if(result) {
        _storedCredential = [credentials copy];
    }
    
    return result;
}

- (BOOL)removeStoredCredentials {
    return [self storeCredentials:nil];
}

#pragma mark -
#pragma mark Private methods

- (void)prepareTemplates {
    _keychainQueryTemplateForAttributes = @{(__bridge id)kSecClass :(__bridge id)kSecClassGenericPassword,
                                           (__bridge id)kSecAttrGeneric : [NSData dataWithBytes:sKeyChainItemIdentifier length:strlen((const char *)sKeyChainItemIdentifier)],
                                           (__bridge id)kSecMatchLimitOne : (__bridge id)kCFBooleanTrue,
                                           (__bridge id)kSecReturnAttributes : (__bridge id)kCFBooleanTrue
                                           };
    
    _keychainItemAttributesTemplate = @{(__bridge id)kSecClass :(__bridge id)kSecClassGenericPassword,
                                       (__bridge id)kSecAttrGeneric : [NSData dataWithBytes:sKeyChainItemIdentifier length:strlen((const char *)sKeyChainItemIdentifier)],
                                       };
}

- (NSDictionary *)queryTemplateForAttributes {
    if(_keychainQueryTemplateForAttributes == nil) {
        [self prepareTemplates];
    }
    
    return [_keychainQueryTemplateForAttributes copy];
}

- (NSDictionary *)queryTemplateForData {
    NSMutableDictionary *queryTemplateForData = [[self queryTemplateForAttributes] mutableCopy];
    [queryTemplateForData removeObjectForKey:(__bridge id)kSecReturnAttributes];
    [queryTemplateForData setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    return queryTemplateForData;
}

- (NSDictionary *)attributesTemplate {
    if(_keychainItemAttributesTemplate == nil) {
        [self prepareTemplates];
    }
    
    return [_keychainItemAttributesTemplate copy];
}

- (CLFCredentials *)credentialsMergedWithStoredCredentials:(CLFCredentials *)credentials {
    CLFCredentials *result = nil;
    
    if(credentials != nil) {
        if(_storedCredential != nil) {
            CLFCredentials *credentialsToStore = [_storedCredential copy];
            if(credentials.sessionId != nil) {
                credentialsToStore.sessionId = credentials.sessionId;
            }
            
            result = credentialsToStore;
        } else {
            result = [credentials copy];
        }
    }
    
    return result;
}

- (NSData *)dataFromCredential:(CLFCredentials *)credentials {
    NSData *result = nil;
    if(credentials != nil) {
        @try {
            NSMutableDictionary *dataToStore = [[NSMutableDictionary alloc] init];
            if(credentials.sessionId != nil) {
                [dataToStore setObject:credentials.sessionId forKey:@"sessionId"];
            }
            
            result = [NSKeyedArchiver archivedDataWithRootObject:dataToStore];
        }
        @catch (NSException *exception) {
            //Do nothing
        }
    }
    return result;
}

- (CLFCredentials *)credentialsFromData:(NSData *)data {
    CLFCredentials *result = nil;
    if(data != nil) {
        id obj = nil;
        @try {
            obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if(obj != nil && [obj isKindOfClass:[NSDictionary class]]) {
                result = [[CLFCredentials alloc] init];
                
                NSDictionary *dictionary = (NSDictionary *)obj;
                NSString *sessionId = [dictionary objectForKey:@"sessionId"];
                if(sessionId != nil) {
                    result.sessionId = sessionId;
                }
            }
        }
        @catch (NSException *exception) {
            //Do nothing
        }
    }
    return result;
}

@end
