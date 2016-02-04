//
//  ViewController.m
//  City
//
//  Created by 贺梦洁 on 16/1/25.
//  Copyright © 2016年 贺梦洁. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSDictionary *dict;//用于存储省份-城市的数据
    NSArray *provinceArray;//省份的数组
    NSArray *cityArray;//城市的数组，在接下来的代码中会有根据省份的选择进行数据更新的操作
}

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *provinceTextField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initPicker];
}

//初始化PickerView使用的数据源
-(void)initPicker{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"province-city" ofType:@"plist"];
    dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    provinceArray = [dict allKeys];
    
    NSInteger selectedProvinceIndex = [self.pickerView selectedRowInComponent:0];
    NSString *seletedProvince = [provinceArray objectAtIndex:selectedProvinceIndex];
    cityArray = [dict objectForKey:seletedProvince];
    self.provinceTextField.text = provinceArray[0];
    self.cityTextField.text = cityArray[0];
}
#pragma mark - UIPickerViewDataSource
//以下3个方法实现PickerView的数据初始化
//确定picker的轮子个数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
//确定picker的每个轮子的item数
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {//省份个数
        return [provinceArray count];
    } else {//市的个数
        return [cityArray count];
    }
}
//确定每个轮子的每一项显示什么内容
#pragma mark 实现协议UIPickerViewDelegate方法
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {//选择省份名
        return [provinceArray objectAtIndex:row];
    } else {//选择市名
        return [cityArray objectAtIndex:row];
    }
}
#pragma mark - 监听轮子的移动
//监听轮子的移动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        NSString *seletedProvince = [provinceArray objectAtIndex:row];
        cityArray = [dict objectForKey:seletedProvince];
        
        //重点！更新第二个轮子的数据
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        NSInteger selectedCityIndex = [self.pickerView selectedRowInComponent:1];
        NSString *seletedCity = [cityArray objectAtIndex:selectedCityIndex];
        self.provinceTextField.text = seletedProvince;
        self.cityTextField.text = seletedCity;
    }
    else {
        NSInteger selectedProvinceIndex = [self.pickerView selectedRowInComponent:0];
        NSString *seletedProvince = [provinceArray objectAtIndex:selectedProvinceIndex];
        
        NSString *seletedCity = [cityArray objectAtIndex:row];
        self.provinceTextField.text = seletedProvince;
        self.cityTextField.text = seletedCity;
    }
}

@end
