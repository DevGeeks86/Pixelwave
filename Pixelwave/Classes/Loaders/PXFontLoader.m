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

#import "PXFontLoader.h"

#import "PXDebug.h"

#import "PXFont.h"
#import "PXFontParser.h"
#import "PXFontOptions.h"

/// @cond DX_IGNORE
@interface PXFontLoader(Private)
- (id) initWithContentsOfFile:(NSString *)path
						orURL:(NSURL *)url
					  options:(PXFontOptions *)options;
@end
/// @endcond

/**
 *	@ingroup Loaders
 *
 *	A PXFontLoader loads font information and creats PXFont objects from the
 *	loaded information.
 *
 *	If the font does not exist, or can not load, then nil is returned instead.
 *
 *	The following font formats are supported natively:
 *	- .fnt (AngelCode Texture Font Format)
 *	- .ttf
 *	- .otf
 *	- .pfm
 *	- .afm
 *	- .inf
 *	- .cff
 *	- .bdf
 *	- .pfr
 *
 *	@b Example:
 *	@code
 *	PXFontLoader *fontLoader = [[PXFontLoader alloc] initWithContentsOfFile:@"font.fnt" options:nil];
 *	PXFont *font = [fontLoader newFont];
 *	[fontLoader release];
 *	@endcode
 */
@implementation PXFontLoader

/**
 *	Creates a new PXFontLoader instance containing the loaded font data returns
 *	<code>nil</code> if the file could not be found, or the format isn't
 *	supported.
 *
 *	@param path
 *		The path of the font file to load. The file path may be absolute or
 *		relative to	the application bundle.
 *
 *	@b Example:
 *	@code
 *	PXFontLoader *fontLoader = [[PXFontLoader alloc] initWithContentsOfFile:@"font.fnt"];
 *	PXFont *font = [fontLoader newFont];
 *
 *	[PXFont registerFont:font withName:@"font"];
 *	// The font is now registered as the name "font", so any time you want to
 *	// reference it, you can use "font.
 *
 *	[font release];
 *	[fontLoader release];
 *	@endcode
 */
- (id) initWithContentsOfFile:(NSString *)path
{
	return [self initWithContentsOfFile:path orURL:nil options:nil];
}
/**
 *	Creates a new PXFontLoader instance containing the loaded font data returns
 *	<code>nil</code> if the file could not be found, or the format isn't
 *	supported.
 *
 *	@param path
 *		The path of the font file to load. The file path may be absolute or
 *		relative to	the application bundle.
 *	@param options
 *		The options defining what form of font you want. Ex. If a
 *		<code>PXTextureFontOption</code> is given, then each glyph of the font
 *		would be mapped to a texture. If the font file you are loading already
 *		has this information, it is also loaded.
 *
 *	@b Example:
 *	@code
 *	PXFontLoader *fontLoader = [[PXFontLoader alloc] initWithContentsOfFile:@"font.fnt" options:nil];
 *	PXFont *font = [fontLoader newFont];
 *
 *	[PXFont registerFont:font withName:@"font"];
 *	// The font is now registered as the name "font", so any time you want to
 *	// reference it, you can use "font.
 *
 *	[font release];
 *	[fontLoader release];
 *	@endcode
 */
- (id) initWithContentsOfFile:(NSString *)path options:(PXFontOptions *)_options
{
	return [self initWithContentsOfFile:path orURL:nil options:_options];
}

/**
 *	Creates a new PXFontLoader instance containing the loaded font data returns
 *	<code>nil</code> if the file could not be found, or the format isn't
 *	supported.
 *
 *	@param url
 *		The url of the font to load.
 *
 *	@b Example:
 *	@code
 *	PXFontLoader *fontLoader = [[PXFontLoader alloc] initWithContentsOfURL:[NSURL URLWithString:@"www.myWebsite.com/font.fnt"]];
 *	PXFont *font = [fontLoader newFont];
 *
 *	[PXFont registerFont:font withName:@"font"];
 *	// The font is now registered as the name "font", so any time you want to
 *	// reference it, you can use "font.
 *
 *	[font release];
 *	[fontLoader release];
 *	@endcode
 */
- (id) initWithContentsOfURL:(NSURL *)url
{
	return [self initWithContentsOfFile:nil orURL:url options:nil];
}
/**
 *	Creates a new PXFontLoader instance containing the loaded font data returns
 *	<code>nil</code> if the file could not be found, or the format isn't
 *	supported.
 *
 *	@param url
 *		The url of the font to load.
 *	@param options
 *		The options defining what form of font you want. Ex. If a
 *		<code>PXTextureFontOption</code> is given, then each glyph of the font
 *		would be mapped to a texture. If the font file you are loading already
 *		has this information, it is also loaded.
 *
 *	@b Example:
 *	@code
 *	PXFontLoader *fontLoader = [[PXFontLoader alloc] initWithContentsOfURL:[NSURL URLWithString:@"www.myWebsite.com/font.fnt"] options:nil];
 *	PXFont *font = [fontLoader newFont];
 *
 *	[PXFont registerFont:font withName:@"font"];
 *	// The font is now registered as the name "font", so any time you want to
 *	// reference it, you can use "font.
 *
 *	[font release];
 *	[fontLoader release];
 *	@endcode
 */

// TODO: Test this method. I have a feeling it won't work with .fnt files
// since they always try to load their companion images from the hard-drive.
- (id) initWithContentsOfURL:(NSURL *)url options:(PXFontOptions *)_options
{
	return [self initWithContentsOfFile:nil orURL:url options:_options];
}

- (id) initWithContentsOfFile:(NSString *)path
						orURL:(NSURL *)url
					  options:(PXFontOptions *)_options
{
	self = [super _initWithContentsOfFile:path orURL:url];
	if (self)
	{
		[self _load];

		fontParser = nil;

		self.options = _options;
	}

	return self;
}

- (void) dealloc
{
	[fontParser release];
	fontParser = nil;

	[super dealloc];
}

- (PXFontOptions *)options
{
	return fontParser.options;
}
- (void) setOptions:(PXFontOptions *)_options
{
	[_options retain];

	// Release the parser, we have new options!
	[fontParser release];
	fontParser = nil;

	// Make a parser with the given options.
	fontParser = [[PXFontParser alloc] initWithData:data
											options:_options
											 origin:origin];

	[_options release];
}

/**
 *	Creates a new PXFont object containing all information needed to view the
 *	font.
 *
 *	@return
 *		The new PXFont object.
 */
- (PXFont *)newFont
{
	if (!fontParser)
	{
		[self _log:@"Could not create a font."];

		return nil;
	}

	return [fontParser newFont];
}

/**
 *	Creates a PXFontLoader instance containing the loaded font data returns
 *	<code>nil</code> if the file could not be found, or the format isn't
 *	supported.
 *
 *	@param path
 *		The path of the font file to load. The file path may be absolute or
 *		relative to	the application bundle.
 *	@param options
 *		The options defining what form of font you want. Ex. If a
 *		<code>PXTextureFontOption</code> is given, then each glyph of the font
 *		would be mapped to a texture. If the font file you are loading already
 *		has this information, it is also loaded.
 *
 *	@return
 *		The resulting, <code>autoreleased</code>, PXFontLoader object.
 *
 *	@b Example:
 *	@code
 *	PXFontLoader *fontLoader = [PXFontLoader fontLoaderWithContentsOfFile:@"font.fnt" options:nil];
 *	PXFont *font = [fontLoader newFont];
 *
 *	[PXFont registerFont:font withName:@"font"];
 *	// The font is now registered as the name "font", so any time you want to
 *	// reference it, you can use "font.
 *
 *	[font release];
 *	@endcode
 */
+ (PXFontLoader *)fontLoaderWithContentsOfFile:(NSString *)path options:(PXFontOptions *)options
{
	return [[[PXFontLoader alloc] initWithContentsOfFile:path options:options] autorelease];
}
/**
 *	Creates a PXFontLoader instance containing the loaded font data returns
 *	<code>nil</code> if the file could not be found, or the format isn't
 *	supported.
 *
 *	@param url
 *		The url of the font to load.
 *	@param options
 *		The options defining what form of font you want. Ex. If a
 *		<code>PXTextureFontOption</code> is given, then each glyph of the font
 *		would be mapped to a texture. If the font file you are loading already
 *		has this information, it is also loaded.
 *
 *	@return
 *		The resulting, <code>autoreleased</code>, PXFontLoader object.
 *
 *	@b Example:
 *	@code
 *	PXFontLoader *fontLoader = [PXFontLoader fontLoaderWithContentsOfURL:[NSURL URLWithString:@"www.myWebsite.com/font.fnt"] options:nil];
 *	PXFont *font = [fontLoader newFont];
 *
 *	[PXFont registerFont:font withName:@"font"];
 *	// The font is now registered as the name "font", so any time you want to
 *	// reference it, you can use "font.
 *
 *	[font release];
 *	@endcode
 */
+ (PXFontLoader *)fontLoaderWithContentsOfURL:(NSURL *)url options:(PXFontOptions *)options
{
	return [[[PXFontLoader alloc] initWithContentsOfURL:url options:options] autorelease];
}

@end
