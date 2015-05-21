//
//  UploadImgaeViewController.m
//  ALLAPIS
//
//  Created by GNR solution PVT.LTD on 21/05/15.
//  Copyright (c) 2015 Harshavardhan Edke. All rights reserved.
//

#import "UploadImgaeViewController.h"

@interface UploadImgaeViewController ()

@end

@implementation UploadImgaeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *image = [UIImage imageNamed:@"lion.jpg"];
    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(image, 0)];

//    NSString *finalImageString = [imageData base64EncodedString];
    
    NSString *theData = [imageData base64EncodedStringWithOptions:kNilOptions];

    NSLog(@"Base64 String of image :\n%@",theData);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
