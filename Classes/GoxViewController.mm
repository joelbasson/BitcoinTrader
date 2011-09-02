//
//  THViewController.m
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


#import "GoxViewController.h"
#import "connectTag.h"
#import "JSON/SBJson.h"
#import "Constants.h"
#import "QRCodeReader.h"
#import "Crypto.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation GoxViewController

@synthesize btcPrice;
@synthesize btcAvail;
@synthesize curAvail;
@synthesize orderTable;
@synthesize buySell;
@synthesize numBtc;
@synthesize limitPrice;
@synthesize go;
@synthesize curPerm;
@synthesize orderList;
@synthesize newOrders;
@synthesize curLabel;
@synthesize refreshAct;
@synthesize scrollingTick;
@synthesize tickTimer;
@synthesize allTimer;
@synthesize apiURL;
@synthesize scrollView;
@synthesize spendBtc;
@synthesize sendBtc;
@synthesize permKey;
@synthesize permSec;
@synthesize prefs;
@synthesize orderLabel;
@synthesize goPay;
@synthesize accID;
@synthesize orderDic;
@synthesize sOid;
@synthesize ordersFunds;
@synthesize withdrawAmt;
@synthesize depAdd;
@synthesize depWith;
@synthesize dwolla;
@synthesize i;
@synthesize length;
@synthesize lastTicker;
@synthesize dataCons;
@synthesize frmtr;
@synthesize scrollingFeed;
@synthesize loading;
@synthesize canDep;
@synthesize canWith;
@synthesize addressButton;
@synthesize iButton;
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
    orderList = [[NSMutableArray alloc] init];
    newOrders = [[NSMutableArray alloc] init];
    frmtr = [[NSNumberFormatter alloc] init]; 
    [frmtr setMaximumFractionDigits:4];
    tickTimer = [[NSTimer alloc] init];
    scrollingFeed = [[NSDictionary alloc] init];
    [self setApiURL:goxURL];
    //not needed for gox yet
    [self setCurPerm:@"USD"];
    [curLabel setText:curPerm];
    [self setPrefs:[NSUserDefaults standardUserDefaults]];
    [self setLoading:0];
    [self setCanDep:0];
    [self setCanWith:0];
    
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
        [self setI:nil];
        [self setLength:nil];
        [self setLastTicker:nil];
        [self setLoading:nil];
        [self setCanDep:nil];
        [self setCanWith:nil];
        [self setActRun:nil];
        [self setAccID:nil];
        if (tickTimer != nil) {
            [tickTimer invalidate];
            [self setTickTimer:nil];
        }
        [allTimer invalidate];
        [self setAllTimer:nil];
        [btcPrice release];
        [btcAvail release];
        [curAvail release];
        [orderTable release];
        [buySell release];
        [numBtc release];
        [limitPrice release];
        [go release];
        [curPerm release];
        [orderList release];
        [newOrders release];
        [curLabel release];
        [refreshAct release];
        [scrollingTick release];
        [apiURL release];
        [scrollView release];
        [spendBtc release];
        [permKey release];
        [permSec release];
        [prefs release];
        [orderLabel release];
        [goPay release];
        [orderDic release];
        [ordersFunds release];
        [withdrawAmt release];
        [depAdd release];
        [depWith release];
        [dwolla release];
        [dataCons release];
        [frmtr release];
        [scrollingFeed release];
        [addressButton release];
        [logOffButton release];
        [sendBtc release];
        [sOid release];
        return YES;
    }
    
}

- (IBAction) logOff:(id)sender {
    
    if ([self reset] == YES) { [self.navigationController popToRootViewControllerAnimated:YES]; }
    
}

- (void) setKeys:(NSString *)pin accid: (int) accountid {
    
    [refreshAct startAnimating];
    actRun++;

    [self setAccID:accountid];
    NSDictionary *results = [prefs objectForKey:[NSString stringWithFormat:@"goxdata_%u", accID]];
    [self setPermKey:[NSString decryptData:[results valueForKey:@"key"] withKey:pin]];
    [self setPermSec:[NSString decryptData:[results valueForKey:@"secret"] withKey:pin]];
    
    NSDate *start = [NSDate date];
    int nonce = [start timeIntervalSince1970];
    
    unsigned char cHMACk[CC_SHA512_DIGEST_LENGTH];
    
    NSString *goxStr = [NSString stringWithFormat:@"%@/info.php", apiURL];
    NSURL *goxUrl = [NSURL URLWithString:goxStr];
    NSLog(@"URL: %@", goxUrl);
    NSMutableURLRequest *goxReq = [NSMutableURLRequest requestWithURL:goxUrl];
    
    [goxReq setHTTPMethod:@"POST"];
    NSString *args = [NSString stringWithFormat:@"&nonce=%u", nonce];
    NSData *tempSec = [NSData base64DataFromString:permSec];
    CCHmac(kCCHmacAlgSHA512, tempSec.bytes, tempSec.length, [args cStringUsingEncoding:NSASCIIStringEncoding], strlen([args cStringUsingEncoding:NSASCIIStringEncoding]), cHMACk);
    NSData *tempData = [[NSData alloc] initWithBytes:cHMACk length:CC_SHA512_DIGEST_LENGTH];
    [goxReq setValue:permKey forHTTPHeaderField:@"Rest-Key"];
    [goxReq setValue:[NSString base64StringFromData:tempData length:tempData.length] forHTTPHeaderField:@"Rest-Sign"];
    [goxReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
    
    connectTag *connect = [[connectTag alloc] initWithRequest:goxReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:9]];
    [connect release];
    [tempData release];
    
    [self loadScrollingTicker];
    
    [self setAllTimer:[NSTimer timerWithTimeInterval:30.0 target:self selector:@selector(reloadAll:) userInfo:nil repeats:YES]];
    [[NSRunLoop currentRunLoop] addTimer:allTimer forMode:NSDefaultRunLoopMode];
    
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
        [spendBtc resignFirstResponder];
        [withdrawAmt resignFirstResponder];
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
            [self setSOid:nil];
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
            [prefs removeObjectForKey:[NSString stringWithFormat:@"goxdata_%u", accID]];
            [prefs removeObjectForKey:[NSString stringWithFormat:@"gox_%u", accID]];
            int deli = 1;

            while (deli <= [prefs integerForKey:@"gox_total"]) {
                if (deli > accID) {
                    [prefs setObject:[prefs objectForKey:[NSString stringWithFormat:@"goxdata_%u", deli]] forKey:[NSString stringWithFormat:@"goxdata_%u", deli-1]];
                    [prefs setObject:[prefs objectForKey:[NSString stringWithFormat:@"gox_%u", deli]] forKey:[NSString stringWithFormat:@"gox_%u", deli-1]];
                    [prefs removeObjectForKey:[NSString stringWithFormat:@"goxdata_%u", deli]];
                    [prefs removeObjectForKey:[NSString stringWithFormat:@"gox_%u", deli]];
                }
                deli++;
            }
            
            [prefs setInteger:[prefs integerForKey:@"gox_total"]-1 forKey:@"gox_total"];
            [self logOff:self];
        }
    }
    if ([alertView tag] == 6)
    {
        if (buttonIndex == 0)
        {
            //nothing
        }
        else
        {
            [refreshAct startAnimating];
            actRun++;
            
            [self setLoading:1];
            NSDate *start = [NSDate date];
            int noncewd = [start timeIntervalSince1970]+1;
            unsigned char cHMACwd[CC_SHA512_DIGEST_LENGTH];
            
            NSString *withString = [NSString stringWithFormat:@"%@/withdraw.php", apiURL];
            NSURL *withUrl = [NSURL URLWithString:withString];
            NSLog(@"URL: %@", withUrl);
            NSMutableURLRequest *withReq = [NSMutableURLRequest requestWithURL:withUrl];
            
            [withReq setHTTPMethod:@"POST"];
            NSString *args = [NSString stringWithFormat:@"nonce=%u&group1=DWUSD&amount=%@", noncewd, [withdrawAmt text]];
            NSData *tempSec = [NSData base64DataFromString:permSec];
            CCHmac(kCCHmacAlgSHA512, tempSec.bytes, tempSec.length, [args cStringUsingEncoding:NSASCIIStringEncoding], strlen([args cStringUsingEncoding:NSASCIIStringEncoding]), cHMACwd);
            NSData *tempData = [[NSData alloc] initWithBytes:cHMACwd length:CC_SHA512_DIGEST_LENGTH];
            [withReq setValue:permKey forHTTPHeaderField:@"Rest-Key"];
            [withReq setValue:[NSString base64StringFromData:tempData length:tempData.length] forHTTPHeaderField:@"Rest-Sign"];
            [withReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
            
            connectTag *connect = [[connectTag alloc] initWithRequest:withReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:10]];
            [tempData release];
            [connect release];
        }
    }
}

- (void) placeOrder: (NSString *) num: (NSString *) pri {
    
    [refreshAct startAnimating];
    actRun++;
    
    [self setLoading:1];
    NSDate *start = [NSDate date];
    int noncepo = [start timeIntervalSince1970]+1;
    
    unsigned char cHMACpo[CC_SHA512_DIGEST_LENGTH];
    
    if ([buySell selectedSegmentIndex] == 0)
    {
        //buy
        NSString *buyString = [NSString stringWithFormat:@"%@/buyBTC.php", apiURL];
        NSURL *buyUrl = [NSURL URLWithString:buyString];
        NSLog(@"URL: %@", buyUrl);
        NSMutableURLRequest *buyReq = [NSMutableURLRequest requestWithURL:buyUrl];
        
        [buyReq setHTTPMethod:@"POST"];
        NSString *args = [NSString stringWithFormat:@"nonce=%u&price=%@&amount=%@", noncepo, pri, num];
        NSData *tempSec = [NSData base64DataFromString:permSec];
        CCHmac(kCCHmacAlgSHA512, tempSec.bytes, tempSec.length, [args cStringUsingEncoding:NSASCIIStringEncoding], strlen([args cStringUsingEncoding:NSASCIIStringEncoding]), cHMACpo);
        NSData *tempData = [[NSData alloc] initWithBytes:cHMACpo length:CC_SHA512_DIGEST_LENGTH];
        [buyReq setValue:permKey forHTTPHeaderField:@"Rest-Key"];
        [buyReq setValue:[NSString base64StringFromData:tempData length:tempData.length] forHTTPHeaderField:@"Rest-Sign"];
        [buyReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
        
        connectTag *connect = [[connectTag alloc] initWithRequest:buyReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:3]];
        [tempData release];
        [connect release];
    }
    
    if ([buySell selectedSegmentIndex] == 1)
    {
        //sell
        NSString *sellString = [NSString stringWithFormat:@"%@/sellBTC.php", apiURL];
        NSURL *sellUrl = [NSURL URLWithString:sellString];
        NSLog(@"URL: %@", sellUrl);
        NSMutableURLRequest *sellReq = [NSMutableURLRequest requestWithURL:sellUrl];
        
        [sellReq setHTTPMethod:@"POST"];
        NSString *args = [NSString stringWithFormat:@"nonce=%u&price=%@&amount=%@", noncepo, pri, num];
        NSData *tempSec = [NSData base64DataFromString:permSec];
        CCHmac(kCCHmacAlgSHA512, tempSec.bytes, tempSec.length, [args cStringUsingEncoding:NSASCIIStringEncoding], strlen([args cStringUsingEncoding:NSASCIIStringEncoding]), cHMACpo);
        NSData *tempData = [[NSData alloc] initWithBytes:cHMACpo length:CC_SHA512_DIGEST_LENGTH];
        [sellReq setValue:permKey forHTTPHeaderField:@"Rest-Key"];
        [sellReq setValue:[NSString base64StringFromData:tempData length:tempData.length] forHTTPHeaderField:@"Rest-Sign"];
        [sellReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
        
        connectTag *connect = [[connectTag alloc] initWithRequest:sellReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:4]];
        [tempData release];
        [connect release];
    }
    [numBtc setText:nil]; [limitPrice setText:nil];
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
    
    [self setSOid:[NSString stringWithFormat:@"%@:%@", [[orderDic objectAtIndex:indexPath.row] valueForKey:@"oid"], [[orderDic objectAtIndex:indexPath.row] valueForKey:@"type"]]];
    NSArray *tempOrderInfo = [sOid componentsSeparatedByString:@":"];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:[NSString stringWithFormat:@"Cancel Order %@?", [tempOrderInfo objectAtIndex:0]] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Cancel", nil];
    [alert setTag:2];
    [alert show];
    [alert release];

}

- (void) cancelOrder {
    
    [refreshAct startAnimating];
    actRun++;
    
    [self setLoading:1];
    NSDate *start = [NSDate date];
    int nonceoc = [start timeIntervalSince1970]+1;
    
    unsigned char cHMACoc[CC_SHA512_DIGEST_LENGTH];
    
    NSString *cancelStr = [NSString stringWithFormat:@"%@/cancelOrder.php", apiURL];
	NSURL *cancelUrl = [NSURL URLWithString:cancelStr];
    NSLog(@"URL: %@", cancelUrl);
	NSMutableURLRequest *cancelReq = [NSMutableURLRequest requestWithURL:cancelUrl];
	
	[cancelReq setHTTPMethod:@"POST"];
    NSArray *tempOrderInfo = [sOid componentsSeparatedByString:@":"];
	NSString *args = [NSString stringWithFormat:@"nonce=%u&oid=%@&type=%u", nonceoc, [tempOrderInfo objectAtIndex:0], [tempOrderInfo lastObject]];
	NSData *tempSec = [NSData base64DataFromString:permSec];
    CCHmac(kCCHmacAlgSHA512, tempSec.bytes, tempSec.length, [args cStringUsingEncoding:NSASCIIStringEncoding], strlen([args cStringUsingEncoding:NSASCIIStringEncoding]), cHMACoc);
    NSData *tempData = [[NSData alloc] initWithBytes:cHMACoc length:CC_SHA512_DIGEST_LENGTH];
    [cancelReq setValue:permKey forHTTPHeaderField:@"Rest-Key"];
    [cancelReq setValue:[NSString base64StringFromData:tempData length:tempData.length] forHTTPHeaderField:@"Rest-Sign"];
    [cancelReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:cancelReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:1]];
    [tempData release];
    [connect release];
}

- (void) loadOrders {
    
    if (loading == 1) { //nothing
    } else {
        
        [refreshAct startAnimating];
        actRun++;
        
        [self setLoading:1];
        NSDate *start = [NSDate date];
        int nonceo = [start timeIntervalSince1970]+1;
    
        unsigned char cHMACo[CC_SHA512_DIGEST_LENGTH];
        
        NSString *urlString = [NSString stringWithFormat:@"%@/getOrders.php", apiURL];
        NSURL *url = [NSURL URLWithString:urlString];
        NSLog(@"URL: %@", url);
        NSMutableURLRequest *ordersReq = [NSMutableURLRequest requestWithURL:url];
	
        [ordersReq setHTTPMethod:@"POST"];
        NSString *args = [NSString stringWithFormat:@"&nonce=%u", nonceo];
        NSData *tempSec = [NSData base64DataFromString:permSec];
        CCHmac(kCCHmacAlgSHA512, tempSec.bytes, tempSec.length, [args cStringUsingEncoding:NSASCIIStringEncoding], strlen([args cStringUsingEncoding:NSASCIIStringEncoding]), cHMACo);
        NSData *tempData = [[NSData alloc] initWithBytes:cHMACo length:CC_SHA512_DIGEST_LENGTH];
        [ordersReq setValue:permKey forHTTPHeaderField:@"Rest-Key"];
        [ordersReq setValue:[NSString base64StringFromData:tempData length:tempData.length] forHTTPHeaderField:@"Rest-Sign"];
        [ordersReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
        connectTag *connect = [[connectTag alloc] initWithRequest:ordersReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:1]];
        [tempData release];
        [connect release];
    }

}

- (void) loadScrollingTicker {
    
    [refreshAct startAnimating];
    actRun++;
    
    [self setI:0];
    [scrollingTick setText:@""];
    NSString *urlString = [NSString stringWithFormat:@"%@/data/ticker.php", apiURL];
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
    [spendBtc resignFirstResponder];
    [withdrawAmt resignFirstResponder];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/data/ticker.php", apiURL];
	NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *tickerReq = [NSMutableURLRequest requestWithURL:url];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:tickerReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:7]];
    [connect release];
    
}

-(void) changeTicker {
            
    NSString *tickerStr = [NSString stringWithFormat:@"High: %@\nLow: %@\nAverage: %@\nVolume: %@\nLast: %@\nBuy: %@\nSell: %@", [scrollingFeed valueForKey:@"high"], [scrollingFeed valueForKey:@"low"], [scrollingFeed valueForKey:@"avg"], [scrollingFeed valueForKey:@"vol"], [scrollingFeed valueForKey:@"last"], [scrollingFeed valueForKey:@"buy"], [scrollingFeed valueForKey:@"sell"]];

    [self setLength:[tickerStr length]];
    
    if (i>length+30) {
        
        //consider saving the remaining label and attaching it to first 15 of next ticker
        
        [tickTimer invalidate];
        [self setTickTimer:nil];
        [self loadScrollingTicker];
    } else if (i<31) {
        [scrollingTick setTextAlignment:UITextAlignmentRight];
        [scrollingTick setText:[tickerStr substringWithRange:NSMakeRange(0, i)]];
        //NSLog(@"i: %u-%u length<31: %u", 0, i, length);
    } else if (i>length) {
        [scrollingTick setTextAlignment:UITextAlignmentLeft];
        //NSLog(@"i: %u-%u length: %u", i-30, (length+30)-i, length);
        [scrollingTick setText:[tickerStr substringWithRange:NSMakeRange(i-30, (length+30)-i)]];
    } else {
        [scrollingTick setTextAlignment:UITextAlignmentCenter];
        [scrollingTick setText:[tickerStr substringWithRange:NSMakeRange(i-30, 30)]];
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
        [withdrawAmt resignFirstResponder];
    }
    if ([ordersFunds selectedSegmentIndex] == 0) { [self loadOrders]; }
}

- (void) payBtcInit: (NSString *)btca {
    
    [refreshAct startAnimating];
    actRun++;
    
    [self setLoading:1];
    NSDate *start = [NSDate date];
    int noncep = [start timeIntervalSince1970]+1;
    
    unsigned char cHMACp[CC_SHA512_DIGEST_LENGTH];
    
    NSString *payStr = [NSString stringWithFormat:@"%@/withdraw.php", apiURL];
	NSURL *payUrl = [NSURL URLWithString:payStr];
    NSLog(@"URL: %@", payUrl);
	NSMutableURLRequest *payReq = [NSMutableURLRequest requestWithURL:payUrl];
	
	[payReq setHTTPMethod:@"POST"];
	NSString *args = [NSString stringWithFormat:@"nonce=%u&group1=BTC&btca=%@&amount=%@", noncep, sendBtc, [spendBtc text]];
    NSData *tempSec = [NSData base64DataFromString:permSec];
    CCHmac(kCCHmacAlgSHA512, tempSec.bytes, tempSec.length, [args cStringUsingEncoding:NSASCIIStringEncoding], strlen([args cStringUsingEncoding:NSASCIIStringEncoding]), cHMACp);
    NSData *tempData = [[NSData alloc] initWithBytes:cHMACp length:CC_SHA512_DIGEST_LENGTH];
    [payReq setValue:permKey forHTTPHeaderField:@"Rest-Key"];
    [payReq setValue:[NSString base64StringFromData:tempData length:tempData.length] forHTTPHeaderField:@"Rest-Sign"];
	[payReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:payReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:12]];
    [tempData release];
    [connect release];
    [self setSendBtc:nil];
    
}

- (IBAction)payBtc:(id)sender {
    
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

- (IBAction)withdraw:(id)sender {
    
    [withdrawAmt resignFirstResponder];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Withdrawal" message:[NSString stringWithFormat:@"Withdraw %@ USD to Dwolla?", [withdrawAmt text]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Withdraw", nil];
    [alert setTag:6];
    [alert show];
    [alert release];
    
}

- (IBAction)depAddress:(id)sender {
    
    [addressButton setEnabled:NO];
    [refreshAct startAnimating];
    actRun++;
    
    [self setLoading:1];
    NSDate *start = [NSDate date];
    int noncedep = [start timeIntervalSince1970]+1;
    
    unsigned char cHMACdep[CC_SHA512_DIGEST_LENGTH];
    
    NSString *depStr = [NSString stringWithFormat:@"%@/btcAddress.php", apiURL];
	NSURL *depUrl = [NSURL URLWithString:depStr];
    NSLog(@"URL: %@", depUrl);
	NSMutableURLRequest *depReq = [NSMutableURLRequest requestWithURL:depUrl];
	
	[depReq setHTTPMethod:@"POST"];
	NSString *args = [NSString stringWithFormat:@"nonce=%u", noncedep];
    NSData *tempSec = [NSData base64DataFromString:permSec];
    CCHmac(kCCHmacAlgSHA512, tempSec.bytes, tempSec.length, [args cStringUsingEncoding:NSASCIIStringEncoding], strlen([args cStringUsingEncoding:NSASCIIStringEncoding]), cHMACdep);
    NSData *tempData = [[NSData alloc] initWithBytes:cHMACdep length:CC_SHA512_DIGEST_LENGTH];
    [depReq setValue:permKey forHTTPHeaderField:@"Rest-Key"];
    [depReq setValue:[NSString base64StringFromData:tempData length:tempData.length] forHTTPHeaderField:@"Rest-Sign"];
	[depReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:depReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:11]];
    [tempData release];
    [connect release];
    
}

- (void) setLayout: (int) section {
    
    NSLog(@"Layout: %u", section);
    
    if (section == 1) {
        //deposit
        [ordersFunds setHidden:NO];
        [self setCanDep:1];
    }
    if (section == 2) {
        //trade
        [buySell setHidden:NO];
        [numBtc setHidden:NO];
        [limitPrice setHidden:NO];
        [go setHidden:NO];
        [orderTable setHidden:NO];
        [self loadOrders];
    }
    if (section == 3) {
        //withdraw
        [self setCanWith:1];
        [ordersFunds setHidden:NO];
        [spendBtc setHidden:NO];
        [goPay setHidden:NO];
    }
    
}

- (IBAction) setLower:(id)sender {
    
    if ([ordersFunds selectedSegmentIndex] == 0) {
        [scrollView setContentSize:CGSizeMake(320, 460)];
        [withdrawAmt resignFirstResponder];
        [orderTable setHidden:NO];
        [depWith setHidden:YES];
        [withdrawAmt setHidden:YES];
        [dwolla setHidden:YES];
        [depAdd setHidden:YES];
        [orderTable reloadData];
    }
    if ([ordersFunds selectedSegmentIndex] == 1) {
        [orderTable setHidden:YES];
        [depWith setHidden:NO];
        [self setFunds:self];
    }
    
}

- (IBAction) setFunds:(id)sender {
    
    if (canDep == 0) { [depWith setEnabled:NO forSegmentAtIndex:0]; }
    if (canWith == 0) { [depWith setEnabled:NO forSegmentAtIndex:1]; }
    
    if ([depWith selectedSegmentIndex] == 0) {
        [scrollView setContentSize:CGSizeMake(320, 460)];
        [withdrawAmt resignFirstResponder];
        [withdrawAmt setHidden:YES];
        [dwolla setHidden:YES];
        [depAdd setHidden:NO];
    }
    if ([depWith selectedSegmentIndex] == 1) {
        [scrollView setContentSize:CGSizeMake(320, 650)];
        [depAdd setHidden:YES];
        [withdrawAmt setHidden:NO];
        [dwolla setHidden:NO];
    }
    
}

- (IBAction) remove: (id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Remove Account" message:@"This will remove the account from this device, but not from existence. Are you sure you want to do this?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Remove", nil];
    [alert setTag:5];
    [alert show];
    [alert release];
    
}

- (void) dismissBarcode {
    
    [iButton removeFromSuperview];
    [addressButton setEnabled:YES];
    
}

- (void)connection:(connectTag *)connection didReceiveData:(NSData *)data{
        
    if ([dataCons objectForKey:connection.tag] == nil) {
        
        NSMutableData *newData = [[NSMutableData alloc] initWithData:data];
        
        [dataCons setObject:newData forKey:connection.tag];
        [newData release];
    }
    
    NSString *errorTest = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *errorStr = [[errorTest JSONValue] valueForKey:@"error"];
    NSString *statStr = [[errorTest JSONValue] valueForKey:@"status"];
    [errorTest release];
    if ([errorStr length] > 0) { [self errorAlert: errorStr]; [connection setTag:[NSNumber numberWithInt:99]]; [self setLoading:0]; actRun--; }
    if ([statStr length] > 0) { NSLog(@"Status: %@", statStr); [self setLoading:0]; }

    
    NSLog(@"ConnectTag: %@", [connection tag]);
            
    switch ([[connection tag] intValue]) {
        case 99: {
            //nothing
        } break;
        case 1: {
            //NSLog(@"Original orders: %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];            
            NSArray *tempArray = [[NSArray alloc] initWithArray:[[jsonString JSONValue] objectForKey:@"orders"]];
            NSString *btc = [[jsonString JSONValue] valueForKey:@"btcs"];
            NSString *usd = [[jsonString JSONValue] valueForKey:@"usds"];
            [jsonString release];
            [btcAvail setText:[frmtr stringFromNumber:[frmtr numberFromString:btc]]];
            [curAvail setText:[frmtr stringFromNumber:[frmtr numberFromString:usd]]];
            
            if (orderDic == nil) { orderDic = [[NSMutableArray alloc] init]; }
            [orderList removeAllObjects];
            [orderDic removeAllObjects];
            int oI = 0;
            NSArray *keys = [[NSArray alloc] initWithObjects:@"oid", @"type", nil];
            if ([tempArray count] == 0) { //no orders
            } else {
                while (oI < [tempArray count]) {
                    NSDictionary *order = [[NSDictionary alloc] initWithDictionary:[tempArray objectAtIndex:oI]];
                    NSString *type = [[NSString alloc] init];
                    if ([[order valueForKey:@"type"] intValue] == 1) { type = @"Sell"; }
                    if ([[order valueForKey:@"type"] intValue] == 2) { type = @"Buy"; }
                    [orderList addObject:[NSString stringWithFormat:@"%@: %@ BTC at %@ %@", type, [order valueForKey:@"amount"], [order valueForKey:@"price"], [order valueForKey:@"currency"]]];
                    NSArray *info = [[NSArray alloc] initWithObjects:[order valueForKey:@"oid"], [order valueForKey:@"type"], nil];
                    NSDictionary *tempInfo = [[NSDictionary alloc] initWithObjects:info forKeys:keys];
                    [orderDic addObject:tempInfo];
                    [info release];
                    [tempInfo release];
                    [order release];
                    [type release];
                    oI++;
                }
            }
            [orderTable reloadData];
            
            [tempArray release];
            [keys release];
            [self setLoading:0];
            actRun--;
        } break;
        case 3: {
            //NSLog(@"Original buys: %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            [self setLoading:0];
            actRun--;
            [self performSelector:@selector(loadOrders) withObject:nil afterDelay:1.0];
        } break;
        case 4: {
            [self setLoading:0];
            actRun--;
            //NSLog(@"Original sells: %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            [self performSelector:@selector(loadOrders) withObject:nil afterDelay:1.0];       
        } break;
        case 7: {
            actRun--; if (actRun == 0) { [refreshAct stopAnimating]; }
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *ticker = [[jsonString JSONValue] valueForKey:@"ticker"];
            [jsonString release];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Full Ticker" message:[NSString stringWithFormat:@"High: %@\nLow: %@\nAverage: %@\nVolume: %@\nLast: %@\nBuy: %@\nSell: %@", [ticker valueForKey:@"high"], [ticker valueForKey:@"low"], [ticker valueForKey:@"avg"], [ticker valueForKey:@"vol"], [ticker valueForKey:@"last"], [ticker valueForKey:@"buy"], [ticker valueForKey:@"sell"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Refresh", nil];
            [alert setTag:3];
            [alert show];
            [alert release];
        } break;
        case 8: {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [self setScrollingFeed:[[jsonString JSONValue] valueForKey:@"ticker"]];
            NSDictionary *ticker = [[jsonString JSONValue] valueForKey:@"ticker"];
            [jsonString release];
            
            [self setTickTimer:[NSTimer timerWithTimeInterval:0.175 target:self selector:@selector(changeTicker) userInfo:nil repeats:YES]];
            [[NSRunLoop currentRunLoop] addTimer:tickTimer forMode:NSDefaultRunLoopMode];
            
            NSString *tickerStr = [NSString stringWithFormat:@"%@ %@", [ticker valueForKey:@"last"], curPerm];            
            double curTicker = [[ticker valueForKey:@"last"] doubleValue];
            if (lastTicker > 0) {
                if (lastTicker > curTicker) { [btcPrice setTextColor:[UIColor redColor]]; }
                if (lastTicker < curTicker) { [btcPrice setTextColor:[UIColor greenColor]]; }
                [self setLastTicker:curTicker];
            }
            if (lastTicker == 0) { [self setLastTicker:[[ticker valueForKey:@"last"] doubleValue]]; }
            
            [btcPrice setText:tickerStr];
            actRun--;
        } break;
        case 9: {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSArray *feed = [[jsonString JSONValue] valueForKey:@"Rights"];
            if ([prefs objectForKey:[NSString stringWithFormat:@"gox_%u", accID]] == nil) {
                [prefs setObject:[[jsonString JSONValue] valueForKey:@"Login"] forKey:[NSString stringWithFormat:@"gox_%u", accID]];
            }
            [jsonString release];
            int privs = 0;
            while (privs < [feed count]) {
                if ([[feed objectAtIndex:privs] isEqualToString:@"deposit"]) { [self setLayout: 1]; }
                if ([[feed objectAtIndex:privs] isEqualToString:@"trade"]) { [self setLayout: 2]; }
                if ([[feed objectAtIndex:privs] isEqualToString:@"withdraw"]) { [self setLayout: 3]; }
                privs++;
            }
            if (canDep == 0 && canWith == 0) {
                [ordersFunds setEnabled:NO forSegmentAtIndex:1];
            }
            actRun--;
        } break;
        case 10: {
            //NSLog(@"Original withdraw: %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            [self setLoading:0];
            actRun--;
        } break;
        case 11: {
            actRun--; if (actRun == 0) { [refreshAct stopAnimating]; }
            //NSLog(@"Original btc: %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *btc = [[jsonString JSONValue] valueForKey:@"addr"];
            [jsonString release];
            [self setLoading:0];

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
        } break;
        case 12: {
            //NSLog(@"Original pay: %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            [self setLoading:0];
            actRun--;
        } break;
    }

    if (actRun == 0) { [refreshAct stopAnimating]; }
    if ([[connection tag] intValue] != 99) { [dataCons removeObjectForKey:[connection tag]]; }
    
}

@end
