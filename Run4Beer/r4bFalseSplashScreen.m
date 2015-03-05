//
//  r4bFalseSplashScreen.m
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 01/12/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import "r4bFalseSplashScreen.h"
#import "MBProgressHUD.h"
#import "UIDeviceHardware.h"

@interface r4bFalseSplashScreen ()

 @property (nonatomic) NSMutableArray *imagenesCarteles;

@end

@implementation r4bFalseSplashScreen


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float ancho = [[UIScreen mainScreen] bounds].size.width;
    float alto = [[UIScreen mainScreen] bounds].size.height;

    UIDeviceHardware *h=[[UIDeviceHardware alloc] init];
    NSString *platform = [h platformString];
    
    if (alto < 500) {
        platform = @"iPhone 4";
    }
    
    
    NSString *nombreImagen = @"";
    
    if ([platform isEqualToString:@"iPad"]) {
        nombreImagen = @"false_splash_iPad";
    }
    else if ([platform isEqualToString:@"iPhone 4"]){
        nombreImagen = @"false_splash_iPhone4";
    }
    else{
        nombreImagen = @"false_splash";
    }
    UIImage *imagen = [UIImage imageNamed:nombreImagen];
    
    UIImageView *imageView;
    
    float imgFactor = imagen.size.height / imagen.size.width;
    float altoImagen = ancho * imgFactor;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ancho, altoImagen)];
    [imageView setImage:imagen];
    [self.view addSubview:imageView];
    
    
    NSString *titulo = @"Confirmar Edad";
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:titulo
                                                     message:@"Esta aplicación sólo puede ser usada por mayores de edad.\n\n¿Eres mayor de edad?"
                                                    delegate:self
                                           cancelButtonTitle:@"No"
                                           otherButtonTitles: nil];
    [alert addButtonWithTitle:@"Sí"];
    [alert show];
 
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 0)
    {
        exit(0);
    }
    else if(buttonIndex == 1)
    {
        NSString *storyBoard = @"";

        /*
        //---------Usar esto para diferenciar entre abrir el storyboard de iphone o el de iPad cuando lo hagamos para las dos plataformas-----
        float ancho = [[UIScreen mainScreen] bounds].size.width;
        if (ancho > 400) {
            platform = @"iPad";
        }
         */
        /*
        if ([platform isEqualToString:@"iPad"]) {
            storyBoard = @"Main_iPad";
        }
        else{
            storyBoard = @"Main_iPhone";
        }
        */
        
        storyBoard = @"Main_iPhone";
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString * storyboardName = storyBoard;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"inicioDeApp"];
        [self presentViewController:vc animated:YES completion:nil];
        
        
    }
}

@end