//
//  UIViewController+r4bAgendaItemViewController.h
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 19/09/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface r4bAgendaItemViewController : UIViewController <UITextViewDelegate> {
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UITextView *textView;
    
}

    @property(nonatomic) NSString *myValue;
    @property(nonatomic,strong)IBOutlet UITextView *textView;
    @property(nonatomic,strong)IBOutlet UITextView *textView2;
    @property(nonatomic,strong)IBOutlet UIScrollView *scrollView;

@end

