//
//  ViewController.m
//  Spark RC Car
//
//  Created by Zachary Crockett on 5/7/13.
//  Copyright (c) 2013 Spark Devices. All rights reserved.
//

#import "ViewController.h"

#define DEVICE_ID "MySparkCoreID"

NSMutableData *receivedData;
NSDate *leftMessageDate;
NSDate *rightMessageDate;

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
  
  leftMessageDate = rightMessageDate = [NSDate date];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)makeAPIRequestWithMessage:(NSString *)msg
{
  NSURL *url = [NSURL URLWithString:
                [NSString stringWithFormat:@"https://api.sprk.io/v1/devices/%s", DEVICE_ID]];
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

- (void)makeLeftAPIRequest
{
  leftMessageDate = [NSDate date];
  int outValue = (int)(pow(leftSlider.value / leftSlider.maximumValue, 2) * 255);
  NSString *bodyString = [NSString stringWithFormat:@"message=L%d", outValue];
  [self makeAPIRequestWithMessage:bodyString];
}

- (void)makeRightAPIRequest
{
  rightMessageDate = [NSDate date];
  int outValue = (int)(pow(rightSlider.value / rightSlider.maximumValue, 2) * 255);
  NSString *bodyString = [NSString stringWithFormat:@"message=R%d", outValue];
  [self makeAPIRequestWithMessage:bodyString];
}

- (IBAction)leftValueChanged:(id)sender
{
  NSDate *now = [NSDate date];
  if (0.2 < [now timeIntervalSinceDate:leftMessageDate])
  {
    [self makeLeftAPIRequest];
  }
}

- (IBAction)rightValueChanged:(id)sender
{
  NSDate *now = [NSDate date];
  if (0.2 < [now timeIntervalSinceDate:rightMessageDate])
  {
    [self makeRightAPIRequest];
  }
}

- (IBAction)leftTouchEnded:(id)sender
{
  [self makeLeftAPIRequest];
}

- (IBAction)rightTouchEnded:(id)sender
{
  [self makeRightAPIRequest];
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
