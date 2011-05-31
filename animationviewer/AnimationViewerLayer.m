//
//  AnimationViewer.m
//  animationviewer
//
//  Created by Karvonen Jouko on 5/31/11.
//  Copyright Jouko Karvonen 2011. All rights reserved.
//


// Import the interfaces
#import "AnimationViewerLayer.h"

// AnimationViewerLayer implementation
@implementation AnimationViewerLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	AnimationViewerLayer *layer = [AnimationViewerLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        int i; // Loop counter.
        
        // Create the File Open Dialog class.
        NSOpenPanel *openDlg = [NSOpenPanel openPanel];
        
        
        // Enable the selection of files in the dialog.
        [openDlg setCanChooseFiles:YES];

        // Enable selecting multiple files
        [openDlg setAllowsMultipleSelection:YES];
        
        // Enable the selection of directories in the dialog.
        [openDlg setCanChooseDirectories:NO];
        
        // Display the dialog.  If the OK button was pressed,
        // process the files.
        if ( [openDlg runModalForDirectory:@"~/Desktop/" file:nil] == NSOKButton )
        {
            // Get an array containing the full filenames of all
            // files and directories selected.
            fileList = [openDlg filenames];
            
            // Loop through all the files and process them.
            for( i = 0; i < [fileList count]; i++ )
            {
                NSString *fileName = [fileList objectAtIndex:i];
                
                // Do something with the filename.
                NSLog(@"%@", fileName);
            }
        } else {
            NSLog(@"Quitting...");
            [NSApp terminate: nil];
        }

        // retain the fileList so that it won't be autoreleased
        [fileList retain];

	
        animIdx = 0;
        delay = 0.2f;
        backwardsAlso = FALSE;
        
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

        // initialize the sprite
        sprite = [CCSprite node];
		sprite.position =  ccp( size.width/2 , size.height/2 );
		[self addChild: sprite];

        [self createAndRunAnimationOnSprite];

        self.isKeyboardEnabled = YES;
	}
	return self;
}

-(void) createAndRunAnimationOnSprite
{
    // stop all previous ones
    [sprite stopAllActions];
    
    CCAnimation *animation = [CCAnimation animationWithName:@"anim" delay:delay];
    
    // forward animation
    for (int i = 0; i < [fileList count]; i++) {
        CCSprite *spr = [CCSprite spriteWithFile:[fileList objectAtIndex:i]];
        
        CCSpriteFrame *frame = [CCSpriteFrame
                                frameWithTexture:[spr texture]
                                rect:[spr textureRect]];
        [animation addFrame:frame];
    }

    // without backwardsAlso loops 1,2,3,1,2,3...
    // with backwardsAlso loops    1,2,3,2,1,2...
    if(backwardsAlso && [fileList count] > 2) {
        for (int i = [fileList count]-2; i > 0; i--) {
            CCSprite *spr = [CCSprite spriteWithFile:[fileList objectAtIndex:i]];
            
            CCSpriteFrame *frame = [CCSpriteFrame
                                    frameWithTexture:[spr texture]
                                    rect:[spr textureRect]];
            [animation addFrame:frame];
        }
    }

    [sprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] ]];
}

-(BOOL) ccKeyUp:(NSEvent*)event
{
    return TRUE;
}

-(BOOL) ccKeyDown:(NSEvent*)event
{
    NSLog(@"%@", event);
    if(event.keyCode == 124 || event.keyCode == 126) {
        // right or up - shorter delay
        delay -= 0.05f;
        if(delay < 0.05) delay=0.05;
    } else if(event.keyCode == 123 || event.keyCode == 125) {
        // left or down - longer delay
        delay += 0.05f;
        if(delay > 1) delay=1;
    } else if(event.keyCode == 49) {
        // space - change the mode to reverse thing
        backwardsAlso = !backwardsAlso;
    } else {
        return FALSE;
    }

    [self createAndRunAnimationOnSprite];

    return TRUE;
}

- (void) dealloc
{
    [fileList release];
    fileList = nil;
	
	[super dealloc];
}
@end
