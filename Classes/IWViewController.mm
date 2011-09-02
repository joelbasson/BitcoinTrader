//
//  IWViewController.m
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


#import "IWViewController.h"
#import "connectTag.h"
#import "SBJson.h"
#import "Constants.h"
#import "QRCodeReader.h"

@implementation IWViewController

@synthesize btcPrice;
@synthesize btcAvail;
@synthesize refreshAct;
@synthesize apiURL;
@synthesize spendBtc;
@synthesize sendBtc;
@synthesize iButton;
@synthesize walletID;
@synthesize greenAddress;
@synthesize pay;
@synthesize prefs;
@synthesize allTimer;
@synthesize lastTicker;
@synthesize dataCons;
@synthesize frmtr;
@synthesize address;
@synthesize addressButton;
@synthesize savedAddress;
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
    
    frmtr = [[NSNumberFormatter alloc] init]; 
    [frmtr setMaximumFractionDigits:4];
    [self setApiURL:[[NSString alloc] initWithString:instaURL]];
    [self setPrefs:[NSUserDefaults standardUserDefaults]];
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

- (void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
        
    if ([alertView tag] == 1)
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
    if ([alertView tag] == 2)
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
    if ([alertView tag] == 3)
    {
        if (buttonIndex == 0)
        {
            //nothing
        }
        else
        {
            int delI = 1;
            while (delI <= [prefs integerForKey:@"iw_total"]) {
                //NSLog(@"wid: %@\nobj: %@\ndelI: %@", walletID, [prefs objectForKey:[NSString stringWithFormat:@"%u", delI]], [NSString stringWithFormat:@"%u", delI]);
                if (walletID == [prefs objectForKey:[NSString stringWithFormat:@"iw_%u", delI]]) {
                    [prefs removeObjectForKey:[NSString stringWithFormat:@"iw_%u", delI]];
                    //NSLog(@"removed");
                    if (delI == [prefs integerForKey:@"iw_total"]) {
                        [prefs setInteger:delI-1 forKey:@"iw_total"];
                        //NSLog(@"last");
                    } else {
                        int del2I = delI+1;
                        while (del2I <= [prefs integerForKey:@"iw_total"]) {
                            [prefs setObject:[prefs objectForKey:[NSString stringWithFormat:@"iw_%u", del2I]] forKey:[NSString stringWithFormat:@"iw_%u", del2I-1]];
                            //NSLog(@"rearrange");
                            if (del2I == [prefs integerForKey:@"iw_total"]) {
                                //NSLog(@"done");
                                [prefs setInteger:del2I-1 forKey:@"iw_total"];
                            } else {
                                //NSLog(@"add");
                                del2I++;
                            }
                        }
                    }
                }
                delI++;
            }
            [prefs synchronize];
            [self logOff:self];
        }
    }
}

- (bool) reset {
    
    if (actRun != 0) {
        [logOffButton setEnabled:NO];
        [self performSelector:@selector(logOff:) withObject:nil afterDelay:0.5];
        return NO;
    } else {
        [self setLastTicker:nil];
        [self setActRun:nil];
        [frmtr release];
        [apiURL release];
        [prefs release];
        [walletID release];
        [allTimer invalidate];
        [self setAllTimer:nil];
        [btcPrice release];
        [btcAvail release];
        [refreshAct release];
        [greenAddress release];
        [pay release];
        [spendBtc release];
        [dataCons release];
        [savedAddress release];
        [addressButton release];
        [address release];
        [logOffButton release];
        return YES;
    }
}

- (IBAction) logOff:(id)sender {
    
    if ([self reset] == YES) { [self.navigationController popToRootViewControllerAnimated:YES]; }
    
}

- (void) payBtcInit: (NSString *)btca {
    
    [refreshAct startAnimating];
    actRun++;
    NSString *payStr = [NSString stringWithFormat:@"%@/w/%@/payment", apiURL, walletID];
	NSURL *payUrl = [NSURL URLWithString:payStr];
    NSLog(@"URL: %@", payUrl);
	NSMutableURLRequest *payReq = [NSMutableURLRequest requestWithURL:payUrl];
	
	[payReq setHTTPMethod:@"POST"];
	NSString *args = [NSString stringWithFormat:@"address=%@&amount=%@&use_green_address=%@", btca, ([[spendBtc text] intValue]/100000000), greenAddress];
	[payReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:payReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:4]];
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
    
    [addressButton setEnabled:NO];
    NSString *url = [NSString stringWithFormat:@"http://chart.apis.google.com/chart?cht=qr&chs=350x350&chl=bitcoin:%@", savedAddress];
    NSData *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [UIImage imageWithData:imageData];
    [image stretchableImageWithLeftCapWidth:300 topCapHeight:300];
    [self setIButton:[UIButton buttonWithType:UIButtonTypeCustom]];
    [iButton setBackgroundImage:image forState:UIControlStateNormal];
    [iButton setFrame:CGRectMake(10, 100, 300, 300)];
    [iButton addTarget:self action:@selector(dismissBarcode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:iButton];
    [imageData release];
    
}

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {

    [self setSendBtc:[result substringFromIndex:8]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Payment" message:[NSString stringWithFormat:@"Pay %@ BTC to\n%@?", [spendBtc text], sendBtc] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Pay", nil];
    [alert setTag:2];
    [alert show];
    [alert release];
    
    [self dismissModalViewControllerAnimated:NO];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) loadBalance {
    
    [refreshAct startAnimating];
    actRun++;
    NSString *urlString = [NSString stringWithFormat:@"%@/w/%@/balance", apiURL, walletID];
	NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"URL: %@", url);
	NSMutableURLRequest *ordersReq = [NSMutableURLRequest requestWithURL:url];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:ordersReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:1]];
    
    [connect release];
    
}

- (void) loadTicker {
    
    [refreshAct startAnimating];
    actRun++;
    NSString *urlString = [NSString stringWithFormat:@"%@/ticker.php", goxURL];
	NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *tickerReq = [NSMutableURLRequest requestWithURL:url];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:tickerReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:2]];
    [connect release];
    
}

- (IBAction) moreTicker: (id)sender {
    
    [spendBtc resignFirstResponder];
    [refreshAct startAnimating];
    actRun++;
    
    NSString *urlString = [NSString stringWithFormat:@"%@/ticker.php", goxURL];
	NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *tickerReq = [NSMutableURLRequest requestWithURL:url];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:tickerReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:3]];
    [connect release];
    
}

- (IBAction) reloadAll: (id)sender {
    if ([sender isKindOfClass:[NSTimer class]]) { //nothing
    } else {
        [spendBtc resignFirstResponder];
    }
    [self loadBalance];
    [self loadTicker];
    if (savedAddress == nil) { [self loadAddress]; }
}

- (void) dismissBarcode {
    
    [iButton removeFromSuperview];
    [addressButton setEnabled:YES];
    
}

- (void) setWallet:(NSString *)wID {
    
    [self setWalletID:wID];

    [self loadBalance];
    [self loadTicker];
    //wait a second to load address
    [self performSelector:@selector(loadAddress) withObject:nil afterDelay:1.0];
    
    int wI = 1;
    
    if ([prefs integerForKey:@"iw_total"] == 0) {
        [prefs setObject:wID forKey:@"iw_1"];
        [prefs setInteger:1 forKey:@"iw_total"];
        //NSLog(@"0 - added");
    }
    else 
    {
        while (wI <= [prefs integerForKey:@"iw_total"]) {
            //NSLog(@"wI: %u\ntotal: %u\nid=%@\n", wI, [prefs integerForKey:@"total"], [prefs objectForKey:[NSString stringWithFormat:@"%u", wI]]);
                
            if (walletID == [prefs objectForKey:[NSString stringWithFormat:@"iw_%u", wI]]) {
                wI = [prefs integerForKey:@"iw_total"];
                //NSLog(@"match");
            } else if (walletID != [prefs objectForKey:[NSString stringWithFormat:@"iw_%u", wI]] && wI == [prefs integerForKey:@"iw_total"]) {
                [prefs setObject:wID forKey:[NSString stringWithFormat:@"iw_%u", wI+1]];
                [prefs setInteger:wI+1 forKey:@"iw_total"];
                //NSLog(@"added");
            }
            wI++;
        }
    }
    [prefs synchronize];
    
    [self setAllTimer:[NSTimer timerWithTimeInterval:30.0 target:self selector:@selector(reloadAll:) userInfo:nil repeats:YES]];
    [[NSRunLoop currentRunLoop] addTimer:allTimer forMode:NSDefaultRunLoopMode];
}

- (void) newWallet {

    [refreshAct startAnimating];
    actRun++;
    NSString *urlString = [NSString stringWithFormat:@"%@/new_wallet", apiURL];
	NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *tickerReq = [NSMutableURLRequest requestWithURL:url];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:tickerReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:6]];
    [connect release];
    
}

- (void) loadAddress {
    
    [refreshAct startAnimating];
    actRun++;
    NSString *receiveStr = [NSString stringWithFormat:@"%@/w/%@/address", apiURL, walletID];
	NSURL *receiveUrl = [NSURL URLWithString:receiveStr];
    NSLog(@"URL: %@", receiveUrl);
	NSMutableURLRequest *receiveReq = [NSMutableURLRequest requestWithURL:receiveUrl];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:receiveReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:7]];
    [connect release];
    
}

- (IBAction) removeWallet: (id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Remove Wallet" message:@"This will remove the wallet from this device, but not from existence. Are you sure you want to do this?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Remove", nil];
    [alert setTag:3];
    [alert show];
    [alert release];
    
}

- (void) errorAlert:(NSString *)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert setTag:10];
    [alert show];
    [alert release];
    
}

- (void)connection:(connectTag *)connection didReceiveData:(NSData *)data{
    
    if ([dataCons objectForKey:connection.tag] == nil) {
        
        NSMutableData *newData = [[NSMutableData alloc] initWithData:data];
        
        [dataCons setObject:newData forKey:[connection tag]];
        [newData release];
    }
    
    NSString *errorTest = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *errorStr = [[errorTest JSONValue] valueForKey:@"successful"];
    [errorTest release];
    if ([errorStr isEqual:0]) { [self errorAlert: [[errorTest JSONValue] valueForKey:@"message"]]; [connection setTag:[NSNumber numberWithInt:99]]; actRun--; }
    
    NSLog(@"ConnectTag: %@", [connection tag]);
            
    switch ([[connection tag] intValue]) {
        case 99: {
            //nothing
        } break;
        case 1: {
            //NSLog(@"Original balance: %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];            
            NSNumber *balTemp = [[jsonString JSONValue] objectForKey:@"balance"];
            [jsonString release];
            int balance = [balTemp intValue]*100000000;
            //if (balance > 0) { balance = balance/100000000; }
            [btcAvail setText:[NSString stringWithFormat:@"%u BTC", balance]];
            actRun--;
        } break;
        case 2: {
            //NSLog(@"Original ticker: %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *ticker = [[jsonString JSONValue] valueForKey:@"ticker"];
            [jsonString release];
            //NSLog(@"Received ticker: %@\n", ticker);

            NSString *tickerStr = [NSString stringWithFormat:@"%@ USD", [frmtr stringFromNumber:[ticker valueForKey:@"last"]]];            
            double curTicker = [[ticker valueForKey:@"last"] doubleValue];
            if (lastTicker > 0) {
                if (lastTicker > curTicker) { [btcPrice setTextColor:[UIColor redColor]]; }
                if (lastTicker < curTicker) { [btcPrice setTextColor:[UIColor greenColor]];  }
                [self setLastTicker:curTicker];
            }
            if (lastTicker == 0) { [self setLastTicker:[[ticker valueForKey:@"last"] doubleValue]]; }
        
            [btcPrice setText:tickerStr];
            actRun--;
        } break;
        case 3: {
            actRun--;
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *ticker = [[jsonString JSONValue] valueForKey:@"ticker"];
            [jsonString release];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mt. Gox Ticker" message:[NSString stringWithFormat:@"Sell: %@\nBuy: %@\nLast: %@\nVolume: %@\nHigh: %@\nLow: %@", [ticker valueForKey:@"sell"], [ticker valueForKey:@"buy"], [ticker valueForKey:@"last"], [ticker valueForKey:@"vol"], [ticker valueForKey:@"high"], [ticker valueForKey:@"low"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Refresh", nil];
            [alert setTag:1];
            [alert show];
            [alert release];
        } break;
        case 4: {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *sent = [jsonString JSONValue];
            NSLog(@"Sent: %@", sent);
            [jsonString release];
            actRun--;
        } break;
        case 6: {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *tempID = [[jsonString JSONValue] valueForKey:@"wallet_id"];
            //NSLog(@"ID: %@", tempID);
            [self setWallet:tempID];
            [jsonString release];
            actRun--;
        } break;
        case 7: {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *add = [[jsonString JSONValue] valueForKey:@"address"];
            [address setText:[NSString stringWithFormat:@"InstaWallet Address: %@", add]];
            [self setSavedAddress:add];
            [jsonString release];
            actRun--;
        } break;
    }
    
    if (actRun == 0) { [refreshAct stopAnimating]; }
    if ([[connection tag] intValue] != 99) { [dataCons removeObjectForKey:[connection tag]]; }
}

@end
