//
//	Copyright 2011 James Addyman (JamSoft). All rights reserved.
//	
//	Redistribution and use in source and binary forms, with or without modification, are
//	permitted provided that the following conditions are met:
//	
//		1. Redistributions of source code must retain the above copyright notice, this list of
//			conditions and the following disclaimer.
//
//		2. Redistributions in binary form must reproduce the above copyright notice, this list
//			of conditions and the following disclaimer in the documentation and/or other materials
//			provided with the distribution.
//
//	THIS SOFTWARE IS PROVIDED BY JAMES ADDYMAN (JAMSOFT) ``AS IS'' AND ANY EXPRESS OR IMPLIED
//	WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//	FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL JAMES ADDYMAN (JAMSOFT) OR
//	CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//	SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//	NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//	The views and conclusions contained in the software and documentation are those of the
//	authors and should not be interpreted as representing official policies, either expressed
//	or implied, of James Addyman (JamSoft).
//

#import "JSTokenButton.h"
#import "JSTokenField.h"
#import <QuartzCore/QuartzCore.h>

@interface JSTokenButton ()

@property (nonatomic, strong) id representedObject;
@property (nonatomic, strong) JSTokenField *parentField;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *selectedBackgroundColor;

@end

@implementation JSTokenButton

+ (JSTokenButton *)tokenWithString:(NSString *)string representedObject:(id)obj textFont:(UIFont *)textFont parentField:(JSTokenField *)parentField textColor:(UIColor *)textColor selectedTextColor:(UIColor *)selectedTextColor selectedBackgroundColor:(UIColor *)selectedBackgroundColor;
{
    return [[JSTokenButton alloc] initWithString:string representedObject:obj parentField:parentField textFont:textFont textColor:textColor selectedTextColor:selectedTextColor selectedBackgroundColor:selectedBackgroundColor];
}

- (instancetype)initWithString:(NSString *)string representedObject:(id)obj parentField:(JSTokenField *)parentField textFont:(UIFont *)textFont textColor:(UIColor *)textColor selectedTextColor:(UIColor *)selectedTextColor selectedBackgroundColor:(UIColor *)selectedBackgroundColor {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = string;
        label.textColor = textColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 2;
        label.layer.masksToBounds = YES;
        [self addSubview:label];
        _label = label;
        _button = button;
        _parentField = parentField;
        _representedObject = obj;
        _textColor = textColor;
        _textFont = textFont;
        _selectedTextColor = selectedTextColor;
        _selectedBackgroundColor = selectedBackgroundColor;
    }
    return self;
}

- (void)setToggled:(BOOL)toggled
{
	_toggled = toggled;
	
	if (_toggled)
	{
        self.label.textColor = self.selectedTextColor;
        self.label.backgroundColor = self.selectedBackgroundColor;
	}
	else
	{
        self.label.textColor = self.textColor;
        self.label.backgroundColor = [UIColor clearColor];
	}
}

- (BOOL)becomeFirstResponder {
    BOOL superReturn = [super becomeFirstResponder];
    if (superReturn) {
        self.toggled = YES;
    }
    return superReturn;
}

- (BOOL)resignFirstResponder {
    BOOL superReturn = [super resignFirstResponder];
    if (superReturn) {
        self.toggled = NO;
    }
    return superReturn;
}

#pragma mark - UIKeyInput
- (void)deleteBackward {
    [_parentField removeToken:self];
}

- (BOOL)hasText {
    return NO;
}
- (void)insertText:(NSString *)text {
    return;
}

- (UITextAutocorrectionType)autocorrectionType {
    return UITextAutocorrectionTypeNo;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize intrinsicSize = [self.label sizeThatFits:size];
    return CGSizeMake(intrinsicSize.width+6, intrinsicSize.height);
}

- (void)layoutSubviews {
    CGRect bounds = self.frame;
    bounds.origin = CGPointZero;
    self.button.frame = bounds;
    
    CGSize labelSize = [self.label sizeThatFits:self.bounds.size];
    bounds.origin.y = (bounds.size.height - labelSize.height) / 2;
    bounds.size.height = labelSize.height;
    self.label.frame = bounds;
}

@end
