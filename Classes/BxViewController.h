//
//  BxViewController.h
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

@interface BxViewController : UIViewController <ZXingDelegate> {
	
	IBOutlet UITextField *spendBtc;
	IBOutlet UILabel *btcAvail;
	IBOutlet UILabel *btcRes;
	IBOutlet UILabel *curAvail;
	IBOutlet UILabel *curRes;
    IBOutlet UILabel *curLabel;
    IBOutlet UILabel *marginBtc;
    IBOutlet UILabel *marginCur;
    IBOutlet UITableView *orderTable;
    IBOutlet UISegmentedControl *buySell;
    IBOutlet UITextField *numBtc;
    IBOutlet UITextField *limitPrice;
    IBOutlet UIButton *go;
    IBOutlet UIActivityIndicatorView *refreshAct;
    IBOutlet UILabel *scrollingTick;
    NSMutableArray *orderList;
    NSString *userPerm;
    NSString *passPerm;
    NSString *curPerm;
    NSMutableArray *orderDic;
    NSTimer *allTimer;
    NSString *apiURL;
    NSString *sendBtc;
    NSString *tempType;
    double lastTicker;
    int oid;
    NSMutableDictionary *dataCons;
    NSNumberFormatter *frmtr;
    int actRun;
    IBOutlet UIButton *logOffButton;
}

@property (nonatomic, retain) UITextField *spendBtc;
@property (nonatomic, retain) UILabel *btcAvail;
@property (nonatomic, retain) UILabel *btcRes;
@property (nonatomic, retain) UILabel *curAvail;
@property (nonatomic, retain) UILabel *curRes;
@property (nonatomic, retain) UILabel *curLabel;
@property (nonatomic, retain) UILabel *marginBtc;
@property (nonatomic, retain) UILabel *marginCur;
@property (nonatomic, retain) UILabel *scrollingTick;
@property (nonatomic, retain) UITableView *orderTable;
@property (nonatomic, retain) UITextField *numBtc;
@property (nonatomic, retain) UITextField *limitPrice;
@property (nonatomic, retain) UISegmentedControl *buySell;
@property (nonatomic, retain) UIButton *go;
@property (nonatomic, retain) NSString *userPerm;
@property (nonatomic, retain) NSString *passPerm;
@property (nonatomic, retain) NSString *curPerm;
@property (nonatomic, retain) NSMutableArray *orderList;
@property (nonatomic, retain) UIActivityIndicatorView *refreshAct;
@property (nonatomic, retain) NSTimer *allTimer;
@property (nonatomic, retain) NSString *apiURL;
@property (nonatomic, retain) NSString *sendBtc;
@property (nonatomic, retain) NSString *tempType;
@property (nonatomic, retain) NSMutableArray *orderDic;
@property (nonatomic, assign) double lastTicker;
@property (nonatomic, assign) int oid;
@property (nonatomic, retain) NSMutableDictionary *dataCons;
@property (nonatomic, retain) NSNumberFormatter *frmtr;
@property (nonatomic, assign) int actRun;
@property (nonatomic, retain) UIButton *logOffButton;

- (void) initOrderView: (NSDictionary *) feed: (NSString *)user: (NSString *)pass: (NSString *)currency;
- (void) placeOrder: (NSString *) num: (NSString *)pri;
- (IBAction) confirmTrade: (id)sender;
- (IBAction) reloadAll :(id)sender;
- (void) cancelOrder;
- (void) loadTicker;
- (void) loadBalance;
- (void) loadOrders;
- (IBAction) payBtc: (id)sender;
- (void) payBtcInit: (NSString *) btca;
- (void) errorAlert: (NSString *) error;
- (IBAction) logOff:(id)sender;
- (bool) reset;

@end
