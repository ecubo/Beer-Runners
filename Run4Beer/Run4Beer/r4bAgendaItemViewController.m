//
//  UIViewController+r4bAgendaItemViewController.m
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 19/09/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import "r4bAgendaItemViewController.h"

@interface r4bAgendaItemViewController ()

@end

@implementation r4bAgendaItemViewController
@synthesize textView,textView2,scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    float ancho = [[UIScreen mainScreen] bounds].size.width - 40;
    
    //Muestro la el ScrollView
    [scrollView setScrollEnabled:true];
    //[scrollView setContentSize:CGSizeMake(ancho, 1000)];
    self.scrollView.backgroundColor = [UIColor darkGrayColor];
    
    //Muestro la noticia
    NSData *elJsonGuardado;
    elJsonGuardado = [self getSavedJsonData];
    
    NSDictionary *jsonEnDisco=[NSJSONSerialization
                               JSONObjectWithData:elJsonGuardado
                               options:NSJSONReadingMutableLeaves
                               error:nil];
   
    //NSInteger myValueInt = [self.myValue intValue];

    NSString *fechaNoticia;
    NSString *nombreNoticia;
    NSString *miniDescNoticia;
    NSString *urlNoticia;
    NSString *descNoticia;
    
    for (id key in jsonEnDisco[@"all"][@"noticias"]) {
        //NSLog(@"There are %@ %@'s in stock", jsonEnDisco[@"all"][@"bares"][key], key);
        if ([key[@"id"] isEqualToString:self.myValue]) {
            fechaNoticia = key[@"fecha"];
            nombreNoticia = key[@"titulo"];
            miniDescNoticia = key[@"minidesc"];
            urlNoticia = key[@"url"];
            descNoticia = key[@"descripcion"];
            
            //Convierto la fecha al formato adecuado
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd"];
            NSDate *dateDate;
            dateDate = [df dateFromString: fechaNoticia];
            
            NSDateFormatter *formatter;
            //NSString *dateString;
            formatter = [[NSDateFormatter alloc] init];
            [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"es"]];
            [formatter setDateFormat:@"dd MMMM yyyy"];
            //dateString = [formatter stringFromDate:[NSDate date]];
            fechaNoticia = [formatter stringFromDate:dateDate];
            
        }
    }

    //textView.text = [NSString stringWithFormat:@"%@\n%@\n%@\n\n",fechaNoticia, nombreNoticia, miniDescNoticia];
    //NSString *textViewText = textView.text;
    NSString *textViewText = [NSString stringWithFormat:@"%@\n%@\n%@\n\n",fechaNoticia, nombreNoticia, miniDescNoticia];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:textViewText];
    //Fecha
    [attributedText addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"Bebas Neue" size:21]
                           range:[textViewText rangeOfString:fechaNoticia]];
    [attributedText addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithRed:255/255.0 green:205/255.0 blue:0/255.0 alpha:1]
                           range:[textViewText rangeOfString:fechaNoticia]];
    //Titulo
    [attributedText addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"Bebas Neue" size:29]
                           range:[textViewText rangeOfString:nombreNoticia]];
    [attributedText addAttribute:NSForegroundColorAttributeName
                           value:[UIColor whiteColor]
                           range:[textViewText rangeOfString:nombreNoticia]];
    //Mini descripción
    /*
    [attributedText addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"Helvetica-Bold" size:9]
                           range:[textViewText rangeOfString:miniDescNoticia]];
    [attributedText addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1]
                           range:[textViewText rangeOfString:miniDescNoticia]];
    */
    
    /* calculo alto */
    //Fecha
    UIFont *fontFecha = [UIFont fontWithName:@"Bebas Neue" size:21];
    CGSize constraintFecha = CGSizeMake(ancho - (20 * 2), 20000.0f);
    NSDictionary *attributesFecha = @{NSFontAttributeName: fontFecha};
    CGRect rectFecha = [fechaNoticia boundingRectWithSize:constraintFecha
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:attributesFecha
                                                 context:nil];
    //Nombre
    UIFont *fontNombre = [UIFont fontWithName:@"Bebas Neue" size:29];
    CGSize constraintNombre = CGSizeMake(ancho - (20 * 2), 20000.0f);
    NSDictionary *attributesNombre = @{NSFontAttributeName: fontNombre};
    CGRect rectNombre = [nombreNoticia boundingRectWithSize:constraintNombre
                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                attributes:attributesNombre
                                                   context:nil];
    //Mini descripción
    /*
    UIFont *fontDesc = [UIFont fontWithName:@"Helvetica" size:12];
    CGSize constraintDesc = CGSizeMake(ancho - (20 * 2), 20000.0f);
    NSDictionary *attributesDesc = @{NSFontAttributeName: fontDesc};
    CGRect rectDesc = [miniDescNoticia boundingRectWithSize:constraintDesc
                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                            attributes:attributesDesc
                                               context:nil];
    */
    
    
    
    //float altoTextView = rectFecha.size.height + rectNombre.size.height + rectDesc.size.height + 10;
    float altoTextView = rectFecha.size.height + rectNombre.size.height + 10;
    
    //NSLog(@"altoTextView: %f",altoTextView);
    /* FIN calculo alto */
    
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 10, ancho, altoTextView)];
    
    textView.scrollEnabled = FALSE;
    textView.pagingEnabled = NO;
    textView.editable = NO;
    textView.backgroundColor = [UIColor darkGrayColor];
    
    textView.text = textViewText;
    
    textView.attributedText = attributedText;
    //Muestro la vista
    [scrollView addSubview:textView];
    
    
    /*Pongo la imagen*/
    UIImage *imagen;
    UIImageView *imageView;
    NSString *hayFotoNoticia;
    float altoImagen;
    if (![urlNoticia isEqualToString:@""]) {
        NSString *documentsDirectoryPathForList = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath;
        filePath = [documentsDirectoryPathForList stringByAppendingPathComponent:[NSString stringWithFormat:@"Noticias/%@",urlNoticia]];
        

        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imagen = [UIImage imageWithContentsOfFile:filePath];
        
        float imgFactor = imagen.size.height / imagen.size.width;
        float ancho = [[UIScreen mainScreen] bounds].size.width - 40;
        altoImagen = ancho * imgFactor;
        
        //NSLog(@"imagen.size.height: %f", imagen.size.height);
        //NSLog(@"imgFactor: %f", imgFactor);
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (altoTextView + 10), ancho, altoImagen)];
        [imageView setImage:imagen];
        [scrollView addSubview:imageView];

        hayFotoNoticia = @"SI";
    }
    /*FIN pongo la imagen*/
       
    textView2 = [[UITextView alloc] initWithFrame:CGRectMake(20, (altoTextView + imageView.frame.size.height), ancho, 700)];
    textView2.scrollEnabled = TRUE;
    textView2.pagingEnabled = NO;
    textView2.editable = NO;
    textView2.backgroundColor = [UIColor darkGrayColor];
    
    //textView2.text = [NSString stringWithFormat:@"\n%@", descNoticia];
    //NSString *textViewText2 = textView2.text;
    
    NSMutableAttributedString *attributedText2 = [[NSMutableAttributedString alloc] initWithString:descNoticia];
    
    [attributedText2 addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"Helvetica" size:13]
                           range:[descNoticia rangeOfString:descNoticia]];
    [attributedText2 addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1]
                           range:[descNoticia rangeOfString:descNoticia]];
    
    
    //Calculo tamaño
    UIFont *fontDescDesc = [UIFont fontWithName:@"Helvetica" size:13];
    CGSize constraintDescDesc = CGSizeMake(ancho - (20 * 2), 20000.0f);
    NSDictionary *attributesDescDesc = @{NSFontAttributeName: fontDescDesc};
    CGRect rectDescDesc = [descNoticia boundingRectWithSize:constraintDescDesc
                                                    options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                 attributes:attributesDescDesc
                                                    context:nil];
    
    float altoTextView2 = rectDescDesc.size.height + 10;
    
    descNoticia = [NSString stringWithFormat:@"<span style=\"font-family: Helvetica; font-size:8pt;color:#E3E3E3\">%@</span>",descNoticia];
    
    NSAttributedString *descNoticiaHTML =[[NSAttributedString alloc] initWithData:[descNoticia dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];


    textView2.attributedText = descNoticiaHTML;
    [scrollView addSubview:textView2];

    //Le cambio el alto al scrollView para que se adapte al tamaño de la noticia
    //[scrollView setContentSize:CGSizeMake(ancho, (altoTextView + imageView.frame.size.height + (rectDescDesc.size.height + 50)))];

    [scrollView setContentSize:CGSizeMake(ancho, (altoTextView + altoImagen + altoTextView2 + 50 ))];

}


-(NSData *)getSavedJsonData{
    NSString *jsonPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/all.json"];
    
    return [NSData dataWithContentsOfFile:jsonPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
