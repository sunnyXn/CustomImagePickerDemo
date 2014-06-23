//
//  MainViewController.m
//  CustomImagePickerDemo
//
//  Created by sunny on 14-5-19.
//  Copyright (c) 2014年 joymis.com. All rights reserved.
//

#import "MainViewController.h"
#import "CustomImageViewController.h"
@interface MainViewController ()<UIActionSheetDelegate>
{
    UIImageView * _imageView;
}

@end

@implementation MainViewController


-(id)init
{
    self = [super init];
    if (self) {
        [UIApplication sharedApplication].statusBarHidden = YES;
        [self setupToolBar];
    }
    return self;
}

- (void)setupToolBar
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect rect = self.view.frame;
    btn.frame = CGRectMake(CGRectGetWidth(rect)- 180, 100, 100, 100);
    [btn setTitle:@"选择方式" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    _imageView = [[UIImageView alloc]init];
    _imageView.frame = CGRectMake(100, 100, 100, 100);
    _imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_imageView];
}

-(void)actionBtn
{
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"相册", nil];
    [sheet showInView:self.view];
    [sheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            [self setupView:UIImagePickerControllerSourceTypeCamera];
            break;
            
        case 2:
            [self setupView:UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum ];
            break;
        default:
            
            break;
    }
}

- (void)setupView:(UIImagePickerControllerSourceType)pickerType
{
    CustomImageViewController * civc = [[CustomImageViewController alloc]init];
    civc.pickerType = pickerType;
    civc.sceneType  = sceneVC;
    [civc addTarget:self action:@selector(getImage:)];
    civc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:civc animated:YES];
    [civc release];
}

#pragma -   mark   DealWithImageFromCamera
- (void)getImage:(UIImage *)image
{
    if (image){
        float width = image.size.width;
        float heigh = image.size.height;
        _imageView.image = image;
        _imageView.frame = CGRectMake(100, 100, 200, 200);
        
        NSLog(@"image is getting!!!");
    }
}


#pragma - mark   life cycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    SAFE_RELEASE(_imageView);
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
