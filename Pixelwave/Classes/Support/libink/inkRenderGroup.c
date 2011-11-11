//
//  inkRenderGroup.c
//  ink
//
//  Created by John Lattin on 11/9/11.
//  Copyright (c) 2011 Spiralstorm Games. All rights reserved.
//

#include "inkRenderGroup.h"

// TODO: Remove this
#include "PXGLUtils.h"

inkRenderGroup* inkRenderGroupCreate(size_t vertexSize, INKenum glDrawMode)
{
	if (vertexSize == 0)
		return NULL;

	inkRenderGroup* renderGroup = malloc(sizeof(inkRenderGroup));

	if (renderGroup != NULL)
	{
		renderGroup->glDrawMode = glDrawMode;
		renderGroup->vertices = inkArrayCreate(vertexSize);

		if (renderGroup->vertices == NULL)
		{
			inkRenderGroupDestroy(renderGroup);
			return NULL;
		}
	}

	return renderGroup;
}

inkRenderGroup* inkRenderGroupCreateWithVertices(inkArray *vertices, INKenum glDrawMode)
{
	inkRenderGroup* renderGroup = malloc(sizeof(inkRenderGroup));

	if (renderGroup != NULL)
	{
		renderGroup->glDrawMode = glDrawMode;
		// TODO: Change this hack
		{
			renderGroup->vertices = malloc(sizeof(inkArray));

			if (renderGroup->vertices == NULL)
			{
				inkRenderGroupDestroy(renderGroup);
				return NULL;
			}

			renderGroup->vertices = memcpy(renderGroup->vertices, vertices, sizeof(inkArray));

			if (renderGroup->vertices == NULL)
			{
				inkRenderGroupDestroy(renderGroup);
				return NULL;
			}

			renderGroup->vertices->elements = malloc(vertices->_byteCount);

			if (renderGroup->vertices->elements == NULL)
			{
				inkRenderGroupDestroy(renderGroup);
				return NULL;
			}

			renderGroup->vertices->elements = memcpy(renderGroup->vertices->elements, vertices->elements, vertices->_byteCount);
		}
	}

	return renderGroup;
}

void inkRenderGroupDestroy(inkRenderGroup *renderGroup)
{
	if (renderGroup)
	{
		inkArrayDestroy(renderGroup->vertices);

		free(renderGroup);
	}
}