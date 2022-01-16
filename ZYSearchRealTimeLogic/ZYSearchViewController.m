//
//  ZYSearchViewController.m
//
//  Created by zy on 2022/1/13.
//

#import "ZYSearchViewController.h"
#import "Masonry.h"

static NSString * _CellID = @"CellID";

static inline UIColor * zy_hexColor(NSUInteger hexValue) {
    return [UIColor colorWithRed:((float)(((hexValue) & 0xFF0000) >> 16))/255.0 green:((float)(((hexValue) & 0xFF00) >> 8))/255.0 blue:((float)((hexValue) & 0xFF))/255.0 alpha:1.0];
}

@interface ZYSearchViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) NSMutableArray * searchResultArray;

@end

@implementation ZYSearchViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = true;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchResultArray = [NSMutableArray new];
    [self initUI];
}

- (void)initUI {
    BOOL iPhoneX = ([UIScreen mainScreen].bounds.size.width >= 375.0f &&
                    [UIScreen mainScreen].bounds.size.height >= 812.0f);
    UIView * topView = UIView.new;
    topView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(iPhoneX ? 88 : 64);
    }];
    
    UIButton * cancelButton = UIButton.new;
    [topView addSubview:cancelButton];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.right.offset(0);
        make.width.offset(60);
        make.height.offset(44);
    }];
    
    UIView * searchView = UIView.new;
    searchView.backgroundColor = zy_hexColor(0xeeeeee);
    searchView.layer.cornerRadius = 10;
    searchView.layer.masksToBounds = true;
    [topView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.bottom.offset(-5);
        make.height.offset(34);
        make.right.equalTo(cancelButton.mas_left);
    }];
    
    UIImageView * searchIV = UIImageView.new;
    [searchView addSubview:searchIV];
    searchIV.image = [UIImage imageNamed:@"search_icon"];
    [searchIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(8);
        make.centerY.equalTo(searchView);
        make.width.offset(16);
        make.height.offset(16);
    }];
    
    UITextField * textField = UITextField.new;
    [searchView addSubview:textField];
    _textField = textField;
    textField.placeholder = @"搜索";
    textField.font = [UIFont systemFontOfSize:17];
    [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchIV.mas_right).offset(5);
        make.centerY.equalTo(searchView);
        make.right.offset(-5);
    }];
    [textField becomeFirstResponder];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(topView.mas_bottom);
    }];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 0.1)];
}

- (void)cancelClick {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:true];
    } else {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

#pragma mark - tableView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.textField resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.searchResultArray.count ? 44 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:_CellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:_CellID];
    }
    cell.textLabel.text = self.searchResultArray[indexPath.row];
  
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    !self.searchClickBlock ?: self.searchClickBlock(self.searchResultArray[indexPath.row]);
    [self cancelClick];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * whiteView = UIView.new;

    UILabel * titleLabel = UILabel.new;
    titleLabel.textColor =  zy_hexColor(0xa4a4a4);;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.centerY.offset(0);
     }];
    
    titleLabel.text = @"搜索结果";

    return whiteView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.searchResultArray.count > 0) {
        return 30;
    }
    return 0;
}

- (void)textFieldChanged:(UITextField *)textField {
    
    [self.searchResultArray removeAllObjects];
    [self.searchArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj containsString:textField.text]) {
            [self.searchResultArray addObject:obj];
        }
    }];
    
    [self.tableView reloadData];
    
}

@end
