//
//  Macros.h

///////////////////////////////////////////
// Debugging
///////////////////////////////////////////
#ifdef DEBUG
#   define XQBLog(fmt, ...) NSLog((@"%s [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define XQBLog(...)
#endif

///////////////////////////////////////////
// App
///////////////////////////////////////////

#define APP_NAME        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define APP_VERSION     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_BUNDLE_URL_NAME     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"]
#define APP_BUNDLEID    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define APP_ID          @"890385562"
#define APP_URL         @"https://itunes.apple.com/cn/app/xiao-qu-bao/id890385562?mt=8"

//#define APP_VERSION [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]

///////////////////////////////////////////
// Device & OS
///////////////////////////////////////////

#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define Is3_5Inches() ([[UIScreen mainScreen] bounds].size.height == 480.0f)
#define Is4_0Inches() ([[UIScreen mainScreen] bounds].size.height == 568.0f)
#define Is4_7Inches() ([[UIScreen mainScreen] bounds].size.height == 667.0f)
#define Is5_5Inches() ([[UIScreen mainScreen] bounds].size.height == 960.0f)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


///////////////////////////////////////////
// Random
///////////////////////////////////////////
#define RANDOM_MINUS_1_TO_1() ((random() / (GLfloat)0x3fffffff )-1.0f)
#define RANDOM_0_TO_1() ((random() / (GLfloat)0x7fffffff ))

///////////////////////////////////////////
// Networking
///////////////////////////////////////////
#define IsConnected() !([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

///////////////////////////////////////////
// Misc
///////////////////////////////////////////
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define URLIFY(urlString) [NSURL URLWithString:urlString]
#define F(string, args...) [NSString stringWithFormat:string, args]
#define ALERT(title, msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show]

// block self
#define WEAKSELF __weak typeof(self) weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

// device verson float value
#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

// iPad
#define kIsiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// image STRETCH
#define XQB_STRETCH_IMAGE(image, edgeInsets) (CURRENT_SYS_VERSION < 6.0 ? [image stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top] : [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch])

