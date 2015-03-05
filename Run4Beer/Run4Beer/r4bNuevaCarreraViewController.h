//
//  UIViewController+r4bNuevaCarreraViewController.h
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 09/10/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface r4bNuevaCarreraViewController: UIViewController <UITextFieldDelegate> {
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UITextView *textView;
    
}

@property(nonatomic) NSString *myValue;
@property(nonatomic,strong)IBOutlet UITextView *textView;
@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;
@property(nonatomic, weak) IBOutlet UIButton *button;
//@property(nonatomic,strong)IBOutlet UILabel *label;
//@property (weak, nonatomic) IBOutlet UITextField *textField;
//@property (weak, nonatomic) IBOutlet UITextField *textFieldFecha;
@property(nonatomic, weak) IBOutlet UIButton *buttonSave;

@property(nonatomic,retain) UIDatePicker *datePicker;
@property(nonatomic,retain) IBOutlet UILabel *datelabel;


@end

