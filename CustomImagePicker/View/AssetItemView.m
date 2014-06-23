//
//  AssetItemView.m
//  CustomImagePickerDemo
//
//  Created by sunny on 14-5-20.
//  Copyright (c) 2014年 joymis.com. All rights reserved.
//

#import "AssetItemView.h"
#import "AssetsBaseViewController.h"
@interface AssetItemView() <UIGestureRecognizerDelegate>
{
    UIImageView * _imageView;
    id            _tmpTarget;
    SEL           _tapAction;
    ALAsset     * _asset;
}

@end

@implementation AssetItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithAsset:(ALAsset*)asset
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _asset     = [asset retain];
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(AssetImageViewX, AssetImageViewY, AssetImageViewW, AssetImageViewH);
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.image = [UIImage imageWithCGImage:_asset.thumbnail];
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
        
        UITapGestureRecognizer * tap   = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTap:)];
        tap.delegate =self;
        [self addGestureRecognizer:tap];
        [tap release];
    }
    return self;
}

- (void)actionTap:(UIGestureRecognizer*)gesture
{
    if ([_tmpTarget respondsToSelector:_tapAction]) {
        [_tmpTarget performSelector:_tapAction withObject:_asset];
    }
}

- (void)addTarget:(id)target tapAction:(SEL)tapAction
{
    _tmpTarget = target;
    _tapAction = tapAction;
}

- (void)dealloc
{
    SAFE_RELEASE(_imageView);
    SAFE_RELEASE(_asset);
    [super dealloc];
}

@end
