//
//  PhotoDetailViewController.m
//  Sharkfeed
//
//  Created by Fikirte  Derso on 2/7/18.
//  Copyright © 2018 Fikirte  Derso. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "Constants.h"
#import "WebService.h"

typedef void(^GetPhotoCallback)(NSError * error);

@interface PhotoDetailViewController ()

@property (strong, nonatomic) UIImage * image;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end



@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _photoTitle.text = _pTitle;
    [_activityIndicator setHidesWhenStopped:YES];
    [_activityIndicator startAnimating];
    
    //Load Photo
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // Get Image
        _image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_photoUrl]]];
        
        // Update UI
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = _image;
            [_activityIndicator stopAnimating];
        });
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma IBAction

- (IBAction)openInAppBtnTapped:(UIButton *)sender {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_photoUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_photoUrl]];
    }
    
}

- (IBAction)downoadBtnTapped:(UIButton *)sender {
    
    [self performSelectorInBackground:@selector(savingImageToAlbum) withObject:nil];
    
}

-(void)savingImageToAlbum {
    
    UIImageWriteToSavedPhotosAlbum(_image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
    if (!error) {
        
        [self showAlertWithTitle:PHOTO_SAVE_TITLE andMessage:PHOTO_SAVE_SUCESS_MESSAGE];
    }
    else {
       
        [self showAlertWithTitle:PHOTO_SAVE_TITLE andMessage:PHOTO_SAVE_FAILED_MESSAGE];
    }

}

-(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}




@end
