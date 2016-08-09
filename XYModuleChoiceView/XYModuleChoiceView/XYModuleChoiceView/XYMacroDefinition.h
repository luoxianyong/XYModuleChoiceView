//
//  XYMacroDefinition.h
//  XXXX
//
//  Created by sunon002 on 15-4-28.
//  Copyright (c) 2015年 Jet.Luo. All rights reserved.
//

#ifndef XYMacroDefinition_h
#define XYMacroDefinition_h


//----------------------颜色类start---------------------------
// rgb颜色转换（16进制->10进制）
#define XYUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define XYUIColorFromRGBVlaue(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

//----------------------颜色类end--------------------------


//----------------------图片start----------------------------
#define XYLOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:［NSBundle mainBundle]pathForResource:file ofType:ext］
#define XYLoadImagePNG(file) LOADIMAGE(file,@"png")
//----------------------图片end----------------------------

//获取系统版本
#define XYIOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define XYIOS_9 (XYIOS_VERSION > 9.0 ? YES : NO)
#define XYIOS_8_Later (XYIOS_VERSION > 8.0 ? YES : NO)

//-- 屏幕宽度、高度
#define XYSCREEN_BOUNDS [[UIScreen mainScreen] bounds]
#define XYSCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define XYSCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

//-- 触摸事件
#define XYUIControlEventTouch UIControlEventTouchUpInside

#ifdef DEBUG
# define XYDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define XYDLog(...)
#endif

#endif






