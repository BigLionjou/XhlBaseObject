//
//  XHLDatePicker.m
//  XHLPods
//
//  Created by macmini on 2017/12/30.
//  Copyright © 2017年 xhl. All rights reserved.
//

#import "XHLDatePicker.h"
#import "NSDate+XHLCategory.h"
#import "XHLPicker.h"

@interface XHLDatePicker()

@property (nonatomic, copy) void(^eventHandle)(NSString *);
@property (nonatomic, copy) void(^cancelBlock)(void);
@property (nonatomic) UIView *pickerContainer;
@property (nonatomic) UIDatePicker *datePicker;
@property (nonatomic, copy) NSString *mode;
@property (nonatomic, copy) NSString *fields;

@end

@implementation XHLDatePicker

- (instancetype)initWithMode:(NSString *)mode
                       value:(NSString *)value
                       start:(NSString *)start
                         end:(NSString *)end
                      fields:(NSString *)fields
                  bindChange:(void (^)(NSString *value))eventHandle
                  bindCancel:(void (^)(void))cancelBlock {
    self = [super init];
    if (self) {
        _mode = mode;
        _fields = fields;
        self.frame = [UIScreen mainScreen].bounds;
        self.alpha = 0;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.65];
        
        UIButton *wholeCancelMaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        wholeCancelMaskButton.frame = [UIScreen mainScreen].bounds;
        wholeCancelMaskButton.backgroundColor = [UIColor clearColor];
        [wholeCancelMaskButton addTarget:self
                                   action:@selector(clickCancel:)
                         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:wholeCancelMaskButton];
        
        
        _pickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    CGRectGetHeight([UIScreen mainScreen].bounds),
                                                                    CGRectGetWidth([UIScreen mainScreen].bounds),
                                                                    roundf([UIScreen mainScreen].bounds.size.width * 291 / 414) + 44)];
        _pickerContainer.backgroundColor = [UIColor whiteColor];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 0, 90, 44);
        [cancelButton setTitle:@"取消"
                      forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:102/255.0
                                                    green:102/255.0
                                                     blue:102/255.0
                                                    alpha:1/1.0]
                           forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:102/255.0
                                                    green:102/255.0
                                                     blue:102/255.0
                                                    alpha:0.2]
                            forState:UIControlStateHighlighted];
        [cancelButton addTarget:self
                         action:@selector(clickCancel:)
               forControlEvents:UIControlEventTouchUpInside];
        [_pickerContainer addSubview:cancelButton];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 90, 0, 90, 44);
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor colorWithRed:60/255.0
                                                     green:118/255.0
                                                      blue:255/255.0
                                                     alpha:1/1.0]
                            forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor colorWithRed:60/255.0
                                                     green:118/255.0
                                                      blue:255/255.0
                                                     alpha:.2]
                            forState:UIControlStateHighlighted];
        [confirmButton addTarget:self
                          action:@selector(clickConfirm:)
                forControlEvents:UIControlEventTouchUpInside];
        [_pickerContainer addSubview:confirmButton];
        
        UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                         43.5,
                                                                         CGRectGetWidth([UIScreen mainScreen].bounds),
                                                                         .5)];
        separatorLine.backgroundColor = [UIColor colorWithRed:230/255.0
                                                        green:230/255.0
                                                         blue:230/255.0
                                                        alpha:1/1.0];
        [_pickerContainer addSubview:separatorLine];
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,
                                                                     44,
                                                                     [UIScreen mainScreen].bounds.size.width,
                                                                     CGRectGetHeight(_pickerContainer.bounds) - 44)];
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
#ifdef __IPHONE_13_4
        if (@available(iOS 13.4, *)) {
            _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        } else {
            // Fallback on earlier versions
        }
#endif
        NSString *validValue = nil;
        NSString *validStart = nil;
        NSString *validEnd = nil;
        
        if ([mode isEqualToString:@"time"]) {
            _datePicker.datePickerMode = UIDatePickerModeTime;
            validValue = [self validTimeString:value];
            validStart = [self validTimeString:start];
            validEnd = [self validTimeString:end];
        } else if ([mode isEqualToString:@"date"]) {
            _datePicker.datePickerMode = UIDatePickerModeDate;
            validValue = [self validDateString:value];
            validStart = [self validDateString:start];
            validEnd = [self validDateString:end];
        }
        if (validValue.length) {
            _datePicker.date = [self getCorrectDateFromString:validValue];
        } else {
            _datePicker.date = [NSDate date];
        }
        if (validStart.length) {
            _datePicker.minimumDate = [self getCorrectDateFromString:validStart];
        } else {
            _datePicker.minimumDate = [NSDate distantPast];
        }
        if (validEnd.length) {
            _datePicker.maximumDate = [self getCorrectDateFromString:validEnd];
        } else {
            _datePicker.maximumDate = [NSDate distantFuture];
        }
       
        _datePicker.frame = CGRectMake(0,
                                      44,
                                      [UIScreen mainScreen].bounds.size.width,
                                      CGRectGetHeight(_pickerContainer.bounds) - 44);
        if ([mode isEqualToString:@"date"]
            && fields.length
            && ![fields isEqualToString:@"day"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                         (int64_t)(.1 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                               UIView *dayColumnView = self.datePicker.subviews[0].subviews[0].subviews.lastObject;
                               UIView *monthColumnView = self.datePicker.subviews[0].subviews[0].subviews[1];
                               UIView *yearColumnView = self.datePicker.subviews[0].subviews[0].subviews.firstObject;
                               dayColumnView.hidden = YES;
                               if ([fields isEqualToString:@"month"]) {
                                   monthColumnView.frame = CGRectOffset(monthColumnView.frame,
                                                                        [UIScreen mainScreen].bounds.size.width / 375 * 80,
                                                                        0);
                               } else if ([fields isEqualToString:@"year"]) {
                                   monthColumnView.hidden = YES;
                                   yearColumnView.frame = CGRectOffset(yearColumnView.frame,
                                                                       [UIScreen mainScreen].bounds.size.width / 375 * 75,
                                                                       0);
                               }
                           });
            
        }
        
        [_pickerContainer addSubview:_datePicker];
        [self addSubview:_pickerContainer];
        
        _eventHandle = [eventHandle copy];
        _cancelBlock = [cancelBlock copy];
    }
    return self;
}

- (NSString *)validDateString:(NSString *)dateString {
    NSString *rangeStr = nil;
    if ([self.fields isEqualToString:@"day"]) {
        rangeStr = @"[0-9]{1,4}-[0-9]{1,2}-[0-9]{1,2}";
    } else if ([self.fields isEqualToString:@"month"]) {
        rangeStr = @"[0-9]{1,4}-[0-9]{1,2}";
    } else {
        rangeStr = @"[0-9]{1,4}";
    }
    NSRange range = [dateString rangeOfString:rangeStr
                                      options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return [dateString substringWithRange:range];
    }
    return nil;
}

- (NSString *)validTimeString:(NSString *)timeString {
    NSRange range = [timeString rangeOfString:@"[0-9]{1,2}:[0-9]{1,2}"
                                      options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return [timeString substringWithRange:range];
    }
    return nil;
}

- (NSDate *)getCorrectDateFromString:(NSString *)dateString {
    NSDateComponents *dateComponents = [NSDateComponents new];
    if ([self.mode isEqualToString:@"date"]) {
        NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
        dateComponents.year = ((NSString *)dateArray.firstObject).integerValue;
        if ([_fields isEqualToString:@"day"] || [_fields isEqualToString:@"month"]) {
            dateComponents.month = ((NSString *)dateArray[1]).integerValue;
        } else {
            dateComponents.month = 1;
        }
        if ([_fields isEqualToString:@"day"]) {
            dateComponents.day = ((NSString *)dateArray.lastObject).integerValue;
        } else {
           dateComponents.day = 1;
        }
    } else if ([self.mode isEqualToString:@"time"]) {
        NSArray *timeArray = [dateString componentsSeparatedByString:@":"];
        dateComponents.hour = ((NSString *)timeArray.firstObject).integerValue;
        dateComponents.minute = ((NSString *)timeArray.lastObject).integerValue;
    }
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

/**
 展示picker

 @param desWindow 目标window，为nil时取keyWindow;
 */
- (void)showDatePickerOnWindow:(UIWindow *)desWindow {
    if (desWindow == nil) {
        desWindow = [UIApplication sharedApplication].keyWindow;
    }
    UIView *keyWindowTopView = desWindow.subviews.lastObject;
    if ([keyWindowTopView isKindOfClass:[self class]]) {
        [keyWindowTopView removeFromSuperview];
    }
    [desWindow addSubview:self];
    [UIView animateWithDuration:.35
                     animations:^{
                         self.alpha = 1;
                         self.pickerContainer.frame = CGRectOffset(self.pickerContainer.frame,
                                                                   0,
                                                                   - CGRectGetHeight(self.pickerContainer.frame));
                     }];
}

- (void)clickCancel:(UIButton *)cancelButton {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self dismissPicker];
}

- (void)dismissPicker {
    [UIView animateWithDuration:.35
                     animations:^{
                         self.alpha = 0;
                         self.pickerContainer.frame = CGRectOffset(self.pickerContainer.frame,
                                                                   0,
                                                                   CGRectGetHeight(self.pickerContainer.frame));
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)clickConfirm:(UIButton *)confirmButton {
    if (self.eventHandle) {
        NSCalendarUnit flags = 0;
        if ([self.mode isEqualToString:@"date"]) {
            flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        } else if ([self.mode isEqualToString:@"time"]) {
            flags = NSCalendarUnitHour | NSCalendarUnitMinute;
        }
        
        NSDateComponents *dateComponent = [[NSCalendar currentCalendar] components:flags
                                                                          fromDate:self.datePicker.date];
        NSString *selectDateString = @"";
        if ([self.mode isEqualToString:@"date"]) {
            selectDateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)dateComponent.year, (long)dateComponent.month,(long)dateComponent.day];
            if ([self.fields isEqualToString:@"month"]) {
                selectDateString = [NSString stringWithFormat:@"%ld-%02ld",(long)dateComponent.year, (long)dateComponent.month];
            } else if ([self.fields isEqualToString:@"year"]) {
                selectDateString = [NSString stringWithFormat:@"%ld",(long)dateComponent.year];
            }
        } else if ([self.mode isEqualToString:@"time"]) {
            selectDateString = [NSString stringWithFormat:@"%02ld:%02ld", (long)dateComponent.hour, (long)dateComponent.minute];
        }
        self.eventHandle(selectDateString);
    }
    [self dismissPicker];
}

+ (void)showDatePickerWithMode:(NSString *)mode
                         value:(NSString *)value
                         start:(NSString *)start
                           end:(NSString *)end
                        fields:(NSString *)fields
                    bindChange:(void (^)(NSString *value))eventHandle
                    bindCancel:(void (^)(void))cancelBlock
                      disabled:(BOOL)disabled {
    [self showDatePickerWithMode:mode
                           value:value
                           start:start
                             end:end
                          fields:fields
                      bindChange:eventHandle
                      bindCancel:cancelBlock
                        disabled:disabled
                        onWindow:nil];
}
+ (void)showDatePickerWithMode:(NSString *)mode
                         value:(NSString *)value
                         start:(NSString *)start
                           end:(NSString *)end
                        fields:(NSString *)fields
                    bindChange:(void (^)(NSString *value))eventHandle
                    bindCancel:(void (^)(void))cancelBlock
                      disabled:(BOOL)disabled
                      onWindow:(UIWindow *)window {
    
    if (disabled) return;
    XHLDatePicker *datePicker = [[XHLDatePicker alloc] initWithMode:mode
                                                              value:value
                                                              start:start
                                                                end:end
                                                             fields:fields
                                                         bindChange:eventHandle
                                                         bindCancel:cancelBlock];
    [datePicker    showDatePickerOnWindow:window];
}

/**
 选择时间,年月日时分
 
 @param value 选中值
 @param eventHandle 选中
 @param cancelBlock 取消
 */
+ (void)showDatePickerWithvalue:(NSDate *)value
                          start:(NSDate *)start
                            end:(NSDate *)end
                     bindChange:(void (^)(NSDate *value))eventHandle
                     bindCancel:(void (^)(void))cancelBlock{
    NSMutableArray *yers = [NSMutableArray array];
    for (int i = 1; i<100; i++) {
        NSString *yer = [NSString stringWithFormat:@"%ld年",[NSDate date].year - i];
        [yers insertObject:yer atIndex:0];
    }
    for (int i = 0; i<100; i++) {
        NSString *yer = [NSString stringWithFormat:@"%ld年",[NSDate date].year + i];
        [yers addObject:yer];
    }
    NSMutableArray *mouths = [NSMutableArray array];
    for (int i = 1; i<=12; i++) {
        NSString *mouth = [NSString stringWithFormat:@"%d月",i];
        if (i<10) {
            mouth = [NSString stringWithFormat:@"0%d月",i];
        }
        [mouths addObject:mouth];
    }
    NSArray *days = [self getDaysByMonth:[NSDate date]];
    
    NSMutableArray *hours = [NSMutableArray array];
    for (int i = 0; i<24; i++) {
        NSString *hour = [NSString stringWithFormat:@"%d时",i];
        if (i<10) {
            hour = [NSString stringWithFormat:@"0%d时",i];
        }
        [hours addObject:hour];
    }
    NSMutableArray *minutes = [NSMutableArray array];
    for (int i = 0; i<60; i++) {
        NSString *minute = [NSString stringWithFormat:@"%d分",i];
        if (i<10) {
            minute = [NSString stringWithFormat:@"0%d分",i];
        }
        [minutes addObject:minute];
    }
    
    NSDate *date = value;
    if (!value) {
        date = [NSDate date];
    }
    NSArray *selectDateValue = @[@([yers indexOfObject:[XHLDatePicker getDateStrByDate:date type:NSCalendarUnitYear]]),
                                 @([mouths indexOfObject:[XHLDatePicker getDateStrByDate:date type:NSCalendarUnitMonth]]),
                                 @([days indexOfObject:[XHLDatePicker getDateStrByDate:date type:NSCalendarUnitDay]]),
                                 @([hours indexOfObject:[XHLDatePicker getDateStrByDate:date type:NSCalendarUnitHour]]),
                                 @([minutes indexOfObject:[XHLDatePicker getDateStrByDate:date type:NSCalendarUnitMinute]])];
    __weak __typeof__(self) weakSelf = self;
    [XHLPicker showPickerWithRange:@[yers,mouths,days,hours,minutes]
                             value:selectDateValue
                   bindValueChange:^(XHLPicker *picker, NSArray<NSNumber *> *value) {
                       NSString *yer = yers[value.firstObject.integerValue];
                       NSString *month = mouths[value[1].integerValue];
                       
                       //获取选择年
                       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                       [formatter setDateFormat:@"yyyy年MM月"];
                       NSString *selectDateStr = [NSString stringWithFormat:@"%@%@",yer,month];
                       NSDate *selectDate = [formatter dateFromString:selectDateStr];
                       NSArray *days = [weakSelf getDaysByMonth:selectDate];
                       
                       NSString *day = days[value[2].integerValue];
                       NSString *hour = hours[value[3].integerValue];
                       NSString *minute = minutes[value[4].integerValue];
                       
                       NSDateFormatter *doneDateFormatter = [[NSDateFormatter alloc] init];
                       [doneDateFormatter setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
                       NSString *dateStr = [NSString stringWithFormat:@"%@%@%@ %@%@",yer,month,day,hour,minute];
                       NSDate *doneDate = [doneDateFormatter dateFromString:dateStr];
                       if (eventHandle) {
                           eventHandle(doneDate);
                       }
                   } bindColumnChange:^(XHLPicker *picker, NSInteger column, NSInteger value) {
                       //获取选择年
                       NSString *yer = yers[picker.value.firstObject.integerValue];
                       
                       //获取月
                       NSString *month = mouths[picker.value[1].integerValue];
                       NSLog(@"________%@",picker.value.firstObject);
                       
                       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                       [formatter setDateFormat:@"yyyy年MM月"];
                       NSString *selectDateStr = [NSString stringWithFormat:@"%@%@",yer,month];
                       NSDate *selectDate = [formatter dateFromString:selectDateStr];
                       NSArray *days = [weakSelf getDaysByMonth:selectDate];
                       
                       if (column == 0||column == 1) {//选择年月
                           [picker updatePickerColumns:days columnIndex:2 row:picker.value[2].integerValue];
                       }
                       
                       
                       NSString *day = days[picker.value[2].integerValue];
                       NSString *hour = hours[picker.value[3].integerValue];
                       NSString *minute = minutes[picker.value[4].integerValue];
                       
                       NSDateFormatter *doneDateFormatter = [[NSDateFormatter alloc] init];
                       [doneDateFormatter setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
                       NSString *dateStr = [NSString stringWithFormat:@"%@%@%@ %@%@",yer,month,day,hour,minute];
                       NSDate *doneDate = [doneDateFormatter dateFromString:dateStr];
                       
                       if (!end&&!start) {
                           return ;
                       }
                      
                       if (start) {
                           if ([doneDate isEarlierThanDate:start]) {
                               if (doneDate.year < start.year) {//选择年小于开始年
                                   NSInteger index = [yers indexOfObject:[XHLDatePicker getDateStrByDate:date type:NSCalendarUnitYear]];
                                   [picker selectRow:index inComponent:0 animated:YES];
                               }else  if (doneDate.month < start.month) {//选择年小于开始年
                                   NSInteger index = [mouths indexOfObject:[XHLDatePicker getDateStrByDate:date type:NSCalendarUnitMonth]];
                                   [picker selectRow:index inComponent:1 animated:YES];
                               }else  if (doneDate.day < start.day) {//选择年小于开始年
                                   NSInteger index = [days indexOfObject:[XHLDatePicker getDateStrByDate:date type:NSCalendarUnitDay]];;;
                                   [picker selectRow:index inComponent:2 animated:YES];
                               }else  if (doneDate.hour < start.hour) {//选择年小于开始年
                                   NSInteger index = [hours indexOfObject:[XHLDatePicker getDateStrByDate:date type:NSCalendarUnitHour]];
                                   [picker selectRow:index inComponent:3 animated:YES];
                               }else  if (doneDate.minute < start.minute) {//选择年小于开始年
                                   NSInteger index = [minutes indexOfObject:[XHLDatePicker getDateStrByDate:date type:NSCalendarUnitMinute]];
                                   [picker selectRow:index inComponent:4 animated:YES];
                               }
                           }
                       }
                       if (end) {
                           if([doneDate isLaterThanDate:end]){
                               if (doneDate.year > end.year) {//选择年大于结束年
                                   NSInteger index = [yers indexOfObject:[XHLDatePicker getDateStrByDate:date type:NSCalendarUnitYear]];
                                   [picker selectRow:index inComponent:0 animated:YES];
                               }else  if (doneDate.month > end.month) {//选择年大于结束年
                                   NSInteger index = [mouths indexOfObject:[XHLDatePicker getDateStrByDate:date type:NSCalendarUnitMonth]];
                                   [picker selectRow:index inComponent:1 animated:YES];
                                   //选择年在范围内,但是时间不在预期内,于是就滚动月到当前月
                               }else if (doneDate.day > end.day) {//选择年大于结束年
                                   NSInteger index = [days indexOfObject:[XHLDatePicker getDateStrByDate:date type:NSCalendarUnitDay]];
                                   [picker selectRow:index inComponent:2 animated:YES];
                                   //选择年在范围内,但是时间不在预期内,于是就滚动月到当前月
                               }else  if (doneDate.hour > end.hour) {//选择年大于结束年
                                   NSInteger index = [hours indexOfObject:[XHLDatePicker getDateStrByDate:date type:NSCalendarUnitHour]];
                                   [picker selectRow:index inComponent:3 animated:YES];
                                   //选择年在范围内,但是时间不在预期内,于是就滚动月到当前月
                               }else if (doneDate.minute > end.minute) {//选择年大于结束年
                                   NSInteger index = [minutes indexOfObject:[XHLDatePicker getDateStrByDate:date type:NSCalendarUnitMinute]];
                                   [picker selectRow:index inComponent:4 animated:YES];
                               }
                           }
                       }
                   } bindCancel:^{
                       
                   }];
}

+ (NSString *)getDateStrByDate:(NSDate *)date type:(NSCalendarUnit)type{
    if (type == NSCalendarUnitYear) {
        return date.year < 10 ? [NSString stringWithFormat:@"0%ld年",(long)date.year] : [NSString stringWithFormat:@"%ld年",(long)date.year];
    }else if (type == NSCalendarUnitMonth) {
        return date.month < 10 ? [NSString stringWithFormat:@"0%ld月",(long)date.month] : [NSString stringWithFormat:@"%ld月",(long)date.month];
    }else if (type == NSCalendarUnitDay) {
        return date.day < 10 ? [NSString stringWithFormat:@"0%ld日",(long)date.day] : [NSString stringWithFormat:@"%ld日",(long)date.day];
    }else if (type == NSCalendarUnitHour) {
        return date.hour < 10 ? [NSString stringWithFormat:@"0%ld时",(long)date.hour] : [NSString stringWithFormat:@"%ld时",(long)date.hour];
    }else if (type == NSCalendarUnitMinute) {
        return date.minute < 10 ? [NSString stringWithFormat:@"0%ld分",(long)date.minute] : [NSString stringWithFormat:@"%ld分",(long)date.minute];
    }
    return @"";
}

/**
 选择时间,年月日时分

 @param value 选中值
 @param eventHandle 选中
 @param cancelBlock 取消
 */
+ (void)showDatePickerWithvalue:(NSDate *)value
                     bindChange:(void (^)(NSDate *value))eventHandle
                     bindCancel:(void (^)(void))cancelBlock{
    [self showDatePickerWithvalue:value start:nil end:nil bindChange:eventHandle bindCancel:cancelBlock];
}

+ (NSArray *)getDaysByMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSUInteger numberOfDaysInMonth = range.length;
    NSMutableArray *days = [NSMutableArray array];
    for (NSInteger i = 1; i<= numberOfDaysInMonth; i++) {
        NSString *day = [NSString stringWithFormat:@"%ld日",(long)i];
        if (i<10) {
            day = [NSString stringWithFormat:@"0%ld日",(long)i];
        }
        [days addObject:day];
    }
    return days;
}
@end
