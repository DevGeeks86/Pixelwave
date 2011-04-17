//
//  PXUIKitUtils.m
//  Pixelwave
//
//  Created by Oz Michaeli on 4/16/11.
//  Copyright 2011 NA. All rights reserved.
//

#ifndef _PX_CG_UTILS_H_
#define _PX_CG_UTILS_H_

#include "PXCGUtils.h"

#include "PXEngine.h"
#import "PXTextureData.h"

void _PXCGUtils_releaseDataProvider(void *info,
									const void *data,
									size_t size)
{
	free((char *)data);
}

/**
 * @param pixels	An array of colors, will be taken full control of by this
 *					function. The data within the array must be in RGBA8888
 *					format.
 * @param w
 * @param h
 * @param bytesPerPixel
 *
 * return a CGImageRef which the user should release.
 */
// TODO Later: Support other pixel formats (RGB, LA88, A8, etc.)
// Right now RGBA8888 is hard-coded in.
CGImageRef PXCGUtilsCreateCGImage(void *pixels, int w, int h, CGAffineTransform *transform)
{
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	int bytesPerPixel = (bitsPerPixel >> 3); // (x >> 3) == (x / 8)
	int bytesPerRow, pixelsArrSize;
	
	bytesPerRow = bytesPerPixel * w;
	pixelsArrSize = bytesPerRow * h;
	
	// Create an image to hold the buffer data
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, pixels, pixelsArrSize,
															  _PXCGUtils_releaseDataProvider);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	// Set up the properties of the image ref
	// TODO: Handle the case where the source texture has premultiplied alpha (if it was loaded by cocoa)
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaLast;// kCGImageAlphaPremultipliedLast;
	BOOL shouldInterpolate = NO;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	CGImageRef imageRef = CGImageCreate(w, h,
										bitsPerComponent, bitsPerPixel, bytesPerRow,
										colorSpace, bitmapInfo,
										provider,
										NULL, // image decode array... idk
										shouldInterpolate, renderingIntent);
	
	// Don't need a hold on provider anymore (the imageRef holds on to it)
	CGDataProviderRelease(provider);
	
	// If we need to transform the image (such as when taking a screenshot)
	if(transform != NULL){
		// Summary:
		// Create a new context and draw the original image, transformed,
		// onto it.
		
		// TODO: Test this on the device. If there issues see
		// http://stackoverflow.com/questions/2619224/cgbitmapcontextcreate-on-the-iphone-ipad
		
		// TODO: Figure out the new size of the image given the transformation
		// matrix
		int contextWidth = w;
		int contextHeight = h;
		
		// Create a new context
		
		bytesPerRow = bytesPerPixel * contextWidth;
		pixelsArrSize = bytesPerRow * contextHeight;
		
		uint32_t *contextPixels = malloc(pixelsArrSize);
		CGContextRef context = CGBitmapContextCreate(contextPixels,
													 contextWidth, contextHeight,
													 bitsPerComponent,
													 bytesPerRow,
													 colorSpace,
													 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
		
		if(context)
		{
			CGRect fillRect = CGRectMake(0, 0, contextWidth, contextHeight);
			
			// For testing, the BG can be painted
			//if(YES){
			//	CGContextSetRGBFillColor(context, 1.0f, 1.0f, 0.5f, 1.0f);
			//	CGContextFillRect(context, fillRect);
			//}
			
			// When not testing, clear the pixels
			CGContextClearRect(context, fillRect);
			
			// Apply the transformation
			CGContextConcatCTM(context, *transform);			
			
			// Draw the original image onto it
			CGRect imageRect = CGRectMake(0, 0, w, h);
			CGContextDrawImage(context, imageRect, imageRef);
			
			// Get rid of the original image
			CGImageRelease(imageRef);
			
			// Turn the context into the output image
			imageRef = CGBitmapContextCreateImage(context);
			
			// Get rid of the context
			CGContextRelease(context);
			free(contextPixels);
		}
	}
	
	// Release the color space
	CGColorSpaceRelease(colorSpace);
	
	return imageRef;
}

CGImageRef PXCGUtilsCreateCGImageFromTextureData(PXTextureData *textureData)
{
	// Parameter check
	
	PXTextureDataPixelFormat pixelFormat = textureData.pixelFormat;
	
	// Evidently PVR can't be converted to RGBA8888 reliably...
	if(pixelFormat == PXTextureDataPixelFormat_RGB_PVRTC2 ||
	   pixelFormat == PXTextureDataPixelFormat_RGB_PVRTC4 ||
	   pixelFormat == PXTextureDataPixelFormat_RGBA_PVRTC2 ||
	   pixelFormat == PXTextureDataPixelFormat_RGBA_PVRTC4)
	{
		NSLog(@"Warning: PXTextureData in compressed PVR pixel format cannot be converted to a CGImage");
		return nil;
	}
	
	////////////////////////////////////////
	// Read the data from the TextureData //
	////////////////////////////////////////
	
	int w = textureData.width;
	int h = textureData.height;
	int arrLen = w * h * 4;
	
	// These get free'd when CGImage is freed
	void *pixels = malloc(arrLen);
	
	// Read the data into the pixels
	PXTextureDataReadPixels(textureData, 0, 0, w, h, pixels);
	
	/////////////////////////////////////
	// Write the pixels into the image //
	/////////////////////////////////////
	
	CGImageRef imageRef = PXCGUtilsCreateCGImage(pixels, w, h, NULL);
	
	return imageRef;
}

// A portrait screenshot of the screen
CGImageRef PXCGUtilsCreateCGImageFromScreenBuffer()
{
	/////////////////////////////////////
	// Grab the pixels from the screen //
	/////////////////////////////////////
	
	CGSize size = PXEngineGetScreenBufferSize();
	int w = size.width;
	int h = size.height;
	int arrLen = w * h * 4;
	
	// These get free'd later by the CGImage (it takes control of the arr)
	void *pixels = malloc(arrLen);
	
	PXEngineGetScreenBufferPixels(0, 0, w, h, pixels);
	
	////////////////////////////////////
	// Draw the pixels to the CGImage //
	////////////////////////////////////
	
	// This transform flips the image upside-down
	CGAffineTransform transform = CGAffineTransformMake(1.0f,	0.0f,
														0.0f,	-1.0f,
														0,	h);
		
	CGImageRef imageRef = PXCGUtilsCreateCGImage(pixels, w, h, &transform);
	
	return imageRef;
}

#endif