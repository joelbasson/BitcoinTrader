//
//  THViewController.h
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


@interface THViewController : UIViewController <ZXingDelegate> {
	
	IBOutlet UILabel *btcPrice;
	IBOutlet UILabel *btcAvail;
	IBOutlet UILabel *btcRes;
	IBOutlet UILabel *curAvail;
	IBOutlet UILabel *curRes;
    IBOutlet UILabel *curLabel;    
    IBOutlet UITableView *orderTable;
    IBOutlet UISegmentedControl *buySell;
    IBOutlet UITextField *numBtc;
    IBOutlet UITextField *limitPrice;
    IBOutlet UIButton *go;
    IBOutlet UIButton *pay;
    IBOutlet UIButton *logoutbutton;
    IBOutlet UIActivityIndicatorView *refreshAct;
    IBOutlet UILabel *scrollingTick;
    NSMutableArray *orderList;
    NSString *userPerm;
    NSString *passPerm;
    NSString *curPerm;
    NSMutableArray *orderDic;
    NSString *apiURL;
    IBOutlet UISegmentedControl *ordersFunds;
    IBOutlet UISegmentedControl *wdrawOpts;
    IBOutlet UISegmentedControl *depositWdraw;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *wdrawGo;
    IBOutlet UIButton *receiveBtc;
    IBOutlet UITextField *wdrawAmt;
    IBOutlet UITextField *wdrawUser;
    IBOutlet UITextField *spendBtc;
    NSString *sendBtc;
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

@property (nonatomic, retain) UILabel *btcPrice;
@property (nonatomic, retain) UILabel *btcAvail;
@property (nonatomic, retain) UILabel *btcRes;
@property (nonatomic, retain) UILabel *curAvail;
@property (nonatomic, retain) UILabel *curRes;
@property (nonatomic, retain) UILabel *curLabel;
@property (nonatomic, retain) UILabel *scrollingTick;
@property (nonatomic, retain) UITableView *orderTable;
@property (nonatomic, retain) UITextField *numBtc;
@property (nonatomic, retain) UITextField *limitPrice;
@property (nonatomic, retain) UISegmentedControl *buySell;
@property (nonatomic, retain) UIButton *go;
@property (nonatomic, retain) UIButton *pay;
@property (nonatomic, retain) UIButton *logoutbutton;
@property (nonatomic, retain) NSString *userPerm;
@property (nonatomic, retain) NSString *passPerm;
@property (nonatomic, retain) NSString *curPerm;
@property (nonatomic, retain) NSMutableArray *orderList;
@property (nonatomic, retain) NSMutableArray *orderDic;
@property (nonatomic, retain) UIActivityIndicatorView *refreshAct;
@property (nonatomic, retain) NSTimer *tickTimer;
@property (nonatomic, retain) NSTimer *allTimer;
@property (nonatomic, retain) NSString *apiURL;
@property (nonatomic, retain) UISegmentedControl *ordersFunds;
@property (nonatomic, retain) UISegmentedControl *wdrawOpts;
@property (nonatomic, retain) UISegmentedControl *depositWdraw;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIButton *wdrawGo;
@property (nonatomic, retain) UIButton *receiveBtc;
@property (nonatomic, retain) UITextField *wdrawAmt;
@property (nonatomic, retain) UITextField *wdrawUser;
@property (nonatomic, retain) UIButton *iButton;
@property (nonatomic, retain) NSString *sendBtc;
@property (nonatomic, retain) UITextField *spendBtc;
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
- (IBAction) moreTicker :(id)sender;
- (IBAction) reloadAll :(id)sender;
- (void) cancelOrder;
- (void) loadBalance;
- (void) loadOrders;
- (void) changeTicker;
- (void) loadScrollingTicker;
- (void) errorAlert: (NSString *) error;
- (IBAction)setLower: (id)sender;
- (IBAction)setFunds:(id)sender;
- (IBAction)wdrawOptions:(id)sender;
- (IBAction)receiveBtc:(id)sender;
- (IBAction)wdrawCheck:(id)sender;
- (void) goWdraw;
- (void) payBtcInit: (NSString *) btca;
- (IBAction)payBtc:(id)sender;
- (void) dismissBarcode;
- (bool) reset;
- (IBAction) logOff:(id)sender;

@end
