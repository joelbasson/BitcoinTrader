//
//  IWViewController.h
//  BitcoinTrader
//
//  Created by Tyler Richey on 7/20/11.
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

@interface IWViewController : UIViewController <ZXingDelegate> {
	
	IBOutlet UILabel *btcPrice;
	IBOutlet UILabel *btcAvail;
    IBOutlet UILabel *address;
    IBOutlet UIButton *pay;
    IBOutlet UIActivityIndicatorView *refreshAct;
    IBOutlet UITextField *spendBtc;
    IBOutlet UISwitch *greenAddress;
    NSString *sendBtc;
    NSString *apiURL;
    NSString *walletID;
    NSUserDefaults *prefs;
    NSTimer *allTimer;
    double lastTicker;
    NSMutableDictionary *dataCons;
    NSNumberFormatter *frmtr;
    IBOutlet UIButton *addressButton;
    NSString *savedAddress;
    int actRun;
    IBOutlet UIButton *logOffButton;
    
}

@property (nonatomic, retain) UILabel *btcPrice;
@property (nonatomic, retain) UILabel *btcAvail;
@property (nonatomic, retain) UIButton *pay;
@property (nonatomic, retain) NSString *sendBtc;
@property (nonatomic, retain) UIActivityIndicatorView *refreshAct;
@property (nonatomic, retain) NSString *apiURL;
@property (nonatomic, retain) UITextField *spendBtc;
@property (nonatomic, retain) UIButton *iButton;
@property (nonatomic, retain) UIButton *logOffButton;
@property (nonatomic, retain) NSString *walletID;
@property (nonatomic, retain) UISwitch *greenAddress;
@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) NSTimer *allTimer;
@property (nonatomic, assign) double lastTicker;
@property (nonatomic, retain) NSMutableDictionary *dataCons;
@property (nonatomic, retain) NSNumberFormatter *frmtr;
@property (nonatomic, retain) UILabel *address;
@property (nonatomic, retain) UIButton *addressButton;
@property (nonatomic, retain) NSString *savedAddress;
@property (nonatomic, assign) int actRun;

- (IBAction) moreTicker: (id)sender;
- (IBAction) reloadAll: (id)sender;
- (IBAction) payBtc: (id)sender;
- (IBAction) logOff:(id)sender;
- (void) loadTicker;
- (void) loadBalance;
- (void) payBtcInit: (NSString *) btca;
- (void) errorAlert: (NSString *) error;
- (void) newWallet;
- (void) setWallet:(NSString *)wID;
- (void) loadAddress;
- (IBAction)removeWallet:(id)sender;
- (bool) reset;

@end
