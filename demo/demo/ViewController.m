//
//  ViewController.m
//  demo
//
//  Created by Phil on 2019/11/15.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "ViewController.h"
#import <IRPasscode/IRPasscode.h>
#import "PrivateDataViewController.h"
#import "Utilities.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)demoButtonClick:(id)sender {
    NSBundle *xibBundle = [NSBundle bundleForClass:[IRPasscodeLockSettingViewController class]];
    IRPasscodeLockSettingViewController *vc = [[IRPasscodeLockSettingViewController alloc] initWithNibName:@"IRPasscodeLockSettingViewController" bundle:xibBundle];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)demoUnlockButtonClick:(id)sender {
    PrivateDataViewController *vc = [PrivateDataViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
