//
//  r4bGeneralRun4Beer.h
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 11/11/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface r4bGeneralRun4Beer : UIViewController <UITextViewDelegate> {
    
    
    IBOutlet UITextView *textViewTop;
    IBOutlet UITextView *textViewKm;
}



//@property (nonatomic, strong) IBOutlet UIButton *buttonNuevaCarrera;
//@property (nonatomic, strong) IBOutlet UIButton *buttonVerCarreras;

@property(nonatomic,strong)IBOutlet UITextView *textViewTop;
@property(nonatomic,strong)IBOutlet UITextView *textViewKm;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashTopButton;

@end
