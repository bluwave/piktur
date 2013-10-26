//
//  UIView+PKHelpers.m
//  piktur
//
//  Created by Garrett Richards on 10/26/13.
//
//

#import "UIView+PKHelpers.h"

@implementation UIView (PKHelpers)

- (UIImage *)pkSnapshotImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //    // hack, helps w/ our colors when blurring
    //    NSData *imageData = UIImageJPEGRepresentation(image, 1); // convert to jpeg
    //    image = [UIImage imageWithData:imageData];
    //
//    UIImageView * im = [[UIImageView alloc] initWithImage:image];
//    return im;
    return image;
}

@end
