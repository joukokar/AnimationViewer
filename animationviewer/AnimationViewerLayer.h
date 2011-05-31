//
//  AnimationViewer.h
//  animationviewer
//
//  Created by Karvonen Jouko on 5/31/11.
//  Copyright Jouko Karvonen 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface AnimationViewerLayer : CCLayer
{
    CCSprite *sprite;

    NSArray *fileList;
    int animIdx;
    float delay;
    BOOL backwardsAlso;
}

// returns a CCScene that contains the AnimationViewer as the only child
+(CCScene *) scene;
-(void) createAndRunAnimationOnSprite;

@end
