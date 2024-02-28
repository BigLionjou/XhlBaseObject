//
//  XHLPicker.m
//  XHLPods-XHLUIKit
//
//  Created by xhl on 2018/3/8.
//  Copyright © 2018年 xhl. All rights reserved.
//

#import "XHLPicker.h"
#define RowHeightForComponent 32.0f
#define RowTextFontSize 18.0f
#define UIScreenSize [UIScreen mainScreen].bounds.size
#define ButtonWidth 90.0f
#define ButtonHeight 44.0f
#define PickerContainerHeight roundf(UIScreenSize.width * 291 / 414.0) + ButtonHeight

#define ViewBackgroundColor [[UIColor blackColor] colorWithAlphaComponent:.65]
#define CancelButtonColorWithAplha(x) [UIColor colorWithWhite:102/255.0 alpha:x]
#define ConfirmButtonColorWithAplha(x) [UIColor colorWithRed:60/255.0 green:118/255.0 blue:255/255.0 alpha:x]
#define SeparatorLineColor [UIColor colorWithWhite:230/255.0 alpha:1.0]

#define ViewAnimateDuration .35

@interface XHLPicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIButton *wholeCancelMaskButton;
@property (nonatomic, strong) UIView *pickerContainer;

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, copy) NSArray *pickerRange;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *pickerValue;

@property (nonatomic, copy) XHLPickerValueBlock valueChangeBlock;
@property (nonatomic, copy) XHLPickerColumnBlock columnChangeBlock;
@property (nonatomic, copy) XHLPickerCancelBlock cancelBlock;

@end

@implementation XHLPicker

+ (instancetype)showPickerWithRange:(NSArray *)range
                              value:(NSArray *)value
                    bindValueChange:(XHLPickerValueBlock)valueChange
                   bindColumnChange:(XHLPickerColumnBlock)columnChange
                         bindCancel:(XHLPickerCancelBlock)cancel {
    XHLPicker *picker = [[XHLPicker alloc] initWithRange:range
                                                   value:value
                                         bindValueChange:valueChange
                                        bindColumnChange:columnChange
                                              bindCancel:cancel];
    [picker show];
    return picker;
}

- (instancetype)initWithRange:(NSArray *)range
                        value:(NSArray *)value
              bindValueChange:(XHLPickerValueBlock)valueChange
             bindColumnChange:(XHLPickerColumnBlock)columnChange
                   bindCancel:(XHLPickerCancelBlock)cancel {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.alpha = 0;
        self.backgroundColor = ViewBackgroundColor;
        self.valueChangeBlock = valueChange;
        self.columnChangeBlock = columnChange;
        self.cancelBlock = cancel;
        
        _wholeCancelMaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _wholeCancelMaskButton.frame = [UIScreen mainScreen].bounds;
        _wholeCancelMaskButton.backgroundColor = [UIColor clearColor];
        [_wholeCancelMaskButton addTarget:self
                                   action:@selector(clickCancel:)
                         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_wholeCancelMaskButton];
        
        
        _pickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    UIScreenSize.height,
                                                                    UIScreenSize.width,
                                                                    PickerContainerHeight)];
        _pickerContainer.backgroundColor = [UIColor whiteColor];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, ButtonWidth, ButtonHeight);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:CancelButtonColorWithAplha(1) forState:UIControlStateNormal];
        [_cancelButton setTitleColor:CancelButtonColorWithAplha(.2) forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self
                          action:@selector(clickCancel:)
                forControlEvents:UIControlEventTouchUpInside];
        [_pickerContainer addSubview:_cancelButton];
        
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(UIScreenSize.width - ButtonWidth, 0, ButtonWidth, ButtonHeight);
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:ConfirmButtonColorWithAplha(1) forState:UIControlStateNormal];
        [_confirmButton setTitleColor:ConfirmButtonColorWithAplha(.2) forState:UIControlStateHighlighted];
        [_confirmButton addTarget:self
                           action:@selector(clickConfirm:)
                 forControlEvents:UIControlEventTouchUpInside];
        [_pickerContainer addSubview:_confirmButton];
        
        UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                         ButtonHeight - .5,
                                                                         UIScreenSize.width,
                                                                         .5)];
        separatorLine.backgroundColor = SeparatorLineColor;
        [_pickerContainer addSubview:separatorLine];
        
        _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,
                                                                 ButtonHeight,
                                                                 UIScreenSize.width,
                                                                 _pickerContainer.bounds.size.height - ButtonHeight)];
        _picker.delegate = self;
        _picker.dataSource = self;
        _picker.backgroundColor = [UIColor whiteColor];
        _picker.showsSelectionIndicator = YES;
        [_pickerContainer addSubview:_picker];
        [self addSubview:_pickerContainer];
        [self _updatePickerRange:range value:value];
    }
    return self;
}

- (void)show {
    UIView *keyWindowTopView = [UIApplication sharedApplication].keyWindow.subviews.lastObject;
    if ([keyWindowTopView isKindOfClass:[self class]]) {
        [keyWindowTopView removeFromSuperview];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:ViewAnimateDuration
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
    [self cancel];
}

- (void)cancel {
    [UIView animateWithDuration:ViewAnimateDuration
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
    if (self.valueChangeBlock) {
        self.valueChangeBlock(self, [self.pickerValue copy]);
    }
    [self cancel];
}

- (void)updatePickerRange:(NSArray *)range value:(NSArray *)value {
    // 处理range
    NSMutableArray *tempRange = [NSMutableArray arrayWithCapacity:[self.pickerRange count]];
    for (NSInteger i = 0; i < [self.pickerRange count]; i++) {
        NSArray *columns = range[i];
        if (columns) {
            [tempRange addObject:columns];
        } else {
            [tempRange addObject:[self.pickerRange objectAtIndex:i]];
        }
    }
    [self _updatePickerRange:tempRange value:value];
}

- (void)_updatePickerRange:(NSArray *)range value:(NSArray *)value {
    self.pickerRange = range;
    NSMutableArray *tempValue = [NSMutableArray arrayWithCapacity:[range count]];
    for (NSInteger i = 0; i < [range count]; i++) {
        NSNumber *index = value[i];
        if ([index respondsToSelector:@selector(integerValue)] && index.integerValue >= 0) {
            [tempValue addObject:index];
        } else {
            [tempValue addObject:@(0)];
        }
    }
    self.pickerValue = tempValue;
    [self.picker reloadAllComponents];
    [self reloadPickerSelectRow];
}

- (void)reloadPickerSelectRow {
    for (NSInteger i = 0; i < [self.pickerRange count]; i++) {
        NSNumber *index = self.pickerValue[i];
        NSArray *columns = [self.pickerRange objectAtIndex:i];
        if ([index respondsToSelector:@selector(integerValue)]
            && [index integerValue] >= 0
            && [columns respondsToSelector:@selector(count)]
            && [columns count] > [index integerValue]) {
            [self.picker selectRow:index.integerValue inComponent:i animated:YES];
        } else {
            [self.picker selectRow:0 inComponent:i animated:YES];
        }
    }
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated{
    if (row > [self.picker numberOfRowsInComponent:component]) {
        return;
    }
     [self.picker selectRow:row inComponent:component animated:YES];
    if ([self.pickerValue count] > component) {
        NSInteger value = self.pickerValue[component].integerValue;
        if (value == row) {
            return;
        }
        self.pickerValue[component] = @(row);
    }
}

- (void)updatePickerColumns:(NSArray *)columns columnIndex:(NSInteger)index row:(NSInteger)row {
    if (![columns isKindOfClass:[NSArray class]]) {
        columns = @[];
    }
    
    // 如果不存在该列，则不更新
    if (index < 0 || index >= [self.pickerRange count]) {
        return;
    }
    
    // 更新列数据
    NSMutableArray *tempRange = [NSMutableArray arrayWithArray:self.pickerRange];
    tempRange[index] = columns;
    self.pickerRange = tempRange;
    [self.picker reloadComponent:index];
    
    if (row < 0 || row >= [columns count]) row = 0;
    
    if (index <= [self.pickerValue count]) {
        self.pickerValue[index] = @(row);
    }
    
    [self.picker selectRow:row inComponent:index animated:YES];
}

- (NSArray *)range {
    return self.pickerRange;
}

- (NSArray *)value {
    return [self.pickerValue copy];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [self.pickerRange count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *array = self.pickerRange[component];
    return [array respondsToSelector:@selector(count)] ? [array count] : 0;
}

#pragma mark - UIPickerViewDelegate
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    return self.frame.size.width / [self.pickerRange count];
//}
//
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
//    return RowHeightForComponent;
//}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *column =  self.pickerRange[component];
    if ([column isKindOfClass:[NSArray class]]) {
        return [NSString stringWithFormat:@"%@", column[row]];
    }
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* label = nil;
    if ([label isKindOfClass:[UILabel class]]) {
        label = (UILabel*)view;
    }else{
        CGRect rect = CGRectMake(0, 0, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height);
        label = [[UILabel alloc] initWithFrame:rect];
        label.adjustsFontSizeToFitWidth = YES;
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:23]];
    }
    label.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    label.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 32.0f;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([self.pickerValue count] > component) {
        NSInteger value = self.pickerValue[component].integerValue;
        if (value == row) {
            return;
        }
        self.pickerValue[component] = @(row);
    }
    
    if (self.columnChangeBlock) {
        self.columnChangeBlock(self, component, row);
    }
}

@end
