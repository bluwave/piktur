//
//  PKImageCell.m
//  piktur
//
//  Created by Garrett Richards on 10/26/13.
//
//

#import "PKImageCell.h"
#import "FICImageCache.h"
#import "FICDPhoto.h"


@interface PKImageCell()
@property(nonatomic, weak) id<FICEntity> photo;

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

-(void)loadPhoto:(id <FICEntity>)photo
{
    self.photo = photo;
    __weak __typeof__ (self) weakself = self;
    [[FICImageCache sharedImageCache] retrieveImageForEntity:photo withFormatName:FICDPhotoSquareImageFormatName completionBlock:^(id <FICEntity> entity, NSString *formatName, UIImage *image)
    {
        // This completion block may be called much later. We should check to make sure this cell hasn't been reused for different photos before displaying the image that has loaded.

        NSLog(@"%s imag size; %@", __func__, NSStringFromCGSize(image.size));
        if (photo == [weakself photo])
        {
            if (weakself)
                [weakself.imageView setContentMode:UIViewContentModeCenter];
                [weakself.imageView setImage:image];
        }
    }];
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
