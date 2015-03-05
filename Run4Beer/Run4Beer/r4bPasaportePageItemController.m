//
//  r4bPasaportePageItemController.m
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 07/11/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import "r4bPasaportePageItemController.h"

@interface r4bPasaportePageItemController ()

@end

@implementation r4bPasaportePageItemController
@synthesize itemIndex;
@synthesize imageName;
@synthesize contentImageView;


- (void)viewDidLoad {
    [super viewDidLoad];
    contentImageView.image = [UIImage imageNamed: imageName];
    
    //Acciones del botón cerrar
    [self.button addTarget:self action:@selector(buttonPressed:)
          forControlEvents:UIControlEventTouchUpInside];
}


- (void) setImageName: (NSString *) name
{
    imageName = name;
    //contentImageView.image = [UIImage imageNamed: imageName];
    contentImageView.image = [UIImage imageWithContentsOfFile:imageName];
}

- (void)buttonPressed:(UIButton *)button {
    //NSLog(@"Button Pressed");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
