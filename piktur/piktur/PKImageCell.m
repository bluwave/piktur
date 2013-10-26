//
//  PKImageCell.m
//  piktur
//
//  Created by Garrett Richards on 10/26/13.
//
//

#import "PKImageCell.h"

@interface PKImageCell()


@end

@implementation PKImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        [self.contentView addSubview:self.imageView];
        [self.contentView.layer setMasksToBounds:YES];
    }
    return self;
}



-(void) loadImage:(UIImage * ) img contentMode:(UIViewContentMode) mode
{
    [self.imageView setContentMode:mode];
    [self.imageView setImage:img];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
