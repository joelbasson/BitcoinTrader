//
//  connectTag.m
//  BitcoinTrader
//
//  Modified from: http://www.isignmeout.com/multiple-nsurlconnections-viewcontroller/
//

#import "connectTag.h"

@implementation connectTag

@synthesize tag;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithRequest:(NSMutableURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately tag:(NSNumber*)_tag {
    
    self = [super initWithRequest:request delegate:delegate startImmediately:startImmediately];
    
    if (self) {
        self.tag = _tag;
    }
    
    return self;
    
}

@end
