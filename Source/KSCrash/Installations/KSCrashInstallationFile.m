//
//  KSCrashInstallationFile.m
//  TestCrash
//
//  Created by zhangjunbo on 14-7-28.
//  Copyright (c) 2014年 ZhangJunbo. All rights reserved.
//

#import "KSCrashInstallationFile.h"
#import "KSCrashReportSinkFile.h"

#import "KSCrashInstallation+Private.h"
#import "KSCrashReportSinkFile.h"
#import "KSCrashReportFilterAppleFmt.h"



@implementation KSCrashInstallationFile


+ (instancetype) sharedInstance
{
    static KSCrashInstallationFile *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KSCrashInstallationFile alloc] init];
    });
    return sharedInstance;
}

- (id) init
{
    if((self = [super initWithRequiredProperties:nil]))
    {
        
    }
    return self;
}


- (id<KSCrashReportFilter>) sink
{
    KSCrashReportSinkFile* sink = [KSCrashReportSinkFile sinkWithFileDir:self.fileDir];
    return [sink defaultCrashReportFilterSet];
}



@end
