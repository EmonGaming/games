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



@interface Design_9_9_WallJumping : ActorScript 
{
	@public
		NSString* tempHolder;
		
BOOL _CollidingLeft;

BOOL _CollidingRight;

BOOL _CollidedLeft;

BOOL _CollidedRight;

BOOL _KeyReleased;

BOOL _Jumped;

NSString* _JumpKey;

BOOL _CanJump;

float _ElapsedTime;

float _JumpRightAngle;

float _JumpLeftAngle;

float _JumpForce;

NSString* _WallJumpRightAnimation;

NSString* _WallJumpLeftAnimation;

NSString* _AnimationCategory;

BOOL _PreventWallJump;

}
@end

@implementation Design_9_9_WallJumping

    -(void)load
{
[self handlesCollisions];
        /* @"Inputs: ----------------------" */
        /* @"\"On Ground?\" -- <Boolean> Actor Level Attribute, from \"On Ground\" Behavior (required)" */
        /* @"\"Facing Right?\" -- <Boolean> Actor Level Attribute, from \"Walking\" Behavior (required)" */
        /* @"Outputs: ---------------------" */
        /* @"\"Is Wall Jumping?\" -- <Boolean> Actor Level Attribute" */
}

    -(void)update
{
        if(_PreventWallJump)
{
            return;
}

        _CollidedLeft = _CollidingLeft;
        _CollidedRight = _CollidingRight;
        _CollidingLeft = FALSE;
        _CollidingRight = FALSE;
        if([self asBoolean:[mActor getActorValue:@"On Ground?"]])
{
            [mActor setActorValue:@"Is Wall Jumping?" value:[NSNumber numberWithBool:FALSE]];
            [mActor sayToBehavior:@"Animation Manager" msg:@"ClearAnimCat" withArgs:[NSArray arrayWithObjects:_AnimationCategory,nil]];
            _KeyReleased = FALSE;
            _Jumped = FALSE;
            return;
}

        if([self isKeyPressed:_JumpKey])
{
            if([self asBoolean:[mActor getActorValue:@"On Ground?"]])
{
                _KeyReleased = FALSE;
                if((!(_CollidedLeft) && !(_CollidedRight)))
{
                    [self doLater:1000 * 0.15 task:[self createRunnable:^(Runnable* parent, Script* theScript){
Design_9_9_WallJumping* self = (Design_9_9_WallJumping*) theScript;
                                if((!(_CollidedLeft) && !(_CollidedRight)))
{
                                    _KeyReleased = FALSE;
}

}]];
}

}

}

        if(_KeyReleased)
{
            _CanJump = TRUE;
}

        if((!(_KeyReleased) && !([self isKeyDown:_JumpKey])))
{
            if(!([self asBoolean:[mActor getActorValue:@"On Ground?"]]))
{
                _KeyReleased = TRUE;
}

}

        if(([self isKeyDown:_JumpKey] && ((_CanJump && _KeyReleased) && !([self asBoolean:[mActor getActorValue:@"On Ground?"]]))))
{
            _KeyReleased = FALSE;
            _Jumped = FALSE;
            if(_CollidedLeft)
{
                _Jumped = TRUE;
                _ElapsedTime = 0;
                _CanJump = FALSE;
                [mActor setYVelocity:0];
                [mActor applyImpulseInDirection:_JumpRightAngle withForce:_JumpForce];
                [mActor setActorValue:@"Facing Right?" value:[NSNumber numberWithBool:TRUE]];
                [mActor sayToBehavior:@"Walking" msg:@"PreventWalk" withArgs:[NSArray arrayWithObjects:[NSNumber numberWithBool:TRUE],nil]];
                [mActor sayToBehavior:@"Air Jumping" msg:@"PreventAirJump" withArgs:[NSArray arrayWithObjects:[NSNumber numberWithBool:TRUE],nil]];
                [mActor sayToBehavior:@"Wall Sliding" msg:@"PreventWallSlide" withArgs:[NSArray arrayWithObjects:[NSNumber numberWithBool:TRUE],nil]];
}

            if(_CollidedRight)
{
                _Jumped = TRUE;
                _ElapsedTime = 0;
                _CanJump = FALSE;
                [mActor setYVelocity:0];
                [mActor applyImpulseInDirection:_JumpLeftAngle withForce:_JumpForce];
                [mActor setActorValue:@"Facing Right?" value:[NSNumber numberWithBool:FALSE]];
                [mActor sayToBehavior:@"Walking" msg:@"PreventWalk" withArgs:[NSArray arrayWithObjects:[NSNumber numberWithBool:TRUE],nil]];
                [mActor sayToBehavior:@"Air Jumping" msg:@"PreventAirJump" withArgs:[NSArray arrayWithObjects:[NSNumber numberWithBool:TRUE],nil]];
                [mActor sayToBehavior:@"Wall Sliding" msg:@"PreventWallSlide" withArgs:[NSArray arrayWithObjects:[NSNumber numberWithBool:TRUE],nil]];
}

}

        if(_Jumped)
{
            _ElapsedTime += 1;
            if((_ElapsedTime >= ((.1 * 1000) / (1000 * STEP_SIZE))))
{
                [mActor setActorValue:@"Is Wall Jumping?" value:[NSNumber numberWithBool:TRUE]];
}

            if((_ElapsedTime >= ((.2 * 1000) / (1000 * STEP_SIZE))))
{
                [mActor sayToBehavior:@"Walking" msg:@"PreventWalk" withArgs:[NSArray arrayWithObjects:[NSNumber numberWithBool:FALSE],nil]];
                [mActor sayToBehavior:@"Air Jumping" msg:@"PreventAirJump" withArgs:[NSArray arrayWithObjects:[NSNumber numberWithBool:FALSE],nil]];
                [mActor sayToBehavior:@"Wall Sliding" msg:@"PreventWallSlide" withArgs:[NSArray arrayWithObjects:[NSNumber numberWithBool:FALSE],nil]];
}

}

        else
{
            [mActor sayToBehavior:@"Walking" msg:@"PreventWalk" withArgs:[NSArray arrayWithObjects:[NSNumber numberWithBool:FALSE],nil]];
            [mActor sayToBehavior:@"Air Jumping" msg:@"PreventAirJump" withArgs:[NSArray arrayWithObjects:[NSNumber numberWithBool:FALSE],nil]];
            [mActor sayToBehavior:@"Wall Sliding" msg:@"PreventWallSlide" withArgs:[NSArray arrayWithObjects:[NSNumber numberWithBool:FALSE],nil]];
}

        if([self asBoolean:[mActor getActorValue:@"Is Wall Jumping?"]])
{
            if([self asBoolean:[mActor getActorValue:@"Facing Right?"]])
{
                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_WallJumpRightAnimation,_AnimationCategory,nil]];
}

            else
{
                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_WallJumpLeftAnimation,_AnimationCategory,nil]];
}

}

}

    -(void)handleCollision:(Collision*)c
{
        if(([Collision collidedWithSensor:c actor:mActor] || !([Collision collidedWithTile:c actor:mActor])))
{
            return;
}

        if([Collision fromLeft:c actor:mActor])
{
            _CollidingLeft = TRUE;
            [mActor setActorValue:@"Is Wall Jumping?" value:[NSNumber numberWithBool:FALSE]];
            [mActor sayToBehavior:@"Animation Manager" msg:@"ClearAnimCat" withArgs:[NSArray arrayWithObjects:_AnimationCategory,nil]];
}

        if([Collision fromRight:c actor:mActor])
{
            _CollidingRight = TRUE;
            [mActor setActorValue:@"Is Wall Jumping?" value:[NSNumber numberWithBool:FALSE]];
            [mActor sayToBehavior:@"Animation Manager" msg:@"ClearAnimCat" withArgs:[NSArray arrayWithObjects:_AnimationCategory,nil]];
}

}

    -(void)render:(SPRenderSupport*)g x:(int)x y:(int)y
{
[super render:g x:x y:y];

}

    

/* Params are:__Self __Prevent */
- ( void) PreventWallJump:(NSArray*)args
{
Actor* __Self = mActor;
BOOL __Prevent = (BOOL) [[args objectAtIndex:0] boolValue];
        _PreventWallJump = __Prevent;
}


-(void)forwardMessage:(NSString*)msg
{
	
}

@end