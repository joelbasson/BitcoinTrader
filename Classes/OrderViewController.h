//
//  OrderViewController.h
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


@interface OrderViewController : UIViewController {
	
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
    IBOutlet UIActivityIndicatorView *refreshAct;
    NSMutableArray *orderList;
    NSString *userPerm;
    NSString *passPerm;
    NSString *curPerm;
    NSMutableArray *newOrders;
}

@property (nonatomic, retain) UILabel *btcPrice;
@property (nonatomic, retain) UILabel *btcAvail;
@property (nonatomic, retain) UILabel *btcRes;
@property (nonatomic, retain) UILabel *curAvail;
@property (nonatomic, retain) UILabel *curRes;
@property (nonatomic, retain) UILabel *curLabel;
@property (nonatomic, retain) UITableView *orderTable;
@property (nonatomic, retain) UITextField *numBtc;
@property (nonatomic, retain) UITextField *limitPrice;
@property (nonatomic, retain) UISegmentedControl *buySell;
@property (nonatomic, retain) UIButton *go;
@property (nonatomic, retain) NSString *userPerm;
@property (nonatomic, retain) NSString *passPerm;
@property (nonatomic, retain) NSString *curPerm;
@property (nonatomic, retain) NSMutableArray *orderList;
@property (nonatomic, retain) NSMutableArray *newOrders;
@property (nonatomic, retain) UIActivityIndicatorView *refreshAct;

- (void) initOrderView: (NSDictionary *) feed: (NSString *)user: (NSString *)pass: (NSString *)currency;
- (void) placeOrder: (NSString *) num: (NSString *)pri;
- (IBAction) selectTrade: (id)sender;
- (IBAction) confirmTrade: (id)sender;
- (IBAction) moreTicker :(id)sender;
- (IBAction) reloadAll :(id)sender;
- (void) writeOrders;
- (void) cancelOrder;
- (void) loadTicker;
- (void) loadBalance;
- (void) loadOrders;
@end
