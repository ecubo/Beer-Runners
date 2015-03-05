//
//  r4bFirstViewController.m
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 08/09/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import "r4bFirstViewController.h"
#import "PagedImageScrollView.h"
#import "UIDeviceHardware.h"
#import "MBProgressHUD.h"

@interface r4bFirstViewController ()

    @property (nonatomic) NSURLSession *session;
    @property (nonatomic, copy) NSArray *motivacionales;
    @property (nonatomic, copy) NSArray *imgNoticias;
    @property (nonatomic) NSMutableArray *imagenesCarteles;

@end

@implementation r4bFirstViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.navigationItem.title = @"Bares Beer Runners";
    
    NSURLSessionConfiguration *config =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config
                                             delegate:nil
                                        delegateQueue:nil];
    [self fetchFeed];
    
    sleep(5);
    
    /* Recorro los items del directorio NSDocumentDirectory/Motivacionales */
    NSFileManager *filemgr;
    NSArray *filelist;
    NSString *documentsDirectoryPathForList = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSUInteger count;
    NSString *filePath;
    int i;
    self.imagenesCarteles=[[NSMutableArray alloc]init];
    
    filemgr =[NSFileManager defaultManager];
    filelist = [filemgr contentsOfDirectoryAtPath:[documentsDirectoryPathForList stringByAppendingPathComponent:@"Motivacionales"] error:NULL];
    count = [filelist count];
    
    /*
    iPhone 4: 480 x 320
    iPhone 5: 568 x 320
    iPad: 768 x 1024
     
     -49 del tabBar
    
    ----------------- 
     
    UIDeviceHardware *h=[[UIDeviceHardware alloc] init];
    NSString *platform = [h platformString];
     
    if ([platform isEqualToString:@"iPad"]) {
        pageScrollView = [[PagedImageScrollView alloc] initWithFrame:CGRectMake(0, 0, 768, 975)];
        NSLog(@"Estoy en iPad");
    }
    else if ([platform isEqualToString:@"iPhone 4"]){
        pageScrollView = [[PagedImageScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 431)];
        NSLog(@"Estoy en iPhone 4");
    }
    else{
        pageScrollView = [[PagedImageScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 519)];
    }
    */
    
    
    
    PagedImageScrollView *pageScrollView;
    float anchoVistaFoto = [[UIScreen mainScreen] bounds].size.width;
    float altoVistaFoto = [[UIScreen mainScreen] bounds].size.height - 49;

    pageScrollView = [[PagedImageScrollView alloc] initWithFrame:CGRectMake(0, 0, anchoVistaFoto, altoVistaFoto)];
    
    
    for (i = 0; i < count; i++){
        if ([filelist[i] isEqualToString:@".DS_Store"]) {
            continue;
        }
        if (![self.motivacionales containsObject:filelist[i]] && ![filelist[i] isEqualToString:@"motivacional1.jpg"] && ![filelist[i] isEqualToString:@"motivacional2.jpg"] && ![filelist[i] isEqualToString:@"motivacional3.jpg"] && ![filelist[i] isEqualToString:@"motivacional4.jpg"] && ![filelist[i] isEqualToString:@"motivacional5.jpg"] && ![filelist[i] isEqualToString:@"motivacional6.jpg"] && ![filelist[i] isEqualToString:@"motivacional7.jpg"]) {
            continue;
        }
        
        filePath = [documentsDirectoryPathForList stringByAppendingPathComponent:[NSString stringWithFormat:@"Motivacionales/%@",filelist[i]]];
        [self.imagenesCarteles addObject:@[filePath]];
    
    }
    [pageScrollView setScrollViewContents:@[self.imagenesCarteles]];
    [self.view addSubview:pageScrollView];
    
}

- (void)fetchFeed
{

    NSString *requestString = @"http://run4beer.beerrunners.es/api/all";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithRequest:req
                    completionHandler:
     ^(NSData *data, NSURLResponse *response, NSError *error) {
         NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:0
                                                                    error:nil];
         self.motivacionales = jsonObject[@"all"][@"motivacionales"];
         self.imgNoticias = jsonObject[@"all"][@"noticias"];
         if (data.length > 0) {
             [self saveJsonWithData:data];
         }

         //Recorro cada uno de los elementos del JSON para guardar los carteles motivacionales
         for (int i=0; i<[self.motivacionales count]; i++) {
             NSDictionary *cartel = self.motivacionales[i];
             NSString *cartelURL = cartel[@"url"];

             //Descargo las imagenes de cada URL y las guardo
             NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
             NSString *imgName = [NSString stringWithFormat:@"Motivacionales/%@",cartelURL];
             NSString *imgURL = [NSString stringWithFormat:@"http://run4beer.beerrunners.es/api/motivacional/%@",cartelURL];
             NSFileManager *fileManager = [NSFileManager defaultManager];
             NSString *motivDir = [documentsDirectoryPath stringByAppendingPathComponent:@"Motivacionales"];
             if ([fileManager createDirectoryAtPath:motivDir withIntermediateDirectories:YES
                                     attributes:nil error: NULL] == NO)
             {
                 // Failed to create directory
             }
             
             NSString *writablePath = [documentsDirectoryPath stringByAppendingPathComponent:imgName];
             
             if(![fileManager fileExistsAtPath:writablePath]){
                 // file doesn't exist
                 //save Image From URL
                 NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString: imgURL]];
                 
                 NSError *error = nil;
                 [data writeToFile:[documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imgName]] options:NSAtomicWrite error:&error];
                 
                 if (error) {
                     //NSLog(@"Error Writing File : %@",error);
                 }else{
                     //NSLog(@"Image %@ Saved SuccessFully with id %@",imgName, cartelId);
                 }
             }
             else{
                 // file exist
                 //NSLog(@"file exist %@",writablePath);
             }
         }
         
         //Recorro cada uno de los elementos del JSON para guardar las fotos de las noticias
         for (int i=0; i<[self.imgNoticias count]; i++) {
             NSDictionary *cartel = self.imgNoticias[i];
             NSString *cartelURL = cartel[@"url"];
             
             //Descargo las imagenes de cada URL y las guardo
             NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
             NSString *imgName = [NSString stringWithFormat:@"Noticias/%@",cartelURL];
             NSString *imgURL = [NSString stringWithFormat:@"http://run4beer.beerrunners.es/api/agenda/%@",cartelURL];
             NSFileManager *fileManager = [NSFileManager defaultManager];
             NSString *motivDir = [documentsDirectoryPath stringByAppendingPathComponent:@"Noticias"];
             if ([fileManager createDirectoryAtPath:motivDir withIntermediateDirectories:YES
                                         attributes:nil error: NULL] == NO)
             {
                 // Failed to create directory
             }
             
             NSString *writablePath = [documentsDirectoryPath stringByAppendingPathComponent:imgName];
             
             if(![fileManager fileExistsAtPath:writablePath]){
                 // file doesn't exist
                 //save Image From URL
                 NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString: imgURL]];
                 NSError *error = nil;
                 [data writeToFile:[documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imgName]] options:NSAtomicWrite error:&error];
                 
                 if (error) {
                     //NSLog(@"News: Error Writing File : %@",error);
                 }else{
                     //NSLog(@"News: Image %@ Saved SuccessFully with id %@",imgName, cartelId);
                 }
             }
             else{
                 // file exist
                 //NSLog(@"News: file exist %@",writablePath);
             }
         }
         //Sigo...
     }];
    [dataTask resume];
}

-(void)saveJsonWithData:(NSData *)data{
    
    NSString *jsonPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/all.json"];
    [data writeToFile:jsonPath atomically:YES];
}

-(NSData *)getSavedJsonData{
    NSString *jsonPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/all.json"];
    
    return [NSData dataWithContentsOfFile:jsonPath];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index =%ld",(long)buttonIndex);
    if (buttonIndex == 0)
    {
        NSLog(@"You have clicked Cancel");
    }
    else if(buttonIndex == 1)
    {
        NSLog(@"You have clicked GOO");
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
