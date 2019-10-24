//
//  GLKeyPickerBottomView.h
//
//  Created by huanggulong on 16/7/9.
//  Copyright © 2016年 历山大亚. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GLKeyPickerBottomViewShowDefault,
    GLKeyPickerBottomViewShowDateAndTime = GLKeyPickerBottomViewShowDefault,
    GLKeyPickerBottomViewShowDate,
    GLKeyPickerBottomViewShowOther
} GLKeyPickerBottomViewShowType;

@protocol GLKeyPickerBottomViewDelegate,GLKeyPickerBottomViewDataSource;
@interface GLKeyPickerBottomView : UIView

//内容视图
@property(nonatomic , weak , readonly)UIView * contentView;
//除了GLKeyPickerBottomViewShowOther 才会产生datePicker
@property(nonatomic , readonly , weak)UIDatePicker * datePicker; //
//GLKeyPickerBottomViewShowOther 才会产生pickerView
@property(nonatomic , readonly , weak)UIPickerView * pickerView;
@property(nonatomic , strong)NSDictionary * pickerData;

@property(nonatomic , assign , readonly)GLKeyPickerBottomViewShowType pickerType;


/**
 *  点击完成之后的回调
 */
@property(nonatomic , copy)void(^completeBlock)(NSDictionary *);
/**
 *  数据代理
 */
@property(nonatomic,assign)id<GLKeyPickerBottomViewDelegate> delegate;

/**
 *  数据源
 *  pickerType == GLKeyPickerBottomViewShowOther 才起作用
 */
@property(nonatomic , assign)id<GLKeyPickerBottomViewDataSource>  dataSource;


//初始化数据
- (instancetype)initWithType:(GLKeyPickerBottomViewShowType)pickerType;

- (void)showWithAnimation:(BOOL)animation;

@end


@protocol GLKeyPickerBottomViewDataSource <NSObject>

@optional
/**
 *  有几组
 *
 *  @param pickerView
 *
 *  @return 组数
 */
- (NSInteger)numberOfSectionsInPickerView:(GLKeyPickerBottomView *)pickerView;

/**
 *  每组有几行
 *
 *  @param pickerView
 *  @param sGLtion    第几组
 *
 *  @return 行数
 */
- (NSInteger)pickerView:(GLKeyPickerBottomView *)pickerView numberOfRowsInSection:(NSInteger)section;

/**
 *  某组某行 的 字符串
 *
 *  @param pickerView
 *  @param indexPath
 *
 *  @return 字符串
 */
- (NSString *)pickerView:(GLKeyPickerBottomView *)pickerView titleForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol GLKeyPickerBottomViewDelegate <NSObject>

/**
 *  确认 之后的回调
 *
 *  @param bottomView
 *  @param userInfo   数据字典
 */
-(void)pickerBottomView:(GLKeyPickerBottomView *)bottomView withUserInfo:(id)userInfo;

@optional

/*
 * @huanggulong
 *
 * 取消 退出视图
 */
-(void)cancelBottomView;

/*
 * @huanggulong
 *
 * 第几行 选中了第几列数据
 */
- (void)pickerBottomView:(GLKeyPickerBottomView *)bottomView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

extern NSString *const GLKeyPickerBottomViewDateKey;//时间key
extern NSString *const GLKeyPickerBottomViewListKey;//数组key

