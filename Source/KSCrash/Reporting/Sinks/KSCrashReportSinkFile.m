//
//  KSCrashReportSinkFile.m
//  TestCrash
//
//  Created by zhangjunbo on 14-7-28.
//  Copyright (c) 2014年 ZhangJunbo. All rights reserved.
//

#import "KSCrashReportSinkFile.h"
#import "KSCrashReportFilterAppleFmt.h"
#import "KSCrashReportFilterBasic.h"

@interface KSCrashReportSinkFile ()

@property (nonatomic, readwrite, retain) NSString* fileDir;

@end

@implementation KSCrashReportSinkFile

@synthesize fileDir = _fileDir;

+ (KSCrashReportSinkFile*) sinkWithFileDir:(NSString *)fileDir
{
    return [[self alloc] initWithFileDir:fileDir];
}

- (id) initWithFileDir:(NSString *)fileDir
{
    if((self = [super init])){
        self.fileDir = fileDir;
    }
    return self;
}

- (BOOL) ensureDirectoryExists:(NSString*) path
{
    NSError* error = nil;
    NSFileManager* fm = [NSFileManager defaultManager];
    
    if(![fm fileExistsAtPath:path])
    {
        if(![fm createDirectoryAtPath:path
          withIntermediateDirectories:YES
                           attributes:nil
                                error:&error])
        {
            NSLog(@"Could not create directory %@: %@.", path, error);
            return NO;
        }
    }
    
    return YES;
}


static NSString *filename() {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    NSString *fileName = [NSString stringWithFormat:@"%@-%@-%ld.crash", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"],
                          [dateFormatter stringFromDate:[NSDate date]], (long)[[NSDate date] timeIntervalSince1970]];
    return fileName;
}


- (void) filterReports:(NSArray*) reports
          onCompletion:(KSCrashReportFilterCompletion) onCompletion
{
    [self ensureDirectoryExists:self.fileDir];
    for (NSString *str in reports) {
        NSString *filePath = [self.fileDir stringByAppendingPathComponent:filename()];
        [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    kscrash_callCompletion(onCompletion, reports, YES, nil);
}

- (id <KSCrashReportFilter>) defaultCrashReportFilterSet
{
    return [KSCrashReportFilterPipeline filterWithFilters:
            [KSCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStyleSymbolicated],
            self,
            nil];
}

@end
