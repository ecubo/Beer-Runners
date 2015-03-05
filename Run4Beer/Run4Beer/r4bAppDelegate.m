//
//  r4bAppDelegate.m
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 08/09/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import "r4bAppDelegate.h"
#import "MBProgressHUD.h"


@implementation r4bAppDelegate
@synthesize window = _window;
@synthesize loadingView;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    

    [self.window makeKeyAndVisible];
    
    
    //Miro si existen los ficheros all.json y motivacionales en la carpeta de documentos del usuario para cargarlos. Sólo la primera vez.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    //Creo la carpeta Motivacionales
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *motivDir = [documentsDirectoryPath stringByAppendingPathComponent:@"Motivacionales"];
    if ([fileManager createDirectoryAtPath:motivDir withIntermediateDirectories:YES
                                attributes:nil error: NULL] == NO)
    {
        // Failed to create directory
    }

    //Las fotos defecto de motivacional
    for(int i = 1; i < 8; i++){
        NSString *txtPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Motivacionales/motivacional%d.jpg",i]];
        NSString *nombre = [NSString stringWithFormat:@"motivacional%d",i];
        if ([fileManager fileExistsAtPath:txtPath] == NO) {
            NSString *resourcePath = [[NSBundle mainBundle] pathForResource:nombre ofType:@"jpg"];
            [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
        }
    }

    //El Json
    NSString *txtPathJson = [documentsDirectory stringByAppendingPathComponent:@"all.json"];
    
    if ([fileManager fileExistsAtPath:txtPathJson] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"all" ofType:@"json"];
        [fileManager copyItemAtPath:resourcePath toPath:txtPathJson error:&error];
    }
    
    //El Json de carreras
    NSString *txtPathJsonCarreras = [documentsDirectory stringByAppendingPathComponent:@"carreras.json"];
    
    if ([fileManager fileExistsAtPath:txtPathJsonCarreras] == NO) {
        NSString *resourcePathCarreras = [[NSBundle mainBundle] pathForResource:@"carreras" ofType:@"json"];
        [fileManager copyItemAtPath:resourcePathCarreras toPath:txtPathJsonCarreras error:&error];
    }
    
    //El Json de favoritos
    NSString *txtPathJsonFavoritos = [documentsDirectory stringByAppendingPathComponent:@"favoritos.json"];
    
    if ([fileManager fileExistsAtPath:txtPathJsonFavoritos] == NO) {
        NSString *resourcePathFavoritos = [[NSBundle mainBundle] pathForResource:@"favoritos" ofType:@"json"];
        [fileManager copyItemAtPath:resourcePathFavoritos toPath:txtPathJsonFavoritos error:&error];
    }

    
    return YES;
}

- (void) loadingViewFade
{
    loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
    loadingView.image = [UIImage imageNamed:@"Default.png"];
    [_window addSubview:loadingView];
    [_window bringSubviewToFront:loadingView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:3.0];
    [UIView setAnimationDelay:3.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_window cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    loadingView.alpha = 0.0;
    [UIView commitAnimations];
    
    //Create and add the Activity Indicator to loadingView
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = CGPointMake(160, 430);
    activityIndicator.hidesWhenStopped = NO;
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(140, 435, 160, 30)];
    text.backgroundColor = [UIColor clearColor];
    text.textColor       = [UIColor whiteColor];
    text.font = [UIFont systemFontOfSize:14];
    text.text = @"Loading...";
    [loadingView addSubview:text];
    [loadingView addSubview:activityIndicator];
    [loadingView addSubview:activityIndicator];
    [activityIndicator startAnimating];
}

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    
    [loadingView removeFromSuperview];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
