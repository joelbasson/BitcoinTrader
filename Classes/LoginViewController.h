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
//  Foobar is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with BitcoinTrader.  If not, see <http://www.gnu.org/licenses/>.

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	IBOutlet UITextField *usernameField;
	IBOutlet UITextField *passwordField;
	IBOutlet UIButton *loginButton;
	IBOutlet UIActivityIndicatorView *loginIndicator;
	IBOutlet UILabel *loginStatus;
    IBOutlet UIPickerView *curPick;
    OrderViewController *orderViewController;
    NSMutableArray *cur;
    NSString *currency;
}

@property (nonatomic, retain) UITextField *usernameField;
@property (nonatomic, retain) UITextField *passwordField;
@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) UIActivityIndicatorView *loginIndicator;
@property (nonatomic, retain) UILabel *loginStatus;
@property (nonatomic, retain) UIPickerView *curPick;
@property (nonatomic, retain) OrderViewController *orderViewController;
@property (nonatomic, retain) NSString *currency;

- (IBAction) login: (id) sender;

@end
