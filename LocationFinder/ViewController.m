//
//  ViewController.m
//  StreetAwareness
//
//  Created by Abhijit Sapkal on 04/03/17.
//  Copyright © 2017 Girish Developer. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@import GooglePlaces;
@import GooglePlacePicker;

#define NUMBER_OF_POINTS    20

@interface ViewController ()<CLLocationManagerDelegate>{
    GMSPlacePicker *_placePicker;
    CLLocationManager *locationManager;
}

@property (nonatomic, strong) PRARManager *prARManager;
@end

@implementation ViewController


- (void)alert:(NSString*)title withDetails:(NSString*)details {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:details
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"DIC - %@", _dic);
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    else
        [locationManager startUpdatingLocation];
    // Initialize the manager so it wakes up (can do this anywhere you want
    // self.prARManager = [[PRARManager alloc] initWithSize:self.view.frame.size delegate:self showRadar:YES];
    // self.prARManager = [PRARManager sharedManager];
    [PRARManager sharedManagerWithRadarAndSize:self.view.frame.size andDelegate:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    // Initialize your current location as 0,0 (since it works with our randomly generated locations)
    CLLocationCoordinate2D locationCoordinates = CLLocationCoordinate2DMake(self.Curruntlocation.coordinate.latitude, self.Curruntlocation.coordinate.longitude);
    
    [[PRARManager sharedManager] startARWithData:[self getDummyData] forLocation:locationCoordinates];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}


#pragma mark - Dummy AR Data

// Creates data for `NUMBER_OF_POINTS` AR Objects
-(NSArray*)getDummyData
{
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:[_dic count]];
    
    
    srand48(time(0));
        for (int i=0; i<[_dic count]; i++)
        {
            NSDictionary *dic1 = [_dic objectAtIndex:i];
        
            CLLocationCoordinate2D pointCoordinates ;
          //  NSNumber *lat =dic1[@"geometry"][@"location"][@"lat"];
            pointCoordinates.latitude=  [[[[dic1 valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"]floatValue];
            
           
            
            //NSNumber *lng =dic1[@"geometry"][@"location"][@"lng"];
             pointCoordinates.longitude=  [[[[dic1 valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"]floatValue];
            NSLog(@" location %f %f ", pointCoordinates.latitude , pointCoordinates.longitude);
           
//            
//            [point setObject:dic1[@"name"] forKey:@"title"];
//            [point setObject:dic1[@"geometry"][@"location"][@"lng"] forKey:@"lon"];
//            [point setObject:dic1[@"geometry"][@"location"][@"lat"] forKey:@"lat"];
//            [point setObject:@(the_id) forKey:@"id"];

            [points addObject:[self createPointWithId:i at:pointCoordinates]];
        }
    

//        CLLocationCoordinate2D pointCoordinates = [self getRandomLocation];
//        
//        NSDictionary *point = [self createPointWithId:i at:pointCoordinates];
//        [points addObject:point];
//    }
//    
    return [NSArray arrayWithArray:points];
}

// Returns a random location
-(CLLocationCoordinate2D)getRandomLocation
{
    double latRand = drand48() * 90.0;
    double lonRand = drand48() * 180.0;
    double latSign = drand48();
    double lonSign = drand48();
    
    CLLocationCoordinate2D locCoordinates = CLLocationCoordinate2DMake(latSign > 0.5 ? latRand : -latRand,
                                                                       lonSign > 0.5 ? lonRand*2 : -lonRand*2);
    return locCoordinates;
}

// Creates the Data for an AR Object at a given location
-(NSDictionary*)createPointWithId:(int)the_id at:(CLLocationCoordinate2D)locCoordinates
{
//    NSMutableDictionary *point = [[NSMutableDictionary alloc]init];
//    for (NSDictionary *dic1 in _dic) {
//        
//        [point setObject:dic1[@"name"] forKey:@"title"];
//        [point setObject:dic1[@"geometry"][@"location"][@"lng"] forKey:@"lon"];
//        [point setObject:dic1[@"geometry"][@"location"][@"lat"] forKey:@"lat"];
//        [point setObject:@(the_id) forKey:@"id"];
//        
//    }
//    
   
    
    NSDictionary *point = @{
                            @"id" : @(the_id),
                            @"title" :[_dic objectAtIndex:the_id][@"name"] ,
                            @"lon" :  [[[[_dic objectAtIndex:the_id] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"],
                            @"lat" :  [[[[_dic objectAtIndex:the_id] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"]
                            };
    return point;
}


#pragma mark - PRARManager Delegate

-(void)prarDidSetupAR:(UIView *)arView withCameraLayer:(AVCaptureVideoPreviewLayer *)cameraLayer andRadarView:(UIView *)radar
{
    NSLog(@"Finished displaying ARObjects");
    
    [self.view.layer addSublayer:cameraLayer];
    [self.view addSubview:arView];
    
    [self.view bringSubviewToFront:[self.view viewWithTag:AR_VIEW_TAG]];
    
    [self.view addSubview:radar];
    
    [loadingV setHidden:YES];
}

-(void)prarUpdateFrame:(CGRect)arViewFrame
{
    [[self.view viewWithTag:AR_VIEW_TAG] setFrame:arViewFrame];
}

-(void)prarGotProblem:(NSString *)problemTitle withDetails:(NSString *)problemDetails
{
    [loadingV setHidden:YES];
    [self alert:problemTitle withDetails:problemDetails];
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK"  otherButtonTitles:nil];
    [errorAlert show];
}
@end
