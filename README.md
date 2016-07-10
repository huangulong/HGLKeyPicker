# HGLKeyPicker

1.时间选择器

        GLKeyPickerBottomView *bv = [[GLKeyPickerBottomView alloc] initWithType:(GLKeyPickerBottomViewShowDate)];
        
        bv.delegate = self;
        
        bv.frame = self.view.bounds;
        
        [self.view addSubview:bv];
        
        [bv showWithAnimation:YES];
        
2.picker

        GLKeyPickerBottomView *bv = [[GLKeyPickerBottomView alloc] initWithType:(GLKeyPickerBottomViewShowOther)];
        
        bv.frame = self.view.bounds;
        
        bv.delegate = self;
        
        bv.dataSource = self;
        
        [self.view addSubview:bv];
        
        [bv showWithAnimation:YES];
        
3.定制时间      bv.pickerData = @{GLKeyPickerBottomViewDateKey:tempDate};


4.定制选中项    bv.pickerData = @{GLKeyPickerBottomViewListKey:@[number1,number2]}; 

  //传递空数组时 或者不传都是取0

5. - (void)showWithAnimation:(BOOL)animation;

  animation = YES 添加动画，，收起时也会有动画
  
  contentView 为承载视图
  
  showWithAnimation  //该方法不掉用将无法现实
  
  
注＊ GLKeyPickerBottomViewDataSource里面几个代理方法类似于 UITableViewDataSource
