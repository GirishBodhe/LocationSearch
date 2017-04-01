//
//  LocationFinderViewController.m
//  LocationFinder
//
//  Created by TheAppGuruz-iOS-103 on 15/05/14.
//  Copyright (c) 2014 TheAppGuruz. All rights reserved.
//

#import "LocationFinderViewController.h"
#import <FTGooglePlacesAPI/FTGooglePlacesAPI.h>
#import "ViewController.h"

@import Firebase;
@import FirebaseAuth;

@interface LocationFinderViewController ()
{
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}
@property(nonatomic,strong)NSMutableArray *place1;
@property(nonatomic,strong)CLLocation *location;
@end


@implementation LocationFinderViewController
@synthesize locationManager;
@synthesize txtState, txtLatitude, txtLongitude, txtCountry;

#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    //AIzaSyBDlaMiDp3WT4Y_l9Ats-y_wbHcSJZKJTU
    
    [super viewDidLoad];
    geocoder = [[CLGeocoder alloc] init];
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager.delegate = self;
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Turn off the location manager to save power.
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManager delegate methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    CLLocation *newLocation = [locations lastObject];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
           
            txtState.text = placemark.administrativeArea;
            txtCountry.text = placemark.country;
            //  Create location around which to search (hardcoded location of Big Ben here)
//            CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(19.159960,72.997286);
 CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude,newLocation.coordinate.longitude);
            //  Create request searching nearest galleries and museums
            FTGooglePlacesAPINearbySearchRequest *request = [[FTGooglePlacesAPINearbySearchRequest alloc] initWithLocationCoordinate:locationCoordinate];
            request.rankBy = FTGooglePlacesAPIRequestParamRankByDistance;
            request.types = @[@"art_gallery", @"museum",@"hotel",@"school",@"hospital"];
            //  Execute Google Places API request using FTGooglePlacesAPIService
            [FTGooglePlacesAPIService executeSearchRequest:request
                                     withCompletionHandler:^(FTGooglePlacesAPISearchResponse *response, NSError *error) {
                                         
                                         //  If error is not nil, request failed and you should handle the error
                                         if (error)
                                         {
                                             // Handle error here
                                             NSLog(@"Request failed. Error: %@", error);
                                             
                                             //  There may be a lot of causes for an error (for example networking error).
                                             //  If the network communication with Google Places API was successfull,
                                             //  but the API returned some non-ok status code, NSError will have
                                             //  FTGooglePlacesAPIErrorDomain domain and status code from
                                             //  FTGooglePlacesAPIResponseStatus enum
                                             //  You can inspect error's domain and status code for more detailed info
                                         }
                                         
                                         //  Everything went fine, we have response object we can process
                                        // NSLog(@"Request succeeded. Response: %@",[response.results firstObject]);
                                         _place1 = [[NSMutableArray alloc]init];
                                         for (FTGooglePlacesAPISearchResultItem * places in response.results) {
                                             [_place1 addObject:[places originalDictionaryRepresentation]];
                                             
                                         }
                                         NSLog(@"%@", _place1);
                                         for (NSDictionary *dic in _place1) {
                                             
                                             
                                             NSLog(@" %@",dic);
                                         }
                                         txtLatitude.text = [NSString stringWithFormat:@"%f ",newLocation.coordinate.latitude];
                                         txtLongitude.text = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
                                         
                                         self.location = newLocation;

                                     }];
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
    // Turn off the location manager to save power.
    [manager stopUpdatingLocation];
}
- (IBAction)SignOut:(id)sender {

    [[FIRAuth auth] signOut:nil];
    NSString * storyboardName = @"Main_iPhone";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"SignInSignUpViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    

}

- (void)locationManager:(CLLocationManager *)manager
        didFailWithError:(NSError *)error
{
    NSLog(@"Cannot find the location.");
}

- (IBAction)placeButton:(id)sender {
    
    [self performSegueWithIdentifier:@"place" sender:sender];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"place"])
    {
        // Get reference to the destination view controller
        ViewController *vc = [segue destinationViewController];
        vc.dic=_place1;
        vc.Curruntlocation = self.location;
        NSLog(@"%@",_place1);
        // Pass any objects to the view controller here, like...
        
    }
}

@end
