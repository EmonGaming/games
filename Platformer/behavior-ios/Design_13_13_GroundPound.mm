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



@interface Design_13_13_GroundPound : ActorScript 
{
	@public
		NSString* tempHolder;
		
BOOL _CanPound;

NSString* _GroundPoundKey;

NSString* _DownKey;

BOOL _DownKeyRequired;

float _Force;

NSString* _PoundRightAnimation;

NSString* _PoundLeftAnimation;

float _OldX;

NSString* _AnimationCategory;

}
@end

@implementation Design_13_13_GroundPound

    -(void)load
{
        /* @"Inputs: ----------------------" */
        /* @"\"On Ground?\" -- <Boolean> Actor Level Attribute, from \"On Ground\" Behavior (required)" */
        /* @"\"Is Jumping?\" -- <Boolean> Actor Level Attribute, from \"Jumping\" Behavior (required)" */
        /* @"\"Facing Right?\" -- <Boolean> Actor Level Attribute, from \"Walking\" Behavior (required)" */
        /* @"\"Is Wall Sliding?\" -- <Boolean> Actor Level Attribute, from \"Wall Sliding\" Behavior (NOT required)" */
        /* @"Outputs: ---------------------" */
        /* @"\"Is Ground Pounding\" -- <Boolean> Actor Level Attribute" */
}

    -(void)update
{
        if([self asBoolean:[mActor getActorValue:@"Is Wall Sliding?"]])
{
            [mActor setActorValue:@"Is Ground Pounding?" value:[NSNumber numberWithBool:FALSE]];
            [mActor sayToBehavior:@"Animation Manager" msg:@"ClearAnimCat" withArgs:[NSArray arrayWithObjects:_AnimationCategory,nil]];
            _CanPound = FALSE;
            return;
}

        if((!([self asBoolean:[mActor getActorValue:@"Is Jumping?"]]) || [self asBoolean:[mActor getActorValue:@"On Ground?"]]))
{
            if(([self asBoolean:[mActor getActorValue:@"Is Ground Pounding?"]] && [self asBoolean:[mActor getActorValue:@"On Ground?"]]))
{
                [[Game game] shakeScreen:1*0.01 forDuration:0.2*1000];
}

            _CanPound = FALSE;
            [mActor setActorValue:@"Is Ground Pounding?" value:[NSNumber numberWithBool:FALSE]];
            [mActor sayToBehavior:@"Animation Manager" msg:@"ClearAnimCat" withArgs:[NSArray arrayWithObjects:_AnimationCategory,nil]];
            return;
}

        if([self isKeyPressed:_GroundPoundKey])
{
            if((_DownKeyRequired && !([self isKeyDown:_DownKey])))
{
                return;
}

            _CanPound = FALSE;
            [mActor setActorValue:@"Is Ground Pounding?" value:[NSNumber numberWithBool:TRUE]];
            [mActor applyImpulse:0 dirY:1 withForce:_Force];
}

        if([self asBoolean:[mActor getActorValue:@"Is Ground Pounding?"]])
{
            [mActor setXVelocity:0];
            [mActor setXPosition:_OldX];
            if([self asBoolean:[mActor getActorValue:@"Facing Right?"]])
{
                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_PoundRightAnimation,_AnimationCategory,nil]];
}

            else
{
                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_PoundLeftAnimation,_AnimationCategory,nil]];
}

}

        _OldX = [mActor getX];
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