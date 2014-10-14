//
//  SuccessViewController.m
//  AuthTstUtility
//
//  Created by Jack Bransfield on 10/14/14.
//  Copyright (c) 2014 Builtlight. All rights reserved.
//

#import "SuccessViewController.h"

@interface SuccessViewController ()

@property (strong, nonatomic) IBOutlet UILabel *tokenLabel;

@end

@implementation SuccessViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.tokenLabel.text = self.token;
}


@end
