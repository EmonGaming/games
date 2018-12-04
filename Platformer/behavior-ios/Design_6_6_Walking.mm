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



@interface Design_6_6_Walking : ActorScript 
{
	@public
		NSString* tempHolder;
		
NSString* _MoveRightKey;

NSString* _MoveLeftKey;

float _Acceleration;

float _MaxWalkingSpeed;

BOOL _LimitSpeed;

NSString* _WalkRightAnimation;

NSString* _WalkLeftAnimation;

NSString* _IdleRightAnimation;

NSString* _IdleLeftAnimation;

BOOL _PreventWalking;

NSMutableArray* _DisableStatuses;

NSString* _AnimationCategory;

}
@end

@implementation Design_6_6_Walking

-(void)load
{
	            /* @"Inputs: ----------------------" */
        /* @"\"On Ground?\" -- <Boolean> Actor Level Attribute, from \"On Ground\" Behavior (required)" */
        /* @"\"Is Running?\" -- <Boolean> Actor Level Attribute, from \"Jumping\" Behavior (NOT required)" */
        /* @"\"Is Ducking?\" -- <Boolean> Actor Level Attribute, from \"Ducking\" Behavior (NOT required)" */
        /* @"\"Is Slope Sliding?\" -- <Boolean> Actor Level Attribute, from \"Slope Detection\" Behavior (NOT required)" */
        /* @"Outputs: ---------------------" */
        /* @"\"Facing Right?\" -- <Boolean> Actor Level Attribute" */
        [mActor setActorValue:@"Facing Right?" value:[NSNumber numberWithBool:TRUE]];
    [self addWhenUpdatedListener:nil func:^(NSMutableArray* list, Script* theScript){
Design_6_6_Walking* self = (Design_6_6_Walking*) theScript;
        for(id item in _DisableStatuses)
{
            if([self asBoolean:[mActor getActorValue:[NSString stringWithFormat:@"%@", item]]])
{
                return;
}

}

        if(_PreventWalking)
{
            return;
}

        if(([self isKeyDown:_MoveRightKey] && !([self isKeyDown:_MoveLeftKey])))
{
            [mActor setActorValue:@"Facing Right?" value:[NSNumber numberWithBool:TRUE]];
            if([self asBoolean:[mActor getActorValue:@"On Ground?"]])
{
                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_WalkRightAnimation,_AnimationCategory,nil]];
}

            if((BOOL)[([mActor sayToBehavior:@"Walking" msg:@"AtMaxWalkingSpeed" withArgs:nil]) boolValue])
{
                return;
}

            [mActor push:1 dirY:0 withForce:_Acceleration];
}

        if(([self isKeyDown:_MoveLeftKey] && !([self isKeyDown:_MoveRightKey])))
{
            [mActor setActorValue:@"Facing Right?" value:[NSNumber numberWithBool:FALSE]];
            if([self asBoolean:[mActor getActorValue:@"On Ground?"]])
{
                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_WalkLeftAnimation,_AnimationCategory,nil]];
}

            if((BOOL)[([mActor sayToBehavior:@"Walking" msg:@"AtMaxWalkingSpeed" withArgs:nil]) boolValue])
{
                return;
}

            [mActor push:-1 dirY:0 withForce:_Acceleration];
}

        if((!([self isKeyDown:_MoveRightKey]) && !([self isKeyDown:_MoveLeftKey])))
{
            if([self asBoolean:[mActor getActorValue:@"On Ground?"]])
{
                if([self asBoolean:[mActor getActorValue:@"Facing Right?"]])
{
                    [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_IdleRightAnimation,_AnimationCategory,nil]];
}

                else
{
                    [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_IdleLeftAnimation,_AnimationCategory,nil]];
}

}

}

}];

} 

    

/* Params are:__Self */
- ( NSNumber*) AtMaxWalkingSpeed:(NSArray*)args
{
Actor* __Self = mActor;
        if(([self asBoolean:[mActor getActorValue:@"Facing Right?"]] && ([mActor getXVelocity] >= _MaxWalkingSpeed)))
{
            if(_LimitSpeed)
{
                [mActor setXVelocity:_MaxWalkingSpeed];
}

            return [NSNumber numberWithBool:TRUE];
}

        if((!([self asBoolean:[mActor getActorValue:@"Facing Right?"]]) && ([mActor getXVelocity] <= -(_MaxWalkingSpeed))))
{
            if(_LimitSpeed)
{
                [mActor setXVelocity:-(_MaxWalkingSpeed)];
}

            return [NSNumber numberWithBool:TRUE];
}

        return [NSNumber numberWithBool:FALSE];
}
    

/* Params are:__Self __Accel */
- ( void) WalkAccel:(NSArray*)args
{
Actor* __Self = mActor;
float __Accel = (float) [[args objectAtIndex:0] floatValue];
        _Acceleration = __Accel;
}
    

/* Params are:__Self */
- ( NSNumber*) GetWalkAccel:(NSArray*)args
{
Actor* __Self = mActor;
        return [NSNumber numberWithFloat:_Acceleration];
}
    

/* Params are:__Self __MaxSpeed */
- ( void) MaxWalkSpeed:(NSArray*)args
{
Actor* __Self = mActor;
float __MaxSpeed = (float) [[args objectAtIndex:0] floatValue];
        _MaxWalkingSpeed = __MaxSpeed;
}
    

/* Params are:__Self */
- ( NSNumber*) GetMaxWalkSpeed:(NSArray*)args
{
Actor* __Self = mActor;
        return [NSNumber numberWithFloat:_MaxWalkingSpeed];
}
    

/* Params are:__Self __Prevent */
- ( void) PreventWalk:(NSArray*)args
{
Actor* __Self = mActor;
BOOL __Prevent = (BOOL) [[args objectAtIndex:0] boolValue];
        _PreventWalking = __Prevent;
}
    

/* Params are:__Self __Limit */
- ( void) LimitSpeed:(NSArray*)args
{
Actor* __Self = mActor;
BOOL __Limit = (BOOL) [[args objectAtIndex:0] boolValue];
        _LimitSpeed = __Limit;
}
    

/* Params are:__Self __Rate */
- ( void) SlowToMax:(NSArray*)args
{
Actor* __Self = mActor;
float __Rate = (float) [[args objectAtIndex:0] floatValue];
        if((fabs([__Self getXVelocity]) > _MaxWalkingSpeed))
{
            [mActor setXVelocity:([mActor getXVelocity] * __Rate)];
}

}


-(void)forwardMessage:(NSString*)msg
{
	
}

@end