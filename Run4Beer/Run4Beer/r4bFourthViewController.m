//
//  r4bFourthViewController.m
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 08/09/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import "r4bFourthViewController.h"
#import "r4bPasaportePageItemController.h"

@interface r4bFourthViewController () <UIPageViewControllerDataSource>

    @property (nonatomic, strong) NSMutableArray *contentImages;
    @property (nonatomic, strong) UIPageViewController *pageViewController;
    @property (nonatomic) NSMutableArray *imagenesCarteles;

@end

@implementation r4bFourthViewController
@synthesize contentImages;

- (void) viewDidLoad
{    
    [super viewDidLoad];
    [self createPageViewController];
    [self setupPageControl];
}

- (void) createPageViewController
{
    
    contentImages = [[NSMutableArray alloc] init];
    
    /* Recorro los items del directorio NSDocumentDirectory/Motivacionales */
    NSFileManager *filemgr;
    NSArray *filelist;
    NSString *documentsDirectoryPathForList = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSUInteger count;
    NSString *filePath;
    int i;
    self.imagenesCarteles=[[NSMutableArray alloc]init];
    
    filemgr =[NSFileManager defaultManager];
    filelist = [filemgr contentsOfDirectoryAtPath:[documentsDirectoryPathForList stringByAppendingPathComponent:@"Pasaporte"] error:NULL];
    count = [filelist count];
    
    
    for (i = 0; i < count; i++){
        if ([filelist[i] isEqualToString:@".DS_Store"]) {
            continue;
        }
        filePath = [documentsDirectoryPathForList stringByAppendingPathComponent:[NSString stringWithFormat:@"Pasaporte/%@",filelist[i]]];
        NSLog(@"IMAGEN: %@",filePath);
        [contentImages addObject:filePath];
    }
    /* FIN Recorro los items del directorio NSDocumentDirectory/Motivacionales */
    
    //contentImages = @[@"motivacional1.png", @"motivacional2.png"];
    
    NSLog(@"ARRAY: %@",contentImages);

    UIPageViewController *pageController = [self.storyboard instantiateViewControllerWithIdentifier: @"PasaportePageController"];
    pageController.dataSource = self;
    
    if([contentImages count])
    {
        NSArray *startingViewControllers = @[[self itemControllerForIndex: 0]];
        [pageController setViewControllers: startingViewControllers
                                 direction: UIPageViewControllerNavigationDirectionForward
                                  animated: NO
                                completion: nil];
    }
    
    self.pageViewController = pageController;
    [self addChildViewController: self.pageViewController];
    [self.view addSubview: self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController: self];
}

- (void) setupPageControl
{
    [[UIPageControl appearance] setPageIndicatorTintColor: [UIColor grayColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor: [UIColor whiteColor]];
    [[UIPageControl appearance] setBackgroundColor: [UIColor darkGrayColor]];
}


- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerBeforeViewController:(UIViewController *) viewController
{
    r4bPasaportePageItemController *itemController = (r4bPasaportePageItemController *) viewController;
    
    if (itemController.itemIndex > 0)
    {
        return [self itemControllerForIndex: itemController.itemIndex-1];
    }
    
    return nil;
}

- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerAfterViewController:(UIViewController *) viewController
{
    r4bPasaportePageItemController *itemController = (r4bPasaportePageItemController *) viewController;
    
    if (itemController.itemIndex+1 < [contentImages count])
    {
        return [self itemControllerForIndex: itemController.itemIndex+1];
    }
    
    return nil;
}

- (r4bPasaportePageItemController *) itemControllerForIndex: (NSUInteger) itemIndex
{
    //NSLog(@"itemIndex: %lu", (unsigned long)itemIndex);
    if (itemIndex < [contentImages count])
    {
        r4bPasaportePageItemController *pageItemController = [self.storyboard instantiateViewControllerWithIdentifier: @"PasaporteItemController"];
        pageItemController.itemIndex = itemIndex;
        pageItemController.imageName = contentImages[itemIndex];
        return pageItemController;
    }
    
    return nil;
}

- (NSInteger) presentationCountForPageViewController: (UIPageViewController *) pageViewController
{
    return [contentImages count];
}

- (NSInteger) presentationIndexForPageViewController: (UIPageViewController *) pageViewController
{
    return 0;
}



/* MEMORY WARNING */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
