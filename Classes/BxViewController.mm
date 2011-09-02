//
//  BxViewController.m
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


#import "BxViewController.h"
#import "connectTag.h"
#import "JSON/SBJson.h"
#import "Constants.h"
#import "QRCodeReader.h"

@implementation BxViewController

@synthesize spendBtc;
@synthesize btcAvail;
@synthesize btcRes;
@synthesize curAvail;
@synthesize curRes;
@synthesize marginBtc;
@synthesize marginCur;
@synthesize orderTable;
@synthesize buySell;
@synthesize numBtc;
@synthesize limitPrice;
@synthesize go;
@synthesize userPerm;
@synthesize passPerm;
@synthesize curPerm;
@synthesize orderList;
@synthesize curLabel;
@synthesize refreshAct;
@synthesize scrollingTick;
@synthesize allTimer;
@synthesize apiURL;
@synthesize sendBtc;
@synthesize orderDic;
@synthesize tempType;
@synthesize lastTicker;
@synthesize dataCons;
@synthesize frmtr;
@synthesize oid;
@synthesize actRun;
@synthesize logOffButton;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		[btcPrice setText:@"Worked"];

    }
    return self;
}*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [orderTable setBackgroundColor:[UIColor clearColor]];
    dataCons = [[NSMutableDictionary alloc] init];
    frmtr = [[NSNumberFormatter alloc] init]; 
    [frmtr setMaximumFractionDigits:4];
    apiURL = [[NSString alloc] initWithString:bxURL];
    orderList = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self reset];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    NSLog(@"dealloc");
    [super dealloc];
}

- (bool) reset {
    
    if (actRun != 0) {
        [logOffButton setEnabled:NO];
        [self performSelector:@selector(logOff:) withObject:nil afterDelay:0.5];
        return NO;
    } else {
        [logOffButton release];
        [spendBtc release];
        [btcAvail release];
        [btcRes release];
        [curAvail release];
        [curRes release];
        [marginBtc release];
        [marginCur release];
        [orderTable release];
        [buySell release];
        [numBtc release];
        [limitPrice release];
        [go release];
        [userPerm release];
        [passPerm release];
        [curPerm release];
        [orderList release];
        [curLabel release];
        [refreshAct release];
        [scrollingTick release];
        [allTimer invalidate];
        [self setAllTimer:nil];
        [apiURL release];
        [sendBtc release];
        [orderDic release];
        [tempType release];
        [dataCons release];
        [frmtr release];
        [self setOid:nil];
        [self setActRun:nil];
        [self setLastTicker:nil];
        return YES;
    }
}

- (IBAction)logOff:(id)sender {
    
    if ([self reset] == YES) { [self.navigationController popToRootViewControllerAnimated:YES]; }
    
}

- (IBAction) confirmTrade:(id)sender {
    
    if ([[numBtc text] length] == 0 || [[limitPrice text] length] == 0)
    {
        //error
    }
    else
    {
        [numBtc resignFirstResponder];
        [limitPrice resignFirstResponder];
        NSString *action = [[[NSString alloc] init] autorelease];
        if ([buySell selectedSegmentIndex] == 0) { action = @"Buy"; } if ([buySell selectedSegmentIndex] == 1) { action = @"Sell"; }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Confirm %@ Order", action] message:[NSString stringWithFormat:@"%@ BTC at %@ %@", [numBtc text], [limitPrice text], curPerm] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:action, nil];
        [alert setTag:1];
        [alert show];
        [alert release];
    }
}

- (void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
        
    if ([alertView tag] == 1)
    {
        if (buttonIndex == 0)
        {
            //nothing
        }
        else
        {
            [self placeOrder: [numBtc text]: [limitPrice text]];
        }
    }
    if ([alertView tag] == 2)
    {
        if (buttonIndex == 0)
        {
            [self setTempType:nil];
            [orderTable reloadData];
        }
        else
        {
            [self cancelOrder];
        }
    }
    if ([alertView tag] == 4)
    {
        if (buttonIndex == 0)
        {
            [self setSendBtc:nil];
        }
        else
        {
            [self payBtcInit:sendBtc];
        }
    }
}

- (void) placeOrder: (NSString *) num: (NSString *) pri {
    
    [refreshAct startAnimating];
    actRun++;
    
    if ([buySell selectedSegmentIndex] == 0)
    {
        //buy
        NSString *buyString = [NSString stringWithFormat:@"%@/tradeenter.php", apiURL];
        NSURL *buyUrl = [NSURL URLWithString:buyString];
        NSLog(@"URL: %@", buyUrl);
        NSMutableURLRequest *buyReq = [NSMutableURLRequest requestWithURL:buyUrl];
        
        [buyReq setHTTPMethod:@"POST"];
        NSString *args = [NSString stringWithFormat:@"user=%@&pass=%@&TradeMode=QuickBuy&Quantity=%@&Price=%@", userPerm, passPerm, num, pri];
        [buyReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
        
        connectTag *connect = [[connectTag alloc] initWithRequest:buyReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:3]];
        [connect release];
    }
    
    if ([buySell selectedSegmentIndex] == 1)
    {
        //sell
        NSString *sellString = [NSString stringWithFormat:@"%@/tradeenter.php", apiURL];
        NSURL *sellUrl = [NSURL URLWithString:sellString];
        NSLog(@"URL: %@", sellUrl);
        NSMutableURLRequest *sellReq = [NSMutableURLRequest requestWithURL:sellUrl];
        
        [sellReq setHTTPMethod:@"POST"];
        NSString *args = [NSString stringWithFormat:@"user=%@&pass=%@&TradeMode=QuickSell&Quantity=%@&Price=%@", userPerm, passPerm, num, pri];
        [sellReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
        
        connectTag *connect = [[connectTag alloc] initWithRequest:sellReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:4]];
        [connect release];
    }
    [numBtc setText:@""]; [limitPrice setText:@""];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [orderList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
            
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *cellFinal = [self.orderList objectAtIndex:indexPath.row];
        
    NSString *cellValue = cellFinal;
    //NSLog(@"Log: %@", cellValue);

    cell.textLabel.text = cellValue;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *tempInfo = [orderDic objectAtIndex:indexPath.row];
    [self setOid:[[tempInfo valueForKey:@"oid"] intValue]];
    [self setTempType:[tempInfo valueForKey:@"type"]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:[NSString stringWithFormat:@"Cancel %@ Order #%u?", tempType, oid] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Confirm", nil];
    [alert setTag:2];
    [alert show];
    [alert release];

}

- (void) cancelOrder {
        
    [refreshAct startAnimating];
    actRun++;
    NSString *cancelStr = [NSString stringWithFormat:@"%@/tradecancel.php", apiURL];
	NSURL *cancelUrl = [NSURL URLWithString:cancelStr];
    NSLog(@"URL: %@", cancelUrl);
	NSMutableURLRequest *cancelReq = [NSMutableURLRequest requestWithURL:cancelUrl];
	
	[cancelReq setHTTPMethod:@"POST"];
	NSString *args = [NSString stringWithFormat:@"user=%@&pass=%@&Type=%@&OrderID=%u", userPerm, passPerm, tempType, oid];
	[cancelReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:cancelReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:5]];
    [connect release];
    [self setTempType:nil];
}

- (void) initOrderView:(NSDictionary *)feed: (NSString *)user: (NSString *)pass: (NSString *) currency {
    
    [self setUserPerm:user];
    [self setPassPerm:pass];
    [self setCurPerm:currency];

    [btcAvail setText:[frmtr stringFromNumber:[frmtr numberFromString:[feed valueForKey:@"Total BTC"]]]];
    [btcRes setText:[frmtr stringFromNumber:[frmtr numberFromString:[feed valueForKey:@"Liquid BTC"]]]];
    [curAvail setText:[frmtr stringFromNumber:[frmtr numberFromString:[feed valueForKey:[NSString stringWithFormat:@"Total %@", curPerm]]]]];
    [curRes setText:[frmtr stringFromNumber:[frmtr numberFromString:[feed valueForKey:[NSString stringWithFormat:@"Liquid %@", curPerm]]]]];
    [marginCur setText:[frmtr stringFromNumber:[frmtr numberFromString:[feed valueForKey:[NSString stringWithFormat:@"Margin Account %@", curPerm]]]]];
    [marginBtc setText:[frmtr stringFromNumber:[frmtr numberFromString:[feed valueForKey:@"Margin Account BTC"]]]];
    [curLabel setText:curPerm];
    
    [self setAllTimer:[NSTimer timerWithTimeInterval:30.0 target:self selector:@selector(reloadAll:) userInfo:nil repeats:YES]];
    [[NSRunLoop currentRunLoop] addTimer:allTimer forMode:NSDefaultRunLoopMode];
    
    [self loadTicker];
    [self loadOrders];
        
}

- (void) loadBalance {
    
    [refreshAct startAnimating];
    actRun++;
    NSString *urlString = [NSString stringWithFormat:@"%@/myfunds.php", apiURL];
	NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"URL: %@", url);
	NSMutableURLRequest *ordersReq = [NSMutableURLRequest requestWithURL:url];
	
	[ordersReq setHTTPMethod:@"POST"];
	NSString *args = [NSString stringWithFormat:@"user=%@&pass=%@", userPerm, passPerm];
	[ordersReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:ordersReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:6]];
    
    [connect release];
    
}

- (void) loadOrders {
        
    [refreshAct startAnimating];
    actRun++;
    NSString *urlString = [NSString stringWithFormat:@"%@/myorders.php", apiURL];
	NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"URL: %@", url);
	NSMutableURLRequest *ordersReq = [NSMutableURLRequest requestWithURL:url];
	
	[ordersReq setHTTPMethod:@"POST"];
	NSString *args = [NSString stringWithFormat:@"user=%@&pass=%@", userPerm, passPerm];
	[ordersReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:ordersReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:1]];
    
    [connect release];

}

- (void) loadTicker {
    
    [refreshAct startAnimating];
    actRun++;
    NSString *urlString = [NSString stringWithFormat:@"%@/xticker.php", apiURL];
	NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *tickerReq = [NSMutableURLRequest requestWithURL:url];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:tickerReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:2]];
    [connect release];
    
}

- (IBAction) reloadAll: (id)sender {
    if ([sender isKindOfClass:[NSTimer class]]) { //nothing
    } else {
        [numBtc resignFirstResponder];
        [limitPrice resignFirstResponder];
        [spendBtc resignFirstResponder];
    }
    [self loadBalance];
    [self loadTicker];
    //reload orders after didReceiveData for the balance to avoid API limits
}

- (void) payBtcInit: (NSString *)btca {
    
    [refreshAct startAnimating];
    actRun++;
    NSString *payStr = [NSString stringWithFormat:@"%@/sendbtc.php", apiURL];
	NSURL *payUrl = [NSURL URLWithString:payStr];
    NSLog(@"URL: %@", payUrl);
	NSMutableURLRequest *payReq = [NSMutableURLRequest requestWithURL:payUrl];

	[payReq setHTTPMethod:@"POST"];
	NSString *args = [NSString stringWithFormat:@"user=%@&pass=%@&BTCTo=%@&BTCAmt=%@", userPerm, passPerm, btca, [spendBtc text]];
	[payReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:payReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:9]];
    [connect release];
    [self setSendBtc:nil];
    
}

- (IBAction) payBtc: (id)sender {
    
    [spendBtc resignFirstResponder];
    
    if ([[spendBtc text] length] == 0)
    {
        //nothing
    } else {
        
        ZXingWidgetController *widCon = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
        QRCodeReader *qrCode = [[QRCodeReader alloc] init];
        NSSet *readers = [[NSSet alloc] initWithObjects:qrCode, nil];
        [qrCode release];
        widCon.readers = readers;
        [readers release];
        [self presentModalViewController:widCon animated:YES];
        [widCon release];
        
    }
    
}

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
    
    [self setSendBtc:[[NSString alloc] initWithString:[result substringFromIndex:8]]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Payment" message:[NSString stringWithFormat:@"Pay %@ BTC to\n%@?", [spendBtc text], sendBtc] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Pay", nil];
    [alert setTag:4];
    [alert show];
    [alert release];
    
    [self dismissModalViewControllerAnimated:NO];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) errorAlert:(NSString *)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert setTag:10];
    [alert show];
    [alert release];
    
}

- (void)connection:(connectTag *)connection didReceiveData:(NSData *)data{
    
    if ([dataCons objectForKey:[connection tag]] == nil) {
        
        NSMutableData *newData = [[NSMutableData alloc] initWithData:data];
        
        [dataCons setObject:newData forKey:[connection tag]];
        [newData release];
    }
    
    NSString *errorTest = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *errorStr = [[errorTest JSONValue] valueForKey:@"Error"];
    [errorTest release];
    if ([errorStr length] > 0) { [self errorAlert: errorStr]; [connection setTag:[NSNumber numberWithInt:99]]; actRun--; }
    
    NSLog(@"ConnectTag: %@", [connection tag]);
            
    switch ([[connection tag] intValue]) {
        case 99: {
        } break;
        case 1: {
            //NSLog(@"Original orders: %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSArray *tempBuy = [[NSArray alloc] initWithArray:[[jsonString JSONValue] valueForKey:@"Buy"]];
            NSArray *tempSell = [[NSArray alloc] initWithArray:[[jsonString JSONValue] valueForKey:@"Sell"]];
            [jsonString release];
            
            if (orderDic == nil) { orderDic = [[NSMutableArray alloc] init]; }
            [orderList removeAllObjects];
            [orderDic removeAllObjects];
            
            NSArray *keys = [[NSArray alloc] initWithObjects:@"oid", @"type", nil];
            NSString *buyChk = [[tempBuy objectAtIndex:0] valueForKey:@"Info"];
                        
            if ([buyChk length] > 0) { /* no buy orders */ }
            else {
                int oi = 0;
                while (oi < [tempBuy count]) {
                    NSArray *tempArr = [tempBuy objectAtIndex:oi];
                    NSString *orderType = [[tempArr valueForKey:@"Order Type"] substringFromIndex:6];
                    [orderList addObject:[NSString stringWithFormat:@"%@: %@ BTC at %@ %@", orderType, [frmtr stringFromNumber:[frmtr numberFromString:[tempArr valueForKey:@"Quantity"]]], [tempArr valueForKey:@"Price"], curPerm]];
                    NSArray *info = [[NSArray alloc] initWithObjects:[tempArr valueForKey:@"Order ID"], orderType, nil];
                    NSDictionary *order = [[NSDictionary alloc] initWithObjects:info forKeys:keys];
                    [orderDic addObject:order];
                    oi++;
                    [info release];
                    [order release];
                }
            }
                                                                        
            NSString *sellChk = [[tempSell objectAtIndex:0] valueForKey:@"Info"];
            if ([sellChk length] > 0) { /* no sell orders */ }
            else {
                int oi = 0;
                while (oi < [tempSell count]) {
                    NSArray *tempArr = [tempSell objectAtIndex:oi];
                    NSString *orderType = [[tempArr valueForKey:@"Order Type"] substringFromIndex:6];
                    [orderList addObject:[NSString stringWithFormat:@"%@: %@ BTC at %@ %@", orderType, [frmtr stringFromNumber:[frmtr numberFromString:[tempArr valueForKey:@"Quantity"]]], [tempArr valueForKey:@"Price"], curPerm]];
                    NSArray *info = [[NSArray alloc] initWithObjects:[tempArr valueForKey:@"Order ID"], orderType, nil];
                    NSDictionary *order = [[NSDictionary alloc] initWithObjects:info forKeys:keys];
                    [orderDic addObject:order];
                    oi++;
                    [info release];
                    [order release];
                }
            }
            
            [orderTable reloadData];
            
            //NSLog(@"ol: %@", orderList);
            [tempBuy release];
            [tempSell release];
            [keys release];
            actRun--;
        } break;
        case 2: {
            //NSLog(@"Original ticker: %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *ticker = [jsonString JSONValue];
            [jsonString release];
            //NSLog(@"Received ticker: %@\n", ticker);
        
            NSString *tickerStr = [NSString stringWithFormat:@"Last: %@ Bid: %@ Ask: %@", [frmtr stringFromNumber:[frmtr numberFromString:[ticker valueForKey:@"Last Trade"]]], [frmtr stringFromNumber:[frmtr numberFromString:[ticker valueForKey:@"Best Bid"]]], [frmtr stringFromNumber:[frmtr numberFromString:[ticker valueForKey:@"Best Ask"]]]];
            [scrollingTick setText:tickerStr];
            actRun--;
            
        } break;
        case 3: {
            actRun--;
            [self loadOrders];
            //nothing needed for buy return
        } break;
        case 4: {
            actRun--;
            [self loadOrders];
            //nothing needed for sell return
        } break;
        case 5: {
            actRun--;
            [self loadOrders];
            //nothing needed for cancel return
        } break;
        case 6: {
            //NSLog(@"Original balance: %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *balance = [jsonString JSONValue];
            [jsonString release];
            //NSLog(@"Received balance: %@\n", balance);
            [btcAvail setText:[frmtr stringFromNumber:[frmtr numberFromString:[balance valueForKey:@"Total BTC"]]]];
            [btcRes setText:[frmtr stringFromNumber:[frmtr numberFromString:[balance valueForKey:@"Liquid BTC"]]]];
            [curAvail setText:[frmtr stringFromNumber:[frmtr numberFromString:[balance valueForKey:[NSString stringWithFormat:@"Total %@", curPerm]]]]];
            [curRes setText:[frmtr stringFromNumber:[frmtr numberFromString:[balance valueForKey:[NSString stringWithFormat:@"Liquid %@", curPerm]]]]];
            [marginCur setText:[frmtr stringFromNumber:[frmtr numberFromString:[balance valueForKey:[NSString stringWithFormat:@"Margin Account %@", curPerm]]]]];
            [marginBtc setText:[frmtr stringFromNumber:[frmtr numberFromString:[balance valueForKey:@"Margin Account BTC"]]]];
            actRun--;
        } break;
        case 9: {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *sent = [jsonString JSONValue];
            NSLog(@"Sent: %@", sent);
            [jsonString release];
            actRun--;
        } break;
    }

    if ([[connection tag] intValue] != 99) { [dataCons removeObjectForKey:[connection tag]]; }
    if (actRun == 0) { [refreshAct stopAnimating]; }

}

@end
