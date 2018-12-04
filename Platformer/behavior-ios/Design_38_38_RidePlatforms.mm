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



@interface Design_38_38_RidePlatforms : ActorScript 
{
	@public
		NSString* tempHolder;
		
BOOL _OnPlatform;

BOOL _HitPlatform;

SPDisplayObjectContainer* _PlatformActorGroup;

Actor* _PlatformActor;

NSString* _LeftKey;

NSString* _RightKey;

NSString* _JumpKey;

float _XOffset;

float _YOffset;

}
@end

@implementation Design_38_38_RidePlatforms

    -(void)load
{
[self handlesCollisions];

}

    -(void)update
{
        _OnPlatform = _HitPlatform;
        _HitPlatform = FALSE;
        if(!(_OnPlatform))
{
            return;
}

        if((!([self isKeyDown:_RightKey]) && (!([self isKeyDown:_LeftKey]) && !([self isKeyDown:_JumpKey]))))
{
            if(((_PlatformActor != nil) && [Actor isAlive:_PlatformActor]))
{
                [mActor setXVelocity:[_PlatformActor getXVelocity]];
                [mActor setYVelocity:[_PlatformActor getYVelocity]];
                [mActor setXPosition:([_PlatformActor getX] + _XOffset)];
                [mActor setYPosition:([_PlatformActor getY] + _YOffset)];
}

}

}

    -(void)handleCollision:(Collision*)c
{
        if([Collision fromBottom:c actor:mActor])
{
            if([self sameAs:[[Game game] getGroup:c.otherShape->groupID actor:(Actor*)c.otherShape->GetBody()->GetUserData()] two:_PlatformActorGroup])
{
                _HitPlatform = TRUE;
                _PlatformActor = [mActor getLastCollidedActor];
                _XOffset = ([mActor getX] - [_PlatformActor getX]);
                _YOffset = ([mActor getY] - [_PlatformActor getY]);
}

}

}

    -(void)render:(SPRenderSupport*)g x:(int)x y:(int)y
{
[super render:g x:x y:y];

}



-(void)forwardMessage:(NSString*)msg
{
	
}

@end