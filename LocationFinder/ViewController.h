//
//  ViewController.h
//  LocationFinder
//
//  Created by Abhijit Sapkal on 28/03/17.
//  Copyright © 2017 TheAppGuruz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PRAugmentedReality/PRARManager.h>

@interface ViewController : UIViewController<PRARManagerDelegate>
{
    IBOutlet UIView *loadingV;
}
@property (nonatomic ,strong)NSArray *dic;
@property(nonatomic,strong)CLLocation *Curruntlocation;
@end
