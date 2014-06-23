//
//  AssetImagePreview.m
//  CustomImagePickerDemo
//
//  Created by sunny on 14-5-21.
//  Copyright (c) 2014年 joymis.com. All rights reserved.
//

#import "AssetImagePreview.h"
#import "AssetsBaseViewController.h"
@interface AssetImagePreview() <UIScrollViewDelegate>
{
    UIImageView  *  imageView;
    UIScrollView *  scrollView;
    UILabel      *  label;
    id            _tmpTarget;
    SEL           _useAction;
}
@end

@implementation AssetImagePreview

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        // Initialization code
        [self setupSubView];
        [self setupCustomNaview];
    }
    return self;
}

- (void)setupCustomNaview
{
    CGRect rect = self.bounds;
    UIView * customNav = [[UIView alloc]init];
    customNav.frame = CGRectMake(0, rect.size.height - 60, rect.size.width, 60);
    customNav.opaque = NO;
    customNav.layer.opacity = 0.5f;
    customNav.backgroundColor = [UIColor grayColor];
    [self addSubview:customNav];
    
    label    = [[UILabel alloc]init];
    label.frame        = CGRectMake(30, 10, rect.size.width - 60, 40);
    label.backgroundColor = [UIColor clearColor];
    label.textColor    = [UIColor blackColor];
    label.font         = [UIFont boldSystemFontOfSize:24];
    label.textAlignment= UITextAlignmentCenter;
    [customNav addSubview:label];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 10, 80, 40);
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [backBtn setTitle:@"返回列表" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backBtn  addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    [customNav addSubview:backBtn];
    
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(customNav.frame.size.width - 80 - 20, 10, 80, 40);
    cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancleBtn setTitle:@"选用" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancleBtn  addTarget:self action:@selector(actionChoose) forControlEvents:UIControlEventTouchUpInside];
    [customNav addSubview:cancleBtn];
    
    [customNav release];
}

- (void)addTarget:(id)target actionUse:(SEL)Action
{
    _tmpTarget = target;
    _useAction = Action;
}

- (void)actionChoose
{
    NSLog(@"actionChoose: %@ \n",_asset.defaultRepresentation.UTI);
    if ([_tmpTarget respondsToSelector:_useAction]) {
        [self removeFromSuperview];
        [_tmpTarget performSelector:_useAction withObject:_asset];
    }
}

- (void)actionBack
{
    [self setShowDisappearAnimation:YES duration:1.f];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.f];
}


- (void)setupSubView
{
    scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
    scrollView.pagingEnabled = NO;
    scrollView.bounces       = NO;
//    scrollView.userInteractionEnabled   = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.maximumZoomScale = 2.f;
    scrollView.minimumZoomScale = 0.5f;
    scrollView.zoomScale        = 1.f;
    scrollView.decelerationRate = 1.f;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    
    imageView  = [[UIImageView alloc]init];
    imageView.frame = self.frame;
    imageView.userInteractionEnabled = YES;
    imageView.autoresizingMask = scrollView.autoresizingMask;
    imageView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:imageView];
}

- (void)setAsset:(ALAsset *)asset
{
    if (_asset)
        [_asset release];
        _asset = nil;
        _asset = [asset retain];
    
    NSInteger ori         = _asset.defaultRepresentation.orientation;
    imageView.image = [UIImage imageWithCGImage:_asset.defaultRepresentation.fullResolutionImage scale:_asset.defaultRepresentation.scale orientation:ori];
    imageView.frame  = CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height);
    
    scrollView.contentSize = imageView.image.size;
    scrollView.center = self.center;
    
    label.text         = _asset.defaultRepresentation.filename;
    
    NSLog(@"\n UTI: %@ \n fileName:%@ \n %@",_asset.defaultRepresentation.UTI,_asset.defaultRepresentation.filename,_asset.defaultRepresentation.metadata);
}

#pragma  - mark scrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)newScrollView
{
    
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)newScrollView withView:(UIView *)view
{
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)newScrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    newScrollView.center = self.center;
}


- (void)dealloc
{
    SAFE_RELEASE(imageView);
    SAFE_RELEASE(_asset);
    SAFE_RELEASE(scrollView);
    
    [super dealloc];
}

-(void)setShowDisappearAnimation:(BOOL)animate duration:(CGFloat)during
{
    if (animate)
    {
        self.alpha = 1.0f;
        [UIView animateWithDuration:during animations:^{
            self.alpha = 0.0f;
        }];
    }
    else
    {
        self.alpha = 0.0f;
        [UIView animateWithDuration:during animations:^{
            self.alpha = 1.0f;
        }];
    }
}


@end
