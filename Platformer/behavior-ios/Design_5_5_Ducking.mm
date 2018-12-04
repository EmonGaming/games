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



@interface Design_5_5_Ducking : ActorScript 
{
	@public
		NSString* tempHolder;
		
NSString* _DuckKey;

NSString* _DuckRightAnimation;

NSString* _DuckLeftAnimation;

NSString* _AnimationCategory;

}
@end

@implementation Design_5_5_Ducking

    -(void)load
{
        /* @"Inputs:---------------------" */
        /* @"\"Facing Right?\" -- <Boolean> Actor Level Attribute, set in \"Walking\" Behavior (required)" */
        /* @"Outputs:-------------------" */
        /* @"\"Is Ducking?\" -- <Boolean> Actor Level Attribute" */
}

    -(void)update
{
        if([self isKeyDown:_DuckKey])
{
            [mActor setActorValue:@"Is Ducking?" value:[NSNumber numberWithBool:TRUE]];
            if([self asBoolean:[mActor getActorValue:@"Facing Right?"]])
{
                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_DuckRightAnimation,_AnimationCategory,nil]];
}

            else
{
                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_DuckLeftAnimation,_AnimationCategory,nil]];
}

}

        else
{
            [mActor setActorValue:@"Is Ducking?" value:[NSNumber numberWithBool:FALSE]];
            [mActor sayToBehavior:@"Animation Manager" msg:@"ClearAnimCat" withArgs:[NSArray arrayWithObjects:_AnimationCategory,nil]];
}

}

    -(void)handleCollision:(Collision*)c
{

}

    -(void)render:(SPRenderSupport*)g x:(int)x y:(int)y
{
[super render:g x:x y:y];

}



-(void)forwardMessage:(NSString*)msg
{
	
}

@end