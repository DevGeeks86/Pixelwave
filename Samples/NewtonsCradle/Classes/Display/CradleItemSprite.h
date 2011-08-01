//
//  CradleBall.h
//  NewtonsCradle
//
//  Created by Oz Michaeli on 7/31/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "Pixelwave.h"

@class CradleBallSprite;

@interface CradleItemSprite : PXSimpleSprite
{
@private
	CradleBallSprite *ballSprite;
}

- (id) initWithAtlas:(PXTextureAtlas *)atlas ropeLength:(float)ropeLength;

- (void) setSelected:(BOOL)selected;

@end
