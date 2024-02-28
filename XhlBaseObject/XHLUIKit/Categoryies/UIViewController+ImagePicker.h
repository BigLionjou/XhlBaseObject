//
//  UIViewController+ImagePicker.h
//  lxtxAppBackstage
//
//  Created by com.chetuba on 15/7/16.
//  Copyright (c) 2015年 Lxtx. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^FinishPickingMediaWithInfo)(NSDictionary *info);

@interface UIViewController (ImagePicker)<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/**
 *  UIImagePickerController
 */
@property (strong,nonatomic) UIImagePickerController *imagePicker;

/// 打开选择
/// 使用系统相册
/// 使用系统相机
/// - Parameter block: 返回选择的和拍摄的 照片
- (void)openChoiceWithCompleteBlock:(FinishPickingMediaWithInfo)block;
///打开系统相册
- (void)openSystemAblumBlock:(FinishPickingMediaWithInfo)block;
///打开相机
- (void)openSystemCameraBlock:(FinishPickingMediaWithInfo)block;


@end
