//
//  SamTools.m
//  SamTools
//
//  Created by Sam on 14-7-8.
//  Copyright (c) 2014年 HelloWorld. All rights reserved.
//

#import "SamTools.h"
#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>
#import "IPAddress.h"

@implementation SamTools

+ (NSArray *)propertysInObject:(NSObject *)object
{
    unsigned int propertiesCount = 0;
    objc_property_t *properties = class_copyPropertyList([object class], &propertiesCount);
    
    NSMutableArray *propertiesArray = [[NSMutableArray alloc] initWithCapacity:propertiesCount];
    
    for(int i = 0; i < propertiesCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [propertiesArray addObject:propertyName];
    }
    
    free(properties);
    
    return propertiesArray;
}

+ (NSDictionary *)dictionaryFromPropertysInObject:(NSObject *)object
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for(NSString *aProperty in [[self class] propertysInObject:object])
    {
        id propertyValue = [object valueForKey:aProperty];
        if (propertyValue && ![propertyValue isKindOfClass:[NSNull class]])
		{
            [dic setObject:propertyValue forKey:aProperty];
        }
        else
        {
            NSLog(@"WARNING dictionaryFromPropertysInObject: property(%@) is value(%@) kind of class(%@)", aProperty, propertyValue, [propertyValue class]);
        }
        
    }
    
    return dic;
}

+ (void)reflectFromObject:(NSObject *)fromObject toObject:(NSObject *)toObject
{
    for(NSString *aProperty in [[self class] propertysInObject:toObject])
    {
        id propertyValue = [fromObject valueForKey:aProperty];
        if (propertyValue && ![propertyValue isKindOfClass:[NSNull class]])
		{
            [toObject setValue:propertyValue forKey:aProperty];
        }
        else
        {
            NSLog(@"WARNING reflectFromObject: property(%@) is value(%@) kind of class(%@)", aProperty, propertyValue, [propertyValue class]);
        }
    }
}

+ (NSString *)getUUID
{
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    NSString * uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);
    
    return uuidString;
}

+ (void)checkNSNull:(NSObject **)obj
{
    if ([*obj isKindOfClass:[NSNull class]])
    {
        *obj = nil;
    }
}

+ (BOOL)validateUrl:(NSString *)candidate
{
    NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

+ (NSString *)getCacheDir
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return cachePath;
}

+ (NSString *)getDocumentsDir
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return documentsPath;
}

+ (NSString *)getTmpDir
{
    NSString *tmpDir = NSTemporaryDirectory();
    return tmpDir;
}

+ (BOOL)checkDir:(NSString *)dir
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL isDir = YES;
    if([fileManager fileExistsAtPath:dir isDirectory:&isDir])
    {
        if (isDir)
		{
            return YES;
        }
        else
        {
            NSLog(@"checkDir: \"dir\" is NOT Directory!");
            return NO;
        }
    }
    else
    {
        NSError *error = nil;
        if([fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"checkDir: Create Dir!");
            return YES;
        }
        else
        {
            NSLog(@"checkDir: %@", error.localizedDescription);
            return NO;
        }
    }
    
    
}

+ (BOOL)removeItem:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSError *error = nil;
    BOOL isDir = YES;
    
    if([fileManager fileExistsAtPath:path isDirectory:&isDir])
    {
        if ([fileManager removeItemAtPath:path error:&error])
        {
            return YES;
        }
        else
        {
            NSLog(@"removeFile %@ Error: %@", [path lastPathComponent], error.localizedDescription);
            return NO;
        }
    }
    else
    {
        NSLog(@"removeFile: %@ NOT EXIST", [path lastPathComponent]);
        return YES;
    }
}

+ (BOOL)removeDir:(NSString *)path;
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSError *error = nil;
    if([fileManager removeItemAtPath:path error:&error])
    {
        return YES;
    }
    else
    {
        NSLog(@"removeDir ERROR: %@", error.localizedDescription);
        return NO;
    }
}

+ (NSArray *)getFilesInDir:(NSString *)dir
{
    NSMutableArray *files = [NSMutableArray array];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSError *error = nil;
    BOOL isDir = YES;
    
    if([fileManager fileExistsAtPath:dir isDirectory:&isDir])
    {
        if (isDir)
		{
            NSArray *subObjects = [fileManager contentsOfDirectoryAtPath:dir error:&error];
            if (error)
            {
                NSLog(@"getFilesInDir ERROR %@", error.localizedDescription);
                return nil;
            }
            else
            {
                for(NSString *aPath in subObjects)
                {
                    NSString *aFullPath = [dir stringByAppendingPathComponent:aPath];
                    if([fileManager fileExistsAtPath:aFullPath isDirectory:&isDir])
                    {
                        if (!isDir)
                        {
                            [files addObject:aFullPath];
                        }
                    }
                    else
                    {
                        NSLog(@"getFilesInDir ERROR 挑选文件时发生错误!!!");
                        return nil;
                    }
                }
                
                // TODO: 按创建时间排序
                [files sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    NSString *file1 = obj1;
                    NSString *file2 = obj2;
                    
                    NSDictionary *attributes1 = [fileManager attributesOfItemAtPath:file1 error:nil];
                    NSDictionary *attributes2 = [fileManager attributesOfItemAtPath:file2 error:nil];
                    
                    NSDate *file1Date = attributes1[NSFileCreationDate];
                    NSDate *file2Date = attributes2[NSFileCreationDate];
                    
                    if ([file1Date compare:file2Date] == NSOrderedAscending)
                    {
                        return NSOrderedDescending;
                    }
                    else if ([file1Date compare:file2Date] == NSOrderedAscending)
                    {
                        return NSOrderedAscending;
                    }
                    else
                    {
                        return NSOrderedSame;
                    }
                }];
                
                return files;
            }
        }
        else
        {
            NSLog(@"getFilesInDir ERROR \"dir\" is NOT a Directory!!!");
            return nil;
        }
    }
    else
    {
        NSLog(@"getFilesInDir ERROR %@ NOT EXIST", [dir lastPathComponent]);
        return nil;
    }
}

+ (NSTimeInterval)getAudioFileDuration:(id)filePath
{
    NSURL *url = nil;
    
    if ([filePath isKindOfClass:[NSString class]])
    {
        url = [NSURL fileURLWithPath:filePath];
    }
    else if ([filePath isKindOfClass:[NSURL class]])
    {
        url = filePath;
    }
    
    if (url)
    {
        AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:url options:nil];
        NSTimeInterval audioDuration = CMTimeGetSeconds(audioAsset.duration);
        
        return audioDuration;
    }
    else
    {
        NSLog(@"getAudioFileDuration ERROR: 错误的文件地址!!!");
        return 0;
    }
}

+ (NSString *)dateStringFromtimeInterval:(NSTimeInterval)interval
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

+ (void)makeGrayBordAndRoundCorner:(UIView *)view
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5.0f;
    view.layer.borderColor = [UIColor grayColor].CGColor;
    view.layer.borderWidth = 1.0f;
}

+ (BOOL)checkFile:(NSString *)file
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if([fileManager fileExistsAtPath:file])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)moveFile:(NSString *)oldPath to:(NSString *)newPath
{
    if (!oldPath || !newPath)
    {
        NSLog(@"moveFile ERROR 没有指定文件!!!");
        return NO;
    }
    
    NSError *error = nil;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if([fileManager fileExistsAtPath:oldPath])
    {
        [SamTools removeItem:newPath];
        if([fileManager moveItemAtPath:oldPath toPath:newPath error:&error])
        {
            return YES;
        }
        else
        {
            NSLog(@"moveFile ERROR %@", error.localizedDescription);
            return NO;
        }
        
    }
    else
    {
        NSLog(@"moveFile ERROR oldPath 没有对应文件！");
        return NO;
    }

}

+ (UInt32)getID
{
    UInt32 result = 0;
    
    NSNumber *newID = [[NSUserDefaults standardUserDefaults] objectForKey:ID_Key];
    if (!newID)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:ID_Key];
    }
    else
    {
        result = [newID unsignedLongValue];
        [[NSUserDefaults standardUserDefaults] setObject:@(result + 1) forKey:ID_Key];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return result;
}

+ (int)getIDWithKey:(NSString *)key
{
    if (!key)
    {
        NSLog(@"getIDWithKey ERROR: key is nil !!!");
        return 0;
    }
    int result = 0;
    
    NSNumber *newID = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!newID)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:key];
    }
    else
    {
        result = [newID intValue];
        [[NSUserDefaults standardUserDefaults] setObject:@(result + 1) forKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return result;
}


+ (void)checkNilToString:(NSObject **)obj
{
    if (nil == *obj)
    {
        *obj = @"";
    }
}

+ (NSString *)getLocalHost
{
    InitAddresses();
    GetIPAddresses();
//    GetHWAddresses();
    return [NSString stringWithFormat:@"%s", ip_names[1]];
}










@end
