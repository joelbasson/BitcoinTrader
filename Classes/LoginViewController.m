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
//  Foobar is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with BitcoinTrader.  If not, see <http://www.gnu.org/licenses/>.

#import "BitcoinTraderAppDelegate.h"
#import "LoginViewController.h"
#import "JSON/SBJson.h"
#import "OrderViewController.h"
#import "Constants.h"

@implementation LoginViewController

@synthesize usernameField;
@synthesize passwordField;
@synthesize loginButton;
@synthesize loginIndicator;
@synthesize loginStatus;
@synthesize orderViewController;
@synthesize curPick;
@synthesize currency;

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
    
    currency = @"USD";
    cur = [[NSMutableArray alloc] init];
    [cur addObject:@"USD"];
    [cur addObject:@"EUR"];
    [cur addObject:@"GBP"];
    [cur addObject:@"CAD"];
    [cur addObject:@"AUD"];
    [cur addObject:@"BRL"];
    [cur addObject:@"CHF"];
    [cur addObject:@"CLP"];
    [cur addObject:@"CNY"];
    [cur addObject:@"CZK"];
    [cur addObject:@"DKK"];
    [cur addObject:@"HKD"];
    [cur addObject:@"ARS"];
    [cur addObject:@"ILS"];
    [cur addObject:@"INR"];
    [cur addObject:@"JPY"];
    [cur addObject:@"LR"];
    [cur addObject:@"MXN"];
    [cur addObject:@"NZD"];
    [cur addObject:@"NOK"];
    [cur addObject:@"PEN"];
    [cur addObject:@"PLN"];
    [cur addObject:@"SGD"];
    [cur addObject:@"ZAR"];
    [cur addObject:@"SEK"];
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
    currency = [cur objectAtIndex:row];
    NSLog(@"Currency: %@\n", currency);
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

- (IBAction) login: (id) sender
{
	loginStatus.hidden = TRUE;
	loginIndicator.hidden = TRUE;
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@/GetBalance", apiURL, currency];
	NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"URL: %@", url);
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //testing only
    //[NSMutableURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
	
	[request setHTTPMethod:@"POST"];
	NSString *args = [NSString stringWithFormat:@"name=%@&pass=%@", usernameField.text, passwordField.text];
	[request setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection release];
	
	loginIndicator.hidden = FALSE;
	[loginIndicator startAnimating];
	
	loginButton.enabled = FALSE;
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Method: -(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error");
	NSLog(@"code: %d, domain: %@, localizedDesc: %@",[error code],[error domain],[error localizedDescription]);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *) data {
	
	NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSDictionary *feed = [jsonString JSONValue];
	//NSLog(@"Received data: %@\n", feed);
    [jsonString release];
	
	if ([feed count] < 3) {
		[loginStatus setText:@"Error logging in."];
		loginIndicator.hidden = TRUE;
		loginStatus.hidden = FALSE;
		loginButton.enabled = TRUE;
	} else {
		[loginStatus setText:@"Login Succesful."];
		loginIndicator.hidden = TRUE;
		loginStatus.hidden = FALSE;
        
        if (self.orderViewController == nil)
        {
            OrderViewController *viewTwo = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:[NSBundle mainBundle]];
            self.orderViewController = viewTwo;
            [viewTwo release];
        }
        
        [self.navigationController pushViewController:self.orderViewController animated:YES];
        [orderViewController initOrderView: feed: (NSString *)usernameField.text: (NSString *)passwordField.text: currency];
	}
	
}

@end
