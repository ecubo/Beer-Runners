//
//  r4bThirdViewController.m
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 08/09/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import "r4bThirdViewController.h"
#import "r4bNuevaCarreraViewController.h"
#import "r4bEditCarreraViewController.h"
#import "objc/runtime.h"

@interface r4bThirdViewController ()

    @property (nonatomic) UIAlertView *alert;

@end

@implementation r4bThirdViewController

const char carreraSeleccionadaAlert;

@synthesize textView,scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Limpio el ScrollView antes de empezar a mostrarlo.
    NSArray *subviews = [scrollView subviews];
    for(int i = 0; i < subviews.count; i++)
    {
        UIImageView *imageView = (UIImageView *)[subviews objectAtIndex:i];
        
        [imageView removeFromSuperview];
    }
    //FIN Limpio el ScrollView antes de empezar a mostrarlo.
    
    
    float ancho = [[UIScreen mainScreen] bounds].size.width - 40;
    
    //Botón
    UIButton *buttonNuevaCarrera = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    buttonNuevaCarrera.frame = CGRectMake(20, 73, ancho, 30);
    
    [buttonNuevaCarrera setTitle:@"AÑADIR NUEVA CARRERA" forState:UIControlStateNormal];
    [buttonNuevaCarrera.titleLabel setFont:[UIFont fontWithName:@"Bebas Neue" size:25]];
    [buttonNuevaCarrera setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonNuevaCarrera setBackgroundColor:[UIColor darkGrayColor]];

    [buttonNuevaCarrera addTarget:self action:@selector(buttonPressed:)
                 forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:buttonNuevaCarrera];

    //Cojo los datos de carreras del Json
    NSData *elJsonGuardado;
    elJsonGuardado = [self getSavedJsonData];
    
    NSDictionary *jsonEnDisco=[NSJSONSerialization
                               JSONObjectWithData:elJsonGuardado
                               options:NSJSONReadingMutableLeaves
                               error:nil];
    
    [scrollView setScrollEnabled:true];
    
    CGFloat altoDelScrollView;
    altoDelScrollView = (70 + 120 * [jsonEnDisco[@"all"][@"carreras"] count]);
    [scrollView setContentSize:CGSizeMake(ancho, altoDelScrollView)];
    

    NSInteger cuenta = 1;
    CGFloat vertical = 0;
    CGFloat altoTotal = 50;
    
    
    /* ORDENO POR FECHA */
    NSMutableArray *ordenarCarrerasArray;
    ordenarCarrerasArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionarySort in jsonEnDisco[@"all"][@"carreras"])
    {
        NSString *idCarreraSort;
        NSString *fechaCarreraSort;
        
        idCarreraSort = dictionarySort[@"id"];
        fechaCarreraSort = dictionarySort[@"fx"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setLocale:[NSLocale localeWithLocaleIdentifier:@"es"]];
        [df setDateFormat:@"dd MMMM yyyy"];
        NSDate *dateDateSort;
        dateDateSort = [df dateFromString: fechaCarreraSort];
        
        NSDictionary *dateFormateada = @{
                               @"fx": dictionarySort[@"fx"],
                               @"id": dictionarySort[@"id"],
                               @"km": dictionarySort[@"km"],
                               @"tag": dictionarySort[@"tag"],
                               @"fechaSort": dateDateSort,
                               @"txt": dictionarySort[@"txt"]};
        
        [ordenarCarrerasArray addObject:dateFormateada];
    }

    
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                         sortDescriptorWithKey:@"fechaSort"
                                         ascending:NO
                                         selector:@selector(compare:)];
    
    NSArray *descriptors = @[dateDescriptor];
    [ordenarCarrerasArray sortUsingDescriptors:descriptors];
    /* FIN ORDENO POR FECHA */

    //for (NSDictionary *dictionary in jsonEnDisco[@"all"][@"carreras"])
    for (NSDictionary *dictionary in ordenarCarrerasArray)
    {

        NSString *idCarrera;
        NSString *fechaCarrera;
        NSString *kmCarrera;
        NSString *txtCarrera;
        NSString *tagCarrera;
        
        idCarrera = dictionary[@"id"];
        
        fechaCarrera = dictionary[@"fx"];
        if ([fechaCarrera  isEqual: @""]) {
            fechaCarrera = @"FECHA";
        }
        //kmCarrera = dictionary[@"km"];
        kmCarrera = [NSString stringWithFormat:@"%@",dictionary[@"km"]];
        if ([kmCarrera  isEqual: @""]) {
            kmCarrera = @"0";
        }
        txtCarrera = dictionary[@"txt"];
        if ([txtCarrera  isEqual: @""]) {
            txtCarrera = @"DESCRIPCION";
        }
        tagCarrera = dictionary[@"tag"];
        if ([tagCarrera  isEqual: @""]) {
            tagCarrera = @"all";
        }
        
        NSString *kilometrosString = @" KM";
        
        NSString *textViewText = [NSString stringWithFormat:@"\n%@%@\n%@",kmCarrera,kilometrosString,txtCarrera];
        
        NSMutableAttributedString *attributedTextFecha = [[NSMutableAttributedString alloc] initWithString:fechaCarrera];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:textViewText];
        
        if (cuenta & 1) {
            //Fecha
            [attributedTextFecha addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"Bebas Neue" size:20]
                                   range:[fechaCarrera rangeOfString:fechaCarrera]];
            [attributedTextFecha addAttribute:NSForegroundColorAttributeName
                                   value:[UIColor colorWithRed:221/255.0 green:154/255.0 blue:0/255.0 alpha:1]
                                   range:[fechaCarrera rangeOfString:fechaCarrera]];
            
            //Número kilómetros
            [attributedText addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"Bebas Neue" size:40]
                                   range:[textViewText rangeOfString:kmCarrera]];
            [attributedText addAttribute:NSForegroundColorAttributeName
                                   value:[UIColor blackColor]
                                   range:[textViewText rangeOfString:kmCarrera]];
            
            //KM
            [attributedText addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"Bebas Neue" size:27]
                                   range:[textViewText rangeOfString:kilometrosString]];
            [attributedText addAttribute:NSForegroundColorAttributeName
                                   value:[UIColor blackColor]
                                   range:[textViewText rangeOfString:kilometrosString]];
            
            //Texto
            [attributedText addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"Bebas Neue" size:14]
                                   range:[textViewText rangeOfString:txtCarrera]];
            [attributedText addAttribute:NSForegroundColorAttributeName
                                   value:[UIColor blackColor]
                                   range:[textViewText rangeOfString:txtCarrera]];
        } else {
            //Fecha
            [attributedTextFecha addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"Bebas Neue" size:20]
                                   range:[fechaCarrera rangeOfString:fechaCarrera]];
            [attributedTextFecha addAttribute:NSForegroundColorAttributeName
                                   value:[UIColor colorWithRed:255/255.0 green:205/255.0 blue:0/255.0 alpha:1]
                                   range:[fechaCarrera rangeOfString:fechaCarrera]];
            
            //Número kilómetros
            [attributedText addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"Bebas Neue" size:40]
                                   range:[textViewText rangeOfString:kmCarrera]];
            [attributedText addAttribute:NSForegroundColorAttributeName
                                   value:[UIColor whiteColor]
                                   range:[textViewText rangeOfString:kmCarrera]];
            
            //KM
            [attributedText addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"Bebas Neue" size:27]
                                   range:[textViewText rangeOfString:kilometrosString]];
            [attributedText addAttribute:NSForegroundColorAttributeName
                                   value:[UIColor whiteColor]
                                   range:[textViewText rangeOfString:kilometrosString]];
            
            //Texto
            [attributedText addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"Bebas Neue" size:14]
                                   range:[textViewText rangeOfString:txtCarrera]];
            [attributedText addAttribute:NSForegroundColorAttributeName
                                   value:[UIColor whiteColor]
                                   range:[textViewText rangeOfString:txtCarrera]];
        }
        
        
        /* calculo alto */
        //Fecha
        UIFont *fontFecha = [UIFont fontWithName:@"Bebas Neue" size:20];
        CGSize constraintFecha = CGSizeMake(ancho - (20 * 2), 20000.0f);
        NSDictionary *attributesFecha = @{NSFontAttributeName: fontFecha};
        CGRect rectFecha = [fechaCarrera boundingRectWithSize:constraintFecha
                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                  attributes:attributesFecha
                                                     context:nil];
        
        //Número kilómetros
        UIFont *fontKm = [UIFont fontWithName:@"Bebas Neue" size:40];
        CGSize constraintKm = CGSizeMake(ancho - (20 * 2), 20000.0f);
        NSDictionary *attributesKm = @{NSFontAttributeName: fontKm};
        CGRect rectKm = [kmCarrera boundingRectWithSize:constraintKm
                                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                   attributes:attributesKm
                                                      context:nil];
        
        //KM
        UIFont *fontKmString = [UIFont fontWithName:@"Bebas Neue" size:27];
        CGSize constraintKmString = CGSizeMake(ancho - (20 * 2), 20000.0f);
        NSDictionary *attributesKmString = @{NSFontAttributeName: fontKmString};
        CGRect rectKmString = [kilometrosString boundingRectWithSize:constraintKmString
                                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                   attributes:attributesKmString
                                                      context:nil];
        
        //Texto
        UIFont *fontTexto = [UIFont fontWithName:@"Bebas Neue" size:13];
        CGSize constraintTexto = CGSizeMake(ancho - (20 * 2), 20000.0f);
        NSDictionary *attributesTexto = @{NSFontAttributeName: fontTexto};
        CGRect rectTexto = [txtCarrera boundingRectWithSize:constraintTexto
                                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                   attributes:attributesTexto
                                                      context:nil];
        
        float alto = rectFecha.size.height + rectKm.size.height + rectKmString.size.height + rectTexto.size.height;
        altoTotal = altoTotal + alto;
        /* FIN calculo alto */
        
        if (cuenta == 1) {
            //vertical = 70;
            vertical = 0;
        }
        else{
            //vertical = (70 + alto + 20) * cuenta;
            vertical = vertical + 20;
        }
        textView = [[UITextView alloc] initWithFrame:CGRectMake(20, vertical, ancho, alto)];
        
        vertical = vertical + alto;
        
        //textView.scrollEnabled = TRUE;
        textView.pagingEnabled = NO;
        textView.editable = NO;
        
        if (cuenta & 1) {
            textView.backgroundColor = [UIColor whiteColor]; // odd
        } else {
            textView.backgroundColor = [UIColor blackColor]; // even
        }
        
        cuenta = cuenta + 1;
        
        //Text padding
        textView.textContainerInset = UIEdgeInsetsMake(7, 6, 0, 0);
        
        NSMutableAttributedString *todoElTexto = attributedTextFecha;
        [todoElTexto appendAttributedString:attributedText];
        
        textView.attributedText = todoElTexto;

        //Muestro la vista
        [scrollView addSubview:textView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [singleTap setNumberOfTapsRequired:1];
        //Añado el label para sacar el ID de la noticia en el evento
        [singleTap setAccessibilityLabel:[NSString stringWithFormat:@"%@", idCarrera]];
        [self.textView addGestureRecognizer:singleTap];
    }
    
    [scrollView setContentSize:CGSizeMake(ancho, (20 * cuenta) + altoTotal )];
}


-(void)saveJsonWithData:(NSData *)data{
    NSString *jsonPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/carreras.json"];
    [data writeToFile:jsonPath atomically:YES];
    //NSLog(@"fSalvado JSON en:  %@",jsonPath);
}

-(NSData *)getSavedJsonData{
    NSString *jsonPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/carreras.json"];
    return [NSData dataWithContentsOfFile:jsonPath];
}

-(void)handleSingleTap: (UITapGestureRecognizer *)recognizer{
    //handle tap in here
    [self buttonAction:@[recognizer.accessibilityLabel]];
}

-(void)buttonAction:(id)sender
{
    [self performSegueWithIdentifier:@"viewEditCarreraSegue" sender:sender];
}

- (void)buttonPressed:(UIButton *)button {
    //NSLog(@"Button Pressed");
    [self performSegueWithIdentifier:@"viewNuevaCarreraSegue" sender:@"Nueva carrera"];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //NSLog(@"Vamonos de segue: %@",sender);
    if([segue.identifier isEqualToString:@"viewEditCarreraSegue"])
    {
        r4bEditCarreraViewController *viewController = [segue destinationViewController];
        viewController.myValue = sender[0];
        //NSLog(@"Vamonos de segue: %@",sender);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    //NSLog(@"Vuelvoo");
    [super viewWillAppear:animated];
    [self viewDidLoad];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //NSLog(@"Button Index =%ld",(long)buttonIndex);
    if (buttonIndex == 0)
    {
        //Ha dado a CANCEL, no hago nada
    }
    else if(buttonIndex == 1)
    {
        //NSLog(@"You have clicked GOO");
        
        //Borro esta carrera
        NSString *idCarreraBorrar = objc_getAssociatedObject(alertView, &carreraSeleccionadaAlert);
        //NSLog(@"Borrar la carrera: %@", idCarreraBorrar);
        
        NSData *carrerasGuardadas;
        carrerasGuardadas = [self getSavedJsonData];
        NSMutableDictionary *carrerasEnDisco=[NSJSONSerialization
                                              JSONObjectWithData:carrerasGuardadas
                                              options:NSJSONReadingMutableLeaves
                                              error:nil];
        
        NSMutableArray *carrerasArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dictionary in carrerasEnDisco[@"all"][@"carreras"]){
            if ([dictionary[@"id"] isEqualToString:idCarreraBorrar]) {
                NSLog(@"Voy a borrar la carrera de %@ kilometros", dictionary[@"km"]);
            }
            else{
                [carrerasArray addObject:dictionary];
            }
        }
        //Aquí tengo el array carrerasArray con todas las carreras menos la que han seleccionado para borrar
        NSDictionary *addCarreraToCarreras = @{@"carreras" : carrerasArray};
        NSDictionary *carrerasASalvar = @{@"all" : addCarreraToCarreras};
        
        NSError *error = nil;
        NSData *json;
        
        if ([NSJSONSerialization isValidJSONObject:carrerasASalvar])
        {
            // Serialize the dictionary
            json = [NSJSONSerialization dataWithJSONObject:carrerasASalvar options:NSJSONWritingPrettyPrinted error:&error];
            // If no errors, let's view the JSON
            if (json != nil && error == nil)
            {
                //NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
                [self saveJsonWithData:json];
            }
        }

        // get all subviews inside your scrollview into an array
        NSArray *subviews = [scrollView subviews];
        
        // loop through array, for each image view subview in your scrollview
        // remove it from the superview (superview is your scroll view in this case)
        for(int i = 0; i < subviews.count; i++)
        {
            UIImageView *imageView = (UIImageView *)[subviews objectAtIndex:i];
            
            [imageView removeFromSuperview];
        }

        [self viewWillAppear:TRUE];
 
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
