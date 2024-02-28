//
//  PHPhotoLibrary+XhlCategory.h
//  XhlBaseObject
//
//  Created by xiaoshiheng on 2022/9/1.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHPhotoLibrary (XhlCategory)

+ (void)savePhotoWithData:(NSData *)data completion:(void (^)(NSError *error))completion ;

@end

NS_ASSUME_NONNULL_END
