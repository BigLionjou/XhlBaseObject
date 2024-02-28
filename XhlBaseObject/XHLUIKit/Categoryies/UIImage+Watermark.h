//
//  UIImage+Watermark.h
//  mn_tools
//
//  Created by xhl on 2021/8/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    WaterImageLocationCenter,  //中心
    WaterImageLocationTopLeft,  //左上
    WaterImageLocationTopRight,  //右上
    WaterImageLocationBottomLeft, //左下
    WaterImageLocationBottomRight,  //右下
    WaterImageLocationTop,  //中上
    WaterImageLocationLeft,  //左中
    WaterImageLocationRight,  //右中
    WaterImageLocationBottom  //中下
} WaterImageLocation;


@interface UIImage (Watermark)

/// 给图片加水印
/// @param watermarkInfo  水印信息
- (UIImage *)addWatermarkWithWatermarkInfo:(NSDictionary *)watermarkInfo;
@end

NS_ASSUME_NONNULL_END
