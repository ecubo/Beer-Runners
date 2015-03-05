//
//  r4bEditCarreraViewController.m
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 09/10/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import "r4bEditCarreraViewController.h"
#import "r4bThirdViewController.h"

@interface r4bEditCarreraViewController ()

@property (nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic) UITextField *textFieldFecha;
@property (nonatomic) UITextField *textField;

@end

@implementation r4bEditCarreraViewController
@synthesize textView,scrollView,datelabel,datePicker;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //Cojo la carrera seleccionada
    NSData *elJsonGuardado;
    elJsonGuardado = [self getSavedJsonData];
    
    NSDictionary *jsonEnDisco=[NSJSONSerialization
                               JSONObjectWithData:elJsonGuardado
                               options:NSJSONReadingMutableLeaves
                               error:nil];
    
    //NSInteger myValueInt = [self.myValue intValue];
    
    NSString *fechaCarrera;
    NSString *kmCarrera;
    NSString *txtCarrera;
    NSString *tagCarrera;
    
    for (id key in jsonEnDisco[@"all"][@"carreras"]) {
        //NSLog(@"There are %@ %@'s in stock", jsonEnDisco[@"all"][@"bares"][key], key);
        if ([key[@"id"] isEqualToString:self.myValue]) {
            fechaCarrera = key[@"fx"];
            kmCarrera = key[@"km"];
            txtCarrera = key[@"txt"];
            tagCarrera = key[@"tag"];
        }
    }
    
    
    float ancho = [[UIScreen mainScreen] bounds].size.width - 40;
    //float alto = [[UIScreen mainScreen] bounds].size.height;
    
    //label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 90, ancho, 30)];
    [label setBackgroundColor:[UIColor clearColor]];
    NSString *labelString = @"EDITAR CARRERA";
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
    dateString = fechaCarrera;
    
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
    
    
    NSMutableAttributedString *attributedTextKm = [[NSMutableAttributedString alloc] initWithString:kmCarrera];
    [attributedTextKm addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"Bebas Neue" size:35]
                           range:[kmCarrera rangeOfString:kmCarrera]];
    self.textField.attributedText = attributedTextKm;
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
    UIButton *buttonEliminar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    buttonGuardar.frame = CGRectMake(20, 280, ancho, 30);
    buttonCancelar.frame = CGRectMake(20, 320, ancho, 30);
    buttonEliminar.frame = CGRectMake(20, 370, ancho, 30);
    
    [buttonGuardar setTitle:@"EDITAR CARRERA" forState:UIControlStateNormal];
    [buttonGuardar.titleLabel setFont:[UIFont fontWithName:@"Bebas Neue" size:25]];
    [buttonGuardar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonGuardar setBackgroundColor:[UIColor darkGrayColor]];
    
    [buttonCancelar setTitle:@"CANCELAR" forState:UIControlStateNormal];
    [buttonCancelar.titleLabel setFont:[UIFont fontWithName:@"Bebas Neue" size:25]];
    [buttonCancelar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonCancelar setBackgroundColor:[UIColor darkGrayColor]];
    
    [buttonEliminar setTitle:@"ELIMINAR CARRERA" forState:UIControlStateNormal];
    [buttonEliminar.titleLabel setFont:[UIFont fontWithName:@"Bebas Neue" size:25]];
    [buttonEliminar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonEliminar setBackgroundColor:[UIColor redColor]];
    
    [buttonGuardar addTarget:self action:@selector(buttonSavePressed:)
            forControlEvents:UIControlEventTouchUpInside];
    
    [buttonCancelar addTarget:self action:@selector(buttonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [buttonEliminar addTarget:self action:@selector(buttonDeletePressed:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:buttonGuardar];
    [self.view addSubview:buttonCancelar];
    [self.view addSubview:buttonEliminar];
    

    /*
    //Pongo la fecha en el textFieldFecha
    NSString *textFieldFecha = fechaCarrera;
    
    self.textFieldFecha.textColor = [UIColor grayColor];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:textFieldFecha];
    [attributedText addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"Helvetica" size:9]
                           range:[textFieldFecha rangeOfString:textFieldFecha]];
    self.textFieldFecha.attributedText = attributedText;
    
    //Pongo los kilómetros en el textField
    self.textField.text = kmCarrera;
    
    //label
    label.text = @"";
    [label sizeToFit];
    label.numberOfLines = 0;
    [label sizeToFit];
    */
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
        
        NSString *idCarreraEditar = self.myValue;
        
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
        
        CGFloat kilometrosCorridos = (CGFloat)[self.textField.text floatValue];
        
        NSString *textoMotivador = @" ";
        
        if (kilometrosCorridos < 1) {
            NSUInteger randomIndex = arc4random() % [frases11 count];
            textoMotivador = frases11[randomIndex];
            NSLog(@"Menos de 1 km: %@", textoMotivador);
        }
        else if (kilometrosCorridos >= 1 && kilometrosCorridos < 3){
            NSUInteger randomIndex = arc4random() % [frases12 count];
            textoMotivador = frases12[randomIndex];
            NSLog(@"Entre 1 km y 3 km: %@", textoMotivador);
        }
        else if (kilometrosCorridos >= 3 && kilometrosCorridos < 10){
            NSUInteger randomIndex = arc4random() % [frases13 count];
            textoMotivador = frases13[randomIndex];
            NSLog(@"Entre 3 km y 10 km: %@", textoMotivador);
        }
        else if (kilometrosCorridos >= 10 && kilometrosCorridos < 20){
            NSUInteger randomIndex = arc4random() % [frases14 count];
            textoMotivador = frases14[randomIndex];
            NSLog(@"Entre 10 km y 20 km: %@", textoMotivador);
        }
        else if (kilometrosCorridos >= 20 && kilometrosCorridos < 40){
            NSUInteger randomIndex = arc4random() % [frases15 count];
            textoMotivador = frases15[randomIndex];
            NSLog(@"Entre 20 km y 40 km: %@", textoMotivador);
        }
        else if (kilometrosCorridos >= 40){
            NSUInteger randomIndex = arc4random() % [frases16 count];
            textoMotivador = frases16[randomIndex];
            NSLog(@"Más de 40 km: %@", textoMotivador);
        }
        
        NSString *textoMotivadorFormatted = [textoMotivador stringByReplacingOccurrencesOfString:@"\\n" withString:@"\r"];
        
        
        /*Edito la carrera*/
        NSData *carrerasGuardadas;
        carrerasGuardadas = [self getSavedJsonData];
        NSMutableDictionary *carrerasEnDisco=[NSJSONSerialization
                                              JSONObjectWithData:carrerasGuardadas
                                              options:NSJSONReadingMutableLeaves
                                              error:nil];
        
        NSMutableArray *carrerasArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dictionary in carrerasEnDisco[@"all"][@"carreras"]){
            if ([dictionary[@"id"] isEqualToString:idCarreraEditar]) {
                //NSLog(@"Voy a editar la carrera de %@ kilometros", dictionary[@"km"]);

                NSMutableDictionary *nuevaCarrera = [NSMutableDictionary dictionary];
                
                [nuevaCarrera setObject: [NSString stringWithFormat:@"%@",idCarreraEditar] forKey: @"id"];
                [nuevaCarrera setObject: [NSString stringWithFormat:@"%@",self.textFieldFecha.text]forKey: @"fx"];
                [nuevaCarrera setObject: [NSString stringWithFormat:@"%@",self.textField.text]forKey: @"km"];
                [nuevaCarrera setObject: [NSString stringWithFormat:@"%@",textoMotivadorFormatted]forKey: @"txt"];
                [nuevaCarrera setObject: [NSString stringWithFormat:@"%@",dictionary[@"tag"]]forKey: @"tag"];

                [carrerasArray addObject:nuevaCarrera];
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
        /*FIN Edito la carrera*/

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

- (void)buttonDeletePressed:(UIButton *)button {
    //NSLog(@"ButtonDelete Pressed");
    
    //Borro esta carrera
    NSString *idCarreraBorrar = self.myValue;
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
            //NSLog(@"Voy a borrar la carrera de %@ kilometros", dictionary[@"km"]);
        }
        else{
            [carrerasArray addObject:dictionary];
        }
    }
    //Aquí tengo el array carrerasArray con todas las carreras menos la que han seleccionado para borrar
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
            //NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            [self saveJsonWithData:json];
        }
    }
    
    
    
    //Vuelvo a la lista de carreras
    [self.navigationController popViewControllerAnimated:YES];

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end