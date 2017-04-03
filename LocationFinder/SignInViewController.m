//
//  SignInViewController.m
//  LocationFinder
//
//  Created by Abhijit Sapkal on 01/04/17.
//  Copyright © 2017 TheAppGuruz. All rights reserved.
//

#import "SignInViewController.h"
<<<<<<< HEAD
@import Firebase;
@import FirebaseAuth;
@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailidTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwaordTextField;
=======

@interface SignInViewController ()
>>>>>>> origin/master

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
<<<<<<< HEAD
- (IBAction)SignIn:(id)sender {
    
    [[FIRAuth auth]
     signInWithEmail:self.emailidTextField.text
     password:self.passwaordTextField.text
     completion:^(FIRUser *_Nullable user,
                  NSError *_Nullable error) {
         
         if (error) {
             
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                      message:@"Check Email Id & Password"
                                                                               preferredStyle:UIAlertControllerStyleAlert];
             //We add buttons to the alert controller by creating UIAlertActions:
             UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil]; //You can use a block here to handle a press on this button
             [alertController addAction:actionOk];
             [self presentViewController:alertController animated:YES completion:nil];
             
         }else
         {
             NSString * storyboardName = @"Main_iPhone";
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
             UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"LocationFinderViewController"];
             
             [self presentViewController:vc animated:YES completion:nil];
             
         }
         
     }];
    

}
- (IBAction)cancle:(id)sender {
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}
=======
>>>>>>> origin/master

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
