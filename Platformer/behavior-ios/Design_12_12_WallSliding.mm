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



@interface Design_12_12_WallSliding : ActorScript 
{
	@public
		NSString* tempHolder;
		
BOOL _CanSlide;

BOOL _CollidingLeft;

BOOL _CollidingRight;

BOOL _CollidedLeft;

BOOL _CollidedRight;

float _OldY;

NSString* _LeftKey;

NSString* _RightKey;

float _SlideSpeed;

NSString* _SlideRightAnimation;

NSString* _SlideLeftAnimation;

BOOL _LimittoTiles;

BOOL _PreventWallSlide;

NSString* _AnimationCategory;

}
@end

@implementation Design_12_12_WallSliding

    -(void)load
{
[self handlesCollisions];
        /* @"Inputs: ----------------------" */
        /* @"\"On Ground?\" -- <Boolean> Actor Level Attribute, from \"On Ground\" Behavior (required)" */
        /* @"\"Facing Right?\" -- <Boolean> Actor Level Attribute, from \"Walking\" Behavior (required)" */
        /* @"\"Is Wall Jumping?\" -- <Boolean> Actor Level Attribute, from \"Wall Jumping\" Behavior (NOT required)" */
        /* @"\"Is Climbing?\" -- <Boolean> Actor Level Attribute, from \"Climbing\" Behavior (NOT required)" */
        /* @"\"Is Ducking?\" -- <Boolean> Actor Level Attribute, from \"Ducking\" Behavior (NOT required)" */
        /* @"Outputs: ---------------------" */
        /* @"\"Is Wall Sliding?\" -- <Boolean> Actor Level Attribute" */
}

    -(void)update
{
        if(_PreventWallSlide)
{
            _CanSlide = FALSE;
            [mActor setActorValue:@"Is Wall Sliding?" value:[NSNumber numberWithBool:FALSE]];
            [mActor sayToBehavior:@"Animation Manager" msg:@"ClearAnimCat" withArgs:[NSArray arrayWithObjects:_AnimationCategory,nil]];
            return;
}

        _CanSlide = TRUE;
        if(([self asBoolean:[mActor getActorValue:@"Is Climbing?"]] || ([self asBoolean:[mActor getActorValue:@"Is Ducking?"]] || [self asBoolean:[mActor getActorValue:@"On Ground?"]])))
{
            _CanSlide = FALSE;
            [mActor setActorValue:@"Is Wall Sliding?" value:[NSNumber numberWithBool:FALSE]];
}

        _CollidedLeft = _CollidingLeft;
        _CollidedRight = _CollidingRight;
        _CollidingLeft = FALSE;
        _CollidingRight = FALSE;
        if((([mActor getY] > _OldY) && _CanSlide))
{
            if(!([self asBoolean:[mActor getActorValue:@"On Ground?"]]))
{
                if(((_CollidedLeft && [self isKeyDown:_LeftKey]) || (_CollidedRight && [self isKeyDown:_RightKey])))
{
                    [mActor setActorValue:@"Is Wall Sliding?" value:[NSNumber numberWithBool:TRUE]];
}

                else
{
                    [mActor setActorValue:@"Is Wall Sliding?" value:[NSNumber numberWithBool:FALSE]];
}

}

}

        if([self asBoolean:[mActor getActorValue:@"Is Wall Sliding?"]])
{
            [mActor setYVelocity:_SlideSpeed];
            if([self asBoolean:[mActor getActorValue:@"Facing Right?"]])
{
                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_SlideRightAnimation,_AnimationCategory,nil]];
}

            else
{
                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_SlideLeftAnimation,_AnimationCategory,nil]];
}

}

        else
{
            [mActor sayToBehavior:@"Animation Manager" msg:@"ClearAnimCat" withArgs:[NSArray arrayWithObjects:_AnimationCategory,nil]];
}

        _OldY = [mActor getY];
}

    -(void)handleCollision:(Collision*)c
{
        if([Collision collidedWithSensor:c actor:mActor])
{
            return;
}

        if([Collision fromLeft:c actor:mActor])
{
            if((_LimittoTiles && !([Collision collidedWithTile:c actor:mActor])))
{
                return;
}

            _CollidingLeft = TRUE;
}

        if([Collision fromRight:c actor:mActor])
{
            if((_LimittoTiles && !([Collision collidedWithTile:c actor:mActor])))
{
                return;
}

            _CollidingRight = TRUE;
}

}

    -(void)render:(SPRenderSupport*)g x:(int)x y:(int)y
{
[super render:g x:x y:y];

}

    

/* Params are:__Self __Prevent */
- ( void) PreventWallSlide:(NSArray*)args
{
Actor* __Self = mActor;
BOOL __Prevent = (BOOL) [[args objectAtIndex:0] boolValue];
        _PreventWallSlide = __Prevent;
}


-(void)forwardMessage:(NSString*)msg
{
	
}

@end