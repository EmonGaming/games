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



@interface Design_11_11_OnGround : ActorScript 
{
	@public
		NSString* tempHolder;
		
BOOL _HitGround;

BOOL _LimitToTiles;

NSMutableArray* _ExcludedGroups;

}
@end

@implementation Design_11_11_OnGround

-(void)load
{
	    [self handlesCollisions];
        /* @"Inputs:" */
        /* @"None" */
        /* @"Outputs:" */
        /* @"\"On Ground?\" -- <Boolean> Actor Level Attribute" */
    [self addWhenUpdatedListener:nil func:^(NSMutableArray* list, Script* theScript){
Design_11_11_OnGround* self = (Design_11_11_OnGround*) theScript;
        [mActor setActorValue:@"On Ground?" value:[NSNumber numberWithBool:_HitGround]];
        _HitGround = FALSE;
}];
    [self addCollisionListener:mActor func:^(Collision* c, NSMutableArray* list, Script* theScript){
Design_11_11_OnGround* self = (Design_11_11_OnGround*) theScript;
        /* @"Don't consider collisions with sensors as hitting the ground" */
        if([Collision collidedWithSensor:c actor:mActor])
{
            return;
}

        /* @"If we only want to detect collions with Tiles, and the Actor hit something other than the tile -- Quit" */
        if((_LimitToTiles && !([Collision collidedWithTile:c actor:mActor])))
{
            return;
}

        /* @"If we are excluding certain Actor Groups - check those here and quit if appropriate" */
        if(([_ExcludedGroups count] > 0))
{
            for(id item in _ExcludedGroups)
{
                if([self sameAs:[NSString stringWithFormat:@"%@", item] two:[NSString stringWithFormat:@"%@", [[Game game] getGroup:c.otherShape->groupID actor:(Actor*)c.otherShape->GetBody()->GetUserData()]]])
{
                    return;
}

}

}

        /* @"If we get here and detect a bottom collision, we're on the ground" */
        for(CollisionPoint* point in [Collision points:c actor:mActor])
{
            if((fabs((point.normal->y * PHYSICS_SCALE)) > 0.1))
{
                _HitGround = TRUE;
                return;
}

}

        if([Collision fromBottom:c actor:mActor])
{
            _HitGround = TRUE;
            return;
}

}];

} 



-(void)forwardMessage:(NSString*)msg
{
	
}

@end