//
//  ExchbViewController.m
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


#import "ExchbViewController.h"
#import "connectTag.h"
#import "SBJson.h"
#import "Constants.h"
#import "QRCodeReader.h"

@implementation ExchbViewController

@synthesize btcPrice;
@synthesize btcAvail;
@synthesize curAvail;
@synthesize orderTable;
@synthesize buySell;
@synthesize numBtc;
@synthesize limitPrice;
@synthesize go;
@synthesize userPerm;
@synthesize passPerm;
@synthesize curPerm;
@synthesize orderList;
@synthesize orderDic;
@synthesize curLabel;
@synthesize refreshAct;
@synthesize scrollingTick;
@synthesize tickTimer;
@synthesize allTimer;
@synthesize apiURL;
@synthesize spendBtc;
@synthesize sendBtc;
@synthesize iButton;
@synthesize ordersFunds;
@synthesize checkDwolla;
@synthesize wdrawAmt;
@synthesize wdrawBut;
@synthesize scrollView;
@synthesize i;
@synthesize oid;
@synthesize length;
@synthesize lastTicker;
@synthesize dataCons;
@synthesize frmtr;
@synthesize scrollingFeed;
@synthesize addressButton;
@synthesize actRun;
@synthesize payBut;
@synthesize logoffbutton;

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
    tickTimer = [[NSTimer alloc] init];
    scrollingFeed = [[NSDictionary alloc] init];
    orderList = [[NSMutableArray alloc] init];
    apiURL = [[NSString alloc] initWithString:exchbURL];
    [scrollView setContentSize:CGSizeMake(320, 600)];
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
        [logoffbutton setEnabled:NO];
        [self performSelector:@selector(logOff:) withObject:nil afterDelay:0.5];
        return NO;
    } else {
        [btcPrice release];
        [btcAvail release];
        [curAvail release];
        [orderTable release];
        [buySell release];
        [numBtc release];
        [limitPrice release];
        [go release];
        [userPerm release];
        [passPerm release];
        [curPerm release];
        [orderList release];
        [orderDic release];
        [curLabel release];
        [refreshAct release];
        [scrollingTick release];
        if (tickTimer != nil) {
            [tickTimer invalidate];
            [self setTickTimer:nil];
        }
        [allTimer invalidate];
        [self setAllTimer:nil];
        [apiURL release];
        [spendBtc release];
        [sendBtc release];
        [ordersFunds release];
        [checkDwolla release];
        [wdrawAmt release];
        [wdrawBut release];
        [scrollView release];
        [dataCons release];
        [frmtr release];
        [scrollingFeed release];
        [addressButton release];
        [payBut release];
        [logoffbutton release];
        [self setI:nil];
        [self setOid:nil];
        [self setLength:nil];
        [self setLastTicker:nil];
        [self setActRun:nil];
        return YES;
    }
}

- (IBAction) logOff:(id)sender {
    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Confirm %@ Order", action] message:[NSString stringWithFormat:@"%@ BTC at %@ %@", numBtc.text, limitPrice.text, curPerm] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:action, nil];
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
            [self placeOrder: numBtc.text: limitPrice.text];
        }
    }
    if ([alertView tag] == 2)
    {
        if (buttonIndex == 0)
        {
            [self setOid:nil];
            [orderTable reloadData];
        }
        else
        {
            [self cancelOrder];
        }
    }
    if ([alertView tag] == 3)
    {
        if (buttonIndex == 0)
        {
            //nothing
        }
        else
        {
            [self moreTicker:alertView];
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
    if ([alertView tag] == 5)
    {
        if (buttonIndex == 0)
        {
            //nothing
        }
        else
        {
            [self withdraw];
        }
    }
}

- (void) placeOrder: (NSString *) num: (NSString *) pri {
        
    [refreshAct startAnimating];
    actRun++;
    
    if ([buySell selectedSegmentIndex] == 0)
    {
        //buy
        NSString *buyString = [NSString stringWithFormat:@"%@/buyBTC", apiURL];
        NSURL *buyUrl = [NSURL URLWithString:buyString];
        NSLog(@"URL: %@", buyUrl);
        NSMutableURLRequest *buyReq = [NSMutableURLRequest requestWithURL:buyUrl];
        
        [buyReq setHTTPMethod:@"POST"];
        NSString *args = [NSString stringWithFormat:@"name=%@&pass=%@&amount=%@&price=%@", userPerm, passPerm, num, pri];
        [buyReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
        
        //NSURLConnection *buyCon = [[NSURLConnection alloc] initWithRequest:buyReq delegate:self];
        connectTag *connect = [[connectTag alloc] initWithRequest:buyReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:1]];
        [connect release];
    }
    
    if ([buySell selectedSegmentIndex] == 1)
    {
        //sell
        NSString *sellString = [NSString stringWithFormat:@"%@/sellBTC", apiURL];
        NSURL *sellUrl = [NSURL URLWithString:sellString];
        NSLog(@"URL: %@", sellUrl);
        NSMutableURLRequest *sellReq = [NSMutableURLRequest requestWithURL:sellUrl];
        
        [sellReq setHTTPMethod:@"POST"];
        NSString *args = [NSString stringWithFormat:@"name=%@&pass=%@&amount=%@&price=%@", userPerm, passPerm, num, pri];
        [sellReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
        
        connectTag *connect = [[connectTag alloc] initWithRequest:sellReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:1]];
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
    
    NSString *cellValue = [self.orderList objectAtIndex:indexPath.row];
    //NSLog(@"Log: %@", cellValue);
    
    cell.textLabel.text = cellValue;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self setOid:[[orderDic objectAtIndex:indexPath.row] intValue]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:[NSString stringWithFormat:@"Cancel Order #%u?", oid] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Cancel", nil];
    [alert setTag:2];
    [alert show];
    [alert release];

}

- (void) cancelOrder {
    
    [refreshAct startAnimating];
    actRun++;
    
    NSString *cancelStr = [NSString stringWithFormat:@"%@/cancelOrder", apiURL];
	NSURL *cancelUrl = [NSURL URLWithString:cancelStr];
    NSLog(@"URL: %@", cancelUrl);
	NSMutableURLRequest *cancelReq = [NSMutableURLRequest requestWithURL:cancelUrl];
	
	[cancelReq setHTTPMethod:@"POST"];
	NSString *args = [NSString stringWithFormat:@"name=%@&pass=%@&oid=%u", userPerm, passPerm, oid];
	[cancelReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:cancelReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:1]];
    [connect release];
    [self setOid:nil];
}

- (void) payBtcInit: (NSString *)btca {
    
    [refreshAct startAnimating];
    actRun++;

    NSString *payStr = [NSString stringWithFormat:@"%@/withdraw", apiURL];
	NSURL *payUrl = [NSURL URLWithString:payStr];
    NSLog(@"URL: %@", payUrl);
	NSMutableURLRequest *payReq = [NSMutableURLRequest requestWithURL:payUrl];
	
	[payReq setHTTPMethod:@"POST"];
	NSString *args = [NSString stringWithFormat:@"name=%@&pass=%@&currency=BTC&btca=%@&amount=%@", userPerm, passPerm, btca, spendBtc.text];
	[payReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:payReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:9]];
    [connect release];
    [self setSendBtc:nil];
    
}

- (IBAction) payBtc: (id)sender {
    
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

- (IBAction) receiveBtc: (id)sender {
    
    [refreshAct startAnimating];
    actRun++;
    
    [addressButton setEnabled:NO];
    NSString *receiveStr = [NSString stringWithFormat:@"%@/getDepositAddress", apiURL];
	NSURL *receiveUrl = [NSURL URLWithString:receiveStr];
    NSLog(@"URL: %@", receiveUrl);
	NSMutableURLRequest *receiveReq = [NSMutableURLRequest requestWithURL:receiveUrl];
	
	[receiveReq setHTTPMethod:@"POST"];
	NSString *args = [NSString stringWithFormat:@"name=%@&pass=%@", userPerm, passPerm];
	[receiveReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:receiveReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:10]];
    [connect release];
    
}

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {

    [self setSendBtc:[[NSString alloc] initWithString:[result substringFromIndex:8]]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Payment" message:[NSString stringWithFormat:@"Pay %@ BTC to\n%@?", spendBtc.text, sendBtc] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Pay", nil];
    [alert setTag:4];
    [alert show];
    [alert release];
    
    [self dismissModalViewControllerAnimated:NO];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) initOrderView:(NSDictionary *)feed: (NSString *)user: (NSString *)pass: (NSString *) currency {
    
    [self setUserPerm:user];
    [self setPassPerm:pass];
    [self setCurPerm:currency];

    [btcAvail setText:[frmtr stringFromNumber:[feed valueForKey:@"btcs"]]];
    [curAvail setText:[frmtr stringFromNumber:[feed valueForKey:@"usds"]]];
    [curLabel setText:curPerm];
    
    [self setAllTimer:[NSTimer timerWithTimeInterval:30.0 target:self selector:@selector(reloadAll:) userInfo:nil repeats:YES]];
    [[NSRunLoop currentRunLoop] addTimer:allTimer forMode:NSDefaultRunLoopMode];
    
    [self loadOrders];
    [self loadScrollingTicker];
        
}

- (void) loadBalance {
    
    [refreshAct startAnimating];
    actRun++;

    NSString *urlString = [NSString stringWithFormat:@"%@/getFunds", apiURL];
	NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"URL: %@", url);
	NSMutableURLRequest *ordersReq = [NSMutableURLRequest requestWithURL:url];
	
	[ordersReq setHTTPMethod:@"POST"];
	NSString *args = [NSString stringWithFormat:@"name=%@&pass=%@", userPerm, passPerm];
	[ordersReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:ordersReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:6]];
    
    [connect release];
    
}

- (void) loadOrders {
        
    [refreshAct startAnimating];
    actRun++;
    
    NSString *urlString = [NSString stringWithFormat:@"%@/getOrders", apiURL];
	NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"URL: %@", url);
	NSMutableURLRequest *ordersReq = [NSMutableURLRequest requestWithURL:url];
	
	[ordersReq setHTTPMethod:@"POST"];
	NSString *args = [NSString stringWithFormat:@"name=%@&pass=%@", userPerm, passPerm];
	[ordersReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:ordersReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:1]];
    
    [connect release];

}

- (void) loadScrollingTicker {
    
    [refreshAct startAnimating];
    actRun++;
    
    [self setI:0];
    [scrollingTick setText:@""];
    NSString *urlString = [NSString stringWithFormat:@"%@/ticker", apiURL];
	NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *tickerReq = [NSMutableURLRequest requestWithURL:url];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:tickerReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:8]];
    [connect release];
    
}

- (IBAction) moreTicker: (id)sender {
    
    [refreshAct startAnimating];
    actRun++;
    
    [numBtc resignFirstResponder];
    [limitPrice resignFirstResponder];
    [wdrawAmt resignFirstResponder];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/ticker", apiURL];
	NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *tickerReq = [NSMutableURLRequest requestWithURL:url];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:tickerReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:7]];
    [connect release];
    
}

-(void) changeTicker {
    
    NSString *tickerStr = [NSString stringWithFormat:@"Sell: %@ Buy: %@ Last: %@ Volume: %@ High: %@ Low: %@", [scrollingFeed valueForKey:@"sell"], [scrollingFeed valueForKey:@"buy"], [scrollingFeed valueForKey:@"last"], [scrollingFeed valueForKey:@"vol"], [scrollingFeed valueForKey:@"high"], [scrollingFeed valueForKey:@"low"]];
    
    [self setLength:[tickerStr length]];
    
    if (i>length+25) {
        
        //consider saving the remaining label and attaching it to first 15 of next ticker
        
        [tickTimer invalidate];
        [self setTickTimer:nil];
        [self loadScrollingTicker];
    } else if (i<26) {
        [scrollingTick setTextAlignment:UITextAlignmentRight];
        [scrollingTick setText:[tickerStr substringWithRange:NSMakeRange(0, i)]];
        //NSLog(@"i: %u-%u length<31: %u", 0, i, length);
    } else if (i>length) {
        [scrollingTick setTextAlignment:UITextAlignmentLeft];
        //NSLog(@"i: %u-%u length: %u", i-30, (length+30)-i, length);
        [scrollingTick setText:[tickerStr substringWithRange:NSMakeRange(i-25, (length+25)-i)]];
    } else {
        [scrollingTick setTextAlignment:UITextAlignmentCenter];
        [scrollingTick setText:[tickerStr substringWithRange:NSMakeRange(i-25, 25)]];
        //NSLog(@"i: %u-%u length : %u", i-30, i, length);
    }
    
    i++;
        
}

- (IBAction) reloadAll: (id)sender {
    if ([sender isKindOfClass:[NSTimer class]]) { //nothing
    } else {
        [numBtc resignFirstResponder];
        [limitPrice resignFirstResponder];
        [spendBtc resignFirstResponder];
        [wdrawAmt resignFirstResponder];
    }
    [self loadBalance];
    if ([ordersFunds selectedSegmentIndex] == 0) { [self loadOrders]; }
}

- (void) dismissBarcode {
    
    [iButton removeFromSuperview];
    [addressButton setEnabled:YES];
}

- (IBAction) setLower:(id)sender {
    if ([ordersFunds selectedSegmentIndex] == 0) {
        [checkDwolla setHidden:YES];
        [wdrawAmt setHidden:YES];
        [wdrawBut setHidden:YES];     
        [spendBtc setHidden:YES];
        [payBut setHidden:YES];
        [addressButton setHidden:YES];
        [logoffbutton setHidden:NO];
        [orderTable setHidden:NO];
        [orderTable reloadData];
    }
    if ([ordersFunds selectedSegmentIndex] == 1) {
        [spendBtc setHidden:NO];
        [payBut setHidden:NO];
        [addressButton setHidden:NO];
        [logoffbutton setHidden:YES];
        [checkDwolla setHidden:NO];
        [wdrawAmt setHidden:NO];
        [wdrawBut setHidden:NO];
        [orderTable setHidden:YES];
    }
}

- (IBAction) wdrawAlert:(id)sender {
    
    NSString *method;
    if ([checkDwolla selectedSegmentIndex] == 0) { method = @"Check"; }
    if ([checkDwolla selectedSegmentIndex] == 1) { method = @"Dwolla"; }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Withdrawl" message:[NSString stringWithFormat:@"Withdraw %@ %@ via %@?", wdrawAmt.text, curPerm, method] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Withdraw", nil];
    [alert setTag:5];
    [alert show];
    [alert release];
    
}

- (void) withdraw {
    
    [refreshAct startAnimating];
    actRun++;
    
    NSString *urlString = [NSString stringWithFormat:@"%@/withdraw", apiURL];
	NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"URL: %@", url);
	NSMutableURLRequest *ordersReq = [NSMutableURLRequest requestWithURL:url];
	
	[ordersReq setHTTPMethod:@"POST"];
    NSString *method;
    if ([checkDwolla selectedSegmentIndex] == 0) { method = @"check"; }
    if ([checkDwolla selectedSegmentIndex] == 1) { method = @"dwolla"; }
	NSString *args = [NSString stringWithFormat:@"name=%@&pass=%@&currency=%@&method=%@&amount=%@", userPerm, passPerm, curPerm, method, wdrawAmt.text];
	[ordersReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:ordersReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:11]];
    
    [connect release];
    
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
    NSString *errorStr = [[errorTest JSONValue] valueForKey:@"status"];
    [errorTest release];
    NSArray *testErr = [errorStr componentsSeparatedByString:@" "];
    if ([errorStr length] > 0) {
        if ([[testErr lastObject] isEqualToString:@"cancelled."]) { //nothing
        } else {
            [self errorAlert: errorStr]; 
            [connection setTag:[NSNumber numberWithInt:99]]; 
            actRun--;
        }
    }
    
    NSLog(@"ConnectTag: %@", [connection tag]);
            
    switch ([[connection tag] intValue]) {
        case 99: {
            //nothing
        } break;
        case 1: {
            //NSLog(@"Original orders: %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];            
            NSArray *tempArray = [[NSArray alloc] initWithArray:[[jsonString JSONValue] objectForKey:@"orders"]];
            [jsonString release];
            
            if (orderDic == nil) { orderDic = [[NSMutableArray alloc] init]; }
            [orderDic removeAllObjects];
            [orderList removeAllObjects];
            int oI = 0;
            if ([tempArray count] == 0) { //no orders
            } else {
                while (oI < [tempArray count]) {
                    NSDictionary *order = [[NSDictionary alloc] initWithDictionary:[tempArray objectAtIndex:oI]];
                    [orderList addObject:[NSString stringWithFormat:@"%@: %@ BTC at %@", [order valueForKey:@"type"], [order valueForKey:@"amount"], [order valueForKey:@"price"]]];
                    [orderDic addObject:[order valueForKey:@"oid"]];
                    [order release];
                    oI++;
                }
            }
            [tempArray release];
            [orderTable reloadData];     
            actRun--;
        } break;
        case 6: {
            //NSLog(@"Original balance: %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *balance = [jsonString JSONValue];
            [jsonString release];
            [btcAvail setText:[frmtr stringFromNumber:[balance valueForKey:@"btcs"]]];
            [curAvail setText:[frmtr stringFromNumber:[balance valueForKey:@"usds"]]];
            actRun--;
        } break;
        case 7: {
            actRun--; if (actRun == 0) { [refreshAct stopAnimating]; }
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *ticker = [[jsonString JSONValue] valueForKey:@"ticker"];
            [jsonString release];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Full Ticker" message:[NSString stringWithFormat:@"Sell: %@\nBuy: %@\nLast: %@\nVolume: %@\nHigh: %@\nLow: %@", [ticker valueForKey:@"sell"], [ticker valueForKey:@"buy"], [ticker valueForKey:@"last"], [ticker valueForKey:@"vol"], [ticker valueForKey:@"high"], [ticker valueForKey:@"low"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Refresh", nil];
            [alert setTag:3];
            [alert show];
            [alert release];
        } break;
        case 8: {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [self setScrollingFeed:[[jsonString JSONValue] valueForKey:@"ticker"]];
            NSDictionary *ticker = [[jsonString JSONValue] valueForKey:@"ticker"];
            [jsonString release];
            
            NSString *tickerStr = [NSString stringWithFormat:@"%@ %@", [frmtr stringFromNumber:[ticker valueForKey:@"last"]], curPerm];            
            double curTicker = [[ticker valueForKey:@"last"] doubleValue];
            if (lastTicker > 0) {
                if (lastTicker > curTicker) { [btcPrice setTextColor:[UIColor redColor]]; }
                if (lastTicker < curTicker) { [btcPrice setTextColor:[UIColor greenColor]]; }
                [self setLastTicker:curTicker];
            }
            if (lastTicker == 0) { [self setLastTicker:[[ticker valueForKey:@"last"] doubleValue]]; }
            
            [btcPrice setText:tickerStr];
            
            actRun--;
            
            [self setTickTimer:[NSTimer timerWithTimeInterval:0.175 target:self selector:@selector(changeTicker) userInfo:nil repeats:YES]];
            [[NSRunLoop currentRunLoop] addTimer:tickTimer forMode:NSDefaultRunLoopMode];
        } break;
        case 9: {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *sent = [jsonString JSONValue];
            NSLog(@"Sent: %@", sent);
            [jsonString release];
            actRun--;
        } break;
        case 10: {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *btc = [[jsonString JSONValue] valueForKey:@"btca"];
            [jsonString release];
            
            NSString *url = [NSString stringWithFormat:@"http://chart.apis.google.com/chart?cht=qr&chs=350x350&chl=bitcoin:%@", btc];
            NSData *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
            UIImage *image = [UIImage imageWithData:imageData];
            [image stretchableImageWithLeftCapWidth:300 topCapHeight:300];
            iButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [iButton setBackgroundImage:image forState:UIControlStateNormal];
            iButton.frame = CGRectMake(10, 100, 300, 300);
            [iButton addTarget:self action:@selector(dismissBarcode) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:iButton];
            [imageData release];
            actRun--;
        } break;
        case 11: {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *wdraw = [jsonString JSONValue];
            NSLog(@"Wdraw: %@", wdraw);
            [jsonString release];
            actRun--;
            [self reloadAll:connection];
        } break;
    }

    if ([[connection tag] intValue] != 99) { [dataCons removeObjectForKey:[connection tag]]; }
    if (actRun == 0) { [refreshAct stopAnimating]; }
}

@end
