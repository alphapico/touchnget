//
//  VSGLView.m
//  VideoStream
//
//  Created by Tarum Nadus on 11/16/12.
//  Copyright (c) 2012 MobileTR. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "VSGLView.h"
#import "VSVideoDecoder.h"
#import "VSDecodeManager.h"
#import "VSVideoFrame.h"


@interface VSGLView() {
    EAGLContext *_context;
	GLuint _renderbuffer;
	GLuint _framebuffer;
	GLuint _texture;
    GLfloat _points[8];
	GLfloat _texturePoints[8];
    GLint _backingWidth;
	GLint _backingHeight;

    BOOL _glResetting;

    VSDecodeManager *_decodeManager;
}

@end

@implementation VSGLView

+ (Class)layerClass {
	return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];

        self.contentMode = UIViewContentModeScaleAspectFit;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;

    }
    return self;
}


- (int)initGLWithDecodeManager:(VSDecodeManager *)decoder {

    _decodeManager = decoder;
    _glResetting = NO;

    CAEAGLLayer *layer = (CAEAGLLayer *)self.layer;
    layer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGB565, kEAGLDrawablePropertyColorFormat, nil];
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];

    if (![EAGLContext setCurrentContext:_context]) {
        VSLog(kVSLogLevelOpenGL, @"Error: Failed to set current openGL context");
        return -1;
    }

    int err = 0;

    glGenRenderbuffersOES(1, &_renderbuffer);
    err = glGetError();
    if (err) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not generate render buffer: %d", err);
        return -1;
    }

    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _renderbuffer);
    err = glGetError();
    if (err) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not bind render buffer: %d", err);
        glDeleteRenderbuffersOES(1, &_renderbuffer);
        return -1;
    }

    if (![_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer]) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not bind layer to render buffer");
        glDeleteRenderbuffersOES(1, &_renderbuffer);
        return -1;
    }

    glGenFramebuffersOES(1, &_framebuffer);
    err = glGetError();
    if (err) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not generate frame buffer: %d", err);
        glDeleteRenderbuffersOES(1, &_renderbuffer);
        return -1;
    }

    glBindFramebufferOES(GL_FRAMEBUFFER_OES, _framebuffer);
    err = glGetError();
    if (err) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not bind frame buffer: %d", err);
        glDeleteFramebuffersOES(1, &_framebuffer);
        glDeleteRenderbuffersOES(1, &_renderbuffer);
        return -1;
    }

    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _renderbuffer);
    err = glGetError();
    if (err) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not bind render buffer to frame buffer: %d", err);
        glDeleteFramebuffersOES(1, &_framebuffer);
        glDeleteRenderbuffersOES(1, &_renderbuffer);
        return -1;
    }

    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_backingHeight);

    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		VSLog(kVSLogLevelOpenGL, @"Error: Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return -1;
    }

    glViewport(0, 0, _backingWidth, _backingHeight);
    err = glGetError();
    if (err) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not set viewport: %d", err);
        glDeleteFramebuffersOES(1, &_framebuffer);
        glDeleteRenderbuffersOES(1, &_renderbuffer);
        return -1;
    }

    glScissor(0, 0, _backingWidth, _backingHeight);
    err = glGetError();
    if (err) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not set scissors: %d", err);
        glDeleteFramebuffersOES(1, &_framebuffer);
        glDeleteRenderbuffersOES(1, &_renderbuffer);
        return -1;
    }

    glGenTextures(1, &_texture);
    err = glGetError();
    if (err) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not generate texture: %d", err);
        glDeleteFramebuffersOES(1, &_framebuffer);
        glDeleteRenderbuffersOES(1, &_renderbuffer);
        return -1;
    }

    glBindTexture(GL_TEXTURE_2D, _texture);
    err = glGetError();
    if (err) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not bind texture: %d", err);
        glDeleteTextures(1, &_texture);
        glDeleteFramebuffersOES(1, &_framebuffer);
        glDeleteRenderbuffersOES(1, &_renderbuffer);
        return -1;
    }

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    err = glGetError();
    if (err) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not set texture minimization filter: %d", err);
        glDeleteTextures(1, &_texture);
        glDeleteFramebuffersOES(1, &_framebuffer);
        glDeleteRenderbuffersOES(1, &_renderbuffer);
        return -1;
    }

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    err = glGetError();
    if (err) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not set texture magnification filter: %d", err);
        glDeleteTextures(1, &_texture);
        glDeleteFramebuffersOES(1, &_framebuffer);
        glDeleteRenderbuffersOES(1, &_renderbuffer);
        return -1;
    }

    glDisable(GL_DITHER);
    err = glGetError();
    if (err) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not enable dither support: %d", err);
        glDeleteTextures(1, &_texture);
        glDeleteFramebuffersOES(1, &_framebuffer);
        glDeleteRenderbuffersOES(1, &_renderbuffer);
        return -1;
    }

    glMatrixMode(GL_PROJECTION);
    err = glGetError();
    if (err) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not enable projection matrix mode: %d", err);
        glDeleteTextures(1, &_texture);
        glDeleteFramebuffersOES(1, &_framebuffer);
        glDeleteRenderbuffersOES(1, &_renderbuffer);
        return -1;
    }

    glLoadIdentity();
    glOrthof(-1.0f, 1.0f, -1.0f, 1.0f, -1.0f, 1.0f);
    err = glGetError();
    if (err) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not set view matrix: %d", err);
        glDeleteTextures(1, &_texture);
        glDeleteFramebuffersOES(1, &_framebuffer);
        glDeleteRenderbuffersOES(1, &_renderbuffer);
        return -1;
    }

    glMatrixMode(GL_MODELVIEW);
    err = glGetError();
    if (err) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not set model view matrix mode: %d", err);
        glDeleteTextures(1, &_texture);
        glDeleteFramebuffersOES(1, &_framebuffer);
        glDeleteRenderbuffersOES(1, &_renderbuffer);
        return -1;
    }

    glEnable(GL_TEXTURE_2D);
    err = glGetError();
    if (err) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not enable textures: %d", err);
        glDeleteTextures(1, &_texture);
        glDeleteFramebuffersOES(1, &_framebuffer);
        glDeleteRenderbuffersOES(1, &_renderbuffer);
        return -1;
    }

    glEnableClientState(GL_VERTEX_ARRAY);
    err = glGetError();
    if (err) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not enable vertex arrays: %d", err);
        glDeleteTextures(1, &_texture);
        glDeleteFramebuffersOES(1, &_framebuffer);
        glDeleteRenderbuffersOES(1, &_renderbuffer);
        return -1;
    }

    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    err = glGetError();
    if (err) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not enable texture vertex arrays: %d", err);
        glDeleteTextures(1, &_texture);
        glDeleteFramebuffersOES(1, &_framebuffer);
        glDeleteRenderbuffersOES(1, &_renderbuffer);
        return -1;
    }

    glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
    err = glGetError();
    if (err) {
        VSLog(kVSLogLevelOpenGL, @"Error: Could not enable texture replacement mode: %d", err);
        glDeleteTextures(1, &_texture);
        glDeleteFramebuffersOES(1, &_framebuffer);
        glDeleteRenderbuffersOES(1, &_renderbuffer);
        return -1;
    }
    
    return 0;
}

#pragma mark - Picture layout

- (void)layoutSubviews {
    if ([_decodeManager decoderReady]) {
        _glResetting = YES;
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, _renderbuffer);
        [_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);

        GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
        if (status != GL_FRAMEBUFFER_COMPLETE) {
            VSLog(kVSLogLevelOpenGL, @"failed to make complete framebuffer object %x", status);
        } else {
            VSLog(kVSLogLevelOpenGL, @"OK setup GL framebuffer %d:%d", _backingWidth, _backingHeight);
        }

        glViewport(0, 0, _backingWidth, _backingHeight);
        glScissor(0, 0, _backingWidth, _backingHeight);

        [self updateVertices];
        _glResetting = NO;
    }
}

- (void)setContentMode:(UIViewContentMode)contentMode
{
    [super setContentMode:contentMode];
    [self updateVertices];
}

- (void)updateVertices
{
    const BOOL fit      = (self.contentMode == UIViewContentModeScaleAspectFit);
    const float width   = [_decodeManager frameWidth];
    const float height  = [_decodeManager frameHeight];
    const float dH      = (float)_backingHeight / height;
    const float dW      = (float)_backingWidth	  / width;
    const float dd      = fit ? MIN(dH, dW) : MAX(dH, dW);
    const float h       = (height * dd / (float)_backingHeight);
    const float w       = (width  * dd / (float)_backingWidth );

    _points[0] = - w;
    _points[1] = - h;
    _points[2] =   w;
    _points[3] = - h;
    _points[4] = - w;
    _points[5] =   h;
    _points[6] =   w;
    _points[7] =   h;

    _texturePoints[0] = 0;
	_texturePoints[1] = 1;
	_texturePoints[2] = 1;
	_texturePoints[3] = 1;
	_texturePoints[4] = 0;
	_texturePoints[5] = 0;
	_texturePoints[6] = 1;
	_texturePoints[7] = 0;
}

#pragma mark - Draw gl screen

- (void)updateScreenWithFrame:(VSVideoFrame *)vidFrame {
    if (!_glResetting) {
        [self renderFrameToTexture:vidFrame.data];
        [self renderTexture];
        [self presentFrame];
    }
}

- (void)renderFrameToTexture:(NSData *)frameData {
	if ([EAGLContext currentContext] != _context) {
		if (![EAGLContext setCurrentContext:_context]) {
			VSLog(kVSLogLevelOpenGL, @"Error: Failed to set current openGL context");
			return;
		}
	}
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, FRAME_X, FRAME_Y, 0, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, [frameData bytes]);
	int err;
	if ((err = glGetError())) {
		VSLog(kVSLogLevelOpenGL, @"glTexImage2D Error: %d", err);
	}
}

- (void)renderTexture {
	int err;

	glClear(GL_COLOR_BUFFER_BIT);
	if ((err = glGetError())) {
		VSLog(kVSLogLevelOpenGL, @"Error: Could not clear frame buffer: %d", err);
	}

	glVertexPointer(2, GL_FLOAT, 0, _points);
	if ((err = glGetError())) {
		VSLog(kVSLogLevelOpenGL, @"Error: Could not create vertex array: %d", err);
		return;
	}

	glTexCoordPointer(2, GL_FLOAT, 0, _texturePoints);
	if ((err = glGetError())) {
		VSLog(kVSLogLevelOpenGL, @"Error: Could not create texture vertex array: %d", err);
		return;
	}

	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	if ((err = glGetError())) {
		VSLog(kVSLogLevelOpenGL, @"Error: Could not draw texture: %d", err);
	}
}

- (BOOL)presentFrame {

    if (![_context presentRenderbuffer:GL_RENDERBUFFER_OES]) {
		VSLog(kVSLogLevelOpenGL, @"Error: Failed to present renderbuffer");
        return NO;
	}
    return YES;
}

#pragma mark - Shutdown

- (void)shutdown {
    glDeleteTextures(1, &_texture);
	glDeleteFramebuffersOES(1, &_framebuffer);
	glDeleteRenderbuffersOES(1, &_renderbuffer);

    if ([EAGLContext currentContext] == _context) {
        [_context release];
		[EAGLContext setCurrentContext:nil];
	} else if(_context) {
        [_context release];
        _context = nil;
    }
}

- (void)dealloc {
    VSLog(kVSLogLevelOpenGL, @"GLView is deallocated");
    [super dealloc];
}

@end
