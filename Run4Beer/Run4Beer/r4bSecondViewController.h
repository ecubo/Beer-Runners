//
//  r4bSecondViewController.h
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 08/09/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "r4bAgendaItemViewController.h"

@interface r4bSecondViewController : UIViewController <UITextViewDelegate,UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UITextView *textView;


}


    @property(nonatomic,strong)IBOutlet UITextView *textView;
    @property(nonatomic,strong)IBOutlet UIScrollView *scrollView;
    @property (weak, nonatomic) IBOutlet UIBarButtonItem *searchTopButton;
    @property (nonatomic,strong) NSMutableArray *tags;
@property (nonatomic,strong) UIPickerView *myPickerView;

@end
