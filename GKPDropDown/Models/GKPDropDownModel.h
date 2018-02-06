//
//  GKPDropDownModel.h
//  GKPDropDown
//
//  Created by Gokhan on 19.09.2016.
//  Copyright © 2016 Gokhan ALP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface GKPDropDownModel : NSObject

@property (nonatomic,strong, nullable) NSString* title;
@property (nonatomic,strong, nullable) NSString* detail;
@property (nonatomic,strong, nullable) UIImage* image;

@property (nonatomic,strong, nullable) void (^actionBlock)(void);

@end
