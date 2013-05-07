//
//  ViewController.m
//  Spark RC Car
//
//  Created by Zachary Crockett on 5/7/13.
//  Copyright (c) 2013 Spark Devices. All rights reserved.
//

#import "ViewController.h"

NSMutableData *receivedData;

@interface ViewController ()

@end

@implementation ViewController

@synthesize leftSlider, rightSlider;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
	CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
  leftSlider.transform = trans;
  rightSlider.transform = trans;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeAPIRequestWithMessage:(NSString *)msg
{
  NSURL *url = [NSURL URLWithString:@"https://api.sprk.io/v1/devices/rccar"];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
  [req setHTTPMethod:@"POST"];
  
  NSData *body = [NSData dataWithBytes:[msg cStringUsingEncoding:NSASCIIStringEncoding]
                                length:[msg length]];
  [req setHTTPBody:body];
  
  NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
  if (conn) {
    receivedData = [NSMutableData data];
  } else {
    NSLog(@"no connection");
  }
}

- (IBAction)leftValueChanged:(id)sender
{
  NSString *bodyString = [NSString stringWithFormat:@"message=L%d", (int)leftSlider.value];
  [self makeAPIRequestWithMessage:bodyString];
}

- (IBAction)rightValueChanged:(id)sender
{
  NSString *bodyString = [NSString stringWithFormat:@"message=R%d", (int)rightSlider.value];
  [self makeAPIRequestWithMessage:bodyString];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  NSLog(@"Connection failed! Error - %@ %@",
        [error localizedDescription],
        [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  // debug
  if (false) {
    NSLog(@"Succeeded! Received %d bytes of data", [receivedData length]);
    char data[80];
    memset(data, 0, 80);
    [receivedData getBytes:data length:79];
    NSLog(@"%s", data);
  }
}

@end
