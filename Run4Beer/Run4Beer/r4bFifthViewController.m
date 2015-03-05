//
//  r4bFifthViewController.m
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 08/09/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import "r4bFifthViewController.h"
#import "objc/runtime.h"

@interface r4bFifthViewController ()
    @property (nonatomic) NSURLSession *session;
    @property (nonatomic, copy) NSArray *bares;
    @property (nonatomic) NSInteger yaMostradaLocalizacion;
    @property (nonatomic) UIAlertView *alert;
    @property (nonatomic) MKCoordinateRegion regionMadrid;
@end

@implementation r4bFifthViewController

const char webSeleccionadoAlert;
const char socialSeleccionadoAlert;

@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.regionMadrid = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.416947,-3.703528), 5000, 5000);
    
    //UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    // Add an action in current code file (i.e. target)
    [self.button addTarget:self action:@selector(buttonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    
    self.yaMostradaLocalizacion = 0;
        
    /* Pongo los bares en el mapa */    
    NSData *elJsonGuardado;
    elJsonGuardado = [self getSavedJsonData];
    
    NSDictionary *jsonEnDisco=[NSJSONSerialization
                               JSONObjectWithData:elJsonGuardado
                               options:NSJSONReadingMutableLeaves
                               error:nil];
    
    CLLocationCoordinate2D location;                         // coordinates of the annotation
    NSMutableArray *newAnnotations = [NSMutableArray array]; // an array in which we'll save our annotations temporarily
    MKPointAnnotation *newAnnotation;
    
    for (NSDictionary *dictionary in jsonEnDisco[@"all"][@"bares"])
    {
        if (dictionary[@"lat"] == (id)[NSNull null] || dictionary[@"lng"] == (id)[NSNull null]) {
            //NSLog(@"ID null: %@",dictionary[@"id"]);
            continue;
        }
        // retrieve latitude and longitude from the dictionary entry
        location.latitude = [dictionary[@"lat"] doubleValue];
        location.longitude = [dictionary[@"lng"] doubleValue];
        
        // create the annotation
        newAnnotation = [[MKPointAnnotation alloc] init];
        newAnnotation.title = dictionary[@"name"];
        newAnnotation.subtitle = dictionary[@"address"];
        newAnnotation.accessibilityLabel = dictionary[@"id"];
        newAnnotation.coordinate = location;
        
        [newAnnotations addObject:newAnnotation];
 
    }
    // when done, add the annotations
    [self.mapView addAnnotations:newAnnotations];
    /* FIN Pongo los bares en el mapa */

    self.mapView.delegate = self;

    self.locationManager.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }

    [self.locationManager startUpdatingLocation];

    mapView.showsUserLocation = YES;
    
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    
    
    

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


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (self.yaMostradaLocalizacion != 1) {
                
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 5000, 5000);
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
        // Add an annotation
        /*
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = userLocation.coordinate;
        point.title = @"Estás aquí";
        //point.subtitle = @"I'm here!!!";
    
        [self.mapView addAnnotation:point];
         */
        self.yaMostradaLocalizacion = 1;
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    MKAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation)
    {
        static NSString *defaultPinID = @"Ber Ruuners Bar Pin";
        pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        //pinView.pinColor = MKPinAnnotationColorGreen;
        pinView.canShowCallout = YES;
        //pinView.animatesDrop = YES;
        
        
        UIImage * img = [UIImage imageNamed:@"pinMapR4B"] ;
        CGRect resizeRect;
        resizeRect.size.height = 40;
        resizeRect.size.width = 25;
        resizeRect.origin = (CGPoint){0.0f, 0.0f};
        UIGraphicsBeginImageContext(resizeRect.size);
        [img drawInRect:resizeRect];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        pinView.image = resizedImage;

        //pinView.image = [UIImage imageNamed:@"pinMap.png"];    //as suggested by Squatch
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        //rightButton.tag =
        pinView.rightCalloutAccessoryView = rightButton;
        
        // Add a custom image to the left side of the callout.
        UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pinViewImageR4B"]];
        pinView.leftCalloutAccessoryView = myCustomImage;
    }
    return pinView;
}

- (void) mapView: (MKMapView *) mapView annotationView: (MKAnnotationView *) view calloutAccessoryControlTapped: (UIControl *) control {

    MKPointAnnotation *newAnnotation = view.annotation;
    //NSLog(@"accessibilityLabel = %@", newAnnotation.accessibilityLabel);
    NSString * reciboBar = newAnnotation.accessibilityLabel;
    if (![reciboBar isKindOfClass:[NSNull class]] && reciboBar != nil ) {
        NSString *name;
        NSString *address;
        NSString *web;
        NSString *redsocial;
        NSString *type;
    
        NSData *elJsonGuardado;
        elJsonGuardado = [self getSavedJsonData];
    
        NSDictionary *jsonEnDisco=[NSJSONSerialization
                               JSONObjectWithData:elJsonGuardado
                               options:NSJSONReadingMutableLeaves
                               error:nil];
    
        for (id key in jsonEnDisco[@"all"][@"bares"]) {
            //NSLog(@"There are %@ %@'s in stock", jsonEnDisco[@"all"][@"bares"][key], key);
            if ([key[@"id"] isEqualToString:newAnnotation.accessibilityLabel]) {
                name = key[@"name"];
                address = key[@"address"];
                web = key[@"web"];
                redsocial = key[@"redsocial"];
                type = key[@"type"];
            }
        }
    
        NSString *mensajeDatosTotales = @"";

        if (![address isEqual: @""] && ![address isKindOfClass:[NSNull class]]) {
            mensajeDatosTotales = [mensajeDatosTotales stringByAppendingString:[NSString stringWithFormat:@"\nDirección: %@\n", address]];
        }

        /*if (![web isEqual: @""] && ![web isKindOfClass:[NSNull class]]) {
            mensajeDatosTotales = [mensajeDatosTotales stringByAppendingString:[NSString stringWithFormat:@"\nWeb: %@\n", web]];
         }*/

        /*if (![redsocial isEqual: @""] && ![redsocial isKindOfClass:[NSNull class]]) {
            mensajeDatosTotales = [mensajeDatosTotales stringByAppendingString:[NSString stringWithFormat:@"\nSocial: %@\n", redsocial]];
         }*/
    
        /*if (![type isEqual: @""] && ![type isKindOfClass:[NSNull class]]) {
            mensajeDatosTotales = [mensajeDatosTotales stringByAppendingString:[NSString stringWithFormat:@"\nTipo de local: %@\n", type]];
         }*/
    
    
    
        /* HAGO UN ALERT */
        NSString *titulo = [NSString stringWithFormat:@"%@", name];
        self.alert =[[UIAlertView alloc ] initWithTitle:titulo
                                                    message:mensajeDatosTotales
                                                    delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        if (![redsocial isEqual: @""] && ![redsocial isKindOfClass:[NSNull class]]) {
            [self.alert addButtonWithTitle:@"Facebook"];
        }
        if (![web isEqual: @""] && ![web isKindOfClass:[NSNull class]]) {
            [self.alert addButtonWithTitle:@"Web"];
        }
        [self.alert show];
        objc_setAssociatedObject(self.alert, &webSeleccionadoAlert, web, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self.alert, &socialSeleccionadoAlert, redsocial, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    /* FIN HAGO UN ALERT */
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //NSLog(@"Button Index =%ld",(long)buttonIndex);
    
    NSString *txtWebSeleccionadoAlert = objc_getAssociatedObject(alertView, &webSeleccionadoAlert);
    NSString *txtSocialSeleccionadoAlert = objc_getAssociatedObject(alertView, &socialSeleccionadoAlert);
    
    if (buttonIndex == 0)
    {
        //Ha dado a CANCEL, no hago nada
    }
    else if(buttonIndex == 1)
    {
        //Ha dado a FACEBOOK
        //NSLog(@"Abrir facebook: %@",txtSocialSeleccionadoAlert);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:txtSocialSeleccionadoAlert]];
    }
    else if(buttonIndex == 2)
    {
        //Ha dado a WEB
        //NSLog(@"Abrir web: %@",txtWebSeleccionadoAlert);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:txtWebSeleccionadoAlert]];
    }
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone; //Whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    //View Area
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.regionMadrid.center, 5000, 5000);
    //MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span.longitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    //[mapView setRegion:region animated:YES];
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        [mapView setRegion:region animated:YES];
    }
    else{
        [mapView setRegion:self.regionMadrid animated:YES];
    }
    
}

- (void)buttonPressed:(UIButton *)button {
    //NSLog(@"Button Pressed");
    self.locationManager.distanceFilter = kCLDistanceFilterNone; //Whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    //View Area
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.regionMadrid.center, 5000, 5000);
    //MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span.longitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        [mapView setRegion:region animated:YES];
    }
    else{
        [mapView setRegion:self.regionMadrid animated:YES];
    }
    

}


@end
