//
//  NonRotatingUIImagePickerController.m
//  NEEDS
//
//  Created by Tom on 2016/9/13.
//  Copyright © 2016年 jacky. All rights reserved.
//

#import "NonRotatingUIImagePickerController.h"

@interface NonRotatingUIImagePickerController ()

/*
 UIImagePickerController *imagePicker = [[NonRotatingUIImagePickerController alloc] init];
 [myPopoverController setContentViewController:imagePicker animated:YES];
 */

@end

@implementation NonRotatingUIImagePickerController

- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


@end
