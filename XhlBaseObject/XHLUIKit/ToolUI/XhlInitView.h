//
//  XhlInitView.h
//  XhlBaseObjectDemo
//
//  Created by rogue on 2019/1/8.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XhlInitView : NSObject

@end

UIView *newView(void);

UIImageView *newImageView(void);

UILabel *newLabel(void);

UILabel *newLabelNoLimitLines(void);

UITableView *newTable(void);

UITableView *newTableType(UITableViewStyle style);

UIImage *newImage(NSString *imageName);

UIButton *newButtonCustom(void);

UIButton *newButton(UIButtonType type);

UIScrollView *newScroll(void);

UITextField *newTextField(void);

UITextView *newTextView(void);

UICollectionView *newCollectView(void);//默认竖

UICollectionView *newCollectViewScrollDirection(UICollectionViewScrollDirection scrollDirection);
NS_ASSUME_NONNULL_END
