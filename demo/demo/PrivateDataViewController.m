//
//  PrivateDataViewController.m
//  demo
//
//  Created by Phil on 2019/12/9.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "PrivateDataViewController.h"
#import "Utilities.h"

@interface PrivateDataViewController ()

@end

@implementation PrivateDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Utilities openSecurityPinPage];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
