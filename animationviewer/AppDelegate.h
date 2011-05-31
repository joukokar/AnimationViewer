//
//  AppDelegate.h
//  animationviewer
//
//  Created by Karvonen Jouko on 5/31/11.
//  Copyright Jouko Karvonen 2011. All rights reserved.
//

#import "cocos2d.h"

@interface animationviewerAppDelegate : NSObject <NSApplicationDelegate>
{
	NSWindow	*window_;
	MacGLView	*glView_;
}

@property (assign) IBOutlet NSWindow	*window;
@property (assign) IBOutlet MacGLView	*glView;

- (IBAction)toggleFullScreen:(id)sender;

@end
