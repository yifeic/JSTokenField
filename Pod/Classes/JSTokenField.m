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

#import "JSTokenField.h"
#import "JSTokenButton.h"

#define HEIGHT_PADDING 3
#define WIDTH_PADDING 3

#define DEFAULT_HEIGHT 31

@interface JSTokenField () {
    UIFont *_tokenTextFont;
}

@property (nonatomic, readwrite) JSBackspaceReportingTextField *textField;
@property (nonatomic, readwrite) UILabel *label;
@property (nonatomic, strong) NSMutableArray *tokens;

@property (nonatomic, strong) JSTokenButton *deletedToken;
@property (nonatomic) CGFloat selfHeight;

- (JSTokenButton *)tokenWithString:(NSString *)string representedObject:(id)obj;
- (void)commonSetup;

@end


@implementation JSTokenField

- (void)dealloc
{
	self.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
	if (frame.size.height < DEFAULT_HEIGHT)
	{
		frame.size.height = DEFAULT_HEIGHT;
	}
	
    if ((self = [super initWithFrame:frame]))
	{
        [self commonSetup];
    }
	
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (void)commonSetup {
    _lineHeight = 30;
    _verticalMargin = 2;
    _horizontalMargin = 2;
    
    [self setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
    
//    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, DEFAULT_HEIGHT)];
//    [self.label setBackgroundColor:[UIColor clearColor]];
//    [self.label setTextColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0]];
//    [self.label setFont:[UIFont fontWithName:@"Helvetica Neue" size:17.0]];
//    
//    [self addSubview:self.label];
    
    //		self.layer.borderColor = [[UIColor blueColor] CGColor];
    //		self.layer.borderWidth = 1.0;
    
    self.tokens = [[NSMutableArray alloc] init];
    
    self.textField = [[JSBackspaceReportingTextField alloc] initWithFrame:CGRectMake(0, HEIGHT_PADDING, self.frame.size.width, DEFAULT_HEIGHT)];
    self.textField.backgroundColor = [UIColor clearColor];
    [self.textField setDelegate:self];
    [self.textField setBorderStyle:UITextBorderStyleNone];
    [self.textField setBackground:nil];
//    [self.textField setBackgroundColor:[UIColor clearColor]];
    [self.textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    self.textField.keyboardType = UIKeyboardTypeEmailAddress;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    //		[self.textField.layer setBorderColor:[[UIColor redColor] CGColor]];
    //		[self.textField.layer setBorderWidth:1.0];
    
    [self addSubview:self.textField];
    
    [self.textField addTarget:self action:@selector(textFieldWasUpdated:) forControlEvents:UIControlEventEditingChanged];
}

- (NSArray *)allTokens
{
	return [self.tokens copy];
}

- (void)addTokenWithTitle:(NSString *)string representedObject:(id)obj
{
	NSString *aString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	if ([aString length])
	{
		JSTokenButton *token = [self tokenWithString:aString representedObject:obj];
		[self.tokens addObject:token];
		
		if ([self.delegate respondsToSelector:@selector(tokenField:didAddToken:representedObject:)])
		{
			[self.delegate tokenField:self didAddToken:aString representedObject:obj];
		}
		
		[self setNeedsLayout];
	}
}

//- (void)removeTokenWithTest:(BOOL (^)(JSTokenButton *token))test {
//    JSTokenButton *tokenToRemove = nil;
//    for (JSTokenButton *token in [self.tokens reverseObjectEnumerator]) {
//        if (test(token)) {
//            tokenToRemove = token;
//            break;
//        }
//    }
//    
//    if (tokenToRemove) {
//        if (tokenToRemove.isFirstResponder) {
//            [self.textField becomeFirstResponder];
//        }
//        [tokenToRemove removeFromSuperview];
//        
//        [self.tokens removeObject:tokenToRemove];
//        if ([self.delegate respondsToSelector:@selector(tokenField:didRemoveToken:representedObject:)])
//        {
//				NSString *tokenName = [tokenToRemove titleForState:UIControlStateNormal];
//				[self.delegate tokenField:self didRemoveToken:tokenName representedObject:tokenToRemove.representedObject];
//
//		}
//	}
//	
//	[self setNeedsLayout];
//}

- (void)removeToken:(JSTokenButton *)token {
    if (token.isFirstResponder) {
        [self.textField becomeFirstResponder];
    }
    [token removeFromSuperview];
    [self.tokens removeObject:token];
    if ([self.delegate respondsToSelector:@selector(tokenField:didRemoveToken:representedObject:)])
    {
        NSString *tokenName = token.label.text;
        [self.delegate tokenField:self didRemoveToken:tokenName representedObject:token.representedObject];
    }
 
    [self setNeedsLayout];
}

//- (void)removeTokenForString:(NSString *)string
//{
//    [self removeTokenWithTest:^BOOL(JSTokenButton *token) {
//        return [[token titleForState:UIControlStateNormal] isEqualToString:string] && [token isToggled];
//    }];
//}

//- (void)removeTokenWithRepresentedObject:(id)representedObject {
//    [self removeTokenWithTest:^BOOL(JSTokenButton *token) {
//        return [[token representedObject] isEqual:representedObject];
//    }];
//}

//- (void)removeAllTokens {
//	NSArray *tokensCopy = [self.tokens copy];
//	for (JSTokenButton *button in tokensCopy) {
//		[self removeTokenWithTest:^BOOL(JSTokenButton *token) {
//			return token == button;
//		}];
//	}
//}

- (JSTokenButton *)tokenWithString:(NSString *)string representedObject:(id)obj
{
    JSTokenButton *token = [JSTokenButton tokenWithString:string representedObject:obj parentField:self textFont:self.tokenTextFont textColor:self.tokenTextColor selectedTextColor:self.tokenTextSelectedColor selectedBackgroundColor:self.tokenSelectedBackgroundColor borderColor:self.tokenBorderColor];

	CGRect frame = [token frame];
	
	if (frame.size.width > self.frame.size.width)
	{
		frame.size.width = self.frame.size.width - (WIDTH_PADDING * 2);
	}
	
	[token setFrame:frame];
	
	[token.button addTarget:self
			  action:@selector(toggle:)
	forControlEvents:UIControlEventTouchUpInside];
	
	return token;
}

- (void)layoutSubviews
{
//	[self.label sizeToFit];
//	[self.label setFrame:CGRectMake(WIDTH_PADDING, HEIGHT_PADDING, [self.label frame].size.width, [self.label frame].size.height + HEIGHT_PADDING)];
//	
//	currentRect.origin.x = self.label.frame.origin.x;
//	if (self.label.frame.size.width > 0) {
//		currentRect.origin.x += self.label.frame.size.width + WIDTH_PADDING;
//	}
	
	NSMutableArray *lastLineTokens = [NSMutableArray array];
    CGSize frameSize = self.frame.size;
    CGFloat x = self.horizontalMargin,y = self.verticalMargin;
    
	for (UIButton *token in self.tokens)
	{
//		CGRect frame = [token frame];
        CGSize tokenSize = [token sizeThatFits:CGSizeMake(frameSize.width-x, self.lineHeight)];
		
		if ((x + tokenSize.width) > frameSize.width)
		{
			[lastLineTokens removeAllObjects];
            x = self.horizontalMargin;
            y += self.lineHeight + self.verticalMargin;
//			currentRect.origin = CGPointMake(WIDTH_PADDING, (currentRect.origin.y + tokenSize.height + HEIGHT_PADDING));
		}
		
//		frame.origin.x = currentRect.origin.x;
//		frame.origin.y = currentRect.origin.y + HEIGHT_PADDING;
        CGRect tokenFrame = CGRectMake(x, y, tokenSize.width, self.lineHeight);
		token.frame = tokenFrame;
		
		if (![token superview])
		{
			[self addSubview:token];
		}
		[lastLineTokens addObject:token];
		
//		currentRect.origin.x += frame.size.width + WIDTH_PADDING;
//		currentRect.size = frame.size;
        x += tokenSize.width+self.horizontalMargin;
	}
	
    CGFloat restWidth = frameSize.width - x;
    CGRect textFieldFrame = CGRectZero;
    
    if (restWidth >= 60) {
        textFieldFrame.origin = CGPointMake(x, y+1);
        textFieldFrame.size = CGSizeMake(restWidth-self.horizontalMargin, self.lineHeight);
    }
    else {
        y += self.lineHeight + self.verticalMargin;
		[lastLineTokens removeAllObjects];
        textFieldFrame.origin = CGPointMake(self.horizontalMargin, y+1);
        textFieldFrame.size = CGSizeMake(frameSize.width-self.horizontalMargin*2, self.lineHeight);
    }
    self.textField.frame = textFieldFrame;
    
    CGFloat totalHeight = y + self.lineHeight + self.verticalMargin;
//	textFieldFrame.origin = currentRect.origin;
//	
//	if ((self.frame.size.width - textFieldFrame.origin.x) >= 60)
//	{
//		textFieldFrame.size.width = self.frame.size.width - textFieldFrame.origin.x;
//	}
//	else
//	{
//		[lastLineTokens removeAllObjects];
//		textFieldFrame.size.width = self.frame.size.width;
//        textFieldFrame.origin = CGPointMake(WIDTH_PADDING * 2, 
//                                            (currentRect.origin.y + currentRect.size.height + HEIGHT_PADDING));
//	}
	
//	textFieldFrame.origin.y += HEIGHT_PADDING;
//	[self.textField setFrame:textFieldFrame];
//	CGRect selfFrame = [self frame];
//	selfFrame.size.height = textFieldFrame.origin.y + textFieldFrame.size.height + self.verticalMargin;
	
//	CGFloat textFieldMidY = CGRectGetMidY(textFieldFrame);
//	for (UIButton *token in lastLineTokens) {
//		// Center the last line's tokens vertically with the text field
//		CGPoint tokenCenter = token.center;
//		tokenCenter.y = textFieldMidY;
//		token.center = tokenCenter;
//	}
	
    if (fabs(totalHeight - self.selfHeight) > 0.01) {
        self.selfHeight = totalHeight;
        
    	__weak JSTokenField *weak_self = self;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weak_self invalidateIntrinsicContentSize];
        }];
    }
}

- (CGSize)intrinsicContentSize {
	return CGSizeMake(UIViewNoIntrinsicMetric, self.selfHeight);
}

- (void)toggle:(id)sender
{
	for (JSTokenButton *token in self.tokens)
	{
        if (token.button == sender) {
            [token becomeFirstResponder];
            break;
        }
	}
}

- (UIFont *)tokenTextFont {
    return _tokenTextFont;
}

- (void)setTokenTextFont:(UIFont *)tokenTextFont {
    _tokenTextFont = tokenTextFont;
    self.textField.font = tokenTextFont;
}

#pragma mark -
#pragma mark UITextFieldDelegate


- (void)textFieldWasUpdated:(UITextField *)sender {
    if ([self.delegate respondsToSelector:@selector(tokenFieldTextDidChange:)]) {
        [self.delegate tokenFieldTextDidChange:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""] && NSEqualRanges(range, NSMakeRange(0, 0)))
	{
        JSTokenButton *token = [self.tokens lastObject];
		if (!token) {
			return NO;
		}
		
		
		NSString *name = token.label.text;
		// If we don't allow deleting the token, don't even bother letting it highlight
		BOOL responds = [self.delegate respondsToSelector:@selector(tokenField:shouldRemoveToken:representedObject:)];
		if (responds == NO || [self.delegate tokenField:self shouldRemoveToken:name representedObject:token.representedObject])
		{
			[token performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
		}
		return NO;
	}

	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.textField == textField) {
        if ([self.delegate respondsToSelector:@selector(tokenFieldShouldReturn:)]) {
            return [self.delegate tokenFieldShouldReturn:self];
        }
    }
	
	return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(tokenFieldDidEndEditing:)]) {
        [self.delegate tokenFieldDidEndEditing:self];
        return;
    }
    else if ([[textField text] length] > 1)
    {
        [self addTokenWithTitle:[textField text] representedObject:[textField text]];
        [textField setText:nil];
    }
}

@end
