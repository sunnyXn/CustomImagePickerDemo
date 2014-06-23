//
//  AssetsViewController.m
//  CustomImagePickerDemo
//
//  Created by sunny on 14-5-20.
//  Copyright (c) 2014年 joymis.com. All rights reserved.
//

#import "AssetsViewController.h"
#import "AssetsTableViewCell.h"
#import "AssetImagePreview.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface AssetsViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView     * _tableView;
    NSMutableArray  * assetsImage;
    AssetImagePreview  * imagePreview;
    id      _tmpTarget;
    SEL     _useAction;
}

@end

@implementation AssetsViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self setupView];
}

- (void)setupView
{
    [self setupCustomNaview];
    
    [self setuptableView];
    [self setupAssetImage];
}

#pragma - mark      tableViewMethods
- (void) setuptableView
{
    CGRect rect                 =   self.view.bounds;
    
    _tableView                  =   [[UITableView alloc]init];
    _tableView.frame            =   CGRectMake(0, 70, rect.size.width, rect.size.height - 70);
    _tableView.delegate         =   self;
    _tableView.dataSource       =   self;
    _tableView.rowHeight        =   CellHeight;
    _tableView.separatorStyle   =   UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor  =   [UIColor clearColor];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (ceil((double)assetsImage.count/Colomns)+1);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"count: %d \n row : %d",assetsImage.count,indexPath.row);
    if (indexPath.row==ceil((double)assetsImage.count/Colomns)) {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellFooter"];
        
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFooter"];
        }
        cell.textLabel.font=[UIFont boldSystemFontOfSize:24];
        cell.textLabel.backgroundColor=[UIColor clearColor];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.text =    [NSString stringWithFormat:@"共 %d 张照片",assetsImage.count];
        return cell;
    }


    static NSString *  singe = @"cell";
    
    AssetsTableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:singe];
    
    if (!cell) {
        cell = [[[AssetsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:singe] autorelease];;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell reset];
    for (int i = indexPath.row * Colomns; i<assetsImage.count && i< indexPath.row * Colomns + Colomns; i++) {
        ALAsset * asset      = [assetsImage objectAtIndex:i];
        NSLog(@"\n i: %d  \n row : %d \n ",i ,indexPath.row);
        [cell addItemView:asset];
        [cell addTarget:self tapAction:@selector(actionTap:)];
    }
    
    return cell;
}

- (void)reloadTableView
{
    [_tableView reloadData];
}

#pragma -   mark   tapAction
- (void)actionTap:(id)sender
{
    if (![sender isKindOfClass:[ALAsset class]])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"无法获取当前照片，请退出或重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    ALAsset * asset = (ALAsset*)sender;
    
    imagePreview = [[AssetImagePreview alloc]initWithFrame:self.view.bounds];
    imagePreview.asset = asset;
    [imagePreview addTarget:self actionUse:@selector(actionUseFromPhotoAlbum:)];
    [self.view addSubview:imagePreview];
    [imagePreview setShowDisappearAnimation:NO duration:1.f];
}

#pragma -   mark    delegateMethods
- (void)addTarget:(id)target actionUse:(SEL)Action
{
    _tmpTarget = target;
    _useAction = Action;
}

- (void)actionUseFromPhotoAlbum:(ALAsset *)asset
{
    [self useAction:asset];
    [self dismissViewController];
}

- (void)useAction:(ALAsset *)asset
{
    if ([_tmpTarget respondsToSelector:_useAction]) {
        [_tmpTarget performSelector:_useAction withObject:asset];
    }
}

#pragma -  mark   setupAssetImageMethods

- (void)setupAssetImage
{
    dispatch_queue_t  assetsImageQueue = dispatch_queue_create("com.myqueue.assetsImageQueue", 0);
    
    dispatch_async(assetsImageQueue, ^{
        if (!assetsImage)
            assetsImage = [[NSMutableArray alloc]init];
        else
            [assetsImage removeAllObjects];
        
        ALAssetsGroupEnumerationResultsBlock resluts = ^(ALAsset *asset, NSUInteger index, BOOL *stop){
            if (asset) {
                NSString * type = [asset valueForProperty:ALAssetPropertyType];
                if ([type isEqualToString:ALAssetTypePhoto])
                    [assetsImage addObject:asset];
            }
            else if (assetsImage.count > 0){
            //    NSLog(@"assetsImage.count: %d",assetsImage.count);
                [self reloadTableView];
                //            [btn setImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
            }
        };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [self.group enumerateAssetsUsingBlock:resluts];
        });
    });
    
}


#pragma -   mark        setupCustomNaviewMethods
- (void)setupCustomNaview
{
    CGRect rect = self.view.bounds;
    UIView * customNav = [[UIView alloc]init];
    customNav.frame = CGRectMake(0, 0, rect.size.width, 60);
    customNav.opaque = NO;
    customNav.layer.opacity = 0.5f;
    customNav.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:customNav];
    
    UILabel * label    = [[UILabel alloc]init];
    label.frame        = CGRectMake(30, 10, rect.size.width - 60, 40);
    label.backgroundColor = [UIColor clearColor];
    label.textColor    = [UIColor blackColor];
    label.font         = [UIFont boldSystemFontOfSize:24];
    label.textAlignment= UITextAlignmentCenter;
    label.text         = [self.group valueForProperty:ALAssetsGroupPropertyName];
    [customNav addSubview:label];
    [label release];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 10, 80, 40);
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [backBtn setTitle:@"返回相册" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backBtn  addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    [customNav addSubview:backBtn];
    
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(customNav.frame.size.width - 80 - 20, 10, 80, 40);
    cancleBtn.titleLabel.font =  [UIFont boldSystemFontOfSize:18];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancleBtn  addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
    [customNav addSubview:cancleBtn];
    
    [customNav release];
}

- (void)actionBack
{
    [self dismissViewController];
}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionCancel
{
    [self useAction:nil];
}

#pragma -   mark        deallocMethods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    SAFE_RELEASE(assetsImage);
    SAFE_RELEASE(_tableView);
    SAFE_RELEASE(imagePreview);
    
    [super dealloc];
}

@end
