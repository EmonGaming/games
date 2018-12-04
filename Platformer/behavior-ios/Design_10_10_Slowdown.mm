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



@interface Design_10_10_Slowdown : ActorScript 
{
	@public
		NSString* tempHolder;
		
NSString* _RightKey;

NSString* _LeftKey;

float _GroundSlowdown;

float _AirSlowdown;

float _DuckingSlowdown;

float _MovingAirSlowdown;

float _MovingGroundSlowdown;

}
@end

@implementation Design_10_10_Slowdown

-(void)load
{
	            /* @"Inputs: ----------------------" */
        /* @"\"On Ground?\" -- <Boolean> Actor Level Attribute, from \"On Ground\" Behavior" */
        /* @"\"Is Ducking?\" -- <Boolean> Actor Level Attribute, from \"Ducking\" Behavior" */
        /* @"\"Is Slope Sliding?\" -- <Boolean> Actor Level Attribute, from \"Slope Detection\" Behavior" */
        /* @"Outputs: ---------------------" */
        /* @"None" */
    [self addWhenUpdatedListener:nil func:^(NSMutableArray* list, Script* theScript){
Design_10_10_Slowdown* self = (Design_10_10_Slowdown*) theScript;
        if([self asBoolean:[mActor getActorValue:@"Is Slope Sliding?"]])
{
            return;
}

        if(([self asBoolean:[mActor getActorValue:@"Is Ducking?"]] && [self asBoolean:[mActor getActorValue:@"On Ground?"]]))
{
            [mActor setXVelocity:([mActor getXVelocity] * _DuckingSlowdown)];
            return;
}

        if(((!([self isKeyDown:_RightKey]) && !([self isKeyDown:_LeftKey])) && !([self asBoolean:[mActor getActorValue:@"Is Ducking?"]])))
{
            if([self asBoolean:[mActor getActorValue:@"On Ground?"]])
{
                [mActor setXVelocity:([mActor getXVelocity] * _GroundSlowdown)];
}

            else
{
                [mActor setXVelocity:([mActor getXVelocity] * _AirSlowdown)];
}

}

        else
{
            if([self asBoolean:[mActor getActorValue:@"On Ground?"]])
{
                [mActor sayToBehavior:@"Walking" msg:@"SlowToMax" withArgs:[NSArray arrayWithObjects:[NSNumber numberWithFloat:_MovingGroundSlowdown],nil]];
}

            else
{
                [mActor setXVelocity:([mActor getXVelocity] * _MovingAirSlowdown)];
}

}

}];

} 



-(void)forwardMessage:(NSString*)msg
{
	
}

@end