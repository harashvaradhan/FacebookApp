//
//  ViewController.m
//  ALLAPIS
//
//  Created by GNR solution PVT.LTD on 18/05/15.
//  Copyright (c) 2015 Harshavardhan Edke. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<FBSDKLoginButtonDelegate>{
    FBSDKLoginButton *loginButton;
    UITableView *tblFriendList;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    loginButton.delegate = self;
    loginButton.frame = CGRectMake(self.view.frame.size.width / 2 - loginButton.frame.size.width/2, self.view.frame.size.height - loginButton.frame.size.height, loginButton.frame.size.width, loginButton.frame.size.height);
    [self.view addSubview:loginButton];
    
    tblFriendList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - loginButton.frame.size.height)];
    [self.view addSubview:tblFriendList];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    [self getFacebookFriends];
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
}

-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewDidDisappear");
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
}

#pragma mark - FBSDKLoginButton Delegate Methods

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    NSLog(@"Login Buttom action Login completion handler");
    
    [self getFacebookFriends];
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    NSLog(@"Login Buttom action Logout completion handler");
}

#pragma mark - Get Facebook Friends of User{
-(void)getFacebookFriends{
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Access Token %@",[FBSDKAccessToken currentAccessToken].tokenString);
        
        // For more complex open graph stories, use `FBSDKShareAPI`
        // with `FBSDKShareOpenGraphContent`
        /* make the API call */
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"/me/friends"
                                      parameters:nil
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            if (error) {
                NSLog(@"%@", error);
                return;
            }
            if (result) {
                NSArray *data = result[@"data"];
            }
            NSLog(@"Result from FBSDKGraphRequestConnection %@",result);
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
