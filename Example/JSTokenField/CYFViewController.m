//
//  CYFViewController.m
//  JSTokenField
//
//  Created by yifeic on 07/02/2015.
//  Copyright (c) 2014 yifeic. All rights reserved.
//

#import "CYFViewController.h"
#import "JSTokenField.h"

@interface CYFViewController () <JSTokenFieldDelegate>

@property (weak, nonatomic) IBOutlet JSTokenField *field;

@end

@implementation CYFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.field.delegate = self;
//    self.field.tokenTextFont = [UIFont fontWithName:@"Cochin" size:13];
    self.field.lineHeight = 25;
    self.field.verticalMargin = 5;
    self.field.horizontalMargin = 5;
    self.field.tokenTextColor = [UIColor blueColor];
    self.field.tokenTextSelectedColor = [UIColor whiteColor];
    self.field.tokenSelectedBackgroundColor = [UIColor brownColor];
    self.field.tokenBorderColor = [UIColor greenColor];
}

#pragma mark JSTokenFieldDelegate

- (void)tokenField:(JSTokenField *)tokenField didAddToken:(NSString *)title representedObject:(id)obj
{
    
}

- (void)tokenField:(JSTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{
    
}

- (BOOL)tokenFieldShouldReturn:(JSTokenField *)tokenField {

    NSString *rawStr = [[tokenField textField] text];
 
    if ([rawStr length])
    {
        [tokenField addTokenWithTitle:rawStr representedObject:nil];
    }
    
    [[tokenField textField] setText:@""];
    
    return NO;
}

@end
