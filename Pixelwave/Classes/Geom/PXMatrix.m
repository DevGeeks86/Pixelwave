/*
 *  _____                       ___                                            
 * /\  _ `\  __                /\_ \                                           
 * \ \ \L\ \/\_\   __  _    ___\//\ \    __  __  __    ___     __  __    ___   
 *  \ \  __/\/\ \ /\ \/ \  / __`\\ \ \  /\ \/\ \/\ \  / __`\  /\ \/\ \  / __`\ 
 *   \ \ \/  \ \ \\/>  </ /\  __/ \_\ \_\ \ \_/ \_/ \/\ \L\ \_\ \ \_/ |/\  __/ 
 *    \ \_\   \ \_\/\_/\_\\ \____\/\____\\ \___^___ /\ \__/|\_\\ \___/ \ \____\
 *     \/_/    \/_/\//\/_/ \/____/\/____/ \/__//__ /  \/__/\/_/ \/__/   \/____/
 *       
 *           www.pixelwave.org + www.spiralstormgames.com
 *                            ~;   
 *                           ,/|\.           
 *                         ,/  |\ \.                 Core Team: Oz Michaeli
 *                       ,/    | |  \                           John Lattin
 *                     ,/      | |   |
 *                   ,/        |/    |
 *                 ./__________|----'  .
 *            ,(   ___.....-,~-''-----/   ,(            ,~            ,(        
 * _.-~-.,.-'`  `_.\,.',.-'`  )_.-~-./.-'`  `_._,.',.-'`  )_.-~-.,.-'`  `_._._,.
 * 
 * Copyright (c) 2011 Spiralstorm Games http://www.spiralstormgames.com
 * 
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * 
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

#import "PXMatrix.h"
#import "PXPoint.h"
#import "PXMathUtils.h"

/**
 *	@ingroup Geom
 *
 *	A PXMatrix object that represents a two-dimensional transformation matrix.
 *
 *	The following code creates an identity matrix:
 *	@code
 *	PXMatrix *matrix = [PXMatrix new];
 *	@endcode
 *
 *	The following code creates a matrix that has been rotated 30 degrees
 *	(PI/6.0f radians) and translated (-4.0f, 2.5f):
 *	@code
 *	PXMatrix *matrix = [[PXMatrix alloc] initWithA:0.866025f andB:0.5f andC:0.5f andD:0.866025f andTX:-4.0f andTY:2.5f];
 *	@endcode
 *
 *	Likewise the following code creates a matrix that has been rotated 30
 *	degrees (PI/6.0f radians) and translated (-4.0f, 2.5f):
 *	@code
 *	PXMatrix *matrix = [PXMatrix new];
 *	[matrix rotate:M_PI/6.0f];
 *	[matrix translateX:-4.0f andY:2.5f];
 *	@endcode
 */
@implementation PXMatrix

@synthesize a, b, c, d, tx, ty;

- (id) init
{
	return [self initWithA:1.0f andB:0.0f andC:0.0f andD:1.0f andTX:0.0f andTY:0.0f];
}

/**
 *	Creates a new matrix with values of (a, b, c, d, tx, ty).
 *
 *	@param a
 *		The value that affects the positioning of pixels along the x-axis when
 *		scaling or rotating.
 *	@param b
 *		The value that affects the positioning of pixels along the y-axis when
 *		skewing or rotating.
 *	@param c
 *		The value that affects the positioning of pixels along the x-axis when
 *		skewing or rotating.
 *	@param d
 *		The value that affects the positioning of pixels along the y-axis when
 *		scaling or rotating.
 *	@param tx
 *		The value that affects the positioning of pixels along the x-axis when
 *		translating.
 *	@param ty
 *		The value that affects the positioning of pixels along the y-axis when
 *		translating.
 *
 *	@b Example:
 *	@code
 *	PXMatrix *matrix = [[PXMatrix alloc] initWithA:0.866025f andB:0.5f andC:0.5f andD:0.866025f andTX:-4.0f andTY:2.5f];
 *	// matrix will be (a=0.866025f, b=0.5f, c=0.5f, d=0.866025f, tx=-4.0f, ty=2.5f)
 *	@endcode
 */
- (id) initWithA:(float)_a andB:(float)_b andC:(float)_c andD:(float)_d andTX:(float)_tx andTY:(float)_ty
{
	self = [super init];
	if (self)
	{
		[self setA:_a andB:_b andC:_c andD:_d andTX:_tx andTY:_ty];
	}

	return self;
}

#pragma mark NSObject overrides

- (id) copyWithZone:(NSZone *)zone
{
	return [[[self class] allocWithZone:zone] initWithA:a andB:b andC:c andD:d andTX:tx andTY:ty];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"(a=%f, b=%f, c=%f, d=%f, tx=%f, ty=%f)", a, b, c, d, tx, ty];
}

#pragma mark Pooled Reset

- (void) reset
{
	a  = 1.0f;
	b  = 0.0f;
	c  = 0.0f;
	d  = 1.0f;
	tx = 0.0f;
	ty = 0.0f;
}

/**
 *	Sets the matrix values to (a, b, c, d, tx, ty).
 *
 *	@param a
 *		The value that affects the positioning of pixels along the x-axis when
 *		scaling or rotating.
 *	@param b
 *		The value that affects the positioning of pixels along the y-axis when
 *		skewing or rotating.
 *	@param c
 *		The value that affects the positioning of pixels along the x-axis when
 *		skewing or rotating.
 *	@param d
 *		The value that affects the positioning of pixels along the y-axis when
 *		scaling or rotating.
 *	@param tx
 *		The value that affects the positioning of pixels along the x-axis when
 *		translating.
 *	@param ty
 *		The value that affects the positioning of pixels along the y-axis when
 *		translating.
 *
 *	@b Example:
 *	@code
 *	PXMatrix *matrix = [[PXMatrix alloc] init];
 *	[matrix setA:0.866025f andB:0.5f andC:0.5f andD:0.866025f andTX:-4.0f andTY:2.5f];
 *	// matrix will be (a=0.866025f, b=0.5f, c=0.5f, d=0.866025f, tx=-4.0f, ty=2.5f)
 *	@endcode
 */
- (void) setA:(float)_a andB:(float)_b andC:(float)_c andD:(float)_d andTX:(float)_tx andTY:(float)_ty
{
	a  = _a;
	b  = _b;
	c  = _c;
	d  = _d;
	tx = _tx;
	ty = _ty;
}

// A*B = B.concat(A)
/**
 *	Concatenates the specified matrix with this matrix, this is the same as
 *	multiplying the specified matrix with this matrix.
 *
 *	@param m
 *		The matrix to be concatenated.
 *
 *	@b Example:
 *	@code
 *	PXMatrix *matrix1 = [[PXMatrix alloc] initWithA:0.866025f andB:0.5f andC:0.5f andD:0.866025f andTX:-4.0f andTY:2.5f];
 *	// matrix1 will be (a=0.866025f, b=0.5f, c=0.5f, d=0.866025f, tx=-4.0f, ty=2.5f)
 *	PXMatrix *matrix2 = [[PXMatrix alloc] initWithA:0.0f andB:1.0f andC:1.0f andD:0.0f andTX:-1.0f andTY:1.0f];
 *	// matrix2 will be (a=0.0f, b=1.0f, c=1.0f, d=0.0f, tx=1.0f, ty=3.0f)
 *	[matrix1 concat:matrix2];
 *	// matrix1 will be (a=0.5f, b=0.866025f, c=0.866025f, d=0.5f, tx=-4.366030f, ty=2.866030f)
 *	@endcode
 */
- (void) concat:(PXMatrix *)m
{
	float a2 = a;
	float b2 = b;
	float c2 = c;
	float d2 = d;
	float tx2 = tx;
	float ty2 = ty;

	float a1 = m->a;
	float b1 = m->b;
	float c1 = m->c;
	float d1 = m->d;
	float tx1 = m->tx;
	float ty1 = m->ty;

	a = a1 * a2 + b1 * c2;      b = a1 * b2 + b1 * d2;
	c = c1 * a2 + d1 * c2;      d = c1 * b2 + d1 * d2;
	tx = tx1 * a2 + ty1 * c2 + tx2;
	ty = tx1 * b2 + ty1 * d2 + ty2;
}

/**
 *	Sets the values of the matrix to (a=1, b=0, c=0, d=1, tx=0, ty=0).
 *
 *	@b Example:
 *	@code
 *	PXMatrix *matrix = [[PXMatrix alloc] initWithA:0.866025f andB:0.5f andC:0.5f andD:0.866025f andTX:-4.0f andTY:2.5f];
 *	// matrix will be (a=0.866025f, b=0.5f, c=0.5f, d=0.866025f, tx=-4.0f, ty=2.5f)
 *	[matrix identity];
 *	// matrix will be (a=1.0f, b=0.0f, c=0.0f, d=1.0f, tx=0.0f, ty=0.0f)
 *	@endcode
 */
- (void) identity
{
	a = 1;  c = 0;  tx = 0;
	b = 0;  d = 1;  ty = 0;
}

/**
 *	Inverts the matrix.  If the matrix is not invertible then the matrix is set
 *	back to identity.
 *
 *	@b Example:
 *	@code
 *	PXMatrix *matrix = [[PXMatrix alloc] initWithA:1.0f andB:1.0f andC:0.5f andD:1.0f andTX:0.0f andTY:0.0f];
 *	// matrix will be (a=1.0f, b=1.0f, c=0.5f, d=1.0f, tx=0.0f, ty=0.0f)
 *	[matrix invert];
 *	// matrix will be (a=2.0f, b=-2.0f, c=-1.0f, d=2.0f, tx=0.0f, ty=0.0f)
 *	@endcode
 */
- (void) invert
{
	float oldA = a;
	float oldB = b;
	float oldC = c;
	float oldD = d;
	float oldTX = tx;
	float oldTY = ty;

	float denom = (oldA * oldD - oldB * oldC);
	if (PXMathIsZero(denom))
	{
		[self identity];
		return;
	}
	float invBottom = 1.0f / denom;

	a  =  oldD * invBottom;
	b  = -oldB * invBottom;
	c  = -oldC * invBottom;
	d  =  oldA * invBottom;
	tx = (oldC * oldTY - oldD * oldTX) * invBottom;
	ty = -(oldA * oldTY - oldB * oldTX) * invBottom;
}

/**
 *	Rotates the matrix.
 *
 *	@param angle
 *		Angle of rotation in radians.
 *
 *	@b Example:
 *	@code
 *	PXMatrix *matrix = [PXMatrix new];
 *	// matrix will be (a=1.0f, b=0.0f, c=0.0f, d=1.0f, tx=0.0f, ty=0.0f)
 *	[matrix rotate:M_PI/6.0f]; //30 degrees
 *	// matrix will be (a=0.866025f, b=0.5f, c=0.5f, d=0.866025f, tx=0.0f, ty=0.0f)
 *	@endcode
 */
- (void) rotate:(float)angle
{
	float sinVal = sinf(angle);
	float cosVal = cosf(angle);

	float oldA = a;
	float oldB = b;
	float oldC = c;
	float oldD = d;
	float oldTX = tx;
	float oldTY = ty;

	a = oldA * cosVal - oldB * sinVal;
	b = oldA * sinVal + oldB * cosVal;
	c = oldC * cosVal - oldD * sinVal;
	d = oldC * sinVal + oldD * cosVal;
	tx = oldTX * cosVal - oldTY * sinVal;
	ty = oldTX * sinVal + oldTY * cosVal;
}

/**
 *	Scales the matrix.
 *
 *	@param sx
 *		The horizontal scaling factor.
 *	@param sy
 *		The vertical scaling factor.
 *
 *	@b Example:
 *	@code
 *	PXMatrix *matrix = [[PXMatrix alloc] initWithA:0.866025f andB:0.5f andC:0.5f andD:0.866025f andTX:-4.0f andTY:2.5f];
 *	// matrix will be (a=0.866025f, b=0.5f, c=0.5f, d=0.866025f, tx=-4.0f, ty=2.5f)
 *	[matrix scaleX:0.5f andY:0.5f];
 *	// matrix will be (a=0.433012f, b=0.5f, c=0.5f, d=0.433012f, tx=-2.0f, ty=1.0f)
 *	@endcode
 */
- (void) scaleX:(float)sx andY:(float)sy
{
	a *= sx;
	d *= sy;
	tx *= sx;
	ty *= sy;
}

/**
 *	Translates the matrix.
 *
 *	@param dx
 *		The horizontal translation.
 *	@param dy
 *		The vertical translation.
 *
 *	@b Example:
 *	@code
 *	PXMatrix *matrix = [[PXMatrix alloc] initWithA:0.866025f andB:0.5f andC:0.5f andD:0.866025f andTX:-4.0f andTY:2.5f];
 *	// matrix will be (a=0.866025f, b=0.5f, c=0.5f, d=0.866025f, tx=-4.0f, ty=2.5f)
 *	[matrix translateX:1.0f andY:-0.5f];
 *	// matrix will be (a=0.866025f, b=0.5f, c=0.5f, d=0.866025f, tx=-3.0f, ty=2.0f)
 *	@endcode
 */
- (void) translateX:(float)dx andY:(float)dy
{
	tx += dx;
	ty += dy;
}

/**
 *	Using the create box method is the same as if you were to call identity,
 *	rotate, scale and translate in succession.
 *
 *	@param scaleX
 *		The horizontal scale factor.
 *	@param scaleY
 *		The vertical scale factor.
 *	@param rotation
 *		The angle of rotation in radians.
 *	@param tx
 *		The horizontal translation. 
 *	@param ty
 *		The vertical translation.
 *
 *	@b Example:
 *	@code
 *	PXMatrix *matrix = [[PXMatrix alloc] initWithA:0.866025f andB:0.5f andC:0.5f andD:0.866025f andTX:-4.0f andTY:2.5f];
 *	// matrix will be (a=0.866025f, b=0.5f, c=0.5f, d=0.866025f, tx=-4.0f, ty=2.5f)
 *	[matrix createBoxWithScaleX:0.5f andScaleY:0.5f rotation:M_PI/6.0f tx:-3.0f ty:2.0f];
 *	// matrix will be (a=0.433013f, b=0.5f, c=0.5f, d=0.433013f, tx=-3.0f, ty=2.0f)
 *	@endcode
 */
- (void) createBoxWithScaleX:(float)_scaleX andScaleY:(float)_scaleY rotation:(float)_rotation tx:(float)_tx ty:(float)_ty
{
	[self identity];
	[self rotate:_rotation];
	[self scaleX:_scaleX andY:_scaleY];
	[self translateX:_tx andY:_ty];
}

/**
 *	Returns a point transformed by this matrix.
 *
 *	@param point
 *		The point for transformation.
 *
 *	@return
 *		The point after transformation.
 *
 *	@b Example:
 *	@code
 *	PXMatrix *matrix = [[PXMatrix alloc] initWithA:0.0f andB:1.0f andC:0.0f andD:1.0f andTX:-4.0f andTY:2.5f];
 *	// matrix will be (a=0.866025f, b=0.5f, c=0.5f, d=0.866025f, tx=-4.0f, ty=2.5f)
 *	PXPoint *point = [[PXPoint alloc] initWithX:1.0f andY:1.0f];
 *	PXPoint *transformedPoint = [matrix transformPoint:point];
 *	// transformedPoint will be (-4.0f, 4.5f)
 *	@endcode
 */
- (PXPoint *)transformPoint:(PXPoint *)point
{
	float x = point.x * a + point.y * c + tx;
	float y = point.x * b + point.y * d + ty;

	return [[[PXPoint alloc] initWithX:x andY:y] autorelease];
}

/**
 *	Returns a point transformed by this matrix, ignoring the tx and ty
 *	parameters.
 *
 *	@param point
 *		The point for transformation.
 *
 *	@return
 *		The point after transformation.
 *
 *	@b Example:
 *	@code
 *	PXMatrix *matrix = [[PXMatrix alloc] initWithA:0.0f andB:1.0f andC:0.0f andD:1.0f andTX:-4.0f andTY:2.5f];
 *	// matrix will be (a=0.866025f, b=0.5f, c=0.5f, d=0.866025f, tx=-4.0f, ty=2.5f)
 *	PXPoint *point = [[PXPoint alloc] initWithX:1.0f andY:1.0f];
 *	PXPoint *transformedPoint = [matrix deltaTransformPoint:point];
 *	// transformedPoint will be (0.0f, 2.0f)
 *	@endcode
 */
- (PXPoint *)deltaTransformPoint:(PXPoint *)point
{
	float x = point.x * a + point.y * c;
	float y = point.x * b + point.y * d;

	return [[[PXPoint alloc] initWithX:x andY:y] autorelease];
}

/**
 *	Creates a matrix with values of (a, b, c, d, tx, ty).
 *
 *	@param a
 *		The value that affects the positioning of pixels along the x-axis when
 *		scaling or rotating.
 *	@param b
 *		The value that affects the positioning of pixels along the y-axis when
 *		skewing or rotating.
 *	@param c
 *		The value that affects the positioning of pixels along the x-axis when
 *		skewing or rotating.
 *	@param d
 *		The value that affects the positioning of pixels along the y-axis when
 *		scaling or rotating.
 *	@param tx
 *		The value that affects the positioning of pixels along the x-axis when
 *		translating.
 *	@param ty
 *		The value that affects the positioning of pixels along the y-axis when
 *		translating.
 *
 *	@return
 *		The created matrix.
 *
 *	@b Example:
 *	@code
 *	PXMatrix *matrix = [PXMatrix matrixWithA:0.866025f andB:0.5f andC:0.5f andD:0.866025f andTX:-4.0f andTY:2.5f];
 *	// matrix will be (a=0.866025f, b=0.5f, c=0.5f, d=0.866025f, tx=-4.0f, ty=2.5f)
 *	@endcode
 */
+ (PXMatrix *)matrixWithA:(float)a andB:(float)b andC:(float)c andD:(float)d andTX:(float)tx andTY:(float)ty
{
	return [[[PXMatrix alloc] initWithA:a andB:b andC:c andD:d andTX:tx andTY:ty] autorelease];
}

+ (PXMatrix *)identityMatrix
{
	return [[[PXMatrix alloc] init] autorelease];
}

@end
