//
//  PHPhotoLibrary+XhlCategory.m
//  XhlBaseObject
//
//  Created by xiaoshiheng on 2022/9/1.
//

#import "PHPhotoLibrary+XhlCategory.h"
#import "XhlAuthTools.h"

@implementation PHPhotoLibrary (XhlCategory)



+ (void)savePhotoWithData:(NSData *)data completion:(void (^)(NSError *error))completion {
    
    [XhlAuthTools judgeCanUsePhotosStatusCompletion:^(BOOL allow) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if(allow){
                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{

                        PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
                        options.shouldMoveFile = YES;
                        PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
                        [request addResourceWithType:PHAssetResourceTypePhoto data:data options:options];
                        request.creationDate = [NSDate date];

                    } completionHandler:^(BOOL success, NSError * _Nullable error) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            if (success && completion) {
                                completion(nil);
                            } else if (error) {
                                NSLog(@"保存照片出错:%@",error.localizedDescription);
                                if (completion) {
                                    completion(error);
                                }
                            }
                        });
                    }];
                }else{
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if (completion) {
                            NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:0 userInfo:nil];
                            completion(error);
                        }
                    });
                }
        });
        
    }];
    
    
}


@end
