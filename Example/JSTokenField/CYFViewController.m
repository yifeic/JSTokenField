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
    self.field.tokenImage = [UIImage imageNamed:@"tokenNormal"];
    self.field.tokenSelectedImage = [UIImage imageNamed:@"tokenSelected"];
    
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
