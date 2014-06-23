//
//  AssetsTableViewCell.h
//  CustomImagePickerDemo
//
//  Created by sunny on 14-5-20.
//  Copyright (c) 2014年 joymis.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AssetsTableViewCell : UITableViewCell

- (void)reset;
- (void)addItemView:(ALAsset*)asset;
- (void)addTarget:(id)target tapAction:(SEL)tapAction;

@end
