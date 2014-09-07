//
//  SamTools.h
//  SamTools
//
//  Created by Sam on 14-7-8.
//  Copyright (c) 2014年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ColorRGBA(r, g, b, a) ([UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha:a]);
#define isIos7  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)

#define ID_Key  @"Sam_getID_Key"

@interface SamTools : NSObject

+ (NSArray *)propertysInObject:(NSObject *)object;                                  // 封装object的属性到array
+ (NSDictionary *)dictionaryFromPropertysInObject:(NSObject *)object;               // 封装object当前的属性和值到dictionary
+ (void)reflectFromObject:(NSObject *)fromObject toObject:(NSObject *)toObject;     // 将fromObject的值赋给toObject
+ (NSString *)getUUID;
+ (void)checkNSNull:(NSObject **)obj;                                               // 检查是否为NSNull类型，若是改为nil；
+ (void)checkNilToString:(NSObject **)obj;                                          // 检查是否为nil，若是改为NSString；
+ (BOOL)validateUrl:(NSString *)candidate;                                          // 判断string是否符合HTTP URL规范

+ (NSString *)getCacheDir;                                                          // 获取Caches目录
+ (NSString *)getDocumentsDir;                                                      // 获取Documents目录
+ (NSString *)getTmpDir;                                                            // 获取tmp目录，应用不运行时会清空
+ (BOOL)checkDir:(NSString *)dir;                                                   // 查看dir是否存在，如果不存在则创建
+ (BOOL)checkFile:(NSString *)file;                                                 // 查看file是否存在
+ (BOOL)removeItem:(NSString *)path;                                                // 移除对应目录的对象
+ (BOOL)removeDir:(NSString *)path;                                                 // 移除对应目录
+ (BOOL)moveFile:(NSString *)oldPath to:(NSString *)newPath;                        // 移动到对应的目录

+ (NSArray *)getFilesInDir:(NSString *)dir;                                         // 获取dir下的所有文件, 最新创建的排最前
+ (NSTimeInterval)getAudioFileDuration:(id)filePath;                                // 获取filePath(NSString或NSURL)指向的音频文件持续时间
+ (NSString *)dateStringFromtimeInterval:(NSTimeInterval)interval;                  // 将interval变换为时间格式 (90 ---> 01:30)

+ (void)makeGrayBordAndRoundCorner:(UIView *)view;                                  // view圆角灰边

+ (UInt32)getID;                                                                    // 获取一个唯一ID号,0开始，每次递增
+ (int)getIDWithKey:(NSString *)key;


@end
