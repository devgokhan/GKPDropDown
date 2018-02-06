//
//  GKPDropDown.m
//  GKPDropDown
//
//  Created by Gokhan on 19.09.2016.
//  Copyright © 2016 Gokhan ALP. All rights reserved.
//

#import "GKPDropDown.h"

@interface GKPDropDown()

@property (nonatomic) DropDownType dropDownType;
@property (nonatomic) UIView *sourceView;

@property (nonatomic) NSArray<GKPDropDownModel*>* dropdownOrginalItems;
@property (nonatomic) NSMutableArray<GKPDropDownModel*>* dropdownFilteredItems;

@property (nonatomic) CGFloat goTopMargin;
@property (nonatomic) CGFloat moveAnimDuration;
@property UIColor* rowBackgroundColor;
@property UIColor* backgroundColor;

@property (nonatomic) bool isActionsAuto;
@property (nonatomic) CGRect orginalSourceViewFrame;

@end

@implementation GKPDropDown

-(instancetype)initWithView: (UIView*) srcView items :(NSArray<GKPDropDownModel*>*) items isActionsSetAuto:(bool)isActionsSetAuto type:(int) type
{
    return [self initWithView:srcView items:items isActionsSetAuto:isActionsSetAuto type:type configuration:nil];
}

-(instancetype)initWithView: (UIView*) srcView items :(NSArray<GKPDropDownModel*>*) items isActionsSetAuto:(bool)isActionsSetAuto type:(int) type configuration:(GKPDropDownConfiguration*)configuration
{
    self = [super init];
    
    if (self) {
        self.dropdownOrginalItems = items;
        self.dropdownFilteredItems =  [NSMutableArray arrayWithArray:self.dropdownOrginalItems];
        self.sourceView = srcView;
        self.orginalSourceViewFrame = srcView.frame;
        
        self.dropDownType = type;
        self.isActionsAuto = isActionsSetAuto;
        
        if([self validation] == false)
        {
            return self;
        }
        
        [self setActionsAutomatically];
        [self setParametersWithConfiguration:configuration];
        
        [self setTableViewLook];
        
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

# pragma mark - Startup Things

-(void) setParametersWithConfiguration:(GKPDropDownConfiguration*)configuration
{
    // Defaults are
    self.separatorColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    if(configuration == nil) // Get default values from instance
    {
        configuration = [[GKPDropDownConfiguration alloc] init];
    }
    
    self.rowHeight = (configuration.rowHeight);
    self.goTopMargin = (configuration.goTopMargin);
    self.separatorColor = configuration.seperatorColor;
    self.rowBackgroundColor = configuration.rowBackgroundColor;
    self.separatorColor = configuration.seperatorColor;
    self.backgroundColor = configuration.backgroundColor;
    self.moveAnimDuration = configuration.moveAnimDuration;
    
    // Seting some values
    self.hidden = true;
    self.scrollEnabled = true;
    self.backgroundColor = self.backgroundColor;
}

-(bool) validation
{
    if(self.dropDownType == DropDownGoesTopWithSearchBarOnlyButton  && ([self.sourceView isKindOfClass:[UIButton class]] == false ))
    {
        [NSException raise:@"Dropdown is not valid!" format:@"DropDownGoesTopWithSearchBarOnlyButton type can only use with UIButton"];
        return false;
    }
    
    return true;
}

#pragma mark - UI Things

-(void) setActionsAutomatically
{
    if(self.isActionsAuto)
    {
        if([self.sourceView isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton*)self.sourceView;
            [btn addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if([self.sourceView isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)self.sourceView;
            [txt setDelegate:self];
            txt.returnKeyType = UIReturnKeyDone;
            [txt addTarget:self action:@selector(onTextStartEditing:) forControlEvents:UIControlEventEditingDidBegin];
            [txt addTarget:self action:@selector(onTextEditEnd:) forControlEvents:UIControlEventEditingDidEnd];
            [txt addTarget:self action:@selector(onTextChanged:) forControlEvents:UIControlEventEditingChanged];
            
            [UIView animateWithDuration:self.moveAnimDuration animations:^{
                self.sourceView.frame = CGRectMake(self.sourceView.frame.origin.x, 400 , self.sourceView.frame.size.width, self.sourceView.frame.size.height);
            } completion:^(BOOL finished) {
                
            }];
            
        }
    }
}

-(void) setTableViewLook
{
    [self.sourceView layoutIfNeeded];
    
    UIView *sourceDropDownView = self.sourceView;
    UIView *sourceTableFieldView = self.sourceView.superview;
    
    [sourceDropDownView layoutIfNeeded];
    [sourceTableFieldView layoutIfNeeded];
    
    CGRect sourceDropDownViewFrame = sourceDropDownView.frame;
    
    CGFloat tableX;
    CGFloat tableWidth;
    CGFloat tableY;
    CGFloat tableHeight;
    
    if(self.dropDownType == DropDownGoesTop || self.dropDownType == DropDownGoesTopWithSearchBarOnlyButton)
    {
        sourceDropDownViewFrame =  CGRectMake(sourceDropDownView.frame.origin.x,
                                              self.goTopMargin,
                                              sourceDropDownView.frame.size.width,
                                              sourceDropDownView.frame.size.height);
        
        tableX = sourceDropDownView.frame.origin.x;
        tableWidth = sourceDropDownView.frame.size.width;
        
        tableY = sourceDropDownViewFrame.size.height + sourceDropDownViewFrame.origin.y;
        tableHeight = sourceTableFieldView.frame.size.height + (sourceTableFieldView.frame.origin.y - sourceDropDownViewFrame.origin.y);
    }
    else
    {
        tableX = sourceDropDownViewFrame.origin.x;
        tableWidth = sourceDropDownViewFrame.size.width;
        
        tableY = sourceDropDownViewFrame.origin.y + sourceDropDownViewFrame.size.height;
    }
    
    CGFloat height = sourceTableFieldView.frame.size.height - (sourceDropDownViewFrame.origin.y + sourceDropDownViewFrame.size.height );
    CGFloat tableEstimatedHeight = self.dropdownFilteredItems.count * self.rowHeight;
    bool showAtBottom = true;
    [self layoutIfNeeded];
    if(tableEstimatedHeight > height)
    {
        height = height - 20;
    }
    else
    {
        height = tableEstimatedHeight;
    }
    
    if(height < 50)
    {
        showAtBottom = false;
        height = ( sourceDropDownViewFrame.origin.y );
        if(tableEstimatedHeight > height)
        {
            height = height - 20;
        }
        else
        {
            height = tableEstimatedHeight ;
        }
    }
    
    if(showAtBottom)
    {
        CGRect rect = CGRectMake(tableX,
                                 (tableY ),
                                 tableWidth,
                                 height);
        self.frame = rect;
    }
    else // showsAtTop
    {
        CGRect rect = CGRectMake(tableX,
                                 tableY - height - sourceDropDownViewFrame.size.height,
                                 tableWidth,
                                 height);
        self.frame = rect;
    }
    
    [self layoutIfNeeded];
}

-(void) addComponentToViewController: (UIViewController*) vc
{
    [vc.view layoutIfNeeded];
    [vc.view addSubview: self];
}

-(void) addComponentToView: (UIView*) view
{
    [view layoutIfNeeded];
    [view addSubview: self];
}

# pragma mark - Functions

-(void) moveDropDownIfNeeded :(bool)hide
{
    CGRect newLocation;
    bool unhideitWhenCompleted = false;
    if(!hide)
    {
        unhideitWhenCompleted = true;
        newLocation = CGRectMake(self.sourceView.frame.origin.x, self.goTopMargin , self.sourceView.frame.size.width, self.sourceView.frame.size.height);
    }
    else
    {
        self.hidden = true;
        newLocation = self.orginalSourceViewFrame;
    }
    
    [UIView animateWithDuration:self.moveAnimDuration animations:^{
        self.sourceView.frame = newLocation;
    } completion:^(BOOL finished) {
        if(unhideitWhenCompleted)
        {
            self.hidden = false;
        }
    }];
}

# pragma mark - Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dropdownFilteredItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tbc = [[UITableViewCell alloc] init];
    tbc.backgroundColor = self.rowBackgroundColor;
    CGRect rect = CGRectMake(0, 0, tableView.frame.size.width, 50);
    tbc.frame = rect;
    
    
    int imgMargin = 5;
    
    if(self.dropdownFilteredItems[indexPath.row].image != nil)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, tbc.frame.size.height - 15)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.image = self.dropdownFilteredItems[indexPath.row].image;
        imgMargin = imgView.frame.origin.x + imgView.frame.size.width + 10;
        [tbc addSubview:imgView];
    }
    
    UILabel *lblTitle = [[UILabel alloc] init];
    
    if(self.dropdownFilteredItems[indexPath.row].detail != nil) // title and detail
    {
        // title first
        lblTitle.frame = CGRectMake(imgMargin, tbc.frame.origin.y, tbc.frame.size.width - imgMargin - 5, tbc.frame.size.height/2);
        [lblTitle setText:self.dropdownFilteredItems[indexPath.row].title];
        [tbc addSubview:lblTitle];
        
        // detail
        UILabel *lblDetail = [[UILabel alloc] init];
        lblDetail.frame = CGRectMake(imgMargin, tbc.frame.size.height/2, tbc.frame.size.width - imgMargin - 5, tbc.frame.size.height/2);
        [lblDetail setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [lblDetail setText:self.dropdownFilteredItems[indexPath.row].detail];
        [tbc addSubview:lblDetail];
        
    }
    else // only title
    {
        lblTitle.frame = CGRectMake(imgMargin, tbc.frame.origin.y, tbc.frame.size.width - imgMargin - 5, tbc.frame.size.height);
        [lblTitle setText:self.dropdownFilteredItems[indexPath.row].title];
        [tbc addSubview:lblTitle];
    }
    
    
    
    return tbc;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dropdownFilteredItems[indexPath.row].actionBlock != nil)
    {
        self.dropdownFilteredItems[indexPath.row].actionBlock();
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.rowHeight;
}

# pragma mark - Actions

- (IBAction)onClickButton:(id)sender {
    
    if(self.dropDownType == DropDownGoesTop || self.dropDownType == DropDownGoesTopWithSearchBarOnlyButton)
    {
        [self moveDropDownIfNeeded :!(self.hidden)];
    }
    else
    {
        self.hidden = !(self.hidden);
    }
}

#pragma mark - Textfield Methods

- (IBAction)onTextStartEditing:(id)sender {
    if(self.dropDownType == DropDownGoesTop || self.dropDownType == DropDownGoesTopWithSearchBarOnlyButton)
    {
        [self moveDropDownIfNeeded :false];
    }
    else
    {
        self.hidden = false;
    }
}

- (IBAction)onTextEditEnd:(id)sender {
    if(self.dropDownType == DropDownGoesTop || self.dropDownType == DropDownGoesTopWithSearchBarOnlyButton)
    {
        [self moveDropDownIfNeeded :true];
    }
    else
    {
        self.hidden = true;
    }
}

- (IBAction)onTextChanged:(UITextField *)textField {
    
    NSString *txtSearch = [[(textField.text) lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [self.dropdownFilteredItems removeAllObjects];
    
    if(txtSearch == nil || txtSearch.length < 1)
    {
        [self.dropdownFilteredItems addObjectsFromArray:self.dropdownOrginalItems];
    }
    
    for(GKPDropDownModel* item in self.dropdownOrginalItems)
    {
        NSString* title = [[(item.title) lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString* detail = [[(item.detail) lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if([title containsString:txtSearch] || [detail containsString:txtSearch])
        {
            [self.dropdownFilteredItems addObject:item];
        }
    }
    
    [self reloadData];
    [self setTableViewLook];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

@end
