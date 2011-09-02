//
//  GoxViewController.h
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


@interface GoxViewController : UIViewController <ZXingDelegate> {
	
	IBOutlet UILabel *btcPrice;
	IBOutlet UILabel *btcAvail;
    IBOutlet UILabel *curAvail;
    IBOutlet UILabel *curLabel;    
    IBOutlet UITableView *orderTable;
    IBOutlet UISegmentedControl *buySell;
    IBOutlet UITextField *numBtc;
    IBOutlet UITextField *limitPrice;
    IBOutlet UIButton *go;
    IBOutlet UIButton *goPay;
    IBOutlet UIButton *logOffButton;
    IBOutlet UIActivityIndicatorView *refreshAct;
    IBOutlet UILabel *scrollingTick;
    NSMutableArray *orderList;
    NSString *curPerm;
    NSMutableArray *newOrders;
    NSString *apiURL;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *spendBtc;
    NSString *sendBtc;
    NSString *permKey;
    NSString *permSec;
    NSUserDefaults *prefs;
    IBOutlet UILabel *orderLabel;
    int accID;
    NSMutableArray *orderDic;
    NSString *sOid;
    IBOutlet UISegmentedControl *ordersFunds;
    IBOutlet UISegmentedControl *depWith;
    IBOutlet UIButton *depAdd;
    IBOutlet UIButton *dwolla;
    IBOutlet UITextField *withdrawAmt;
    bool loading;
    bool canWith;
    bool canDep;
    int i;
    int length;
    double lastTicker;
    NSMutableDictionary *dataCons;
    NSNumberFormatter *frmtr;
    NSDictionary *scrollingFeed;
    IBOutlet UIButton *addressButton;
    int actRun;
}

@property (nonatomic, retain) UILabel *btcPrice;
@property (nonatomic, retain) UILabel *btcAvail;
@property (nonatomic, retain) UILabel *curAvail;
@property (nonatomic, retain) UILabel *curLabel;
@property (nonatomic, retain) UILabel *scrollingTick;
@property (nonatomic, retain) UITableView *orderTable;
@property (nonatomic, retain) UITextField *numBtc;
@property (nonatomic, retain) UITextField *limitPrice;
@property (nonatomic, retain) UISegmentedControl *buySell;
@property (nonatomic, retain) UIButton *go;
@property (nonatomic, retain) UIButton *goPay;
@property (nonatomic, retain) NSString *curPerm;
@property (nonatomic, retain) NSMutableArray *orderList;
@property (nonatomic, retain) NSMutableArray *newOrders;
@property (nonatomic, retain) UIActivityIndicatorView *refreshAct;
@property (nonatomic, retain) NSTimer *tickTimer;
@property (nonatomic, retain) NSTimer *allTimer;
@property (nonatomic, retain) NSString *apiURL;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSString *sendBtc;
@property (nonatomic, retain) UITextField *spendBtc;
@property (nonatomic, retain) NSString *permKey;
@property (nonatomic, retain) NSString *permSec;
@property (nonatomic, retain) NSUserDefaults *prefs;
@property (nonatomic, retain) UILabel *orderLabel;
@property (nonatomic, assign) int accID;
@property (nonatomic, retain) NSMutableArray *orderDic;
@property (nonatomic, retain) NSString *sOid;
@property (nonatomic, retain) UISegmentedControl *ordersFunds;
@property (nonatomic, retain) UISegmentedControl *depWith;
@property (nonatomic, retain) UIButton *dwolla;
@property (nonatomic, retain) UIButton *depAdd;
@property (nonatomic, retain) UIButton *logOffButton;
@property (nonatomic, retain) UITextField *withdrawAmt;
@property (nonatomic, assign) bool loading;
@property (nonatomic, assign) bool canWith;
@property (nonatomic, assign) bool canDep;
@property (nonatomic, assign) double lastTicker;
@property (nonatomic, assign) int i;
@property (nonatomic, assign) int length;
@property (nonatomic, retain) NSMutableDictionary *dataCons;
@property (nonatomic, retain) NSNumberFormatter *frmtr;
@property (nonatomic, retain) NSDictionary *scrollingFeed;
@property (nonatomic, retain) UIButton *addressButton;
@property (nonatomic, retain) UIButton *iButton;
@property (nonatomic, assign) int actRun;

- (void) placeOrder: (NSString *) num: (NSString *)pri;
- (IBAction) confirmTrade: (id)sender;
- (IBAction) moreTicker :(id)sender;
- (IBAction) reloadAll :(id)sender;
- (void) cancelOrder;
- (void) loadOrders;
- (void) changeTicker;
- (void) loadScrollingTicker;
- (void) errorAlert: (NSString *) error;
- (void) payBtcInit: (NSString *) btca;
- (IBAction)payBtc:(id)sender;
- (void) setKeys: (NSString *) pin accid: (int) accountid;
- (void) setLayout: (int) section;
- (IBAction) remove: (id)sender;
- (IBAction) setLower:(id)sender;
- (IBAction) setFunds:(id)sender;
- (IBAction) depAddress:(id)sender;
- (IBAction) withdraw:(id)sender;
- (void) dismissBarcode;
- (bool) reset;
- (IBAction) logOff:(id)sender;

@end
