//
//  GroupMemberController.m
//  TUIKitDemo
//
//  Created by kennethmiao on 2018/10/18.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "GroupMemberController.h"
#import "TUIGroupMemberController.h"
#import "TUIContactSelectController.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "Toast/Toast.h"
@import ImSDK;

@interface GroupMemberController () <TGroupMemberControllerDelegagte>

@end

@implementation GroupMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    TUIGroupMemberController *members = [[TUIGroupMemberController alloc] init];
    members.groupId = _groupId;
    members.delegate = self;
    [self addChildViewController:members];
    [self.view addSubview:members.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didCancelInGroupMemberController:(TUIGroupMemberController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)groupMemberController:(TUIGroupMemberController *)controller didAddMembersInGroup:(NSString *)groupId hasMembers:(NSMutableArray *)members
{
    TUIContactSelectController *vc = [[TUIContactSelectController alloc] initWithNibName:nil bundle:nil];
    vc.title = @"添加联系人";
    vc.viewModel.disableFilter = ^BOOL(TCommonContactSelectCellData *data) {
        for (TGroupMemberCellData *cd in members) {
            if ([cd.identifier isEqualToString:data.identifier])
                return YES;
        }
        return NO;
    };
    @weakify(self)
    [self.navigationController pushViewController:vc animated:YES];
    vc.finishBlock = ^(NSArray<TCommonContactSelectCellData *> *selectArray) {
        @strongify(self)
        NSMutableArray *list = @[].mutableCopy;
        for (TCommonContactSelectCellData *data in selectArray) {
            [list addObject:data.identifier];
        }
        [self.navigationController popToViewController:self animated:YES];
        [self addGroupId:groupId memebers:list controller:controller];
    };
}

- (void)groupMemberController:(TUIGroupMemberController *)controller didDeleteMembersInGroup:(NSString *)groupId hasMembers:(NSMutableArray *)members
{
    TUIContactSelectController *vc = [[TUIContactSelectController alloc] initWithNibName:nil bundle:nil];
    vc.title = @"删除联系人";
    vc.viewModel.avaliableFilter = ^BOOL(TCommonContactSelectCellData *data) {
        for (TGroupMemberCellData *cd in members) {
            if ([cd.identifier isEqualToString:data.identifier])
                return YES;
        }
        return NO;
    };
    @weakify(self)
    [self.navigationController pushViewController:vc animated:YES];
    vc.finishBlock = ^(NSArray<TCommonContactSelectCellData *> *selectArray) {
        @strongify(self)
        NSMutableArray *list = @[].mutableCopy;
        for (TCommonContactSelectCellData *data in selectArray) {
            [list addObject:data.identifier];
        }
        [self.navigationController popToViewController:self animated:YES];
        [self deleteGroupId:groupId memebers:list controller:controller];
    };
}

- (void)addGroupId:(NSString *)groupId memebers:(NSArray *)members controller:(TUIGroupMemberController *)controller
{
    [[TIMGroupManager sharedInstance] inviteGroupMember:_groupId members:members succ:^(NSArray *members) {
        [self.view makeToast:@"添加成功"];
        [controller updateData];
    } fail:^(int code, NSString *msg) {
        [self.view makeToast:msg];
    }];
}

- (void)deleteGroupId:(NSString *)groupId memebers:(NSArray *)members controller:(TUIGroupMemberController *)controller
{
    [[TIMGroupManager sharedInstance] deleteGroupMemberWithReason:groupId reason:@"" members:members succ:^(NSArray *members) {
        [self.view makeToast:@"删除成功"];
        [controller updateData];
    } fail:^(int code, NSString *msg) {
        [self.view makeToast:msg];
    }];
}
@end