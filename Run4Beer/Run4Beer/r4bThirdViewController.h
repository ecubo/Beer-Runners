//
//  r4bThirdViewController.h
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 08/09/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const char carreraSeleccionadaAlert;

@interface r4bThirdViewController : UIViewController <UITextViewDelegate> {
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UITextView *textView;
    
}


@property(nonatomic,strong)IBOutlet UITextView *textView;
@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;
//@property (nonatomic, weak) IBOutlet UIButton *button;

@end
