//
//  r4bFifthViewController.h
//  Run4Beer
//
//  Created by Javier Hernanz Arnaiz on 08/09/14.
//  Copyright (c) 2014 Javier Hernanz Arnaiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

extern const char webSeleccionadoAlert;
extern const char socialSeleccionadoAlert;

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface r4bFifthViewController : UIViewController <MKMapViewDelegate,  CLLocationManagerDelegate>

    @property (nonatomic, strong) IBOutlet MKMapView *mapView;
    @property(nonatomic, retain) CLLocationManager *locationManager;
    @property (nonatomic, weak) IBOutlet UIButton *button;

@end
