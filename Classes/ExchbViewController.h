//
//  ExchbViewController.h
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

@interface ExchbViewController : UIViewController <ZXingDelegate> {
	IBOutlet UIScrollView *scrollView;
	IBOutlet UILabel *btcPrice;
	IBOutlet UILabel *btcAvail;
	IBOutlet UILabel *curAvail;
    IBOutlet UILabel *curLabel;    
    IBOutlet UITableView *orderTable;
    IBOutlet UISegmentedControl *buySell;
    IBOutlet UISegmentedControl *ordersFunds;
    IBOutlet UITextField *numBtc;
    IBOutlet UITextField *limitPrice;
    IBOutlet UIButton *go;
    IBOutlet UIButton *payBut;
    IBOutlet UIButton *logoffbutton;
    IBOutlet UIActivityIndicatorView *refreshAct;
    IBOutlet UILabel *scrollingTick;
    IBOutlet UITextField *spendBtc;
    IBOutlet UISegmentedControl *checkDwolla;
    IBOutlet UITextField *wdrawAmt;
    IBOutlet UIButton *wdrawBut;
    NSMutableArray *orderList;
    NSString *userPerm;
    NSString *passPerm;
    NSString *curPerm;
    NSString *sendBtc;
    NSMutableArray *orderDic;
    NSString *apiURL;
    int i;
    int length;
    double lastTicker;
    int oid;
    NSMutableDictionary *dataCons;
    NSNumberFormatter *frmtr;
    NSDictionary *scrollingFeed;
    IBOutlet UIButton *addressButton;
    int actRun;
}

@property (nonatomic, retain) UIScrollView *scrollView;
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
@property (nonatomic, retain) UIButton *payBut;
@property (nonatomic, retain) UIButton *logoffbutton;
@property (nonatomic, retain) NSString *userPerm;
@property (nonatomic, retain) NSString *passPerm;
@property (nonatomic, retain) NSString *curPerm;
@property (nonatomic, retain) NSString *sendBtc;
@property (nonatomic, retain) NSMutableArray *orderList;
@property (nonatomic, retain) NSMutableArray *orderDic;
@property (nonatomic, retain) UIActivityIndicatorView *refreshAct;
@property (nonatomic, retain) NSTimer *tickTimer;
@property (nonatomic, retain) NSTimer *allTimer;
@property (nonatomic, retain) NSString *apiURL;
@property (nonatomic, retain) UITextField *spendBtc;
@property (nonatomic, retain) UIButton *iButton;
@property (nonatomic, retain) UISegmentedControl *ordersFunds;
@property (nonatomic, retain) UISegmentedControl *checkDwolla;
@property (nonatomic, retain) UITextField *wdrawAmt;
@property (nonatomic, retain) UIButton *wdrawBut;
@property (nonatomic, assign) double lastTicker;
@property (nonatomic, assign) int oid;
@property (nonatomic, assign) int i;
@property (nonatomic, assign) int length;
@property (nonatomic, retain) NSMutableDictionary *dataCons;
@property (nonatomic, retain) NSNumberFormatter *frmtr;
@property (nonatomic, retain) NSDictionary *scrollingFeed;
@property (nonatomic, retain) UIButton *addressButton;
@property (nonatomic, assign) int actRun;    

- (void) initOrderView: (NSDictionary *) feed: (NSString *)user: (NSString *)pass: (NSString *)currency;
- (void) placeOrder: (NSString *) num: (NSString *)pri;
- (IBAction) confirmTrade: (id)sender;
- (IBAction) moreTicker: (id)sender;
- (IBAction) reloadAll: (id)sender;
- (IBAction) payBtc: (id)sender;
- (void) cancelOrder;
- (void) loadBalance;
- (void) loadOrders;
- (void) changeTicker;
- (void) loadScrollingTicker;
- (void) payBtcInit: (NSString *) btca;
- (void) errorAlert: (NSString *) error;
- (IBAction)setLower:(id)sender;
- (void) withdraw;
- (IBAction)wdrawAlert:(id)sender;
- (void) dismissBarcode;
- (bool) reset;
- (IBAction) logOff:(id)sender;

@end
