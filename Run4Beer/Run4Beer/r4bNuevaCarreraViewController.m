//
//  r4bNuevaCarreraViewController.m
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 09/10/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import "r4bNuevaCarreraViewController.h"

@interface r4bNuevaCarreraViewController ()

    @property (nonatomic) UITapGestureRecognizer *tapRecognizer;
    @property (nonatomic) UITextField *textFieldFecha;
    @property (nonatomic) UITextField *textField;

@end

@implementation r4bNuevaCarreraViewController
@synthesize textView,scrollView,datelabel,datePicker;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //Ancho
    float ancho = [[UIScreen mainScreen] bounds].size.width - 40;
    
    //label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 90, ancho, 30)];
    [label setBackgroundColor:[UIColor clearColor]];
    NSString *labelString = @"¿CUÁNTOS KILÓMETROS HAS CORRIDO?";
    NSMutableAttributedString *attributedTextLabel = [[NSMutableAttributedString alloc] initWithString:labelString];
    [attributedTextLabel addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"Bebas Neue" size:25]
                                range:[labelString rangeOfString:labelString]];
    [label setAttributedText:attributedTextLabel];
    [label sizeToFit];
    label.numberOfLines = 0;
    [label sizeToFit];
    [self.view addSubview:label];
    
    //Pongo la fecha en el textFieldFecha
    NSDateFormatter *formatter;
    NSString *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"es"]];
    [formatter setDateFormat:@"dd MMMM yyyy"];
    dateString = [formatter stringFromDate:[NSDate date]];
    
    self.textFieldFecha = [[UITextField alloc] init];
    self.textFieldFecha.textColor = [UIColor darkGrayColor];
    self.textFieldFecha.frame = CGRectMake(20, 151, 150, 30);
    self.textFieldFecha.backgroundColor = [UIColor whiteColor];
    [self.textFieldFecha setBorderStyle:UITextBorderStyleRoundedRect];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:dateString];
    [attributedText addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"Bebas Neue" size:20]
                           range:[dateString rangeOfString:dateString]];
    self.textFieldFecha.attributedText = attributedText;
    self.textFieldFecha.delegate = self;
    
    datePicker = [[UIDatePicker alloc]init];
    datePicker.date = [NSDate date];
    [datePicker addTarget:self
                   action:@selector(LabelChange:)
         forControlEvents:UIControlEventValueChanged];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    self.textFieldFecha.inputView = datePicker;
    
    [self.view addSubview:self.textFieldFecha];

    //Pongo el textField de kilometros
    self.textField = [[UITextField alloc] init];
    self.textField.frame = CGRectMake(20, 200, 92, 40);
    self.textField.backgroundColor = [UIColor whiteColor];
    [self.textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [self.textField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.textField setFont:[UIFont fontWithName:@"Bebas Neue" size:35]];
    [self.view addSubview:self.textField];
    
    
    //Label de KM
    UILabel *labelKm = [[UILabel alloc]init];
    labelKm.frame = CGRectMake(120, 200, 42, 50);
    [labelKm setBackgroundColor:[UIColor clearColor]];
    NSString *labelKmString = @"KM";
    NSMutableAttributedString *attributedTextLabelKm = [[NSMutableAttributedString alloc] initWithString:labelKmString];
    [attributedTextLabelKm addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"Bebas Neue" size:35]
                                range:[labelKmString rangeOfString:labelKmString]];
    [labelKm setAttributedText:attributedTextLabelKm];
    [labelKm sizeToFit];
    labelKm.numberOfLines = 0;
    [labelKm sizeToFit];
    [self.view addSubview:labelKm];
    
    //Añado los botones
    UIButton *buttonGuardar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *buttonCancelar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    buttonGuardar.frame = CGRectMake(20, 280, ancho, 30);
    buttonCancelar.frame = CGRectMake(20, 320, ancho, 30);
    
    [buttonGuardar setTitle:@"AÑADIR NUEVA CARRERA" forState:UIControlStateNormal];
    [buttonGuardar.titleLabel setFont:[UIFont fontWithName:@"Bebas Neue" size:25]];
    [buttonGuardar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonGuardar setBackgroundColor:[UIColor darkGrayColor]];
    
    [buttonCancelar setTitle:@"CANCELAR" forState:UIControlStateNormal];
    [buttonCancelar.titleLabel setFont:[UIFont fontWithName:@"Bebas Neue" size:25]];
    [buttonCancelar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonCancelar setBackgroundColor:[UIColor darkGrayColor]];
    
    [buttonGuardar addTarget:self action:@selector(buttonSavePressed:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [buttonCancelar addTarget:self action:@selector(buttonPressed:)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:buttonGuardar];
    [self.view addSubview:buttonCancelar];
    

    //Inicializo el textField donde meten los kilómetros
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
    
    
}


- (void)LabelChange:(id)sender{
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"es"]];
    [formatter setDateFormat:@"dd MMMM yyyy"];

    //NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //df.dateStyle = NSDateFormatterMediumStyle;
    
    self.textFieldFecha.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:datePicker.date]];
}

- (void)buttonPressed:(UIButton *)button {
    //NSLog(@"Button Pressed");
    
    //Vuelvo a la lista de carreras
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonSavePressed:(UIButton *)button {
    //NSLog(@"ButtonSave Pressed");
    
    //Miro si lo que ha metido es un número o no
    NSNumberFormatter *myFormatter = [[NSNumberFormatter alloc] init];
    [myFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"es"]];
    NSNumber *myNumber = [myFormatter numberFromString:self.textField.text];
    
    //NSLog(@"ButtonSave Pressed: %@",self.textField.text);
    
    if (![self.textField.text isEqual: @""] && ![self.textField.text isEqual: @"0"] && myNumber) {
        //NSLog(@"Es bien: %@",self.textField.text);

        //Guardo el valor de los kilómetros en el Json
        //Cojo los datos de carreras del Json
        NSData *carrerasGuardadas;
        carrerasGuardadas = [self getSavedJsonData];
        NSMutableDictionary *carrerasEnDisco=[NSJSONSerialization
                                   JSONObjectWithData:carrerasGuardadas
                                   options:NSJSONReadingMutableLeaves
                                   error:nil];
        
        NSInteger mayorId = 0;
        for (NSDictionary *dictionary in carrerasEnDisco[@"all"][@"carreras"]){
            if ([dictionary[@"id"] integerValue] > mayorId) {
                mayorId = [dictionary[@"id"] integerValue];
            }
        }
        mayorId = mayorId + 1;
                
        //Miro cuántos kilómetros ha corrido y cojo un texto motivador
        CGFloat kilometrosCorridos = (CGFloat)[self.textField.text floatValue];
        
        //Cojo el JSON frases
        NSData *elJsonGuardadoFrases;
        elJsonGuardadoFrases = [self getSavedJsonDataFrases];
        
        NSDictionary *jsonEnDiscoFrases=[NSJSONSerialization
                                         JSONObjectWithData:elJsonGuardadoFrases
                                         options:NSJSONReadingMutableLeaves
                                         error:nil];

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
        
        for (NSDictionary *dictionaryFrases in jsonEnDiscoFrases[@"all"][@"frases"]){
            switch ([dictionaryFrases[@"rango"] integerValue]){
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
    
        NSString *textoMotivador = @" ";
        
        if (kilometrosCorridos < 1) {
            NSUInteger randomIndex = arc4random() % [frases11 count];
            textoMotivador = frases11[randomIndex];
            //NSLog(@"Menos de 1 km: %@", textoMotivador);
        }
        else if (kilometrosCorridos >= 1 && kilometrosCorridos < 3){
            NSUInteger randomIndex = arc4random() % [frases12 count];
            textoMotivador = frases12[randomIndex];
            //NSLog(@"Entre 1 km y 3 km: %@", textoMotivador);
        }
        else if (kilometrosCorridos >= 3 && kilometrosCorridos < 10){
            NSUInteger randomIndex = arc4random() % [frases13 count];
            textoMotivador = frases13[randomIndex];
            //NSLog(@"Entre 3 km y 10 km: %@", textoMotivador);
        }
        else if (kilometrosCorridos >= 10 && kilometrosCorridos < 20){
            NSUInteger randomIndex = arc4random() % [frases14 count];
            textoMotivador = frases14[randomIndex];
            //NSLog(@"Entre 10 km y 20 km: %@", textoMotivador);
        }
        else if (kilometrosCorridos >= 20 && kilometrosCorridos < 40){
            NSUInteger randomIndex = arc4random() % [frases15 count];
            textoMotivador = frases15[randomIndex];
            //NSLog(@"Entre 20 km y 40 km: %@", textoMotivador);
        }
        else if (kilometrosCorridos >= 40){
            NSUInteger randomIndex = arc4random() % [frases16 count];
            textoMotivador = frases16[randomIndex];
            //NSLog(@"Más de 40 km: %@", textoMotivador);
        }
        
        NSString *textoMotivadorFormatted = [textoMotivador stringByReplacingOccurrencesOfString:@"\\n" withString:@"\r"];
        
        NSMutableDictionary *nuevaCarrera = [NSMutableDictionary dictionary];
        
        [nuevaCarrera setObject: [@(mayorId) stringValue] forKey: @"id"];
        [nuevaCarrera setObject: [NSString stringWithFormat:@"%@",self.textFieldFecha.text]forKey: @"fx"];
        [nuevaCarrera setObject: [NSString stringWithFormat:@"%@",self.textField.text]forKey: @"km"];
        [nuevaCarrera setObject: textoMotivadorFormatted forKey: @"txt"];
        [nuevaCarrera setObject: @"Cadiz" forKey: @"tag"];
        
        //NSLog(@"Carrera: %@",nuevaCarrera);
        
        NSMutableArray *carrerasArray = [NSMutableArray arrayWithObjects:nuevaCarrera, nil];

        for (NSDictionary *dictionary in carrerasEnDisco[@"all"][@"carreras"]){
            [carrerasArray addObject:dictionary];
        }
        
        //NSLog(@"someArray: %@",carrerasArray);
        
        NSDictionary *addCarreraToCarreras = @{@"carreras" : carrerasArray};
        NSDictionary *carrerasASalvar = @{@"all" : addCarreraToCarreras};
        
        //NSLog(@"carrerasASalvar: %@",carrerasASalvar);

        NSError *error = nil;
        NSData *json;
        
        // Dictionary convertable to JSON
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
        //Vuelvo a la lista de carreras
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        //NSLog(@"Es cero o blanco: %@",self.textField.text);
        /* HAGO UN ALERT */
        NSString *titulo = @"Error";
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:titulo
        message:@"Debes introducir un número válido"
        delegate:self
        cancelButtonTitle:@"Cancel"
        otherButtonTitles: nil];
        [alert show];
        /* FIN HAGO UN ALERT */
    }
}


-(void)saveJsonWithData:(NSData *)data{
    NSString *jsonPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/carreras.json"];
    [data writeToFile:jsonPath atomically:YES];
}

-(NSData *)getSavedJsonData{
    NSString *jsonPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/carreras.json"];
    return [NSData dataWithContentsOfFile:jsonPath];
}

-(NSData *)getSavedJsonDataFrases{
    NSString *jsonPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/all.json"];
    return [NSData dataWithContentsOfFile:jsonPath];
}

-(void) keyboardWillShow:(NSNotification *) note {
    //NSLog(@"keyboardWillShow");
    [self.view addGestureRecognizer:self.tapRecognizer];
}

-(void) keyboardWillHide:(NSNotification *) note
{
    //NSLog(@"keyboardWillHide");
    [self.view removeGestureRecognizer:self.tapRecognizer];
    
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    //NSLog(@"didTapAnywhere");
    [self.textField resignFirstResponder];
    [self.textFieldFecha resignFirstResponder];
    //datePicker.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end