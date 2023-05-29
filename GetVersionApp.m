
// Developer By Azozz ALFiras 
// GetVersionApp - 29/5/2023

#import "GetVersionApp.h"

@interface LSApplicationWorkspace : NSObject
- (id)allApplications;
+ (id)defaultWorkspace;
@end


@interface LSBundleProxy 
@property (nonatomic, copy) NSURL *appStoreReceiptURL;
@property (nonatomic, readonly) NSURL *bundleContainerURL;
@property (nonatomic, readonly) NSURL *bundleURL;
@property (nonatomic, readonly) NSURL *containerURL;
@property (nonatomic, readonly) NSURL *dataContainerURL;
@end 

@interface LSApplicationProxy
@property (nonatomic,readonly) NSString * applicationIdentifier;
@property(readonly) NSString * bundleVersion;
@property(readonly) BOOL isAppUpdate;
+ (instancetype)applicationProxyForIdentifier:(NSString *)identifier;
@property (nonatomic, readonly) NSString *sourceAppIdentifier;// API_AVAILABLE(ios(8.2)); // e.g. App Store, TestFlight
@end



@implementation GetVersionApp
NSString *ExportPathApp(NSString *From,NSString *To,id String) {
 
NSString *str = [NSString stringWithFormat:@"%@",String];
NSString *stringlast = nil;

NSScanner *scanner = [NSScanner scannerWithString:str];
[scanner scanUpToString:[NSString stringWithFormat:@"%@",From] intoString:nil];

while (![scanner isAtEnd]) {

[scanner scanString:[NSString stringWithFormat:@"%@",From] intoString:nil];
[scanner scanUpToString:[NSString stringWithFormat:@"%@",To] intoString:&stringlast];
[scanner scanUpToString:[NSString stringWithFormat:@"%@",From] intoString:nil];

}
return stringlast;
}

+(NSArray *_Nullable) GetAllApps{
LSApplicationWorkspace *apps = [NSClassFromString(@"LSApplicationWorkspace") defaultWorkspace];
NSArray *appsArr = [apps allApplications];
NSMutableArray *installedApps = [[NSMutableArray alloc] init];
for(int i =0 ; i < [appsArr count];i++){
[installedApps addObject:appsArr[i]];
}

return installedApps;
}
+(NSString *_Nullable) GetVersionApp:(NSString *_Nullable)PathApp{
@try {
NSString *InfoPlist = [NSString stringWithFormat:@"%@.app/Info.plist",PathApp];
NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:InfoPlist];
NSString *version = [dictionary objectForKey:@"CFBundleShortVersionString"];
return version; 
}@catch(NSException*e){
return nil;
}
}
+(NSString *_Nullable)GetAllVersionApp{
NSArray *ArrayApp = [self GetAllApps];
for(NSDictionary* ArrayApth in ArrayApp) {
NSString *Export  = ExportPathApp(@"file:///private",@".app",ArrayApth);
NSString *Version = [self GetVersionApp:Export];
NSLog(@"Version : %@",Version);
}
return nil;
}
@end 