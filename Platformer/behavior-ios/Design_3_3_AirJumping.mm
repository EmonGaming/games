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



@interface Design_3_3_AirJumping : ActorScript 
{
	@public
		NSString* tempHolder;
		
BOOL _PreventAirJump;

float _CurrentJumps;

BOOL _CanJump;

float _ElapsedTime;

float _OldY;

float _MaxJumps;

NSString* _JumpKey;

BOOL _MustBeRising;

float _JumpForce;

NSString* _JumpRightAnimation;

NSString* _JumpLeftAnimation;

NSString* _AnimationCategory;

}
@end

@implementation Design_3_3_AirJumping

    -(void)load
{
        /* @"Inputs:----------------------" */
        /* @"\"Is Jumping?\" -- Actor Level Attribute, from Behavior \"Jumping\" (required)" */
        /* @"Outputs:---------------------" */
        /* @"\"Is Air Jumping?\" -- <Boolean> Actor Level Attribute" */
}

    -(void)update
{
        /* Prevent Air Jump can be set via a custom block by other Behaviors that may want to temporarily prevent Air Jumping */
        if(_PreventAirJump)
{
            return;
}

        if(!([self asBoolean:[mActor getActorValue:@"Is Jumping?"]]))
{
            _CurrentJumps = 0;
            _ElapsedTime = 0;
            _CanJump = FALSE;
}

        if([self asBoolean:[mActor getActorValue:@"Is Air Jumping?"]])
{
            if(([self asBoolean:[mActor getActorValue:@"On Ground?"]] || [self asBoolean:[mActor getActorValue:@"Is Falling?"]]))
{
                [mActor setActorValue:@"Is Air Jumping?" value:[NSNumber numberWithBool:FALSE]];
                [mActor sayToBehavior:@"Animation Manager" msg:@"ClearAnimCat" withArgs:[NSArray arrayWithObjects:_AnimationCategory,nil]];
}

}

        /* @"Check if the Actor is rising or falling" */
        [self CheckPosition];
        if(([self isKeyPressed:_JumpKey] && (_CurrentJumps < _MaxJumps)))
{
            if([self asBoolean:[mActor getActorValue:@"Is Jumping?"]])
{
                if((_MustBeRising && !(_CanJump)))
{
                    return;
}

                [self doLater:1000 * 0.05 task:[self createRunnable:^(Runnable* parent, Script* theScript){
Design_3_3_AirJumping* self = (Design_3_3_AirJumping*) theScript;
                            [mActor setActorValue:@"Is Air Jumping?" value:[NSNumber numberWithBool:TRUE]];
                            if([self asBoolean:[mActor getActorValue:@"Facing Right?"]])
{
                                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_JumpRightAnimation,_AnimationCategory,nil]];
}

                            else
{
                                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_JumpLeftAnimation,_AnimationCategory,nil]];
}

}]];
                [mActor setYVelocity:0];
                [mActor applyImpulse:0 dirY:-1 withForce:_JumpForce];
                _CurrentJumps += 1;
}

}

        _OldY = [mActor getY];
}

    -(void)handleCollision:(Collision*)c
{

}

    -(void)render:(SPRenderSupport*)g x:(int)x y:(int)y
{
[super render:g x:x y:y];

}

    -(void)CheckPosition
{
        if((_CanJump && ([mActor getY] > _OldY)))
{
            _ElapsedTime += (1000 * STEP_SIZE);
            if((_ElapsedTime >= 150))
{
                _CanJump = FALSE;
}

}

        if(([mActor getY] < _OldY))
{
            _CanJump = TRUE;
}

}

    

/* Params are:__Self __Prevent */
- ( void) PreventAirJump:(NSArray*)args
{
Actor* __Self = mActor;
BOOL __Prevent = (BOOL) [[args objectAtIndex:0] boolValue];
        _PreventAirJump = __Prevent;
}


-(void)forwardMessage:(NSString*)msg
{
	
}

@end