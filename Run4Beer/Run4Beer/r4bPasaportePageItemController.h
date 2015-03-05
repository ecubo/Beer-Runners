//
//  r4bPasaportePageItemController.h
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 07/11/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface r4bPasaportePageItemController : UIViewController

    // Item controller information
    @property (nonatomic) NSUInteger itemIndex;
    @property (nonatomic, strong) NSString *imageName;

    // IBOutlets
    @property (nonatomic, weak) IBOutlet UIImageView *contentImageView;
    @property (nonatomic, weak) IBOutlet UIButton *button;

@end
