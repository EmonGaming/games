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



@interface Design_2_2_AnimationManager : ActorScript 
{
	@public
		NSString* tempHolder;
		
BOOL _PlayingOneTime;

NSString* _CurrentCategory;

NSString* _DefaultRightAnimation;

NSString* _DefaultLeftAnimation;

NSMutableArray* _CategoryHierarchy;

BOOL _CurrentIndex;

BOOL _RequestedIndex;

}
@end

@implementation Design_2_2_AnimationManager

-(void)load
{
	    
    [self addWhenUpdatedListener:nil func:^(NSMutableArray* list, Script* theScript){
Design_2_2_AnimationManager* self = (Design_2_2_AnimationManager*) theScript;
        if(_PlayingOneTime)
{
            if(!([mActor isAnimationPlaying]))
{
                _PlayingOneTime = FALSE;
}

            else
{
                return;
}

}

        if((_CurrentCategory == nil))
{
            if([self asBoolean:[mActor getActorValue:@"Facing Right?"]])
{
                [mActor setAnimation:_DefaultRightAnimation];
}

            else
{
                [mActor setAnimation:_DefaultLeftAnimation];
}

            return;
}

}];

} 

    

/* Params are:__Self __Animation */
- ( void) PlayOnce:(NSArray*)args
{
Actor* __Self = mActor;
NSString* __Animation = (NSString*) [args objectAtIndex:0];
        [mActor setAnimation:__Animation];
        _PlayingOneTime = TRUE;
}
    

/* Params are:__Self __Animation __Category */
- ( void) LoopAnim:(NSArray*)args
{
Actor* __Self = mActor;
NSString* __Animation = (NSString*) [args objectAtIndex:0];

NSString* __Category = (NSString*) [args objectAtIndex:1];
        if(_PlayingOneTime)
{
            return;
}

        if((_CurrentCategory == nil))
{
            
tempHolder = _CurrentCategory;_CurrentCategory = __Category;
[_CurrentCategory retain];
[tempHolder release];
}

        _CurrentIndex = FALSE;
        _RequestedIndex = FALSE;
        for(id item in _CategoryHierarchy)
{
            if([self sameAs:item two:__Category])
{
                _RequestedIndex = TRUE;
}

            if([self sameAs:item two:_CurrentCategory])
{
                _CurrentIndex = TRUE;
}

            if((_CurrentIndex && !(_RequestedIndex)))
{
                return;
}

}

        [mActor setAnimation:__Animation];
        
tempHolder = _CurrentCategory;_CurrentCategory = __Category;
[_CurrentCategory retain];
[tempHolder release];
}
    

/* Params are:__Self */
- ( void) ClearCat:(NSArray*)args
{
Actor* __Self = mActor;
        _CurrentCategory = nil;
}
    

/* Params are:__Self */
- ( NSString*) GetCat:(NSArray*)args
{
Actor* __Self = mActor;
        return _CurrentCategory;
}
    

/* Params are: __CheckCategory */
- ( NSNumber*) CategorySameAs:(NSArray*)args
{
Actor* __Self = mActor;
NSString* __CheckCategory = (NSString*) [args objectAtIndex:0];
        return [NSNumber numberWithBool:[self sameAs:__CheckCategory two:_CurrentCategory]];
}
    

/* Params are: __ChkCat */
- ( void) ClearAnimCat:(NSArray*)args
{
Actor* __Self = mActor;
NSString* __ChkCat = (NSString*) [args objectAtIndex:0];
        if([self sameAs:__ChkCat two:_CurrentCategory])
{
            _CurrentCategory = nil;
}

}


-(void)forwardMessage:(NSString*)msg
{
	
}

@end