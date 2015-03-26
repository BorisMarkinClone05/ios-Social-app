/***********************************************************************
 *
 * iOS Client
 * Copyright (C) by CloseFriends, Inc.
 *
 ***********************************************************************/


#import "CLFSignInPhoneCell.h"
#import "CLFPhoneNumber.h"
#import "UIDevice+OSVersion.h"

@interface CLFSignInPhoneCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (nonatomic, weak) CLFPhoneNumber *phoneNumber;
@property (nonatomic, strong) NSCharacterSet *digitalSet;
@property (nonatomic, copy) void (^codeСhangesHandler)(NSString *code);

@end

@implementation CLFSignInPhoneCell

#pragma mark - UITableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];

    UIColor *textColor = [UIColor whiteColor];
    CGFloat fontSize = 15.0f;
    NSString *fontName = @"AvenirNext-Regular";

    _codeTextField.font = [UIFont fontWithName:fontName size:fontSize];
    _codeTextField.textColor = textColor;
    _codeTextField.delegate = self;

    _phoneTextField.font = [UIFont fontWithName:fontName size:fontSize];
    _phoneTextField.textColor = textColor;
    _phoneTextField.delegate = self;

    _separatorView.backgroundColor = [UIColor colorWithRed:111.0f / 255.0f
                                                     green:121.0f / 255.0f
                                                      blue:141.0f / 255.0f
                                                     alpha:1.0f];

    CGFloat alpha = 0.2f;
    if ([UIDevice isiOS8AndEarlier]) {
        alpha += 0.1f;
    }
    self.backgroundColor = [UIColor colorWithRed:1.0f
                                           green:1.0f
                                            blue:1.0f
                                           alpha:alpha];

    _digitalSet = [NSCharacterSet decimalDigitCharacterSet];
}

#pragma mark - Public methods

@dynamic code;

- (void)setCode:(NSString *)code{
    _codeTextField.text = code;
}

- (NSString *)code{
    return _codeTextField.text;
}

@dynamic phone;

- (void)setPhone:(NSString *)phone{
    _phoneTextField.text = phone;
}

- (NSString *)phone{
    return _phoneTextField.text;
}

- (void)configureCellWithPhoneNumber:(CLFPhoneNumber *)phoneNumber andCodeСhangesHandler:(void(^)(NSString *code))handler {
    _phoneNumber = phoneNumber;
    self.codeСhangesHandler = handler;
    self.code = phoneNumber.dialCode;
    self.phone = [phoneNumber formattedNumber];

}

#pragma mark - Text field delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![[string stringByTrimmingCharactersInSet:self.digitalSet] isEqualToString:@""]) {
        return NO;
    }

    if (textField == self.codeTextField) {
        BOOL needUpdateString = YES;
        NSString *resultString = [[textField.text stringByReplacingCharactersInRange:range withString:string] stringByReplacingOccurrencesOfString:@"+" withString:@""];
        if (range.location == 0) {
            if ([string isEqualToString:@""]) {
                resultString = [textField.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
                needUpdateString = NO;
            } else {
                needUpdateString = NO;
            }
        }

        NSString *phoneString = nil;
        if (resultString.length > 4) {
            NSString *fullString = resultString;
            resultString = [fullString substringWithRange:NSMakeRange(0, 4)];
            phoneString = [NSString stringWithFormat:@"%@%@", [fullString substringWithRange:NSMakeRange(4, fullString.length - 4)],
                                                     [self digitalStringFromString:self.phoneTextField.text]];
            [self.phoneNumber updatePhoneNumber:phoneString];
            [self.phoneTextField becomeFirstResponder];
            needUpdateString = NO;
        }

        resultString = [NSString stringWithFormat:@"+%@", resultString];

        if (self.codeСhangesHandler) {
            self.codeСhangesHandler(resultString);
        }

        _phoneTextField.text = [self.phoneNumber formattedNumber];

        if (needUpdateString) {
            return YES;
        } else {
            textField.text = resultString;
            return NO;
        }
    } else if (textField == self.phoneTextField) {
        NSInteger caretPosition = [self pushCaretPositionFrom:textField withRange:range];
        NSInteger digitsInRange = [self valuableCharCountIn:[textField.text substringWithRange:range]];
        if (digitsInRange == 0 && caretPosition != 0 && [string isEqualToString:@""]) {
            digitsInRange = 1;
            caretPosition--;
        }
        NSString *digitalString = [self digitalStringFromString:textField.text];
        NSString *newDigitalString = [digitalString stringByReplacingCharactersInRange:NSMakeRange(caretPosition, digitsInRange) withString:string];
        [self.phoneNumber updatePhoneNumber:newDigitalString];
        caretPosition += string.length;

        textField.text = [self.phoneNumber formattedNumber];
        [self popCaretPosition:caretPosition  to:textField];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - Phone field
- (NSString *)digitalStringFromString:(NSString *)string  {
    NSCharacterSet *charactersToRemove = [self.digitalSet invertedSet];
    return [[string componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
}

- (NSInteger)pushCaretPositionFrom:(UITextField *)textField withRange:(NSRange)range {
    NSString *subString = [textField.text substringToIndex:range.location];
    return [self valuableCharCountIn:subString];
}

- (NSInteger)valuableCharCountIn:(NSString *)string {
    NSInteger count = 0;
    for (NSInteger i = 0; i < string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if ([self.digitalSet characterIsMember:ch]) {
            count++;
        }
    }
    return count;
}

- (void)popCaretPosition:(NSInteger)caretPosition to:(UITextField *)textField {
    NSString *string = textField.text;
    NSInteger digitalCount = caretPosition;
    NSInteger start = 0;
    for (NSInteger i = 1; i <= string.length && digitalCount > 0; i++) {
        unichar ch = [string characterAtIndex:i - 1];
        if ([self.digitalSet characterIsMember:ch]) {
            digitalCount--;
        }
        if (digitalCount == 0) {
            start = i;
            break;
        }
    }

    [self selectTextIn:textField atRange:NSMakeRange(start,0)];
}

- (void)selectTextIn:(UITextField *)textField atRange:(NSRange)range {
    UITextPosition *startPosition = [textField positionFromPosition:[textField beginningOfDocument]
                                                             offset:range.location];
    UITextPosition *endPosition = [textField positionFromPosition:startPosition
                                                           offset:range.length];
    [textField setSelectedTextRange:[textField textRangeFromPosition:startPosition toPosition:endPosition]];
}

#pragma mark - Private methods
- (BOOL)becomeFirstResponder {
    return [_phoneTextField becomeFirstResponder];
}

@end