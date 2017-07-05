//
//  RegularHelp.m
//

#import "RegularHelp.h"
#import "sys/utsname.h"
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import "IDMPhotoBrowser.h"
#import<CommonCrypto/CommonDigest.h>

@implementation RegularHelp

//判断大小添加＋号和%号
+(NSString *)addStringPer:(NSString *)string{
    float tur = [[NSString stringWithFormat:@"%@",string] floatValue];
    if (tur > 0) {
        return [NSString stringWithFormat:@"+%.2lf%%",tur];
    }else{
        return [NSString stringWithFormat:@"%.2lf%%",tur];
    }
}

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+(NSString*)getTheSize
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if (SCREEN_HEIGHT>SCREEN_WIDTH) {
            if (SCREEN_HEIGHT == 736) {
                return @"5.5-inch";
            }else if (SCREEN_HEIGHT == 667){
                return @"4.7-inch";
            }else if (SCREEN_HEIGHT == 568){
                return @"4-inch";
            }else{
                return @"3.5-inch";
            }
        }else
        {
            if (SCREEN_WIDTH == 736) {
                return @"5.5-inch";
            }else if (SCREEN_WIDTH == 667){
                return @"4.7-inch";
            }else if (SCREEN_WIDTH == 568){
                return @"4-inch";
            }else{
                return @"3.5-inch";
            }
        }
    }else
    {
        return @"ipad";
    }
}

+(NSString*)compareDate:(NSString *)date format:(NSString *)format
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[date integerValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (strIsEmpty(format)) {
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    [dateFormatter setDateFormat:format];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSString* str = [dateFormatter stringFromDate:confromTimesp];
    return str;
}

+(NSString*)compareWithTimestamp:(NSInteger)timestamp format:(NSString *)format
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (strIsEmpty(format)) {
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    [dateFormatter setDateFormat:format];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSString* str = [dateFormatter stringFromDate:confromTimesp];
    return str;
}

+(NSDate*)compareWithTimeString:(NSString*)dateStr
{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    formater.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDate* date = [formater dateFromString:dateStr];
    return date;
}



+(CGFloat)getWidthWithTitle:(NSString*)title font:(UIFont *)font
{
    if (!font) {
        font = HXQFont(15);
    }
    CGRect tmpRect = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    return tmpRect.size.width;
}

+(CGFloat)getHeightWithTitle:(NSString *)title font:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    if (!font) {
        font = HXQFont(15);
    }
    CGRect tmpRect = [title boundingRectWithSize:CGSizeMake(maxWidth, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    return tmpRect.size.height+1;
}

+(NSString*)conversionDate:(NSInteger)date
{
    NSInteger minutes = date/60;
    NSInteger seconds = date%60;
    return [NSString stringWithFormat:@"%@:%@",minutes<10?[NSString stringWithFormat:@"0%ld",minutes]:[NSString stringWithFormat:@"%ld",minutes],seconds<10?[NSString stringWithFormat:@"0%ld",seconds]:[NSString stringWithFormat:@"%ld",seconds]];
}

+(NSString*)conversionDateHMS:(NSInteger)date
{
    NSInteger hours = (date/60)/60;
    NSInteger minutes = (date/60)%60;
    NSInteger seconds = date%60;
    NSMutableString* string = [[NSMutableString alloc] init];
    if (hours>0) {
        [string appendFormat:@"%ld:",hours];
    }
    
    [string appendFormat:@"%@:",minutes<10?[NSString stringWithFormat:@"0%ld",minutes]:[NSString stringWithFormat:@"%ld",minutes]];
    
    [string appendFormat:@"%@",seconds<10?[NSString stringWithFormat:@"0%ld",seconds]:[NSString stringWithFormat:@"%ld",seconds]];
    
    return string;
}

+(void)loadShadow:(UIView*)view fram:(CGRect)frame topDistance:(CGFloat)topDistance bottomDistance:(CGFloat)bottomDistance shadowDistabce:(CGFloat)shadowDistabce shadowColor:(UIColor*)shadowColor opacity:(CGFloat)opacity
{
    view.layer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
    view.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = opacity;//阴影透明度，默认0
    view.layer.shadowRadius = shadowDistabce;//阴影半径，默认3
    
    UIBezierPath* path = [[UIBezierPath alloc] init];
    float width = frame.size.width;
    float height = frame.size.height-topDistance-bottomDistance;
    float x = 0;
    float y = topDistance;
    float addWH = shadowDistabce;
    
    CGPoint topLeft      = CGPointMake(x, y);
    CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
    CGPoint topRight     = CGPointMake(x+width,y);
    
    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
    
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];
    
    view.layer.shadowPath = path.CGPath;
}

+(NSString *)updateTimeForRow:(NSString *)createTimeString {
    
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = [createTimeString longLongValue]/1000;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    NSInteger sec = time/60;
    if (sec<60) {
        return [NSString stringWithFormat:@"%ld分钟前",sec];
    }
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",days];
    }
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前",months];
    }
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",years];
}

+(NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    
    return deviceString;
}

+ (NSString*)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
    
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (UIViewController*)viewController:(UIView*)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

+ (NSString*)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

//设置唯一标示
+(NSString*) setKeyChainValue
{
    
    NSString* bundleId = [[NSBundle mainBundle]bundleIdentifier];
    NSString *retrieveuuid = [SSKeychain passwordForService:bundleId account:@"UUID"];
    if (retrieveuuid.length ==0) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid != NULL);
        CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
        [SSKeychain setPassword: [NSString stringWithFormat:@"%@", uuidStr]
                     forService:bundleId account:@"UUID"];
        return retrieveuuid;
    }else
    {
        return retrieveuuid;
    }
}

+(NSString*)addUnit:(NSInteger)number
{
    if (number>10000) {
        return [NSString stringWithFormat:@"%0.f万",(number/10000.0f)];
    }else
    {
        return [NSString stringWithFormat:@"%ld",number];
    }
}

+ (BOOL)isUrl:(NSString *)url
{
    if(self == nil)
        return NO;
    NSString *urlstr;
    if (url.length>4 && [[url substringToIndex:4] isEqualToString:@"www."]) {
        urlstr = [NSString stringWithFormat:@"http://%@",self];
    }else{
        urlstr = url;
    }
    NSString *urlRegex = @"(https|http|ftp|rtsp|igmp|file|rtspt|rtspu)://((((25[0-5]|2[0-4]\\d|1?\\d?\\d)\\.){3}(25[0-5]|2[0-4]\\d|1?\\d?\\d))|([0-9a-z_!~*'()-]*\\.?))([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.([a-z]{2,6})(:[0-9]{1,4})?([a-zA-Z/?_=]*)\\.\\w{1,5}";
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:url];
}

+(void)openImageViewer:(NSArray<NSURL*>*)urlArray
{
    NSArray *photosWithWrlArray =[IDMPhoto photosWithURLs:urlArray];
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photosWithWrlArray];
    browser.displayToolbar = YES;
    browser.displayActionButton = NO;
    browser.displayCounterLabel = YES;
    [CURRENTVC.navigationController presentViewController:browser animated:YES completion:nil];
}


+(NSString*)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+(NSString*)conversionTime:(NSInteger)time
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    
//    NSString* str = [dateFormatter stringFromDate:confromTimesp];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *yesterday;
    
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * dateString = [dateFormatter stringFromDate:confromTimesp];
    
    NSString* strTime;
    if ([dateString isEqualToString:todayString])
    {
        NSInteger difference = [today timeIntervalSince1970]-time;
        if (difference < 15*60) {
            strTime = @"刚刚";
        }else if (difference < 60*60){
            strTime = [NSString stringWithFormat:@"%0.f分钟前",ceil(difference/60)];
        }else
        {
            strTime = [NSString stringWithFormat:@"%0.f分钟前",ceil(difference/(60*60))];
        }
    } else if ([dateString isEqualToString:yesterdayString])
    {
        strTime = @"昨天";
    }else{
        strTime = dateString;
    }
    return strTime;
}
@end


