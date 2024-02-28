//
//  UIView+XhlInputControl.h
//  AFNetworking
//
//  Created by xiaoshiheng on 2020/9/9.
//  文本输入限制

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

BOOL xhl_shouldChangeCharactersIn(id _Nullable target, NSRange range, NSString * _Nullable string);
void xhl_textDidChange(id _Nullable target);

typedef NS_ENUM(NSInteger, XhlTextControlType) {
    XhlTextControlType_none, //无限制
    
    XhlTextControlType_number,   //数字
    XhlTextControlType_letter,   //字母（包含大小写）
    XhlTextControlType_letterSmall,  //小写字母
    XhlTextControlType_letterBig,    //大写字母
    XhlTextControlType_number_letterSmall,   //数字+小写字母
    XhlTextControlType_number_letterBig, //数字+大写字母
    XhlTextControlType_number_letter,    //数字+字母
    
    XhlTextControlType_exclude,     //输入过程中 限制输入不可见字符（包括空格、制表符、换页符等）
    XhlTextControlType_excludeInvisible, //输入过后 去除不可见字符（包括空格、制表符、换页符等）
    XhlTextControlType_price,    //价格（小数点后最多输入两位）
};

NS_ASSUME_NONNULL_BEGIN

@interface XhlInputControlProfile : NSObject

/**
 限制输入长度，NSUIntegerMax表示不限制（默认不限制）
 */
@property (nonatomic, assign) NSUInteger maxLength;

/**
 限制输入的文本类型（单选，在内部其实是配置了regularStr属性）
 */
@property (nonatomic, assign) XhlTextControlType textControlType;

/**
 限制输入的正则表达式字符串
 */
@property (nonatomic, copy, nullable) NSString *regularStr;

/**
 文本变化回调（observer为UITextFiled或UITextView）
 */
@property (nonatomic, copy, nullable) void(^textChanged)(id observe);

/**
 添加文本变化监听
 @param target 方法接收者
 @param action 方法（方法参数为UITextFiled或UITextView）
 */
- (void)addTargetOfTextChange:(id)target action:(SEL)action;



/**
 链式配置方法（对应属性配置）
 */
+ (XhlInputControlProfile *)creat;
- (XhlInputControlProfile *(^)(XhlTextControlType type))set_textControlType;
- (XhlInputControlProfile *(^)(NSString *regularStr))set_regularStr;
- (XhlInputControlProfile *(^)(NSUInteger maxLength))set_maxLength;
- (XhlInputControlProfile *(^)(void (^textChanged)(id observe)))set_textChanged;
- (XhlInputControlProfile *(^)(id target, SEL action))set_targetOfTextChange;



//键盘索引和键盘类型，当设置了 textControlType 内部会自动配置，当然你也可以自己配置
@property(nonatomic) UITextAutocorrectionType autocorrectionType;
@property(nonatomic) UIKeyboardType keyboardType;

//取消输入前回调的长度判断
@property (nonatomic, assign, readonly) BOOL cancelTextLengthControlBefore;
//文本变化方法体
@property (nonatomic, strong, nullable, readonly) NSInvocation *textChangeInvocation;

@end


@interface UITextField (XhlInputControl) <UITextFieldDelegate>

//是否有值，配合KVO使用
@property (nonatomic, assign) BOOL empty;

@property (nonatomic, strong, nullable) XhlInputControlProfile *xhl_inputCP;

@end


@interface UITextView (XhlInputControl) <UITextViewDelegate>

//是否有值，配合KVO使用
@property (nonatomic, assign) BOOL empty;

@property (nonatomic, strong, nullable) XhlInputControlProfile *xhl_inputCP;

@end

NS_ASSUME_NONNULL_END
