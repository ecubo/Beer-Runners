//
//  r4bGeneralRun4Beer.m
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 11/11/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import "r4bGeneralRun4Beer.h"

@interface r4bGeneralRun4Beer ()

    @property (nonatomic) UIAlertView *alert;

@end

@implementation r4bGeneralRun4Beer

@synthesize textViewTop, textViewKm;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Cojo las frases
    //Cojo el JSON frases
    NSData *elJsonGuardadoFrases;
    elJsonGuardadoFrases = [self getSavedJsonDataFrases];
    
    NSDictionary *jsonEnDiscoFrases=[NSJSONSerialization
                               JSONObjectWithData:elJsonGuardadoFrases
                               options:NSJSONReadingMutableLeaves
                               error:nil];
    
    //NSLog(@"Frases: %@",jsonEnDiscoFrases[@"all"][@"frases"]);
    
    NSMutableArray *frases0 = [NSMutableArray arrayWithObjects:@"¿Preparado? ¡Empieza a correr y gánate esa cerveza!", nil];
    NSMutableArray *frases1 = [NSMutableArray arrayWithObjects:@"¡Acabas de comenzar! Convence a algún amigo y salid juntos a correr", nil];
    NSMutableArray *frases2 = [NSMutableArray arrayWithObjects:@"¡Todavía no lo has dejado! Quizás seas un auténtico Beer Runner...", nil];
    NSMutableArray *frases3 = [NSMutableArray arrayWithObjects:@"Correr es saludable, así que nos tomamos una cerveza... ¡A tu salud!", nil];
    NSMutableArray *frases4 = [NSMutableArray arrayWithObjects:@"¡Vaya! Parece que vas en serio... te mereces esa cerveza bien fresquita", nil];
    NSMutableArray *frases5 = [NSMutableArray arrayWithObjects:@"Tú sí que te mereces dos cervezas bien frías. Disfruta mientras piensas en nuevos retos", nil];
    NSMutableArray *frases6 = [NSMutableArray arrayWithObjects:@"¡Eres un destacado Beer Runner! Te pedirán consejo sobre running... ¡Y sobre cerveza!", nil];
    NSMutableArray *frases7 = [NSMutableArray arrayWithObjects:@"¡Eres la élite de los Beer Runners! Los jóvenes se sentarán en torno a hogueras y escucharán tus proezas", nil];
    NSMutableArray *frases11 = [NSMutableArray arrayWithObjects:@"¡Poco a poco! Lleva con orgullo las zapatillas de correr", nil];
    NSMutableArray *frases12 = [NSMutableArray arrayWithObjects:@"¡Continúa! Se va adivinando tu cerveza en el horizonte", nil];
    NSMutableArray *frases13 = [NSMutableArray arrayWithObjects:@"¡Lo has conseguido! El camarero te espera en la meta", nil];
    NSMutableArray *frases14 = [NSMutableArray arrayWithObjects:@"Sigues dejando atrás kilómetros... ¡Disfruta de tu cerveza!", nil];
    NSMutableArray *frases15 = [NSMutableArray arrayWithObjects:@"¡Increíble, Beer Runner! Te mereces un par de cervezas.", nil];
    NSMutableArray *frases16 = [NSMutableArray arrayWithObjects:@"¡Un par de cervezas con otros Beer Runners es lo mejor de la carrera!", nil];
    
    for (NSDictionary *dictionaryFrases in jsonEnDiscoFrases[@"all"][@"frases"])
    {
        switch ([dictionaryFrases[@"rango"] integerValue])
        
        {
            case 0:
                [frases0 addObject:dictionaryFrases[@"frase"]];
                break;
            case 1:
                [frases1 addObject:dictionaryFrases[@"frase"]];
                break;
            case 2:
                [frases2 addObject:dictionaryFrases[@"frase"]];
                break;
            case 3:
                [frases3 addObject:dictionaryFrases[@"frase"]];
                break;
            case 4:
                [frases4 addObject:dictionaryFrases[@"frase"]];
                break;
            case 5:
                [frases5 addObject:dictionaryFrases[@"frase"]];
                break;
            case 6:
                [frases6 addObject:dictionaryFrases[@"frase"]];
                break;
            case 7:
                [frases7 addObject:dictionaryFrases[@"frase"]];
                break;
            case 11:
                [frases11 addObject:dictionaryFrases[@"frase"]];
                break;
            case 12:
                [frases12 addObject:dictionaryFrases[@"frase"]];
                break;
            case 13:
                [frases13 addObject:dictionaryFrases[@"frase"]];
                break;
            case 14:
                [frases14 addObject:dictionaryFrases[@"frase"]];
                break;
            case 15:
                [frases15 addObject:dictionaryFrases[@"frase"]];
                break;
            case 16:
                [frases16 addObject:dictionaryFrases[@"frase"]];
                break;
            default:
                break;
        }
    }

    //Ancho de la pantalla
    float ancho = [[UIScreen mainScreen] bounds].size.width - 40;
    float alto = [[UIScreen mainScreen] bounds].size.height;
    
    //Acciones del botón de borrar todas la carreras
    id trashTopButton = [[UIBarButtonItem alloc]
                          initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                          target:self
                          action:@selector(trashTopButtonPressed:)
                          ];
    self.navigationItem.rightBarButtonItem=trashTopButton;
    
    //Botones
    UIButton *buttonNuevaCarrera = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *buttonVerCarreras = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    buttonNuevaCarrera.frame = CGRectMake(20, alto - 130, ancho, 30);
    buttonVerCarreras.frame = CGRectMake(20, alto - 90, ancho, 30);
    
    [buttonNuevaCarrera setTitle:@"AÑADIR NUEVA CARRERA" forState:UIControlStateNormal];
    [buttonNuevaCarrera.titleLabel setFont:[UIFont fontWithName:@"Bebas Neue" size:25]];
    [buttonNuevaCarrera setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonNuevaCarrera setBackgroundColor:[UIColor darkGrayColor]];

    [buttonVerCarreras setTitle:@"VER CARRERAS" forState:UIControlStateNormal];
    [buttonVerCarreras.titleLabel setFont:[UIFont fontWithName:@"Bebas Neue" size:25]];
    [buttonVerCarreras setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonVerCarreras setBackgroundColor:[UIColor darkGrayColor]];
    
    [buttonNuevaCarrera addTarget:self action:@selector(buttonNuevaCarreraPressed:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [buttonVerCarreras addTarget:self action:@selector(buttonVerCarrerasPressed:)
                      forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:buttonNuevaCarrera];
    [self.view addSubview:buttonVerCarreras];

    //Cojo los datos de carreras del Json
    NSData *elJsonGuardado;
    elJsonGuardado = [self getSavedJsonData];
    
    NSDictionary *jsonEnDisco=[NSJSONSerialization
                               JSONObjectWithData:elJsonGuardado
                               options:NSJSONReadingMutableLeaves
                               error:nil];
    
    //NSLog(@"cuenta: %@", jsonEnDisco);
    
    NSInteger cuantasCarreras = [jsonEnDisco[@"all"][@"carreras"] count];
    
    CGFloat cuantosKilometros = 0;

    NSInteger cuenta = 0;
    
    NSNumberFormatter *myFormatter = [[NSNumberFormatter alloc] init];
    [myFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"es"]];
    
    for (NSDictionary *dictionary in jsonEnDisco[@"all"][@"carreras"])
    {
        NSString *kmCarrera;
        kmCarrera = dictionary[@"km"];
        NSNumber *kmCarreraNumber = [myFormatter numberFromString:kmCarrera];
        cuantosKilometros = cuantosKilometros + [kmCarreraNumber floatValue];
        //NSLog(@"cuantosKilometros = %f + %f", cuantosKilometros, [kmCarreraNumber floatValue]);
        cuenta = cuenta + 1;
    }
    
    //Saco la suma de kilometros en string con dos decimales
    NSString *cuantosKilometrosDosDecimales = [NSString stringWithFormat:@"%.2f", cuantosKilometros];
    
    //NSLog(@"cuantasCarreras: %ld", (long)cuantasCarreras);
    //NSLog(@"cuantosKilometros: %f", cuantosKilometros);
    //NSLog(@"cuantosKilometrosDosDecimales: %@", cuantosKilometrosDosDecimales);
    
    //Relleno los textViews
    /*----------------------------textViewTop----------------------------*/
    NSString *primeraLineaTop = @" ";
    
    if (cuantosKilometros < 5) {
        NSUInteger randomIndex = arc4random() % [frases1 count];
        primeraLineaTop = frases1[randomIndex];
    }
    else if (cuantosKilometros >= 5 && cuantosKilometros < 10){
        NSUInteger randomIndex = arc4random() % [frases2 count];
        primeraLineaTop = frases2[randomIndex];
    }
    else if (cuantosKilometros >= 10 && cuantosKilometros < 20){
        NSUInteger randomIndex = arc4random() % [frases3 count];
        primeraLineaTop = frases3[randomIndex];
    }
    else if (cuantosKilometros >= 20 && cuantosKilometros < 40){
        NSUInteger randomIndex = arc4random() % [frases4 count];
        primeraLineaTop = frases4[randomIndex];
    }
    else if (cuantosKilometros >= 40 && cuantosKilometros < 80){
        NSUInteger randomIndex = arc4random() % [frases5 count];
        primeraLineaTop = frases5[randomIndex];
    }
    else if (cuantosKilometros >= 80 && cuantosKilometros < 160){
        NSUInteger randomIndex = arc4random() % [frases6 count];
        primeraLineaTop = frases6[randomIndex];
    }
    else if (cuantosKilometros >= 160){
        NSUInteger randomIndex = arc4random() % [frases7 count];
        primeraLineaTop = frases7[randomIndex];
    }
    
    NSString *primeraLineaTopFormatted = [primeraLineaTop stringByReplacingOccurrencesOfString:@"\\n" withString:@"\r"];

    NSMutableAttributedString *attributedTextViewTopText = [[NSMutableAttributedString alloc] initWithString:primeraLineaTopFormatted];
    
    //Primera Linea
    [attributedTextViewTopText addAttribute:NSFontAttributeName
                                     value:[UIFont fontWithName:@"Bebas Neue" size:20]
                                     range:[primeraLineaTopFormatted rangeOfString:primeraLineaTopFormatted]];
    [attributedTextViewTopText addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor blackColor]
                                     range:[primeraLineaTopFormatted rangeOfString:primeraLineaTopFormatted]];

    //Primera Linea tamaño
    UIFont *fontTop = [UIFont fontWithName:@"Bebas Neue" size:20];
    CGSize constraintTop = CGSizeMake(ancho - (20 * 2), 20000.0f);
    NSDictionary *attributesTop = @{NSFontAttributeName: fontTop};
    CGRect rectTop = [primeraLineaTopFormatted boundingRectWithSize:constraintTop
                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         attributes:attributesTop
                                            context:nil];
    
    [textViewTop removeFromSuperview];
    
    textViewTop = [[UITextView alloc] initWithFrame:CGRectMake(20, 73, ancho, rectTop.size.height + 15)];
    
    textViewTop.pagingEnabled = NO;
    textViewTop.editable = NO;
    textViewTop.scrollEnabled = NO;
    textViewTop.backgroundColor = [UIColor clearColor];
    //textViewTop.backgroundColor = [UIColor redColor];
    
    textViewTop.attributedText = attributedTextViewTopText;
    
    
    [self.view addSubview:textViewTop];
    
    /*----------------------------textViewKm----------------------------*/
    NSString *primeraLineaKm;
    NSString *segundaLineaKm;
    NSString *terceraLineaKm;
    NSString *kilometrosString;
    NSString *cuartaLineaKm;
    
    primeraLineaKm = [NSString stringWithFormat:@"EN %ld DÍAS", (long)cuantasCarreras];
    segundaLineaKm = @"HAS HECHO";
    
    NSString *cuantosKilometrosDosDecimalesComa = [cuantosKilometrosDosDecimales stringByReplacingOccurrencesOfString:@"." withString:@","];
    
    terceraLineaKm = [NSString stringWithFormat:@"%@", cuantosKilometrosDosDecimalesComa];
    kilometrosString = @" KM";
    cuartaLineaKm = @"BEBE CON MODERACIÓN";
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:1];
    [style setLineHeightMultiple:-40];
    
    NSString *textViewKmText = [NSString stringWithFormat:@"%@\n%@\n%@%@\n%@",primeraLineaKm,segundaLineaKm,terceraLineaKm,kilometrosString,cuartaLineaKm];
    NSMutableAttributedString *attributedTextViewKmText = [[NSMutableAttributedString alloc] initWithString:textViewKmText];
    
    //Primera Linea
    [attributedTextViewKmText addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"Bebas Neue" size:30]
                           range:[textViewKmText rangeOfString:primeraLineaKm]];
    [attributedTextViewKmText addAttribute:NSForegroundColorAttributeName
                           value:[UIColor blackColor]
                           range:[textViewKmText rangeOfString:primeraLineaKm]];
    [attributedTextViewKmText addAttribute:NSParagraphStyleAttributeName
                           value:style
                           range:[textViewKmText rangeOfString:primeraLineaKm]];
    
    //Segunda Linea
    [attributedTextViewKmText addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"Bebas Neue" size:30]
                           range:[textViewKmText rangeOfString:segundaLineaKm]];
    [attributedTextViewKmText addAttribute:NSForegroundColorAttributeName
                           value:[UIColor whiteColor]
                           range:[textViewKmText rangeOfString:segundaLineaKm]];
    [attributedTextViewKmText addAttribute:NSParagraphStyleAttributeName
                                     value:style
                                     range:[textViewKmText rangeOfString:segundaLineaKm]];
    
    //Tercera Linea
    [attributedTextViewKmText addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"Bebas Neue" size:40]
                           range:[textViewKmText rangeOfString:terceraLineaKm]];
    [attributedTextViewKmText addAttribute:NSForegroundColorAttributeName
                           value:[UIColor whiteColor]
                           range:[textViewKmText rangeOfString:terceraLineaKm]];
    [attributedTextViewKmText addAttribute:NSParagraphStyleAttributeName
                                     value:style
                                     range:[textViewKmText rangeOfString:terceraLineaKm]];
    
    //KM
    [attributedTextViewKmText addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"Bebas Neue" size:27]
                           range:[textViewKmText rangeOfString:kilometrosString]];
    [attributedTextViewKmText addAttribute:NSForegroundColorAttributeName
                           value:[UIColor whiteColor]
                           range:[textViewKmText rangeOfString:kilometrosString]];
    [attributedTextViewKmText addAttribute:NSParagraphStyleAttributeName
                                     value:style
                                     range:[textViewKmText rangeOfString:kilometrosString]];
    
    //Primera Linea
    [attributedTextViewKmText addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"Bebas Neue" size:10]
                           range:[textViewKmText rangeOfString:cuartaLineaKm]];
    [attributedTextViewKmText addAttribute:NSForegroundColorAttributeName
                           value:[UIColor whiteColor]
                           range:[textViewKmText rangeOfString:cuartaLineaKm]];
    [attributedTextViewKmText addAttribute:NSParagraphStyleAttributeName
                                     value:style
                                     range:[textViewKmText rangeOfString:cuartaLineaKm]];
    
    //Primera Linea tamaño
    UIFont *fontPL = [UIFont fontWithName:@"Bebas Neue" size:30];
    CGSize constraintPL = CGSizeMake(ancho - (20 * 2), 20000.0f);
    NSDictionary *attributesPL = @{NSFontAttributeName: fontPL};
    CGRect rectPL = [primeraLineaKm boundingRectWithSize:constraintPL
                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                attributes:attributesPL
                                                   context:nil];
    
    //Primera Linea tamaño
    UIFont *fontSL = [UIFont fontWithName:@"Bebas Neue" size:30];
    CGSize constraintSL = CGSizeMake(ancho - (20 * 2), 20000.0f);
    NSDictionary *attributesSL = @{NSFontAttributeName: fontSL};
    CGRect rectSL = [segundaLineaKm boundingRectWithSize:constraintSL
                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                attributes:attributesSL
                                                   context:nil];
    
    //Primera Linea tamaño
    UIFont *fontTL = [UIFont fontWithName:@"Bebas Neue" size:40];
    CGSize constraintTL = CGSizeMake(ancho - (20 * 2), 20000.0f);
    NSDictionary *attributesTL = @{NSFontAttributeName: fontTL};
    CGRect rectTL = [terceraLineaKm boundingRectWithSize:constraintTL
                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                attributes:attributesTL
                                                   context:nil];
    
    //Primera Linea tamaño
    UIFont *fontKS = [UIFont fontWithName:@"Bebas Neue" size:27];
    CGSize constraintKS = CGSizeMake(ancho - (20 * 2), 20000.0f);
    NSDictionary *attributesKS = @{NSFontAttributeName: fontKS};
    CGRect rectKS = [kilometrosString boundingRectWithSize:constraintKS
                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                attributes:attributesKS
                                                   context:nil];
    
    //Primera Linea tamaño
    UIFont *fontCL = [UIFont fontWithName:@"Bebas Neue" size:10];
    CGSize constraintCL = CGSizeMake(ancho - (20 * 2), 20000.0f);
    NSDictionary *attributesCL = @{NSFontAttributeName: fontCL};
    CGRect rectCL = [cuartaLineaKm boundingRectWithSize:constraintCL
                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                attributes:attributesCL
                                                   context:nil];
    
    CGFloat altoTextViewKm;
    
    altoTextViewKm = rectPL.size.height + rectSL.size.height + rectTL.size.height + rectKS.size.height + rectCL.size.height;
    
    textViewKm = [[UITextView alloc] initWithFrame:CGRectMake(20, (73 + (rectTop.size.height + 15) + 20), ancho, altoTextViewKm)];
    
    textViewKm.pagingEnabled = NO;
    textViewKm.editable = NO;
    textViewKm.scrollEnabled = NO;
    textViewKm.backgroundColor = [UIColor clearColor];
    //textViewKm.backgroundColor = [UIColor redColor];
    textViewKm.attributedText = attributedTextViewKmText;
    
    [self.view addSubview:textViewKm];
}


- (void)trashTopButtonPressed:(UIButton *)button {
    //NSLog(@"Button Pressed");
    /* HAGO UN ALERT */
    NSString *titulo = @"Borrar carreras";
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:titulo
    message:@"¿Deseas borrar todo el historial de carreras?"
    delegate:self
    cancelButtonTitle:@"Cancelar"
    otherButtonTitles: nil];
    [alert addButtonWithTitle:@"Borrar"];
    [alert show];
    /* FIN HAGO UN ALERT */
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //NSLog(@"Button Index =%ld",(long)buttonIndex);
    if (buttonIndex == 0)
    {
        //NSLog(@"You have clicked Cancel");
    }
    else if(buttonIndex == 1)
    {
        //NSLog(@"Borro todas las carreras");
        NSData *carrerasGuardadas;
        carrerasGuardadas = [self getSavedJsonData];

        NSMutableArray *carrerasArray = [[NSMutableArray alloc] init];

        NSDictionary *addCarreraToCarreras = @{@"carreras" : carrerasArray};
        NSDictionary *carrerasASalvar2 = @{@"all" : addCarreraToCarreras};
        
        NSError *error = nil;
        NSData *json;
        
        if ([NSJSONSerialization isValidJSONObject:carrerasASalvar2])
        {
            // Serialize the dictionary
            json = [NSJSONSerialization dataWithJSONObject:carrerasASalvar2 options:NSJSONWritingPrettyPrinted error:&error];
            // If no errors, let's view the JSON
            if (json != nil && error == nil)
            {
                [self saveJsonWithData:json];
            }
        }
        //Recargo el contador
        [textViewKm removeFromSuperview];
        [self viewDidLoad];
    }
}

- (void)buttonNuevaCarreraPressed:(UIButton *)button {
    //NSLog(@"Button Pressed");
    [self performSegueWithIdentifier:@"deGeneralANuevaCarreraSegue" sender:@"Nueva carrera"];
}

- (void)buttonVerCarrerasPressed:(UIButton *)button {
    //NSLog(@"Button Pressed");
    [self performSegueWithIdentifier:@"deGeneralAVerCarrerasSegue" sender:@"Ver carreras"];
}

-(NSData *)getSavedJsonDataFrases{
    NSString *jsonPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/all.json"];
    return [NSData dataWithContentsOfFile:jsonPath];
}

-(NSData *)getSavedJsonData{
    NSString *jsonPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/carreras.json"];
    return [NSData dataWithContentsOfFile:jsonPath];
}

-(void)saveJsonWithData:(NSData *)data{
    
    NSString *jsonPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/carreras.json"];
    [data writeToFile:jsonPath atomically:YES];
    //NSLog(@"fSalvado JSON en:  %@",jsonPath);
}

- (void)viewWillAppear:(BOOL)animated {
    
    [textViewKm removeFromSuperview];

    [self viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
