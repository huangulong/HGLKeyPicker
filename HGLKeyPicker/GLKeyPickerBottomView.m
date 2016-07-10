//
//  ECKeyPickerBottomView.m
//
//  Created by huanggulong on 16/7/9.
//  Copyright © 2016年 历山大亚. All rights reserved.
//

#import "GLKeyPickerBottomView.h"
#import <Masonry.h>

NSString *const GLKeyPickerBottomViewDateKey = @"keyPickerBottomViewDateKey";//时间key
NSString *const GLKeyPickerBottomViewListKey = @"keyPickerBottomViewListKey";//数组key

@interface GLKeyPickerBottomView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    BOOL isAnimation;
}
@property(nonatomic , weak)UIView *  topView;

@end

@implementation GLKeyPickerBottomView
@synthesize datePicker = _datePicker;


- (instancetype)initWithType:(GLKeyPickerBottomViewShowType)pickerType{
    self = [super init];
    if (self) {
        _pickerType = pickerType;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfClick:)]];
        
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        _contentView = view;
        _contentView.backgroundColor = [UIColor colorWithRed:210/255.0 green:213/255.0 blue:218/255.0 alpha:1];
        
        if (pickerType == GLKeyPickerBottomViewShowOther) {
            UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
            [view addSubview:pickerView];
            _pickerView = pickerView;
            pickerView.delegate = self;
            pickerView.dataSource = self;
            [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.and.right.offset(0);
                make.height.mas_equalTo(216);
            }];
        }else{
            UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
            [view addSubview:datePicker];
            _datePicker = datePicker;
            [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.and.right.offset(0);
                make.height.mas_equalTo(216);
            }];
            if (pickerType == GLKeyPickerBottomViewShowDate) {
                datePicker.datePickerMode = UIDatePickerModeDate;
            }else{
                datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            }
        }
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.mas_equalTo(260);//216 44
            make.bottom.offset(260);
        }];
        
        CALayer *layer = _contentView.layer;
        layer.shadowColor = [UIColor blackColor].CGColor;
        layer.shadowOpacity = 0.16;
        layer.shadowOffset = CGSizeMake(0, -2);
        
        //187	194	201
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor colorWithRed:187/255.0 green:194/255.0 blue:201/255.0 alpha:1];
        [self.contentView addSubview:topView];
        _topView = topView;
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.with.right.offset(0);
            make.height.mas_equalTo(44);
        }];
        
        UIButton *button1 = [[UIButton alloc] init];
        [button1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [button1 setTitle:@"取消" forState:(UIControlStateNormal)];
        button1.tag = 1;
        [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:button1];
        button1.frame =CGRectMake(10, 10, 50, 24);
        
        UIButton *button2 = [[UIButton alloc] init];
        [button2 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [button2 setTitle:@"确定" forState:(UIControlStateNormal)];
        button2.tag = 2;
        [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:button2];
        [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10);
            make.top.offset(10);
            make.size.mas_equalTo(CGSizeMake(50, 24));
        }];
    }
    return self;
}

#pragma mark - public
- (void)showWithAnimation:(BOOL)animation{
    isAnimation = animation;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
        }];
        if (animation) {
            [UIView animateWithDuration:0.25 animations:^{
                [self layoutIfNeeded];
            }];
        }
    });
}

#pragma mark - private
- (void)quitCurrentView:(void(^)())completeBlock{
    if (isAnimation) {
        [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(260);
        }];
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (completeBlock) {
                completeBlock();
            }
            [self removeFromSuperview];
        }];
    }else{
        if (completeBlock) {
            completeBlock();
        }
        [self removeFromSuperview];
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInPickerView:)]) {
        return [self.dataSource numberOfSectionsInPickerView:self];
    }
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if ([self.dataSource respondsToSelector:@selector(pickerView:numberOfRowsInSection:)]) {
        return [self.dataSource pickerView:self numberOfRowsInSection:component];
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if ([self.dataSource respondsToSelector:@selector(pickerView:titleForRowAtIndexPath:)]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:component];
        return [self.dataSource pickerView:self titleForRowAtIndexPath:indexPath];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([self.delegate respondsToSelector:@selector(pickerBottomView:didSelectRowAtIndexPath:)]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:component];
        [self.delegate pickerBottomView:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - click
- (IBAction)selfClick:(UIGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:self];
    if (!CGRectContainsPoint(self.contentView.frame, point)) {
        [self quitCurrentView:^{
            if ([self.delegate respondsToSelector:@selector(cancelBottomView)]) {
                [self.delegate cancelBottomView];
            }
        }];
    }
}

- (IBAction)buttonClick:(UIButton *)sender{
    if (sender.tag == 1) {
        [self quitCurrentView:^{
            if ([self.delegate respondsToSelector:@selector(cancelBottomView)]) {
                [self.delegate cancelBottomView];
            }
        }];
    }else{
        [self quitCurrentView:^{
            if ([self.delegate respondsToSelector:@selector(pickerBottomView:withUserInfo:)]) {
                NSDictionary * dict;
                if (self.pickerType == GLKeyPickerBottomViewShowOther) {
                    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.pickerView.numberOfComponents];
                    for (int i = 0; i < self.pickerView.numberOfComponents; i ++) {
                        NSInteger selectedRow = [self.pickerView selectedRowInComponent:i];
                        [array addObject:[NSNumber numberWithInteger:selectedRow]];
                    }
                    
                    dict = @{GLKeyPickerBottomViewListKey:array};
                }else{
                    dict = @{GLKeyPickerBottomViewDateKey:self.datePicker.date};
                }
                [self.delegate pickerBottomView:self withUserInfo:dict];
            }
        }];
    }
}

#pragma mark - getter setter
- (void)setPickerData:(NSDictionary<NSString *,id> *)pickerData{
    if (_pickerType == GLKeyPickerBottomViewShowOther) {
        NSArray *array = [pickerData valueForKey:GLKeyPickerBottomViewListKey];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int i = 0; i < _pickerView.numberOfComponents; i ++) {
                if (i < array.count) {
                    NSNumber *number = [array objectAtIndex:i];
                    [_pickerView selectRow:number.integerValue inComponent:i animated:YES];
                }else{
                    [_pickerView selectRow:0 inComponent:i animated:YES];
                }
            }
        }
    }else{
        NSDate *date = [pickerData valueForKey:GLKeyPickerBottomViewDateKey];
        if ([date isKindOfClass:[NSDate class]]) {
            _datePicker.date = date;
        }
    }
}

- (NSDictionary *)pickerData{
    if (self.pickerType == GLKeyPickerBottomViewShowOther) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < _pickerView.numberOfComponents; i ++) {
            
            NSNumber *number = [NSNumber numberWithInteger:[_pickerView selectedRowInComponent:i]];
            [array addObject:number];
        }
        return @{GLKeyPickerBottomViewListKey:array.copy};
    }else{
        return @{GLKeyPickerBottomViewDateKey:_datePicker.date?:[NSDate date]};
    }
}


@end
