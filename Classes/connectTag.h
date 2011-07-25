//
//  connectTag.h
//  BitcoinTrader
//
//  Modified from: http://www.isignmeout.com/multiple-nsurlconnections-viewcontroller/
//

#import <Foundation/Foundation.h>

@interface connectTag : NSURLConnection {
    
    NSNumber *tag;
    
}
@property (nonatomic, retain) NSNumber *tag;

- (id)initWithRequest:(NSMutableURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately tag:(NSNumber*)_tag;

@end
