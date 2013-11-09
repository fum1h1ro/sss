//
//  VirtualHID.h
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/09.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import <Foundation/Foundation.h>
// タッチ入力をイベント形式でなく、毎フレームのポーリングで擬似的に取得するためのクラス
@interface VirtualHID : NSObject {
    BOOL _isTouch; // ここで明示的に宣言しておかないと、カテゴリの方でアクセスできない？
}
@property (readonly, nonatomic) CGPoint touchPos;
@property (readonly, nonatomic) BOOL isTouch;
+ (VirtualHID*)shared;
@end
