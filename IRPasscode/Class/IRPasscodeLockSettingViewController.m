//
//  IRPasscodeLockSettingViewController.m
//  IRPasscode
//
//  Created by Phil on 2019/11/14.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRPasscodeLockSettingViewController.h"
#import "IRSecurityPinManager.h"
#import "IRLanguageManager.h"

@interface IRPasscodeLockSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation IRPasscodeLockSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _(@"PasscodeLock");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([IRSecurityPinManager sharedInstance].pinCode) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    cell.preservesSuperviewLayoutMargins = false;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = _(@"PasscodeLock");
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            if([IRSecurityPinManager sharedInstance].pinCode)
                switchview.on = YES;
            cell.accessoryView = switchview;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [switchview addTarget:self action:@selector(updateLockEnabled:) forControlEvents:UIControlEventValueChanged];
        }
            break;
        case 1:
        {
            cell.textLabel.text = _(@"ChangePasscode");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        default:
            break;
    }
    
    
    return cell;
}

- (void)updateLockEnabled:(UISwitch*)sender {
    if (!sender.isOn) {
        [[IRSecurityPinManager sharedInstance] presentSecurityPinViewControllerForRemoveWithAnimated:YES completion:nil result:^(IRSecurityResultType type) {
            if(type == Verified) {
                [[IRSecurityPinManager sharedInstance] removePinCode];
            }
            [self.tableView reloadData];
        }];
        return;
    } else {
        [[IRSecurityPinManager sharedInstance] presentSecurityPinViewControllerForCreateWithAnimated:YES completion:nil result:^(IRSecurityResultType type) {
            [self.tableView reloadData];
        }];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat cellHeight = 80.0;
    
    if ([IRSecurityPinManager sharedInstance].pinCode) {
        return 2;
    }
    
    return cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 28)];
    footer.backgroundColor = [UIColor whiteColor];

    UILabel *devicesCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, footer.frame.size.width - 25, 80)];
    devicesCountLabel.text = [NSString stringWithFormat:@"%@", _(@"PasscodeHintString")];
    devicesCountLabel.numberOfLines = 0;
    devicesCountLabel.font = [UIFont systemFontOfSize:13];
    devicesCountLabel.textColor = UIColor.grayColor;
    devicesCountLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [footer addSubview:devicesCountLabel];

    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0 , footer.frame.size.width, 0.5)];
    separatorLineView.backgroundColor = [UIColor lightGrayColor];
    [footer addSubview:separatorLineView];

    footer.clipsToBounds = YES;
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:
            [[IRSecurityPinManager sharedInstance] presentSecurityPinViewControllerForChangePasscodeWithAnimated:YES completion:nil result:nil];
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
