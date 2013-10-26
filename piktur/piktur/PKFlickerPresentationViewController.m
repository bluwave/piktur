//
//  PKFlickerPresentationViewController.m
//  piktur
//
//  Created by Garrett Richards on 10/26/13.
//
//

#import "PKFlickerPresentationViewController.h"

@interface PKFlickerPresentationViewController ()
@property(nonatomic, strong) UIImageView *imageView;
@end

@implementation PKFlickerPresentationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    [self.view setBackgroundColor:[UIColor redColor]];
    self.imageView = [[UIImageView alloc] initWithImage:self.imageToPresent];
    [self.imageView setAlpha:0];
    [self.imageView setFrame:self.view.frame];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];


    [self .view addSubview:self.imageView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    UIView *v = self.imageView;

    [self animateFlicker:5 withView:v];

}

-(void) animateFlicker:(NSInteger) numberOfFlickers withView:(UIView * ) v
{
    [self animateView:v startAlpha:0 endAlpha:1.0 numberOfFlickers:5 complete:^
    {

    } withDuration:1];
}

- (void)animateView:(UIView *)v startAlpha:(CGFloat)startAlpha endAlpha:(CGFloat)endAlpha numberOfFlickers:(NSInteger)numberOfFlickers complete:(void (^)())complete withDuration:(CGFloat)dur
{
    __block NSInteger flickers = numberOfFlickers;
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAutoreverse animations:^
    {
        v.alpha = startAlpha;
    }
    completion:^(BOOL finished)
    {
        flickers--;
        if (numberOfFlickers <= 0 && complete)
            complete();
        else
            [self animateView:v startAlpha:startAlpha endAlpha:endAlpha numberOfFlickers:flickers complete:complete withDuration:dur];

    }];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
