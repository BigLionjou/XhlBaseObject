//
//  UIViewController+ImagePicker.m
//  lxtxAppBackstage
//
//  Created by com.chetuba on 15/7/16.
//  Copyright (c) 2015年 Lxtx. All rights reserved.
//

#import "UIViewController+ImagePicker.h"
#import "UIAlertController+XhlCategory.h"

#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <objc/runtime.h>

static char key;

@implementation UIViewController (ImagePicker)

/**
 OC中的关联就是在已有类的基础上添加对象参数。来扩展原有的类，需要引入#import <objc/runtime.h>头文件。关联是基于一个key来区分不同的关联。
 常用函数: objc_setAssociatedObject     设置关联
 objc_getAssociatedObject     获取关联
 objc_removeAssociatedObjects 移除关联
 */

- (UIImagePickerController *)imagePicker{
    
    UIImagePickerController *Picker = objc_getAssociatedObject(self, _cmd);
    
    if (!Picker) {
        Picker = [[UIImagePickerController alloc] init];
        Picker.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        Picker.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        Picker.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
       
        objc_setAssociatedObject(self, _cmd, Picker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return Picker;
}

- (void)setImagePicker:(UIImagePickerController *)imagePicker{
    
}
- (void)openChoiceWithCompleteBlock:(FinishPickingMediaWithInfo)block{
    
    if (block) {
        ////移除所有关联
        //objc_removeAssociatedObjects(self);
        /**
         1 创建关联（源对象，关键字，关联的对象和一个关联策略。)
         2 关键字是一个void类型的指针。每一个关联的关键字必须是唯一的。通常都是会采用静态变量来作为关键字。
         3 关联策略表明了相关的对象是通过赋值，保留引用还是复制的方式进行关联的；关联是原子的还是非原子的。这里的关联策略和声明属性时的很类似。
         */
        objc_setAssociatedObject(self, &key, block, OBJC_ASSOCIATION_COPY);
    }
    
    xhl_showActionSheet(@"请选择照片:", @[@"拍照",@"相册"], ^(NSInteger index) {
        
        if(index==0){
            //拍照
            [self openSystemCamera];
        }else{
            [self openSystemAblum];
        }
    });

}

///打开系统相册
- (void)openSystemAblumBlock:(FinishPickingMediaWithInfo)block{
    if (block) {
        ////移除所有关联
        //objc_removeAssociatedObjects(self);
        /**
         1 创建关联（源对象，关键字，关联的对象和一个关联策略。)
         2 关键字是一个void类型的指针。每一个关联的关键字必须是唯一的。通常都是会采用静态变量来作为关键字。
         3 关联策略表明了相关的对象是通过赋值，保留引用还是复制的方式进行关联的；关联是原子的还是非原子的。这里的关联策略和声明属性时的很类似。
         */
        objc_setAssociatedObject(self, &key, block, OBJC_ASSOCIATION_COPY);
    }
    
    [self openSystemAblum];
    
}
///打开相机
- (void)openSystemCameraBlock:(FinishPickingMediaWithInfo)block{
    if (block) {
        ////移除所有关联
        //objc_removeAssociatedObjects(self);
        /**
         1 创建关联（源对象，关键字，关联的对象和一个关联策略。)
         2 关键字是一个void类型的指针。每一个关联的关键字必须是唯一的。通常都是会采用静态变量来作为关键字。
         3 关联策略表明了相关的对象是通过赋值，保留引用还是复制的方式进行关联的；关联是原子的还是非原子的。这里的关联策略和声明属性时的很类似。
         */
        objc_setAssociatedObject(self, &key, block, OBJC_ASSOCIATION_COPY);
    }
    
    [self openSystemCamera];
    
}


- (void)openSystemAblum
{
    if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [self requestAuthorizationWithCompletion:^{
            [self openSystemAblum];
        }];
    } else {
        
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 允许编辑
        self.imagePicker.allowsEditing = YES;
        
        self.imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController: self.imagePicker animated:YES completion:nil];
    }
    
}
- (void)openSystemCamera
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self openSystemCamera];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [self requestAuthorizationWithCompletion:^{
            [self openSystemCamera];
        }];
    } else {
        // 设置拍摄的照片允许编辑
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 使用前置摄像头
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        // 允许编辑
        self.imagePicker.allowsEditing = YES;
        
        self.imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    ///获取关联的对象，通过关键字。
    FinishPickingMediaWithInfo block = objc_getAssociatedObject(self, &key);
    if (block) {
        ///block传值
        block(info);
    }
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)requestAuthorizationWithCompletion:(void (^)(void))completion {
    void (^callCompletionBlock)(void) = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            callCompletionBlock();
        }];
    });
}


@end
