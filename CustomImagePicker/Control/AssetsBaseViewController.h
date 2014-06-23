//
//  BaseViewController.h
//  CustomImagePickerDemo
//
//  Created by sunny on 14-5-19.
//  Copyright (c) 2014年 joymis.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CurrentVersion      ([UIDevice currentDevice].systemVersion.floatValue)
#define CurrentIDIOMPad     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define CurrentIDIOMIphone  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define InterfacePad        (CurrentIDIOMPad    ?YES:NO)
#define InterfacePhone      (CurrentIDIOMIphone ?YES:NO)

#define mainRect            ([UIScreen mainScreen].bounds)
#define screenWidth         (mainRect.size.width)
#define screenHeight        (mainRect.size.height)

//#define interfaceLandscape  //横竖屏显示开关

#ifdef  interfaceLandscape

#define mainWidth           (screenWidth>screenHeight?screenHeight:screenWidth)
#define mainHeight          (screenWidth>screenHeight?screenWidth:screenHeight)

#else

#define mainWidth           (screenWidth>screenHeight?screenWidth:screenHeight)
#define mainHeight          (screenWidth>screenHeight?screenHeight:screenWidth)

#endif


#define Colomns                 (6)
#define AssetViewItemY          (4)
#define AssetViewItemWith       (mainWidth/(Colomns+1))
#define AssetViewItemHeight     (CellHeight - AssetViewItemY*2)
#define AssetViewItemInterval   ((mainWidth -  AssetViewItemWith*Colomns)/(Colomns+1))
#define CellHeight              (AssetViewItemWith)

#define AssetImageViewX         (5)
#define AssetImageViewY         (5)
#define AssetImageViewW         (AssetViewItemWith   - AssetImageViewX*2)
#define AssetImageViewH         (AssetViewItemHeight - AssetImageViewY*2)


#define SAFE_RELEASE(_obj)      if (_obj != nil) {[_obj release]; _obj = nil;}


typedef NS_ENUM(NSUInteger, FromScene){
    sceneVC = 0,   //ViewController
    sceneIc    ,   //ImagePicker
    sceneCC    ,   //CustomAssetImageViewController
};

@interface AssetsBaseViewController : UIViewController

@property  (nonatomic,assign) UIImagePickerControllerSourceType     pickerType;
@property  (nonatomic,assign) UIImagePickerControllerCameraDevice   pickerAvailableDevice;
@property  (nonatomic,assign) FromScene sceneType;
@property  (nonatomic,copy  ) NSString * backImagePath;

@end
