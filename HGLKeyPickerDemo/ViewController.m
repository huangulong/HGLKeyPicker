//
//  ViewController.m
//  HGLKeyPickerDemo
//
//  Created by huanggulong on 16/7/10.
//  Copyright © 2016年 历山大亚. All rights reserved.
//

#import "ViewController.h"
#import "GLKeyPickerBottomView.h"

@interface ViewController ()<GLKeyPickerBottomViewDelegate,GLKeyPickerBottomViewDataSource>
{
    UIButton *dateButton;
    UIButton *chooseButton;
    NSNumber * number1 ,* number2; //索引
    NSNumber * tempNum1,* tempNum2; //临时索引
    NSDate *tempDate; //时间
}

@property(nonatomic , strong)NSArray * titles1;
@property(nonatomic , strong)NSArray * titles2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 120, 24)];
    [button1 setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [button1 setTitle:@"1991-01-24" forState:(UIControlStateNormal)];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(buttonClick1:) forControlEvents:(UIControlEventTouchUpInside)];
    dateButton = button1;
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, 120, 24)];
    [button2 setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [button2 setTitle:@"湖北武汉" forState:(UIControlStateNormal)];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(buttonClick2:) forControlEvents:(UIControlEventTouchUpInside)];
    chooseButton = button2;
    
    _titles1 = @[@"湖北",@"湖南"];
    _titles2 = @[@[@"武汉",@"荆州",@"黄石"],@[@"长沙",@"岳阳"]];
    tempDate = [NSDate date];
    number1 = [NSNumber numberWithInteger:0];
    number2 = [NSNumber numberWithInteger:0];
}

- (IBAction)buttonClick1:(id)sender{
    GLKeyPickerBottomView *bv = [[GLKeyPickerBottomView alloc] initWithType:(GLKeyPickerBottomViewShowDate)];
    bv.delegate = self;
    bv.frame = self.view.bounds;
    [bv.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:bv];
    [bv showWithAnimation:YES];
    bv.pickerData = @{GLKeyPickerBottomViewDateKey:tempDate};
}

- (IBAction)buttonClick2:(id)sender{
    GLKeyPickerBottomView *bv = [[GLKeyPickerBottomView alloc] initWithType:(GLKeyPickerBottomViewShowOther)];
    bv.frame = self.view.bounds;
    bv.delegate = self;
    bv.dataSource = self;
    [self.view addSubview:bv];
    [bv showWithAnimation:YES];
    tempNum1 = number1,tempNum2 = number2;
    bv.pickerData = @{GLKeyPickerBottomViewListKey:@[number1,number2]};
}

- (IBAction)dateChange:(UIDatePicker *)sender{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *title = [formatter stringFromDate:sender.date];
    [dateButton setTitle:title forState:(UIControlStateNormal)];
    tempDate = sender.date;
}

#pragma mark - GLKeyPickerBottomViewDelegate
- (void)pickerBottomView:(GLKeyPickerBottomView *)bottomView withUserInfo:(id)userInfo{
    if (bottomView.pickerType == GLKeyPickerBottomViewShowOther) {
        NSArray *array = [userInfo valueForKey:GLKeyPickerBottomViewListKey];
        number1 = array[0];
        number2 = array[1];
        NSString *str1 = [_titles1 objectAtIndex:number1.integerValue];
        NSString *str2 = [_titles2[number1.integerValue] objectAtIndex:number2.integerValue];
        [chooseButton setTitle:[NSString stringWithFormat:@"%@%@",str1,str2] forState:(UIControlStateNormal)];
    }
}

- (void)pickerBottomView:(GLKeyPickerBottomView *)bottomView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        tempNum1 = [NSNumber numberWithInteger:indexPath.row];
        tempNum2 = [NSNumber numberWithInteger:0];
        [bottomView.pickerView reloadComponent:1];
        [bottomView.pickerView selectRow:0 inComponent:1 animated:NO];
    }else{
        tempNum2 = [NSNumber numberWithInteger:indexPath.row];
    }
}


#pragma mark - GLKeyPickerBottomViewDataSource
- (NSInteger)numberOfSectionsInPickerView:(GLKeyPickerBottomView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(GLKeyPickerBottomView *)pickerView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _titles1.count;
    }else{
        NSInteger index = tempNum1.integerValue;
        NSArray *array = [_titles2 objectAtIndex:index];
        return array.count;
    }
}

- (NSString *)pickerView:(GLKeyPickerBottomView *)pickerView titleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [_titles1 objectAtIndex:indexPath.row];
    }else{
        NSInteger index = tempNum1.integerValue;
        NSArray *array = [_titles2 objectAtIndex:index];
        return [array objectAtIndex:indexPath.row];
    }
}


@end
