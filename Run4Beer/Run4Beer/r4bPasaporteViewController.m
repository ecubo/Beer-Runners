//
//  r4bPasaporteViewController.m
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 07/11/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import "r4bPasaporteViewController.h"
#import "r4bFourthViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface r4bPasaporteViewController ()

    @property (nonatomic) NSURLSession *session;
    @property (nonatomic, copy) NSArray *bares;
    @property (nonatomic) NSString *codigoTotalKeySHA1;
    @property (nonatomic) UITapGestureRecognizer *tapRecognizer;
    @property (nonatomic) UITextField *textField;
    @property (nonatomic) NSString *resultado;

@end

@implementation r4bPasaporteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resultado = @"No existe el código insertado";
    
    //Ancho y alto de la pantalla
    float ancho = [[UIScreen mainScreen] bounds].size.width;
    float alto = [[UIScreen mainScreen] bounds].size.height;

    //50 de padding de cada lado y 5 de espacio entre los dos botones
    float anchoUsable = ancho - 100 - 5;
    float anchoUsableMedio = anchoUsable / 2;
    float anchoPrimerBoton = anchoUsableMedio + 10;
    float anchoSegundoBoton = anchoUsableMedio - 10;
    
    //Coloco el textField
    //Pongo el textField de kilometros
    self.textField = [[UITextField alloc] init];
    self.textField.frame = CGRectMake(50, (alto / 2) - 30, (anchoUsable + 5), 30);
    self.textField.backgroundColor = [UIColor whiteColor];
    [self.textField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:self.textField];
    
    //Pongo el imageView de arriba
    UIImage *imagenTop = [UIImage imageNamed:@"pasaporte-cervecero"] ;;
    UIImageView *imageViewTop;
    float altoImagenTop;
    
    imageViewTop.contentMode = UIViewContentModeScaleAspectFit;
    
    float imgFactorTop = imagenTop.size.height / imagenTop.size.width;
    float anchoImagenTop = (ancho - 100);
    altoImagenTop = anchoImagenTop * imgFactorTop;
    
    float dondeEmpiezaElTextField = (alto / 2) - 30;
    
    float dondeEmpiezaElImagenTop = dondeEmpiezaElTextField - altoImagenTop - 5;

    imageViewTop = [[UIImageView alloc] initWithFrame:CGRectMake(50, dondeEmpiezaElImagenTop, anchoImagenTop, altoImagenTop)];
    [imageViewTop setImage:imagenTop];
    [self.view addSubview:imageViewTop];

    //Pongo el imageView de abajo
    UIImage *imagenBottom = [UIImage imageNamed:@"pasaporte-abajo"] ;;
    UIImageView *imageViewBottom;
    float altoImagen;
    
    imageViewBottom.contentMode = UIViewContentModeScaleAspectFit;

    float imgFactor = imagenBottom.size.height / imagenBottom.size.width;
    float anchoImagen = (ancho - 100) + 20;
    altoImagen = anchoImagen * imgFactor;

    imageViewBottom = [[UIImageView alloc] initWithFrame:CGRectMake(50, (alto - 40 - altoImagen), anchoImagen, altoImagen)];
    [imageViewBottom setImage:imagenBottom];
    [self.view addSubview:imageViewBottom];

    //Botón buttonVerificarCodigo
    UIButton *buttonVerificarCodigo = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    buttonVerificarCodigo.frame = CGRectMake(50, (alto / 2) + 5, anchoPrimerBoton, 30);
    
    [buttonVerificarCodigo setTitle:@"VERIFICAR CÓDIGO" forState:UIControlStateNormal];
    [buttonVerificarCodigo.titleLabel setFont:[UIFont fontWithName:@"Bebas Neue" size:20]];
    [buttonVerificarCodigo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonVerificarCodigo setBackgroundColor:[UIColor darkGrayColor]];
    
    [buttonVerificarCodigo addTarget:self action:@selector(buttonVerificarCodigoPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:buttonVerificarCodigo];
    
    //Botón buttonVerSellos
    UIButton *buttonVerSellos = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    buttonVerSellos.frame = CGRectMake(50 + anchoPrimerBoton + 5, (alto / 2) + 5, anchoSegundoBoton, 30);

    [buttonVerSellos setTitle:@"VER SELLOS" forState:UIControlStateNormal];
    [buttonVerSellos.titleLabel setFont:[UIFont fontWithName:@"Bebas Neue" size:20]];
    [buttonVerSellos setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonVerSellos setBackgroundColor:[UIColor darkGrayColor]];

    [buttonVerSellos addTarget:self action:@selector(buttonPressed:)
                forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:buttonVerSellos];
    
    //Inicializo el textField donde meten los kilómetros
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
    
}

- (void)buttonPressed:(UIButton *)button {
    //NSLog(@"Button Pressed");
    NSFileManager *filemgr;
    NSArray *filelist;
    NSString *documentsDirectoryPathForList = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSUInteger count;

    
    filemgr =[NSFileManager defaultManager];
    filelist = [filemgr contentsOfDirectoryAtPath:[documentsDirectoryPathForList stringByAppendingPathComponent:@"Pasaporte"] error:NULL];
    count = [filelist count];
    NSLog(@"Hay fotos: %lu",(unsigned long)count);
    
    if (count > 0) {
        [self performSegueWithIdentifier:@"PasaportePagerSellosSegue" sender:@"Ver Sellos"];
    }
    else{
        /* HAGO UN ALERT */
        NSString *titulo = @"Pasaporte Run4Beer";
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:titulo
        message:@"Aún no has metido ningún pasaporte"
        delegate:self
        cancelButtonTitle:@"OK"
        otherButtonTitles: nil];
        [alert show];
        /* FIN HAGO UN ALERT */
    }
    
    
}

- (void)buttonVerificarCodigoPressed:(UIButton *)button {
    //NSLog(@"Button Pressed");
    
    NSString *codigoIntroducido = self.textField.text;
    NSString *key = @"1687b6bc2c9389c33";
    NSString *codigoTotalKey;
    
    //NSLog(@"Has metido: %@",codigoIntroducido);
    
    //codigoIntroducido = @"123456";
    
    codigoTotalKey = [NSString stringWithFormat:@"%@%@",key,codigoIntroducido];
    
    self.codigoTotalKeySHA1 = [self sha1:codigoTotalKey];
    
    //NSLog(@"El SHA1 total es: %@",self.codigoTotalKeySHA1);
    //3f5353a7e505540c9be457c29bf4b2927d6171ef
    //3f5353a7e505540c9be457c29bf4b2927d6171ef
    
    //Compruebo el JSON
    NSURLSessionConfiguration *config =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config
                                             delegate:nil
                                        delegateQueue:nil];
    [self fetchFeed];
    
    sleep(2);
    
    /* HAGO UN ALERT */
    NSString *titulo = @"Pasaporte Run4Beer";
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:titulo
                                                     message:self.resultado
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles: nil];
    [alert show];
    /* FIN HAGO UN ALERT */
    
}

-(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

- (void)fetchFeed
{
    NSString *requestString = [NSString stringWithFormat:@"http://run4beer.beerrunners.es/api/bares/pasaporte/%@",self.codigoTotalKeySHA1];;
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithRequest:req
                    completionHandler:
     ^(NSData *data, NSURLResponse *response, NSError *error) {
         NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:0
                                                                      error:nil];
         self.bares = jsonObject[@"bares"];

         if ([jsonObject[@"total"] integerValue] > 0) {
             //La url de la uimagen es api/pasaporte/"url".
             for (NSDictionary *dictionary in self.bares){
                 NSLog(@"URL: %@",dictionary[@"url"]);
                 /* Guardo la foto */
                 NSString *cartelURL = dictionary[@"url"];
                 NSString *cartelId = dictionary[@"id"];
                 
                 NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                 
                 NSString *imgName = [NSString stringWithFormat:@"Pasaporte/%@",cartelURL];
                 NSString *imgURL = [NSString stringWithFormat:@"http://run4beer.beerrunners.es/api/pasaporte/%@",cartelURL];
                 NSFileManager *fileManager = [NSFileManager defaultManager];
                 NSString *motivDir = [documentsDirectoryPath stringByAppendingPathComponent:@"Pasaporte"];
                 if ([fileManager createDirectoryAtPath:motivDir withIntermediateDirectories:YES
                                             attributes:nil error: NULL] == NO)
                 {
                     // Failed to create directory
                     NSLog(@"Failed to create directory");
                 }
                 
                 NSString *writablePath = [documentsDirectoryPath stringByAppendingPathComponent:imgName];
                 
                 if(![fileManager fileExistsAtPath:writablePath]){
                     // file doesn't exist
                     NSLog(@"file doesn't exist");
                     
                     //save Image From URL
                     NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString: imgURL]];
                     
                     NSError *error = nil;
                     [data writeToFile:[documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imgName]] options:NSAtomicWrite error:&error];
                     
                     if (error) {
                         NSLog(@"Error Writing File : %@",error);
                     }else{
                         NSLog(@"Image %@ Saved SuccessFully with id %@",imgName, cartelId);
                         self.resultado = @"Pasaporte insertado con éxito";
                     }
                 }
                 else{
                     // file exist
                     NSLog(@"file exist %@",writablePath);
                     self.resultado = @"Ya has insertado este pasaporte";
                 }
                 /* FIN Guardo la foto */
             }
         }
         
     }];
    [dataTask resume];
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
}

@end

