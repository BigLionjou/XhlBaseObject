//
//  XHLFoundation.h
//  XhlBaseObjectDemo
//
//  Created by XHL on 2019/8/2.
//  Copyright © 2019 rogue. All rights reserved.
//

#ifndef XHLFoundation_h
#define XHLFoundation_h

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define xhl_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define xhl_weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define xhl_weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define xhl_weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define xhl_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define xhl_strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define xhl_strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define xhl_strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif



//otherTool
#import "XHLCacheManager.h"
#import "XHLFileManager.h"
#import "XhlAuthTools.h"
#import "XhlTimer.h"


//Categoryies
#import "NSObject+XHLRuntime.h"
#import "NSObject+XHLNotification.h"
#import "NSObject+XHLKVO.h"
#import "NSObject+XHLAssociate.h"
#import "NSObject+XHLDealloc.h"
#import "NSString+XhlCategory.h"
#import "NSArray+XhlCategory.h"
#import "NSMutableArray+XHLCategory.h"
#import "NSDictionary+XhlCategory.h"
#import "NSData+XhlCategory.h"
#import "NSUserDefaults+XHLCategory.h"
#import "NSBundle+XhlCategory.h"
#import "NSAttributedString+XhlCategory.h"
#import "PHPhotoLibrary+XhlCategory.h"



#endif /* XHLFoundation_h */
