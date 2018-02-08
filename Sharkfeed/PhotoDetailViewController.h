//
//  PhotoDetailViewController.h
//  Sharkfeed
//
//  Created by Fikirte  Derso on 2/7/18.
//  Copyright © 2018 Fikirte  Derso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *scrollview;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *photoTitle;
@property (strong, nonatomic) NSString * photoUrl;
@property (strong, nonatomic) NSString * photoId;
@property (strong, nonatomic) NSString * pTitle;

@end
