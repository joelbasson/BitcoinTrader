//
//  LoginViewController.m
//  BitcoinTrader
//
//  Created by Tyler Richey on 7/17/11.
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

#import "BitcoinTraderAppDelegate.h"
#import "LoginViewController.h"
#import "SBJson.h"
#import "THViewController.h"
#import "BxViewController.h"
#import "ExchbViewController.h"
#import "IWViewController.h"
#import "GoxViewController.h"
#import "Constants.h"
#import "QRCodeReader.h"
#import "Crypto.h"

@implementation LoginViewController

@synthesize usernameField;
@synthesize passwordField;
@synthesize loginButton;
@synthesize loginIndicator;
@synthesize loginStatus;
@synthesize thViewController;
@synthesize bxViewController;
@synthesize exchbViewController;
@synthesize goxViewController;
@synthesize curPick;
@synthesize currency;
@synthesize scrollView;
@synthesize apiPick;
@synthesize apiURL;
@synthesize scanButton;
@synthesize scanList;
@synthesize about;
@synthesize begin;
@synthesize newWallet;
@synthesize iwViewController;
@synthesize prefs;
@synthesize pin;
@synthesize goxID;
@synthesize importWal;
@synthesize cur;
@synthesize goButton;
@synthesize tempKey;
@synthesize tempSec;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [scanList setBackgroundColor:[UIColor clearColor]];
    [self setPrefs:[NSUserDefaults standardUserDefaults]];
    //[scrollView setContentSize:CGSizeMake(320, 500)];
    [apiPick setWidth:51 forSegmentAtIndex:3];
    [apiPick setWidth:60 forSegmentAtIndex:2];
    [apiPick setWidth:51 forSegmentAtIndex:1];
    
    [self setCurrency:@"USD"];
    cur = [[NSMutableArray alloc] init];
    /*[cur addObject:@"USD"];
    [cur addObject:@"EUR"];
    [cur addObject:@"CLP"];
    [cur addObject:@"CAD"];
    [cur addObject:@"AUD"];
    [cur addObject:@"LR"];
    [cur addObject:@"INR"];
    
    [cur addObject:@"BRL"];
    [cur addObject:@"CHF"];
    [cur addObject:@"GBP"];
    [cur addObject:@"CNY"];
    [cur addObject:@"CZK"];
    [cur addObject:@"DKK"];
    [cur addObject:@"HKD"];
    [cur addObject:@"ARS"];
    [cur addObject:@"ILS"];
    [cur addObject:@"JPY"];
    [cur addObject:@"MXN"];
    [cur addObject:@"NZD"];
    [cur addObject:@"NOK"];
    [cur addObject:@"PEN"];
    [cur addObject:@"PLN"];
    [cur addObject:@"SGD"];
    [cur addObject:@"ZAR"];
    [cur addObject:@"SEK"];*/
}

- (void)viewDidAppear:(BOOL)animated {
    
    if ([begin isHidden] == YES) {
        if (self.iwViewController != nil) {
            self.iwViewController = nil;
            [iwViewController release];
            [self apiSet:self];
            NSLog(@"returning from IW");
        }
        if (self.goxViewController != nil) {
            self.goxViewController = nil;
            [goxViewController release];
            [apiPick setEnabled:YES];
            [self apiSet:self];
            NSLog(@"returning from Gox");
        }
        if (self.thViewController != nil) {
            self.thViewController = nil;
            [thViewController release];
            [self apiSet:self];
            NSLog(@"returning from TH");
        }
        if (self.bxViewController != nil) {
            self.bxViewController = nil;
            [bxViewController release];
            [self apiSet:self];
            NSLog(@"returning from BX");
        }
        if (self.exchbViewController != nil) {
            self.exchbViewController = nil;
            [exchbViewController release];
            [self apiSet:self];
            NSLog(@"returning from ExchB");
        }
        
        [loginButton setEnabled:YES];
    }
    
}

- (IBAction) apiSet:(id)sender {
    
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [loginStatus setHidden:YES];
    [begin setHidden:YES];
        
    switch ([apiPick selectedSegmentIndex]) {
        case 0:
            //tradehill
            [scanList setHidden:YES];
            [scanButton setHidden:YES];
            [newWallet setHidden:YES];
            [curPick setHidden:NO];
            [loginButton setHidden:NO];
            [usernameField setHidden:NO];
            [passwordField setHidden:NO];
            [about setHidden:NO];
            [self setApiURL:thURL];
            [cur removeAllObjects];
            [cur addObject:@"USD"];
            [cur addObject:@"EUR"];
            [cur addObject:@"CLP"];
            [cur addObject:@"CAD"];
            [cur addObject:@"AUD"];
            [cur addObject:@"LR"];
            [cur addObject:@"INR"];
            [curPick reloadAllComponents];
            break;
        case 1:
            //exchb
            [scanList setHidden:YES];
            [scanButton setHidden:YES];
            [newWallet setHidden:YES];
            [curPick setHidden:NO];
            [loginButton setHidden:NO];
            [usernameField setHidden:NO];
            [passwordField setHidden:NO];
            [about setHidden:NO];
            [self setApiURL:exchbURL];
            [cur removeAllObjects];
            [cur addObject:@"USD"];
            [curPick reloadAllComponents];
            break;
        case 2:
            //bx
            [scanList setHidden:YES];
            [newWallet setHidden:YES];
            [scanButton setHidden:YES];
            [curPick setHidden:NO];
            [about setHidden:NO];
            [loginButton setHidden:NO];
            [usernameField setHidden:NO];
            [passwordField setHidden:NO];
            [self setApiURL:bxURL];
            [cur removeAllObjects];
            [cur addObject:@"USD"];
            [curPick reloadAllComponents];
            break;
        case 3:
            //mtgox
            [self setApiURL:goxURL];
            [loginStatus setHidden:YES];
            [scanButton setHidden:NO];
            [scanList setHidden:NO];
            [scanList reloadData];
            [scanButton setTitle:@"Activate Account" forState:UIControlStateNormal];
            [cur removeAllObjects];
            [newWallet setHidden:YES];
            [curPick setHidden:YES];
            [about setHidden:YES];
            [loginButton setHidden:YES];
            [usernameField setHidden:YES];
            [passwordField setHidden:YES];
            break;
        case 4:
            //instawallet
            [self setApiURL:instaURL];
            [loginStatus setHidden:YES];
            [scanList setHidden:NO];
            [scanList reloadData];
            [scanButton setHidden:NO];
            [newWallet setHidden:NO];
            [scanButton setTitle:@"Import Wallet" forState:UIControlStateNormal];
            [cur removeAllObjects];
            [curPick setHidden:YES];
            [about setHidden:YES];
            [loginButton setHidden:YES];
            [usernameField setHidden:YES];
            [passwordField setHidden:YES];
            break;
        default:
            break;
    }
    
}

- (IBAction) createWallet:(id)sender {
    
    if (self.iwViewController == nil)
    {
        IWViewController *viewTwo = [[IWViewController alloc] initWithNibName:@"IWViewController" bundle:[NSBundle mainBundle]];
        self.iwViewController = viewTwo;
        [viewTwo release];
    }

    [self.navigationController pushViewController:self.iwViewController animated:YES];
    [iwViewController newWallet];
    
}

- (IBAction)goPin:(id)sender {
    
    bool launch = NO;
    
    if ([tempSec length] > 1 && [tempKey length] > 1 && [[pin text] length] != 0) {
        
        int newID = [prefs integerForKey:@"gox_total"]+1;
        [prefs setInteger:newID forKey:@"gox_total"];
        NSArray *keys = [[NSArray alloc] initWithObjects:@"key", @"secret", nil];
        NSArray *secrets = [[NSArray alloc] initWithObjects:[NSData encryptString:tempKey withKey:[pin text]], [NSData encryptString:tempSec withKey:[pin text]], nil];
        NSDictionary *keysec = [[NSDictionary alloc] initWithObjects:secrets forKeys:keys];
        [prefs setObject:keysec forKey:[NSString stringWithFormat:@"goxdata_%u", newID]];
        [prefs synchronize];
        [keys release]; [secrets release]; [keysec release];
        [self setTempSec:nil]; [self setTempKey:nil];
        [self setGoxID:newID];
        launch = YES;
    } else {
        NSDictionary *testDic = [prefs objectForKey:[NSString stringWithFormat:@"goxdata_%u", goxID]];
        NSString *testKey = [NSString decryptData:[testDic valueForKey:@"key"] withKey:pin.text];
        
        if ([[pin text] length] == 0 || [testKey length] == 0) {
            [pin resignFirstResponder];
            [pin setText:@""];
            [pin setHidden:YES];
            [goButton setHidden:YES];
            [apiPick setHidden:NO];
            [scanButton setHidden:NO];
            [scanList reloadData];
        } else {
            launch = YES;
        }
    }
    
    if (launch == YES) {
        
        [pin resignFirstResponder];
        [goButton setHidden:YES];
        [pin setHidden:YES];
        
        if (self.goxViewController == nil)
        {
            GoxViewController *viewTwo = [[GoxViewController alloc] initWithNibName:@"GoxViewController" bundle:[NSBundle mainBundle]];
            self.goxViewController = viewTwo;
            [viewTwo release];
        }
        
        [self.navigationController pushViewController:self.goxViewController animated:YES];
        [goxViewController setKeys:[pin text] accid:goxID];
        [pin setText:@""];
        
    }
    [self setGoxID:nil];
    
}

- (IBAction)activate: (id)sender {
    
    ZXingWidgetController *widCon = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    QRCodeReader *qrCode = [[QRCodeReader alloc] init];
    NSSet *readers = [[NSSet alloc] initWithObjects:qrCode, nil];
    [qrCode release];
    widCon.readers = readers;
    [readers release];
    [self presentModalViewController:widCon animated:YES];
    [widCon release];

}

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
    
    NSString *res = [[NSString alloc] initWithString:result];

    if ([apiPick selectedSegmentIndex] == 3)
    {
        [apiPick setEnabled:NO];
        [scanButton setHidden:YES];
        NSString *key = [res substringFromIndex:17];
        //NSLog(@"Result: %@\nkey: %@", res, key);

        NSString *urlString = [NSString stringWithFormat:@"%@/activate.php", apiURL];
        NSURL *url = [NSURL URLWithString:urlString];
        NSLog(@"URL: %@", url);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
        [request setHTTPMethod:@"POST"];
        NSString *args = [NSString stringWithFormat:@"key=%@&name=My iPhone&app=XXXXXXXXXXXXXXXX", key];
        [request setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection release];
    }
    
    [self dismissModalViewControllerAnimated:NO];
    
    if ([apiPick selectedSegmentIndex] == 4)
    {
        if (self.iwViewController == nil)
        {
            IWViewController *viewTwo = [[IWViewController alloc] initWithNibName:@"IWViewController" bundle:[NSBundle mainBundle]];
            self.iwViewController = viewTwo;
            [viewTwo release];
        }
        
        [self.navigationController pushViewController:self.iwViewController animated:YES];
        [iwViewController setWallet:[res substringFromIndex:30]];

    }
    
    [res release];

}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
    [self dismissModalViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 0;
    if ([apiPick selectedSegmentIndex] == 3) {
        count = [prefs integerForKey:@"gox_total"];
    }
    if ([apiPick selectedSegmentIndex] == 4) {
        count = [prefs integerForKey:@"iw_total"];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *cellValue;
    if ([apiPick selectedSegmentIndex] == 3) { cellValue = [prefs objectForKey:[NSString stringWithFormat:@"gox_%u", indexPath.row+1]]; }
    if ([apiPick selectedSegmentIndex] == 4) { cellValue = [prefs objectForKey:[NSString stringWithFormat:@"iw_%u", indexPath.row+1]]; }
    //NSLog(@"Log: %@", cellValue);
    
    cell.textLabel.text = cellValue;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([apiPick selectedSegmentIndex] == 3)
    {
        [apiPick setEnabled:NO];
        [scanButton setHidden:YES];
        [pin setHidden:NO];
        [goButton setHidden:NO];
        [pin becomeFirstResponder];
        [self setGoxID:indexPath.row+1];
    }
    if ([apiPick selectedSegmentIndex] == 4)
    {
        if (self.iwViewController == nil)
        {
            IWViewController *viewTwo = [[IWViewController alloc] initWithNibName:@"IWViewController" bundle:[NSBundle mainBundle]];
            self.iwViewController = viewTwo;
            [viewTwo release];
        }
        
        [self.navigationController pushViewController:self.iwViewController animated:YES];
        [iwViewController setWallet:[prefs objectForKey:[NSString stringWithFormat:@"iw_%u", indexPath.row+1]]];
    }
    
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)curPick {
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *) curPick numberOfRowsInComponent:(NSInteger)component {
    return [cur count];
}

- (NSString *) pickerView:(UIPickerView *) curPick titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [cur objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *) curPick didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self setCurrency:[cur objectAtIndex:row]];
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
    [super dealloc];
}

- (IBAction) about: (id)sender {
    
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"About" message:@"BitcoinTrader for iPhone\nCopyright 2011 Tyler Richey\nAll Rights Reserved\n\nLicense: GNU GPLv3" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
}

- (IBAction) login: (id) sender {

    [loginStatus setHidden:YES];
    [loginIndicator startAnimating];
	[loginButton setEnabled:NO];
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    NSString *urlString;
	
    if ([apiPick selectedSegmentIndex] == 0)
    {
        urlString = [NSString stringWithFormat:@"%@%@/GetBalance", apiURL, currency];
    }
    if ([apiPick selectedSegmentIndex] == 1)
    {
        urlString = [NSString stringWithFormat:@"%@/getFunds", apiURL];
    }
    if ([apiPick selectedSegmentIndex] == 2)
    {
        urlString = [NSString stringWithFormat:@"%@/myfunds.php", apiURL];
    }
    
	NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"URL: %@", url);
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //NSLog(@"testing only");
    //[NSMutableURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
	
	[request setHTTPMethod:@"POST"];
    NSString *args;
    if ([apiPick selectedSegmentIndex] == 2)
    {
        args = [NSString stringWithFormat:@"user=%@&pass=%@", [usernameField text], [passwordField text]];
    } else {
        args = [NSString stringWithFormat:@"name=%@&pass=%@", [usernameField text], [passwordField text]];

    }
	[request setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection release];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Method: -(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error");
	NSLog(@"code: %d, domain: %@, localizedDesc: %@",[error code],[error domain],[error localizedDescription]);
    [loginIndicator stopAnimating];
    [usernameField setText:@""];
    [passwordField setText:@""];
    [loginStatus setHidden:NO];
    [loginStatus setText:@"Error logging in."];
    [loginButton setEnabled:YES];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *) data {
	
	NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSDictionary *feed = [jsonString JSONValue];
	//NSLog(@"Received data: %@\n", feed);
    [jsonString release];
    
    int login = 1;
    if ([apiPick selectedSegmentIndex] == 0)
    {
        if ([[feed valueForKey:@"error"] isEqualToString:@"Not logged in."]) { login = 0; }
    }
    if ([apiPick selectedSegmentIndex] == 1)
    {
        if ([[feed valueForKey:@"status"] isEqualToString:@"Login failed."]) { login = 0; }
    }
    if ([apiPick selectedSegmentIndex] == 2)
    {
        if ([[feed valueForKey:@"Error"] length] > 0) { login = 0; }
    }
    if ([apiPick selectedSegmentIndex] == 3) {
        
        [self setTempKey:[feed valueForKey:@"Rest-Key"]];
        [self setTempSec:[feed valueForKey:@"Secret"]];
        if ([tempSec length] > 1 && [tempKey length] > 1) {
            [pin setHidden:NO];
            [goButton setHidden:NO];
            [pin becomeFirstResponder];
        }
        login = 2;
    }
	
	if (login == 0) {
		[loginStatus setText:@"Error logging in."];
        [loginIndicator stopAnimating];
        [loginStatus setHidden:NO];
        [loginButton setEnabled:YES];
	} else if (login != 2) {
		[loginStatus setText:@"Login Succesful."];
        [loginIndicator stopAnimating];
        [loginStatus setHidden:NO];
        
        if ([apiPick selectedSegmentIndex] == 0)
        {
            if (self.thViewController == nil)
            {
                THViewController *viewTwo = [[THViewController alloc] initWithNibName:@"THViewController" bundle:[NSBundle mainBundle]];
                self.thViewController = viewTwo;
                [viewTwo release];
            }
            
            [self.navigationController pushViewController:self.thViewController animated:YES];
            [self.thViewController initOrderView: feed: [usernameField text]: [passwordField text]: currency];
        }
        if ([apiPick selectedSegmentIndex] == 1)
        {
            if (self.exchbViewController == nil)
            {
                ExchbViewController *viewTwo = [[ExchbViewController alloc] initWithNibName:@"ExchbViewController" bundle:[NSBundle mainBundle]];
                self.exchbViewController = viewTwo;
                [viewTwo release];
            }
            
            [self.navigationController pushViewController:self.exchbViewController animated:YES];
            [self.exchbViewController initOrderView: feed: [usernameField text]: [passwordField text]: currency];
        }
        if ([apiPick selectedSegmentIndex] == 2)
        {
            if (self.bxViewController == nil)
            {
                BxViewController *viewTwo = [[BxViewController alloc] initWithNibName:@"BxViewController" bundle:[NSBundle mainBundle]];
                self.bxViewController = viewTwo;
                [viewTwo release];
            }
            
            [self.navigationController pushViewController:self.bxViewController animated:YES];
            [self.bxViewController initOrderView: feed: [usernameField text]: [passwordField text]: currency];
        }
        
        [usernameField setText:@""];
        [passwordField setText:@""];

	}
	
}

@end
