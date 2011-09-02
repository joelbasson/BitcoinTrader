//
//  OrderViewController.m
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


#import "OrderViewController.h"
#import "connectTag.h"
#import "JSON/SBJson.h"
#import "Constants.h"

@implementation OrderViewController

@synthesize btcPrice;
@synthesize btcAvail;
@synthesize btcRes;
@synthesize curAvail;
@synthesize curRes;
@synthesize orderTable;
@synthesize buySell;
@synthesize numBtc;
@synthesize limitPrice;
@synthesize go;
@synthesize userPerm;
@synthesize passPerm;
@synthesize curPerm;
@synthesize orderList;
@synthesize newOrders;
@synthesize curLabel;
@synthesize refreshAct;

int trade = 0;
int oid;
double lastTicker = 0;
NSMutableDictionary *dataCons;
NSNumberFormatter *frmtr;


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
    
    dataCons = [[NSMutableDictionary alloc] init];
    orderList = [[NSMutableArray alloc] init];
    newOrders = [[NSMutableArray alloc] init];
    frmtr = [[[NSNumberFormatter alloc] init] retain]; 
    [frmtr setMaximumFractionDigits:4];
    
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [frmtr release];
    [super dealloc];
}

- (IBAction)selectTrade:(id)sender {
    //buy = 0, sell = 1
    trade = [buySell selectedSegmentIndex];
}

- (IBAction) confirmTrade:(id)sender {
    
    if ([numBtc.text length] == 0 || [limitPrice.text length] == 0)
    {
        //error
    }
    else
    {
        [numBtc resignFirstResponder];
        [limitPrice resignFirstResponder];
        NSString *action = [[[NSString alloc] init] autorelease];
        if (trade == 0) { action = @"Buy"; } if (trade == 1) { action = @"Sell"; }
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
            //nothing
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
            [self reloadAll:alertView];
        }
        else
        {
            [self moreTicker:alertView];
        }
    }
}

- (void) placeOrder: (NSString *) num: (NSString *) pri {
    //determine whether buy or sell is pushed, build URL, uialert confirming order, new didreceivedata function, reload order list&table view
    
    if (trade == 0)
    {
        //buy
        NSString *buyString = [NSString stringWithFormat:@"%@%@/BuyBTC", apiURL, curPerm];
        NSURL *buyUrl = [NSURL URLWithString:buyString];
        NSLog(@"URL: %@", buyUrl);
        NSMutableURLRequest *buyReq = [NSMutableURLRequest requestWithURL:buyUrl];
        
        [buyReq setHTTPMethod:@"POST"];
        NSString *args = [NSString stringWithFormat:@"name=%@&pass=%@&price=%@&amount=%@", userPerm, passPerm, pri, num];
        [buyReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
        
        //NSURLConnection *buyCon = [[NSURLConnection alloc] initWithRequest:buyReq delegate:self];
        connectTag *connect = [[connectTag alloc] initWithRequest:buyReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:3]];
        [connect release];
    }
    
    if (trade == 1)
    {
        //sell
        NSString *sellString = [NSString stringWithFormat:@"%@%@/SellBTC", apiURL, curPerm];
        NSURL *sellUrl = [NSURL URLWithString:sellString];
        NSLog(@"URL: %@", sellUrl);
        NSMutableURLRequest *sellReq = [NSMutableURLRequest requestWithURL:sellUrl];
        
        [sellReq setHTTPMethod:@"POST"];
        NSString *args = [NSString stringWithFormat:@"name=%@&pass=%@&price=%@&amount=%@", userPerm, passPerm, pri, num];
        [sellReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
        
        connectTag *connect = [[connectTag alloc] initWithRequest:sellReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:4]];
        [connect release];
    }
    numBtc.text = nil; limitPrice.text = nil;
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
    
    //possibly implement array of cell id and oid for cancelled orders so you can't cancel twice from list
    //[cell setUserInteractionEnabled:NO];
    
    cell.textLabel.text = cellValue;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *tempOrder = [[NSDictionary alloc] initWithDictionary:[newOrders objectAtIndex:[indexPath row]]];
    oid = [[tempOrder valueForKey:@"oid"] intValue];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancel Order?" message:[NSString stringWithFormat:@"Order #%u\n%@ BTC at %@ %@", oid, [frmtr numberFromString:[tempOrder valueForKey:@"amount"]], [frmtr numberFromString:[tempOrder valueForKey:@"price"]], curPerm] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Cancel", nil];
    [alert setTag:2];
    [alert show];
    [alert release];
    [tempOrder release];

}

- (void) cancelOrder {
    
    NSString *cancelStr = [NSString stringWithFormat:@"%@%@/CancelOrder", apiURL, curPerm];
	NSURL *cancelUrl = [NSURL URLWithString:cancelStr];
    NSLog(@"URL: %@", cancelUrl);
	NSMutableURLRequest *cancelReq = [NSMutableURLRequest requestWithURL:cancelUrl];
	
	[cancelReq setHTTPMethod:@"POST"];
	NSString *args = [NSString stringWithFormat:@"name=%@&pass=%@&oid=%u", userPerm, passPerm, oid];
	[cancelReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:cancelReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:5]];
    [connect release];
}

- (void) initOrderView:(NSDictionary *)feed: (NSString *)user: (NSString *)pass: (NSString *) currency {
    
    userPerm = user;
    passPerm = pass;
    curPerm = currency;
    [userPerm retain];
    [passPerm retain];
    [curPerm retain];

    [btcAvail setText:[frmtr stringFromNumber:[frmtr numberFromString:[feed valueForKey:@"BTC_Available"]]]];
    [btcRes setText:[frmtr stringFromNumber:[frmtr numberFromString:[feed valueForKey:@"BTC_Reserved"]]]];
    [curAvail setText:[frmtr stringFromNumber:[frmtr numberFromString:[feed valueForKey:[NSString stringWithFormat:@"%@_Available", curPerm]]]]];
    [curRes setText:[frmtr stringFromNumber:[frmtr numberFromString:[feed valueForKey:[NSString stringWithFormat:@"%@_Reserved", curPerm]]]]];
    [curLabel setText:curPerm];
    
    [self loadTicker];
    [self loadOrders];
        
}

- (void) loadBalance {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/GetBalance", apiURL, curPerm];
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
        
    NSString *urlString = [NSString stringWithFormat:@"%@%@/GetOrders", apiURL, curPerm];
	NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"URL: %@", url);
	NSMutableURLRequest *ordersReq = [NSMutableURLRequest requestWithURL:url];
	
	[ordersReq setHTTPMethod:@"POST"];
	NSString *args = [NSString stringWithFormat:@"name=%@&pass=%@", userPerm, passPerm];
	[ordersReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:ordersReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:1]];
    
    [connect release];

}

- (void) loadTicker {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/Ticker", apiURL, curPerm];
	NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *tickerReq = [NSMutableURLRequest requestWithURL:url];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:tickerReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:2]];
    [connect release];
    
}

- (IBAction) moreTicker: (id)sender {
    
    [numBtc resignFirstResponder];
    [limitPrice resignFirstResponder];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/Ticker", apiURL, curPerm];
	NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *tickerReq = [NSMutableURLRequest requestWithURL:url];
	
    connectTag *connect = [[connectTag alloc] initWithRequest:tickerReq delegate:self startImmediately:YES tag:[NSNumber numberWithInt:7]];
    [connect release];
    
}

- (void) writeOrders {
        
    [orderList removeAllObjects];

    int i = 1;
    while (i <= [newOrders count]) {
        
        NSDictionary *tempOrders = [[NSDictionary alloc ] initWithDictionary:[newOrders objectAtIndex:(i-1)]];
        NSString *tempType = [[[NSString alloc] init] autorelease];
        
        if ([[frmtr stringFromNumber:[tempOrders valueForKey:@"type"]] intValue] == 1) { tempType = @"Sell"; }
        if ([[frmtr stringFromNumber:[tempOrders valueForKey:@"type"]] intValue] == 2) { tempType = @"Buy"; };
                    
        NSString *tempOrder = [NSString stringWithFormat:@"%@: %@ BTC at %@ %@", tempType, [frmtr stringFromNumber:[frmtr numberFromString:[tempOrders valueForKey:@"amount"]]], [frmtr stringFromNumber:[frmtr numberFromString:[tempOrders valueForKey:@"price"]]], [tempOrders valueForKey:@"reserved_currency"]];
        
        [orderList addObject:tempOrder];
        [tempOrders release];
        i++;
    }
    //NSLog(@"Orderlist: %@\n", orderList);
    
    [self.orderTable reloadData];
}

- (IBAction) reloadAll: (id)sender {
    refreshAct.hidden = NO;
    [refreshAct startAnimating];
    [numBtc resignFirstResponder];
    [limitPrice resignFirstResponder];
    [self loadBalance];
    [self loadTicker];
    //reload orders after didReceiveData for the balance to avoid API limits
}



- (void)connection:(connectTag *)connection didReceiveData:(NSData *)data{
    
    if ([dataCons objectForKey:connection.tag] == nil) {
        
        NSMutableData *newData = [[NSMutableData alloc] initWithData:data];
        
        [dataCons setObject:newData forKey:connection.tag];
        [newData release];
    }
    
    
    NSLog(@"ConnectTag: %@", connection.tag);
            
    switch ([connection.tag intValue]) {
        case 1: {
            //NSLog(@"Original orders: %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];            
            NSArray *tempArray = [[NSArray alloc] initWithArray:[[jsonString JSONValue] objectForKey:@"orders"]];
            [newOrders removeAllObjects];
            int i = 0;
            while (i < [tempArray count]) {
                [newOrders addObject:[tempArray objectAtIndex:i]];
                i++;
            }
            [tempArray release];
            [jsonString release];
            //NSLog(@"Received order: %@\n", newOrders);
            [self writeOrders];
            [refreshAct stopAnimating];
            refreshAct.hidden = YES;
        } break;
        case 2: {
            //NSLog(@"Original ticker: %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *ticker = [[jsonString JSONValue] valueForKey:@"ticker"];
            [jsonString release];
            //NSLog(@"Received ticker: %@\n", ticker);

            NSString *tickerStr = [NSString stringWithFormat:@"%@ %@", [frmtr stringFromNumber:[frmtr numberFromString:[ticker valueForKey:@"last"]]], curPerm];            
            double curTicker = [[frmtr numberFromString:[ticker valueForKey:@"last"]] doubleValue];
            if (lastTicker > 0) {
                if (lastTicker > curTicker) { [btcPrice setTextColor:[UIColor redColor]]; NSLog(@"red"); }
                if (lastTicker < curTicker) { [btcPrice setTextColor:[UIColor greenColor]]; NSLog(@"green"); }
                lastTicker = curTicker;
                NSLog(@"Ticker: %f", lastTicker);
            }
            if (lastTicker == 0) { lastTicker = [[frmtr numberFromString:[ticker valueForKey:@"last"]] doubleValue]; }
        
            [btcPrice setText:tickerStr];
        } break;
        case 3: {
            //NSLog(@"Original orders(b): %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSArray *tempArray = [[NSArray alloc] initWithArray:[[jsonString JSONValue] objectForKey:@"orders"]];            
            [newOrders removeAllObjects];
            int i = 0;
            while (i < [tempArray count]) {
                [newOrders addObject:[tempArray objectAtIndex:i]];
                i++;
            }
            [tempArray release];
            [jsonString release];
            //NSLog(@"Received order: %@\n", newOrders);
            [self writeOrders];
        } break;
        case 4: {
            //NSLog(@"Original orders(s): %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSArray *tempArray = [[NSArray alloc] initWithArray:[[jsonString JSONValue] objectForKey:@"orders"]];
            [newOrders removeAllObjects];
            int i = 0;
            while (i < [tempArray count]) {
                [newOrders addObject:[tempArray objectAtIndex:i]];
                i++;
            }           
            [tempArray release];
            [jsonString release];
            //NSLog(@"Received order: %@\n", newOrders);
            [self writeOrders];
        } break;
        case 5: {
            //NSLog(@"Original orders(s): %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSArray *tempArray = [[NSArray alloc] initWithArray:[[jsonString JSONValue] objectForKey:@"orders"]];
            [newOrders removeAllObjects];
            int i = 0;
            while (i < [tempArray count]) {
                [newOrders addObject:[tempArray objectAtIndex:i]];
                i++;
            }           
            [tempArray release];
            [jsonString release];
            //NSLog(@"Received order: %@\n", newOrders);
            [self writeOrders];
        } break;
        case 6: {
            //NSLog(@"Original balance: %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *balance = [jsonString JSONValue];
            [jsonString release];
            //NSLog(@"Received balance: %@\n", balance);
            [btcAvail setText:[frmtr stringFromNumber:[frmtr numberFromString:[balance valueForKey:@"BTC_Available"]]]];
            [btcRes setText:[frmtr stringFromNumber:[frmtr numberFromString:[balance valueForKey:@"BTC_Reserved"]]]];
            [curAvail setText:[frmtr stringFromNumber:[frmtr numberFromString:[balance valueForKey:[NSString stringWithFormat:@"%@_Available", curPerm]]]]];
            [curRes setText:[frmtr stringFromNumber:[frmtr numberFromString:[balance valueForKey:[NSString stringWithFormat:@"%@_Reserved", curPerm]]]]];
            [self loadOrders];
        } break;
        case 7: {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *ticker = [[jsonString JSONValue] valueForKey:@"ticker"];
            [jsonString release];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Full Ticker" message:[NSString stringWithFormat:@"Sell: %@\nBuy: %@\nLast: %@\nVolume: %@\nHigh: %@\nLow: %@\nWhen: %@", [frmtr stringFromNumber:[frmtr numberFromString:[ticker valueForKey:@"sell"]]], [frmtr stringFromNumber:[frmtr numberFromString:[ticker valueForKey:@"buy"]]], [frmtr stringFromNumber:[frmtr numberFromString:[ticker valueForKey:@"last"]]], [frmtr stringFromNumber:[frmtr numberFromString:[ticker valueForKey:@"vol"]]], [frmtr stringFromNumber:[frmtr numberFromString:[ticker valueForKey:@"high"]]], [frmtr stringFromNumber:[frmtr numberFromString:[ticker valueForKey:@"low"]]], [ticker valueForKey:@"last_when"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Refresh", nil];
            [alert setTag:3];
            [alert show];
            [alert release];
        }
    }

    [dataCons removeObjectForKey:connection.tag];
    
}

@end
