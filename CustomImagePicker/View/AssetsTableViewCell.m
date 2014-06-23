//
//  AssetsTableViewCell.m
//  CustomImagePickerDemo
//
//  Created by sunny on 14-5-20.
//  Copyright (c) 2014年 joymis.com. All rights reserved.
//

#import "AssetsTableViewCell.h"
#import "AssetItemView.h"
#import "AssetsBaseViewController.h"
@interface AssetsTableViewCell ()
{
    int itemCount;
    AssetItemView * assetViews[Colomns];
}

@end

@implementation AssetsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        itemCount = 0;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)addItemView:(ALAsset*)asset
{
    AssetItemView * itemView = [[AssetItemView alloc]initWithAsset:asset];
    itemView.frame = CGRectMake(AssetViewItemInterval + itemCount*(AssetViewItemInterval+ AssetViewItemWith), AssetViewItemY, AssetViewItemWith, AssetViewItemHeight);
    [self.contentView addSubview:itemView];
    [itemView release];
    assetViews[itemCount] = itemView;
    itemCount++ ;
}

- (void)addTarget:(id)target tapAction:(SEL)tapAction
{
    for (int i = 0; i<itemCount; i++) {
        [assetViews[i] addTarget:target tapAction:tapAction];
    }
}

-(void) reset
{
    for (int i=0; i<itemCount; i++)
    {
        [assetViews[i] removeFromSuperview];
    }
        itemCount = 0;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
