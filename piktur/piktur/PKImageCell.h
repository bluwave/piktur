//
//  PKImageCell.h
//  piktur
//
//  Created by Garrett Richards on 10/26/13.
//
//

#import <UIKit/UIKit.h>

@interface PKImageCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView *imageView;

-(void) loadImage:(UIImage * ) img contentMode:(UIViewContentMode) mode;
@end
