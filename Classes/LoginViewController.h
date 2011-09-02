//
//  LoginViewController.h
//  BitcoinTrader
//
//  Created by Tyler Richey on 7/17/11.
//  Copyright 2011 Tyler Richey. All rights reserved.
//
//  This file is part of BitcoinTrader.
//
//  BitcoinTrader is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  BitcoinTrader is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with BitcoinTrader.  If not, see <http://www.gnu.org/licenses/>.

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"
#import "IWViewController.h"
#import "ExchbViewController.h"
#import "THViewController.h"
#import "BxViewController.h"
#import "GoxViewController.h"

@interface LoginViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, ZXingDelegate> {
    
    IBOutlet UIScrollView *scrollView;
	IBOutlet UITextField *usernameField;
	IBOutlet UITextField *passwordField;
	IBOutlet UIButton *loginButton;
    IBOutlet UIButton *goButton;
	IBOutlet UIActivityIndicatorView *loginIndicator;
	IBOutlet UILabel *loginStatus;
    IBOutlet UIPickerView *curPick;
    IBOutlet UISegmentedControl *apiPick;
    IBOutlet UIButton *scanButton;   
    IBOutlet UIButton *newWallet;
    IBOutlet UITableView *scanList;
    IBOutlet UIButton *about;
    IBOutlet UILabel *begin;
    IBOutlet UITextField *pin;
    THViewController *thViewController;
    BxViewController *bxViewController;
    ExchbViewController *exchbViewController;
    IWViewController *iwViewController;
    GoxViewController *goxViewController;
    NSMutableArray *cur;
    NSString *currency;
    NSString *apiURL;
    NSUserDefaults *prefs;
    int goxID;
    NSString *importWal;
    NSString *tempSec;
    NSString *tempKey;
    
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UITextField *usernameField;
@property (nonatomic, retain) UITextField *passwordField;
@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) UIButton *goButton;
@property (nonatomic, retain) UIActivityIndicatorView *loginIndicator;
@property (nonatomic, retain) UILabel *loginStatus;
@property (nonatomic, retain) UIPickerView *curPick;
@property (nonatomic, retain) THViewController *thViewController;
@property (nonatomic, retain) BxViewController *bxViewController;
@property (nonatomic, retain) ExchbViewController *exchbViewController;
@property (nonatomic, retain) IWViewController *iwViewController;
@property (nonatomic, retain) GoxViewController *goxViewController;
@property (nonatomic, retain) NSString *currency;
@property (nonatomic, retain) UISegmentedControl *apiPick;
@property (nonatomic, retain) NSString *apiURL;
@property (nonatomic, retain) UIButton *scanButton;
@property (nonatomic, retain) UITableView *scanList;
@property (nonatomic, retain) UIButton *about;
@property (nonatomic, retain) UIButton *newWallet;
@property (nonatomic, retain) UILabel *begin;
@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) UITextField *pin;
@property (nonatomic, assign) int goxID;
@property (nonatomic, retain) NSString *importWal;
@property (nonatomic, retain) NSMutableArray *cur;
@property (nonatomic, retain) NSString *tempSec;
@property (nonatomic, retain) NSString *tempKey;

- (IBAction) login: (id) sender;
- (IBAction) about: (id)sender;
- (IBAction) apiSet: (id)sender;
- (IBAction) activate: (id)sender;
- (IBAction) createWallet: (id)sender;
- (IBAction) goPin:(id)sender;

@end
