//
//  ViewController.m
//  VLCPlayerDemo
//
//  Created by tdx on 2017/8/5.
//  Copyright © 2017年 sjjvenu. All rights reserved.
//

#import "ViewController.h"
#import "SCVideoMainViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnPlayVideo:(id)sender {
    SCVideoMainViewController *vc = [[SCVideoMainViewController alloc] initWithURL:@"http://jiupaivod-out.jiupaicn.com/act-ss-mp4-ld/984415b4-eb02-4138-96a1-a241d876bb38.mp4"];
    vc.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden=YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
