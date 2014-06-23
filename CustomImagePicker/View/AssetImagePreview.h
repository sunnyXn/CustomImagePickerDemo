//
//  AssetImagePreview.h
//  CustomImagePickerDemo
//
//  Created by sunny on 14-5-21.
//  Copyright (c) 2014年 joymis.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface AssetImagePreview : UIView

@property (nonatomic, retain) ALAsset * asset;


- (void)addTarget:(id)target actionUse:(SEL)Action;

-(void)setShowDisappearAnimation:(BOOL)animate duration:(CGFloat)during;

@end
