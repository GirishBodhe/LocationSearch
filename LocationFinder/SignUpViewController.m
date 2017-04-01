//
//  SignUpViewController.m
//  LocationFinder
//
//  Created by Abhijit Sapkal on 01/04/17.
//  Copyright © 2017 TheAppGuruz. All rights reserved.
//

#import "SignUpViewController.h"
@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;
@interface SignUpViewController ()

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *reEnterPasswordTextField;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signUp:(id)sender {
    
    if (![self.passwordTextField.text isEqualToString:self.reEnterPasswordTextField.text]) {
     
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                 message:@"Password is not equal."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];

        
    }else
    {
    
    [[FIRAuth auth]
     createUserWithEmail:self.emailIdTextField.text
     password:self.passwordTextField.text
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
             
             [[[_ref child:@"users"] child:user.uid]
              setValue:@{@"Name": self.nameTextField.text ,@"Email ": self.emailIdTextField.text ,@"Password":self.passwordTextField.text}];
             
             NSString * storyboardName = @"Main_iPhone";
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
             UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"LocationFinderViewController"];
             
             [self presentViewController:vc animated:YES completion:nil];
         
         }
        
     }];
    }
}
- (IBAction)cancle:(id)sender {

   [self.navigationController popToRootViewControllerAnimated:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
