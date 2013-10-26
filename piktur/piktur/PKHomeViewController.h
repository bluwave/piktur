//
//  PKHomeViewController.h
//  piktur
//
//  Created by Garrett Richards on 10/26/13.
//
//

#import <UIKit/UIKit.h>
#import "RFQuiltLayout.h"


enum {
    PKLayoutStyleGrid,
    PKLayoutStyleLine,
    PKLayoutStyleQuilt,
    PKLayoutStyleCoverFlow,

//    SpeakerLayoutStacks,
//    SpeakerLayoutSpiral,

    SpeakerLayoutCount
}
typedef PKLayoutStyle;

@interface PKHomeViewController : UIViewController <RFQuiltLayoutDelegate>

@end
