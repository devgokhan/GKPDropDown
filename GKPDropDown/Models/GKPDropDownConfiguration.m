//
//  GKPDropDownConfiguration.m
//  GKPDropDown
//
//  Created by Gokhan on 16/09/2017.
//  Copyright © 2017 Gokhan. All rights reserved.
//

#import "GKPDropDownConfiguration.h"

@implementation GKPDropDownConfiguration

-(instancetype)init
{
    self = [super init];

    if (self) {
        self.rowHeight = 50;
        self.goTopMargin = 20;
        self.rowBackgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        self.seperatorColor = [UIColor clearColor];
        self.moveAnimDuration = 0.5f;
    }
    return self;
}

@end
