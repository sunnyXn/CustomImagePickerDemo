//
//  AssetsViewController.h
//  CustomImagePickerDemo
//
//  Created by sunny on 14-5-20.
//  Copyright (c) 2014年 joymis.com. All rights reserved.
//

#import "AssetsBaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface AssetsViewController : AssetsBaseViewController


@property (nonatomic,retain)  ALAssetsGroup * group;

- (void)addTarget:(id)target actionUse:(SEL)Action;

@end
