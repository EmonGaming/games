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



@interface Design_8_8_Running : ActorScript 
{
	@public
		NSString* tempHolder;
		
BOOL _PreventRunning;

NSString* _RunKey;

BOOL _KeyReleased;

float _OldAccel;

float _OldMaxSpeed;

BOOL _AtFullSpeed;

float _ElapsedTime;

float _Acceleration;

float _MidRunSpeed;

float _MaxRunSpeed;

NSString* _RightKey;

NSString* _LeftKey;

float _TimeToMaxSpeed;

BOOL _CanSlide;

NSString* _RunRightAnimation;

NSString* _SlipRightAnimation;

NSString* _RunLeftAnimation;

NSString* _FullRunRightAnimation;

NSString* _SlipLeftAnimation;

NSString* _AnimationCategory;

NSString* _FullRunLeftAnimation;

}
@end

@implementation Design_8_8_Running

-(void)load
{
	            /* **Note** - This Behavior requires the "Walking" Behavior to function properly.  */
        /* @"Inputs: ----------------------" */
        /* @"\"Facing Right?\" -- <Boolean> Actor Level Attribute, from \"Walking\" Behavior (required)" */
        /* @"Outputs: ---------------------" */
        /* @"\"Is Running?\" -- <Boolean> Actor Level Attribute" */
        _KeyReleased = TRUE;
    [self addWhenUpdatedListener:nil func:^(NSMutableArray* list, Script* theScript){
Design_8_8_Running* self = (Design_8_8_Running*) theScript;
        if(_PreventRunning)
{
            return;
}

        if((([self isKeyDown:_RunKey] && _KeyReleased) && [self asBoolean:[mActor getActorValue:@"On Ground?"]]))
{
            [mActor setActorValue:@"Is Running?" value:[NSNumber numberWithBool:TRUE]];
            _KeyReleased = FALSE;
            _OldAccel = (float)[([mActor sayToBehavior:@"Walking" msg:@"GetWalkAccel" withArgs:nil]) floatValue];
            _OldMaxSpeed = (float)[([mActor sayToBehavior:@"Walking" msg:@"GetMaxWalkSpeed" withArgs:nil]) floatValue];
            [mActor sayToBehavior:@"Walking" msg:@"WalkAccel" withArgs:[NSArray arrayWithObjects:[NSNumber numberWithFloat:_Acceleration],nil]];
            [mActor sayToBehavior:@"Walking" msg:@"MaxWalkSpeed" withArgs:[NSArray arrayWithObjects:[NSNumber numberWithFloat:_MidRunSpeed],nil]];
            return;
}

        if((!(_KeyReleased) && !([self isKeyDown:_RunKey])))
{
            [mActor setActorValue:@"Is Running?" value:[NSNumber numberWithBool:FALSE]];
            [mActor sayToBehavior:@"Animation Manager" msg:@"ClearAnimCat" withArgs:[NSArray arrayWithObjects:_AnimationCategory,nil]];
            _AtFullSpeed = FALSE;
            _KeyReleased = TRUE;
            _ElapsedTime = 0;
            [mActor sayToBehavior:@"Walking" msg:@"WalkAccel" withArgs:[NSArray arrayWithObjects:[NSNumber numberWithFloat:_OldAccel],nil]];
            [mActor sayToBehavior:@"Walking" msg:@"MaxWalkSpeed" withArgs:[NSArray arrayWithObjects:[NSNumber numberWithFloat:_OldMaxSpeed],nil]];
}

        if((!([self isKeyDown:_RightKey]) && !([self isKeyDown:_LeftKey])))
{
            [mActor setActorValue:@"Is Running?" value:[NSNumber numberWithBool:FALSE]];
            [mActor sayToBehavior:@"Animation Manager" msg:@"ClearAnimCat" withArgs:[NSArray arrayWithObjects:_AnimationCategory,nil]];
            _AtFullSpeed = FALSE;
            return;
}

        if(([self isKeyDown:_RunKey] && ([self isKeyDown:_LeftKey] || [self isKeyDown:_RightKey])))
{
            [mActor setActorValue:@"Is Running?" value:[NSNumber numberWithBool:TRUE]];
}

        if([self asBoolean:[mActor getActorValue:@"Is Running?"]])
{
            [self SetAnimation];
            if((fabs([mActor getXVelocity]) < _MaxRunSpeed))
{
                _AtFullSpeed = FALSE;
}

            if((fabs([mActor getXVelocity]) < _MidRunSpeed))
{
                return;
}

            _ElapsedTime += 1;
            if(((_ElapsedTime >= ((_TimeToMaxSpeed * 1000) / (1000 * STEP_SIZE))) && !(_AtFullSpeed)))
{
                _AtFullSpeed = TRUE;
                [mActor sayToBehavior:@"Walking" msg:@"MaxWalkSpeed" withArgs:[NSArray arrayWithObjects:[NSNumber numberWithFloat:_MaxRunSpeed],nil]];
}

}

}];

} 

    -(void)SetAnimation
{
        if(((!([self isKeyDown:_RightKey]) && !([self isKeyDown:_LeftKey])) || !([self asBoolean:[mActor getActorValue:@"On Ground?"]])))
{
            return;
}

        if([self asBoolean:[mActor getActorValue:@"Facing Right?"]])
{
            if(([self isKeyDown:_RightKey] && (([mActor getXVelocity] <= -1) && _CanSlide)))
{
                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_SlipRightAnimation,@"Running",nil]];
                return;
}

            if(_AtFullSpeed)
{
                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_FullRunRightAnimation,@"Running",nil]];
}

            else
{
                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_RunRightAnimation,@"Running",nil]];
}

}

        else
{
            if(([self isKeyDown:_LeftKey] && (([mActor getXVelocity] >= 1) && _CanSlide)))
{
                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_SlipLeftAnimation,@"Running",nil]];
                return;
}

            if(_AtFullSpeed)
{
                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_FullRunLeftAnimation,@"Running",nil]];
}

            else
{
                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_RunLeftAnimation,@"Running",nil]];
}

}

}



-(void)forwardMessage:(NSString*)msg
{
	
}

@end