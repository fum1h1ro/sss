// vim: fenc=utf-8
//  Common.h
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/14.
//  Copyright (c) 2013 alwaystesting. All rights reserved.
//

#ifndef sss_Common_h
#define sss_Common_h

typedef signed char s8;
typedef unsigned char u8;
typedef signed short s16;
typedef unsigned short u16;
typedef signed int s32;
typedef unsigned int u32;
#ifdef __LP64__
typedef signed long s64;
typedef unsigned long u64;
#else
typedef signed long long s64;
typedef unsigned long long u64;
#endif
typedef float f32;
typedef double f64;




// この定義を有効にすると、擬似的に解像度を下げる（テスト中）
//#define USE_DISPLAY_VIEW 1



#ifdef DEBUG
#   define NS_LOG(...) NSLog(__VA_ARGS__)
#   define NS_REPORT(...) NSLog(__VA_ARGS__)
#else
#   ifndef DISTRIBUTION
#       define NS_LOG(...)
#       define NS_REPORT(...) NSLog(__VA_ARGS__)
#   else
#       define NS_LOG(...)
#       define NS_REPORT(...)
#   endif
#endif



#endif
