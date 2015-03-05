//
//  PagedImageScrollView.m
//  Test
//
//  Created by jianpx on 7/11/13.
//  Copyright (c) 2013 PS. All rights reserved.
//

#import "PagedImageScrollView.h"

@interface PagedImageScrollView() <UIScrollViewDelegate>
@property (nonatomic) BOOL pageControlIsChangingPage;
@property (nonatomic) NSMutableArray *imagenesCarteles;
@property (nonatomic) UIButton *aButton;
@property (nonatomic) UIButton *aButtonFavorito;
@property (nonatomic) NSMutableArray *imagenesFavoritas;
@end

@implementation PagedImageScrollView


#define PAGECONTROL_DOT_WIDTH 20
#define PAGECONTROL_HEIGHT 20

- (id)initWithFrame:(CGRect)frame
{
    //Cojo el JSON de favoritos
    NSData *elJsonGuardado;
    self.imagenesFavoritas=[[NSMutableArray alloc]init];
    elJsonGuardado = [self getSavedJsonData];
    
    NSDictionary *jsonEnDisco=[NSJSONSerialization
                               JSONObjectWithData:elJsonGuardado
                               options:NSJSONReadingMutableLeaves
                               error:nil];
    
    for (NSDictionary *dictionaryFavs in jsonEnDisco[@"all"][@"favoritos"])
    {
        NSString *idImagen;
        idImagen = dictionaryFavs[@"id"];
        [self.imagenesFavoritas addObject:idImagen];
    }

    //Sigo
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.pageControl = [[UIPageControl alloc] init];
        [self setDefaults];
        [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        self.scrollView.delegate = self;
    
    }
    return self;
}


- (void)setPageControlPos:(enum PageControlPosition)pageControlPos
{
    CGFloat width = PAGECONTROL_DOT_WIDTH * self.pageControl.numberOfPages;
    _pageControlPos = pageControlPos;
    if (pageControlPos == PageControlPositionRightCorner)
    {
        self.pageControl.frame = CGRectMake(self.scrollView.frame.size.width - width, self.scrollView.frame.size.height - PAGECONTROL_HEIGHT, width, PAGECONTROL_HEIGHT);
    }else if (pageControlPos == PageControlPositionCenterBottom)
    {
        self.pageControl.frame = CGRectMake((self.scrollView.frame.size.width - width) / 2, self.scrollView.frame.size.height - PAGECONTROL_HEIGHT, width, PAGECONTROL_HEIGHT);
    }else if (pageControlPos == PageControlPositionLeftCorner)
    {
        self.pageControl.frame = CGRectMake(0, self.scrollView.frame.size.height - PAGECONTROL_HEIGHT, width, PAGECONTROL_HEIGHT);
    }
}

- (void)setDefaults
{
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.hidesForSinglePage = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.pageControlPos = PageControlPositionCenterBottom;
}

- (void)setScrollViewContents: (NSArray *)images
{
    images = images[0];
   
    //remove original subviews first.
    for (UIView *subview in [self.scrollView subviews]) {
        [subview removeFromSuperview];
    }
    if (images.count <= 0) {
        self.pageControl.numberOfPages = 0;
        return;
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * images.count, self.scrollView.frame.size.height);
    for (int i = 0; i < images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width * i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setImage:[UIImage imageWithContentsOfFile:images[i][0]]];

        [self.scrollView addSubview:imageView];
    }
    
    /* Pongo botones de acción a las fotos*/
    int xCoord=[[UIScreen mainScreen] bounds].size.width - 40;
    int yCoord=[[UIScreen mainScreen] bounds].size.height - 49 - 50;
    int buttonWidth=30;
    int buttonHeight=30;
    
    self.aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    self.aButton.frame = CGRectMake(xCoord, yCoord,buttonWidth,buttonHeight );
    UIImage *buttonImageNormal = [UIImage imageNamed:@"saveMotiv"];
    UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [self.aButton setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
    [self.aButton addTarget:self action:@selector(botonGuardarImagenPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.pageControl.superview addSubview:self.aButton];
    
    int xCoordFavorito=[[UIScreen mainScreen] bounds].size.width - 80;
    int yCoordFavorito=[[UIScreen mainScreen] bounds].size.height - 49 - 50;
    int buttonWidthFavorito=30;
    int buttonHeightFavorito=30;
    
    
    self.aButtonFavorito = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.aButtonFavorito.frame = CGRectMake(xCoordFavorito, yCoordFavorito,buttonWidthFavorito,buttonHeightFavorito );
    UIImage *buttonImageNormalFavorito;
    if ([self.imagenesFavoritas containsObject:@"0"]) {
        buttonImageNormalFavorito = [UIImage imageNamed:@"favMotivFull"];
    } else {
        buttonImageNormalFavorito = [UIImage imageNamed:@"favMotiv"];
    }
    UIImage *strechableButtonImageNormalFavorito = [buttonImageNormalFavorito stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [self.aButtonFavorito setBackgroundImage:strechableButtonImageNormalFavorito forState:UIControlStateNormal];
    [self.aButtonFavorito addTarget:self action:@selector(botonFavoritoImagenPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.pageControl.superview addSubview:self.aButtonFavorito];
    /* FIN Pongo botones de acción a las fotos*/

    self.pageControl.numberOfPages = images.count;
    self.pageControlPos = self.pageControlPos;
}

- (void)botonFavoritoImagenPressed:(UIButton *)button {
    //Miro si la foto era favorita o no
    if ([self.imagenesFavoritas containsObject:[NSString stringWithFormat:@"%ld",(long)self.pageControl.currentPage]]) {
        //Es favorita: la quito de favorita
        [self.imagenesFavoritas removeObject:[NSString stringWithFormat:@"%ld",(long)self.pageControl.currentPage]];
        UIImage *buttonImageNormalFavorito = [UIImage imageNamed:@"favMotiv"];
        UIImage *strechableButtonImageNormalFavorito = [buttonImageNormalFavorito stretchableImageWithLeftCapWidth:12 topCapHeight:0];
        [self.aButtonFavorito setBackgroundImage:strechableButtonImageNormalFavorito forState:UIControlStateNormal];
    } else {
        //No es favortita: la pongo como favorita
        [self.imagenesFavoritas addObject:[NSString stringWithFormat:@"%ld",(long)self.pageControl.currentPage]];
        UIImage *buttonImageNormalFavorito = [UIImage imageNamed:@"favMotivFull"];
        UIImage *strechableButtonImageNormalFavorito = [buttonImageNormalFavorito stretchableImageWithLeftCapWidth:12 topCapHeight:0];
        [self.aButtonFavorito setBackgroundImage:strechableButtonImageNormalFavorito forState:UIControlStateNormal];
    }
    
    
    NSMutableArray *favoritosArray = [[NSMutableArray alloc] init];
    
    for (NSArray *dictionary in self.imagenesFavoritas){
        NSMutableDictionary *nuevoFav = [NSMutableDictionary dictionary];
        [nuevoFav setObject: [NSString stringWithFormat:@"%@",dictionary] forKey: @"id"];
        [favoritosArray addObject:nuevoFav];
    }
    
    //NSLog(@"favoritosArray %@", favoritosArray);
    
    //Guardo
    NSDictionary *addImagenToImagenes = @{@"favoritos" : favoritosArray};
    NSDictionary *imagenesASalvar = @{@"all" : addImagenToImagenes};
    
    NSError *error = nil;
    NSData *json;
    
    if ([NSJSONSerialization isValidJSONObject:imagenesASalvar])
    {
        json = [NSJSONSerialization dataWithJSONObject:imagenesASalvar options:NSJSONWritingPrettyPrinted error:&error];
        if (json != nil && error == nil)
        {
            [self saveJsonWithData:json];
        }
    }
}

- (void)botonGuardarImagenPressed:(UIButton *)button {
    NSString *titulo = @"Guardar imagen";
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:titulo
                                                     message:@"¿Deseas guardar la imagen en el carrete del teléfono?"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancelar"
                                           otherButtonTitles: nil];
    [alert addButtonWithTitle:@"Guardar"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //NSLog(@"You have clicked Cancel");
    }
    else if(buttonIndex == 1)
    {
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
        
        for (i = 0; i < count; i++){
            if ([filelist[i] isEqualToString:@".DS_Store"]) {
                continue;
            }
            filePath = [documentsDirectoryPathForList stringByAppendingPathComponent:[NSString stringWithFormat:@"Motivacionales/%@",filelist[i]]];
            if (i == self.pageControl.currentPage) {
                UIImage *imageToSave = [UIImage imageWithContentsOfFile:filePath];
                UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil);
            }
        }
    }
}



- (void)changePage:(UIPageControl *)sender
{
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    self.pageControlIsChangingPage = YES;
}

#pragma scrollviewdelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.pageControlIsChangingPage) {
        return;
    }
    CGFloat pageWidth = scrollView.frame.size.width;
    //switch page at 50% across
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    /* Pongo botones de acción a las fotos*/
    if ([self.imagenesFavoritas containsObject:[NSString stringWithFormat:@"%ld",(long)self.pageControl.currentPage]]) {
        UIImage *buttonImageNormalFavorito = [UIImage imageNamed:@"favMotivFull"];
        UIImage *strechableButtonImageNormalFavorito = [buttonImageNormalFavorito stretchableImageWithLeftCapWidth:12 topCapHeight:0];
        [self.aButtonFavorito setBackgroundImage:strechableButtonImageNormalFavorito forState:UIControlStateNormal];
    } else {
        UIImage *buttonImageNormalFavorito = [UIImage imageNamed:@"favMotiv"];
        UIImage *strechableButtonImageNormalFavorito = [buttonImageNormalFavorito stretchableImageWithLeftCapWidth:12 topCapHeight:0];
        [self.aButtonFavorito setBackgroundImage:strechableButtonImageNormalFavorito forState:UIControlStateNormal];
    }
    /* FIN Pongo botones de acción a las fotos*/
}

-(void)saveJsonWithData:(NSData *)data{
    NSString *jsonPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/favoritos.json"];
    [data writeToFile:jsonPath atomically:YES];
}

-(NSData *)getSavedJsonData{
    NSString *jsonPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/favoritos.json"];
    return [NSData dataWithContentsOfFile:jsonPath];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControlIsChangingPage = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.pageControlIsChangingPage = NO;
}

@end