#import <Box2D/Box2D.h>
#import <AudioToolbox/AudioServices.h>
#import <Foundation/Foundation.h>
#import "ActorScript.h"

#import "Script.h"

#import "Actor.h"
#import "ActorType.h"
#import "Assets.h"
#import "Behavior.h"
#import "Collision.h"
#import "CollisionPoint.h"
#import "Game.h"
#import "GameModel.h"
#import "GroupDef.h"
#import "FadeInTransition.h"
#import "FadeOutTransition.h"
#import "Region.h"
#import "Runnable.h"
#import "Scene.h"
#import "SHThumbstick.h"
#import "Sparrow.h"
#import "Transition.h"



@interface Design_20_20_OnScreenButton : ActorScript 
{
	@public
		NSString* tempHolder;
		
NSString* _NormalAnimation;

NSString* _PressedAnimation;

NSString* _Control;

BOOL _touching;

}
@end

@implementation Design_20_20_OnScreenButton

-(void)load
{
	            [mActor makeAlwaysSimulate];
        [mActor anchorToScreen];
        _touching = FALSE;
         
    [self addWhenUpdatedListener:nil func:^(NSMutableArray* list, Script* theScript){
Design_20_20_OnScreenButton* self = (Design_20_20_OnScreenButton*) theScript;
        if((!(_touching) && [mActor touchedActor]))
{
            _touching = TRUE;
            [mActor setAnimation:_PressedAnimation];
                            [self simulateKeyPress:_Control];
}

        if([mActor releasedActor])
{
            _touching = FALSE;
            [mActor setAnimation:_NormalAnimation];
                            [self simulateKeyRelease:_Control];
}

}];

} 



-(void)forwardMessage:(NSString*)msg
{
	
}

@end