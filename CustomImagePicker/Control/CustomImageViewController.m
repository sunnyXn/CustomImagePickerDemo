//
//  CustomImageViewController.m
//  CustomImagePickerDemo
//
//  Created by sunny on 14-5-19.
//  Copyright (c) 2014年 joymis.com. All rights reserved.
//

#import "CustomImageViewController.h"
#import "AssetsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface CustomImageViewController () <UINavigationControllerDelegate , UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * assetGroup;
    id          _tmpDelegate;
    SEL         _getImage;
}

@end

@implementation CustomImageViewController

#pragma - mark   lifeCycle Methods

-(id)init
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

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self decideWhatToDo];
}

#pragma - mark ImagePickerLogicControl

- (void)decideWhatToDo
{
    if (self.sceneType == sceneVC)
    {
        [self setImagePickerType];
    }
    else if (self.sceneType == sceneIc)
    {
        [self dismissViewController];
    }
    else if (self.sceneType == sceneCC)
    {
        NSLog(@"妈蛋的CC");
    }
}

- (void)setImagePickerType
{
    if (self.pickerType == UIImagePickerControllerSourceTypeCamera)
    {
        [self setupImagePicker];
    }
    else if (self.pickerType == (UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum))
    {
        if (!_tableView)
            [self setupCustomImagePicker];
        else
            [self reloadTableView];
    }
}


#pragma - mark  setupImagePicker

- (void)setupImagePicker
{
    if ([UIImagePickerController isSourceTypeAvailable:self.pickerType])
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.sourceType                = self.pickerType;
        picker.cameraDevice              = self.pickerAvailableDevice;
        picker.delegate                  = self;
        picker.allowsEditing             = NO;
        picker.modalTransitionStyle      = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
    else
    {
        NSString * mess = @"抱歉，当前设备不能检测到相册，请检查设备";
        if (self.pickerType == UIImagePickerControllerSourceTypeCamera)
            mess = @"抱歉，当前设备不能检测到相机，请检查设备";
        
        UIAlertView * alert  = [[UIAlertView alloc]initWithTitle:@"提示" message:mess delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewController];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType hasSuffix:@".image"]) {
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
//        [UIImagePNGRepresentation(image) writeToFile:self.backImagePath atomically:YES];
        [self getImageFromCamera:image];
        [self dismissPicker:picker];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissPicker:picker];
}

- (void)dismissPicker:(UIImagePickerController *)picker
{
    self.sceneType = sceneIc;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)addTarget:(id)target action:(SEL)getImage
{
    _tmpDelegate        = target;
    _getImage = getImage;
}

- (void)getImageFromCamera:(UIImage *)image
{
    if ([_tmpDelegate respondsToSelector:_getImage]) {
        [_tmpDelegate performSelector:_getImage withObject:image];
    }
}

#pragma - mark  setupCustomImagePicker

- (void)setupCustomImagePicker
{
    [self setupCustomNaview];
    
    [self setuptableView];
    [self setupAssetGroup];
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
    _tableView.backgroundColor  =   [UIColor clearColor];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return assetGroup.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *  singe = @"cell";
    
    UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:singe];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:singe] autorelease];;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    ALAssetsGroup * group           = [assetGroup objectAtIndex:indexPath.row];
    cell.imageView.image            = [UIImage imageWithCGImage:group.posterImage];
    cell.textLabel.textAlignment    = UITextAlignmentCenter;
    cell.textLabel.text             = [NSString  stringWithFormat:@"%@ (%d)",[group valueForProperty:ALAssetsGroupPropertyName],group.numberOfAssets];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (assetGroup.count >0) {
//        self.sceneType  = sceneCC;
        AssetsViewController * avc = [[AssetsViewController alloc]init];
        avc.group = [assetGroup objectAtIndex:indexPath.row];
        [avc addTarget:self actionUse:@selector(getImageFromPhotoAlbum:)];
        avc.modalTransitionStyle  = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:avc animated:YES];
        [avc release];
    }
}


- (void)getImageFromPhotoAlbum:(ALAsset *)asset
{
    if ([_tmpDelegate respondsToSelector:_getImage] && asset) {
        UIImage * image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage scale:asset.defaultRepresentation.scale orientation:(NSInteger)asset.defaultRepresentation.orientation];
        [_tmpDelegate performSelector:_getImage withObject:image];
    }
    [self dismissViewController];
}

- (void)reloadTableView
{
    [_tableView reloadData];
}

#pragma - mark      AssetGroupMethods

-(void)setupAssetGroup
{
    dispatch_queue_t  assgroupQueue = dispatch_queue_create("com.myqueue.assgroupQueue", 0);
    
    dispatch_async(assgroupQueue, ^{
        if (!assetGroup)
            assetGroup = [[NSMutableArray alloc]init];
        else
            [assetGroup removeAllObjects];
        
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock =
        
        ^(ALAssetsGroup *group, BOOL *stop) {
            
            if (group!=nil) {
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                if (group.numberOfAssets > 0)
                [assetGroup addObject:group];
                
            } else {
                
                [self performSelectorOnMainThread:@selector(reloadTableView)
                 
                                       withObject:nil waitUntilDone:YES];
                
            }
            
        };
        
       ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
        
        {
            
            NSString *errorMessage = nil;
            
            switch ([error code]) {
                    
                case ALAssetsLibraryAccessUserDeniedError:
                    
                case ALAssetsLibraryAccessGloballyDeniedError:
                    
                    errorMessage = @"The user has declined access to it.";
                    
                    break;
                    
                default:
                    
                    errorMessage = @"Reason unknown.";
                    
                    break;
                    
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Opps"
                                          
                                                                   message:errorMessage delegate:self cancelButtonTitle:@"Cancel"
                                          
                                                         otherButtonTitles:nil, nil];
                
                [alertView show];
                
                [alertView release];
            });
        };
        
        NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent |
        
        ALAssetsGroupFaces |ALAssetsGroupSavedPhotos |ALAssetsGroupLibrary;
         __block ALAssetsLibrary * library = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            @autoreleasepool {
            library = [[ALAssetsLibrary alloc]init];
            [library enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
            }
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
    customNav.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:customNav];
    
    UILabel * label    = [[UILabel alloc]init];
    label.frame        = CGRectMake(30, 10, rect.size.width - 60, 40);
    label.backgroundColor = [UIColor clearColor];
    label.font         = [UIFont boldSystemFontOfSize:24];
    label.textAlignment= UITextAlignmentCenter;
    label.text         = @"Photos";
    [customNav addSubview:label];
    [label release];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(customNav.frame.size.width - 80 - 20, 10, 80, 40);
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backBtn  addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    [customNav addSubview:backBtn];
    [customNav release];
}

-(void)actionBack
{
    [self dismissViewController];
}

- (void)dismissViewController
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma -   mark        deallocMethods
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    SAFE_RELEASE(_tableView);
    SAFE_RELEASE(assetGroup);
    
    [super dealloc];
}

@end
