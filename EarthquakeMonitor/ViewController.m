//
//  ViewController.m
//  EarthquakeMonitor
//
//  Created by VaD on 30/12/14.
//  Copyright (c) 2014 PlayInteractive. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#define purpleCo [UIColor colorWithRed:(200/255.0f) green:(105/255.0f) blue:(224/255.0f) alpha:0.80]

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SendWS];
    
    refreshControl = [[UIRefreshControl alloc]
                      init];
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self action:@selector(changeSorting) forControlEvents:UIControlEventValueChanged];
    
    [tbEvent addSubview:refreshControl];
   // [self LaunchTimer:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [self LaunchTimer:YES];
}

- (void)changeSorting
{
    NSLog(@"REfrescando");
    [self SendWS];
    [refreshControl endRefreshing];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailController *detail = [segue destinationViewController];
    detail.dataEarthquake = [[DataTable valueForKey:@"features"] objectAtIndex:selected];
    detail.ColorPin = ColorPin;
    
    
}
#pragma mark Generic Methods

-(void)SendWS{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DataTable =(NSMutableArray*)responseObject;
        NSLog(@"JSON:  el count is : %lu %@",(unsigned long)[[DataTable valueForKey:@"features"] count] ,[DataTable valueForKey:@"features"]  );
        [self reloadData:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


-(UIColor*)RangeMag:(float)mag{
    UIColor *colorCell;
    if (mag >=0.0 && mag <=0.9) {
        colorCell = [UIColor greenColor];
        
    }else if (mag >= 9.0 && mag <=9.9){
        colorCell = [UIColor redColor];
        
    }else{
        colorCell = purpleCo;
        
    }
    

    return colorCell;
}
-(int)PinColor:(float)mag{

    if (mag >=0.0 && mag <=0.9) {
        
        ColorPin = 1;
    }else if (mag >= 9.0 && mag <=9.9){
        
        ColorPin = 0;
    }else{
        
        ColorPin = 2;
    }
    
    
    return ColorPin;
}
-(void)LaunchTimer:(BOOL)is{
    if (is) {
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:10.0f
                                                      target:self
                                                    selector:@selector(_timer:)
                                                    userInfo:nil
                                                     repeats:YES];
        }
    }else{
        if ([_timer isValid]) {
            [_timer invalidate];
        }
        _timer = nil;
    }
}
- (void)_timer:(NSTimer *)timer {
    [self SendWS];
}

#pragma mark UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[DataTable valueForKey:@"features"] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cellEvent"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle      reuseIdentifier:@"cellEvent"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%.2f",[[[[[DataTable valueForKey:@"features"] objectAtIndex:indexPath.row] valueForKey:@"properties"] valueForKey:@"mag"] floatValue]];
    
    cell.backgroundColor = [self RangeMag:[[[[[DataTable valueForKey:@"features"] objectAtIndex:indexPath.row] valueForKey:@"properties"] valueForKey:@"mag"] floatValue]];
    
    cell.detailTextLabel.text = [[[[DataTable valueForKey:@"features"] objectAtIndex:indexPath.row] valueForKey:@"properties"] valueForKey:@"place"];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"pulsando celda %li",(long)indexPath.row);
    selected = indexPath.row;
    ColorPin = [self PinColor:[[[[[DataTable valueForKey:@"features"] objectAtIndex:indexPath.row] valueForKey:@"properties"] valueForKey:@"mag"] floatValue]];
    [self LaunchTimer:NO];
    [self performSegueWithIdentifier:@"pushDetail" sender:self];
    
}

- (void)reloadData:(BOOL)animated
{
    [tbEvent reloadData];
    
    if (animated) {
        
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromBottom];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setFillMode:kCAFillModeBoth];
        [animation setDuration:.3];
        [[tbEvent layer] addAnimation:animation forKey:@"UITableViewReloadDataAnimationKey"];
        
    }
}
#pragma mark Actions Buttons

- (IBAction)ReloadAction:(UIButton *)sender {
    [self SendWS];
}
@end
