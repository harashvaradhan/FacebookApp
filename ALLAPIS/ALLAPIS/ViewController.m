//
//  ViewController.m
//  ALLAPIS
//
//  Created by GNR solution PVT.LTD on 18/05/15.
//  Copyright (c) 2015 Harshavardhan Edke. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<FBSDKLoginButtonDelegate,FBSDKSharingDialog,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    FBSDKLoginButton *loginButton;
    UITableView *tblFriendList;
    UIButton *btnShare;
    UIButton *btPush;
}

@end

@implementation ViewController
@synthesize shareContent;
@synthesize shouldFailOnDataError;

#pragma mark - view methods

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    loginButton.publishPermissions = @[@"publish_actions"];
    loginButton.delegate = self;
    loginButton.frame = CGRectMake(0, self.view.frame.size.height - loginButton.frame.size.height, loginButton.frame.size.width, loginButton.frame.size.height);
    [self.view addSubview:loginButton];
    
    tblFriendList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - loginButton.frame.size.height)];
    [self.view addSubview:tblFriendList];
    
    btnShare = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - loginButton.frame.size.width, self.view.frame.size.height - loginButton.frame.size.height, loginButton.frame.size.width, loginButton.frame.size.height)];
    btnShare.backgroundColor = [UIColor blackColor];
    [btnShare setTitle:@"Share" forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(shareOnFacebook) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnShare];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    [self getFacebookFriends];
    
    [self base64Image];
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


#pragma mark - Share on Facebook
-(void)shareOnFacebook{
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"share on facebook");
        FBSDKShareDialog *fbShareDialog = [[FBSDKShareDialog alloc]init];
        fbShareDialog.mode = FBSDKShareDialogModeAutomatic;
        
        //Share Link
//        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
//        content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
//        content.contentDescription = @"Content Description will go here";
//        content.contentDescription = @"Content Title will go here";
        
        //Share Photo
        UIImage *image = [UIImage imageNamed:@"lion.jpg"];
        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
        photo.image = image;
        photo.userGenerated = YES;
//        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
//        content.photos = @[photo];
        
        //Share Video
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,nil];

//        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//        {
//            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
//        }
//        else
//        {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
//        }
        
        [imagePicker setDelegate:self];
        
        [self presentModalViewController:imagePicker animated:YES];
        
//        NSURL *videoURL = [info objectForKey:UIImagePickerControllerReferenceURL];
//        NSURL *videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"]isDirectory:NO];
//        FBSDKShareVideo *video = [[FBSDKShareVideo alloc] init];
//        video.videoURL = videoURL;
//        FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init];
//        content.video = video;
//        
//        [FBSDKShareDialog showFromViewController:self
//                                         withContent:content
//                                            delegate:nil];
        // Using Graph API
//        [FBSDKShareAPI shareWithContent:content delegate:nil];
    }
}

#pragma mark - FBSDKSharing Delegate

-(BOOL)canShow{
    return YES;
}

-(BOOL)show{
    return YES;
}

#pragma mark - UIImagePickerDelegate
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {

        NSURL *videoURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        if (videoURL) {
            NSLog(@"Got Video URL");
            FBSDKShareVideo *video = [[FBSDKShareVideo alloc] init];
            video.videoURL = videoURL;
            FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init];
            content.video = video;
            
            [FBSDKShareDialog showFromViewController:self
                                         withContent:content
                                            delegate:nil];
        }
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)validateWithError:(NSError *__autoreleasing *)errorRef{
    return YES;
}

-(void)base64Image {
    UIImage *image = [UIImage imageNamed:@"lion.jpg"];
    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(image, 0)];
    NSString *theData = [imageData base64EncodedStringWithOptions:kNilOptions];
    
    NSData *plainData = [NSData dataWithData:UIImageJPEGRepresentation(image, 0)];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    NSLog(@"\n%@", base64String);
    
    
    NSLog(@"Base64 String of image :\n%@",theData);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
