//
//  ViewController.h
//  EarthquakeMonitor
//
//  Created by VaD on 30/12/14.
//  Copyright (c) 2014 PlayInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailController.h"
#import "AFNetworking/AFHTTPRequestOperationManager.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    __weak IBOutlet UITableView *tbEvent;
    
    //Variables
    NSMutableArray *DataTable;
    UIRefreshControl *refreshControl;
    NSTimer *_timer;
    NSInteger selected;
    int ColorPin;
}

- (IBAction)ReloadAction:(UIButton *)sender;

@end

