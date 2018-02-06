//
//  GKPDropDown.h
//  GKPDropDown
//
//  Created by Gokhan on 19.09.2016.
//  Copyright © 2016 Gokhan ALP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKPDropDownModel.h"
#import "GKPDropDownConfiguration.h"

@interface GKPDropDown : UITableView<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

typedef NS_ENUM(NSInteger, DropDownType) {
    DropDownDefault = 0, // defult
    DropDownGoesTop = 1, // dropdown goes top no search
    DropDownGoesTopWithSearchBarOnlyButton = 2 // dropdown go top with search field (only buttons)
};

-(instancetype)initWithView: (UIView*) srcView items :(NSArray<GKPDropDownModel*>*) items isActionsSetAuto:(bool)isActionsSetAuto type:(int) type;
-(instancetype)initWithView: (UIView*) srcView items :(NSArray<GKPDropDownModel*>*) items isActionsSetAuto:(bool)isActionsSetAuto type:(int) type configuration:(GKPDropDownConfiguration*)configuration;
-(void) addComponentToViewController: (UIViewController*) vc;
-(void) addComponentToView: (UIView*) view;

@end
