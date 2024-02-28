//
//  NSAttributedString+XhlCategory.h
//  XHLMedia
//
//  Created by XHL on 2019/11/28.
//  Copyright © 2019 龚魁华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (XhlCategory)

- (CGFloat)xhl_getHeightWithWidth:(CGFloat)width
                             font:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
