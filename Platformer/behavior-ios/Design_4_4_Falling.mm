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



@interface Design_4_4_Falling : ActorScript 
{
	@public
		NSString* tempHolder;
		
float _OldY;

BOOL _CanFall;

NSString* _FallRightAnimation;

NSString* _FallLeftAnimation;

float _GroundY;

NSString* _AnimationCategory;

}
@end

@implementation Design_4_4_Falling

-(void)load
{
	            /* @"Inputs:" */
        /* @"\"Facing Right?\" -- <Boolean> Actor Level Attribute, from \"Walking\" Behavior (required)" */
        /* @"Outputs:" */
        /* @"\"Is Falling?\" -- <Boolean> Actor Level Attribute" */
    [self addWhenUpdatedListener:nil func:^(NSMutableArray* list, Script* theScript){
Design_4_4_Falling* self = (Design_4_4_Falling*) theScript;
        if(!([self asBoolean:[mActor getActorValue:@"On Ground?"]]))
{
            [self CheckFalling];
            if(!(_CanFall))
{
                [mActor sayToBehavior:@"Animation Manager" msg:@"ClearAnimCat" withArgs:[NSArray arrayWithObjects:_AnimationCategory,nil]];
}

}

        else
{
            [mActor sayToBehavior:@"Animation Manager" msg:@"ClearAnimCat" withArgs:[NSArray arrayWithObjects:_AnimationCategory,nil]];
            return;
}

        if(!(_CanFall))
{
            [mActor setActorValue:@"Is Falling?" value:[NSNumber numberWithBool:FALSE]];
}

        else
{
            [mActor setActorValue:@"Is Falling?" value:[NSNumber numberWithBool:TRUE]];
            if([self asBoolean:[mActor getActorValue:@"Facing Right?"]])
{
                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_FallRightAnimation,_AnimationCategory,nil]];
}

            else
{
                [mActor sayToBehavior:@"Animation Manager" msg:@"LoopAnim" withArgs:[NSArray arrayWithObjects:_FallLeftAnimation,_AnimationCategory,nil]];
}

}

        _OldY = [mActor getY];
        if([self asBoolean:[mActor getActorValue:@"On Ground?"]])
{
            _GroundY = [mActor getY];
}

}];

} 

    -(void)CheckFalling
{
        if(([mActor getY] <= _OldY))
{
            _CanFall = FALSE;
            return;
}

        if([self asBoolean:[mActor getActorValue:@"Is Wall Sliding?"]])
{
            _CanFall = FALSE;
            return;
}

        if((!(_CanFall) && (fabs((_GroundY - [mActor getY])) <= 3)))
{
            return;
}

        _CanFall = TRUE;
}



-(void)forwardMessage:(NSString*)msg
{
	
}

@end