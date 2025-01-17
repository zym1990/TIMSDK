//
//  TContactViewModel.h
//  TXIMSDK_TUIKit_iOS
//
//  Created by annidyfeng on 2019/5/5.
//

#import <Foundation/Foundation.h>
#import "TCommonContactCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TContactViewModel : NSObject
@property (readonly) NSDictionary<NSString *, NSArray<TCommonContactCellData *> *> *dataDict;
@property (readonly) NSArray *groupList;

@property (readonly) BOOL isLoadFinished;

- (void)loadContacts;

@end

NS_ASSUME_NONNULL_END
