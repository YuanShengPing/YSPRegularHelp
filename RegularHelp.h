//
//  RegularHelp.h
//

#import <Foundation/Foundation.h>

@interface RegularHelp : NSObject

+(NSString*)getTheSize;

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *)colorWithHexString: (NSString *)color;

//判断大小添加＋号和%号
+(NSString *)addStringPer:(NSString *)string;

/**
 根据间格式返回时
 
 @param date 时间戳
 @param format 格式（yyyy-MM-dd HH:mm）
 @return yyyy-MM-dd HH:mm
 */
+(NSString*)compareDate:(NSString*)date format:(NSString*)format;


/**
 根据格式反悔时间

 @param timestamp 时间戳
 @param format 格式（yyyy-MM-dd HH:mm）
 @return yyyy-MM-dd HH:mm
 */
+(NSString*)compareWithTimestamp:(NSInteger)timestamp format:(NSString *)format;

/**
 标准时间转时间戳

 @param dateStr 标准时间
 @return NSDate
 */
+(NSDate*)compareWithTimeString:(NSString*)dateStr;

/**
 将时间戳转换成分秒

 @param date 秒
 @return  分:秒
 */
+(NSString*)conversionDate:(NSInteger)date;


/**
 讲时间间隔转换成时分秒

 @param date 秒
 @return 时:分:秒
 */
+(NSString*)conversionDateHMS:(NSInteger)date;


/**
 根据文字，字体获取最大宽度

 @param title 文字
 @param font 字体
 @return 宽度
 */
+(CGFloat)getWidthWithTitle:(NSString*)title font:(UIFont*)font;


/**
 根据文字，字体，最大宽度计算高度

 @param title 文字
 @param font 字体
 @param maxWidth 最大宽度
 @return 高度
 */
+(CGFloat)getHeightWithTitle:(NSString*)title font:(UIFont*)font maxWidth:(CGFloat)maxWidth;


/**
 给视图加阴影

 @param view 视图
 @param topDistance 上间距
 @param bottomDistance 下间距
 @param shadowDistabce 阴影间距
 @param shadowColor 颜色
 @param opacity 透明度
 */
+(void)loadShadow:(UIView*)view fram:(CGRect)frame topDistance:(CGFloat)topDistance bottomDistance:(CGFloat)bottomDistance shadowDistabce:(CGFloat)shadowDistabce shadowColor:(UIColor*)shadowColor opacity:(CGFloat)opacity;


/**
 将时间转换成几分钟之前的样子

 @param createTimeString 时间戳
 @return 几分钟前
 */
+(NSString *)updateTimeForRow:(NSString *)createTimeString;


/**
 获取手机型号

 @return 手机型号
 */
+(NSString*)deviceVersion;


/**
 获取当前手机语言

 @return 语言
 */
+ (NSString*)getCurrentLanguage;


/**
 根据颜色生成图片

 @param color 颜色
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;


/**
 根据颜色生成图片

 @param color 颜色
 @param rect rect
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect;


/**
  根据当前视图获取控制器

 @param view 视图
 @return 控制器
 */
+ (UIViewController*)viewController:(UIView*)view;


/**
 获取Mac地址

 @return Mac地址
 */
+ (NSString*)getMacAddress;


/**
 获取唯一标示

 @return 唯一标示
 */
+(NSString*)setKeyChainValue;


/**
 为超过10000的数字添加单位

 @param number 数字
 @return 添加单位后的
 */
+(NSString*)addUnit:(NSInteger)number;


/**
 判断是否为url链接

 @param url 字符串
 @return yes/no
 */
+ (BOOL)isUrl:(NSString *)url;


/**
 打开图片浏览器

 @param urlArray 数组
 */
+(void)openImageViewer:(NSArray<NSURL*>*)urlArray;

/**
 MD5加密

 @param input 字符串
 @return 字符串
 */
+(NSString*)md5:(NSString *)input;

/**
 转换时间
 先判断日期，再判断时间差距。
 
 <1> 如果日期是今天，
 如果距现在15分钟内，显示为：“刚刚”
 如果距现在15-60分钟内，显示为：“XX分钟前”
 如果距现在60分钟以上，显示为：“XX小时前”
 <2> 如果日期是昨天，显示为：“昨天”
 <3> 如果日期是昨天之前，显示为：“XXXX年X月XX日”

 @param time 时间戳
 @return 时间
 */
+(NSString*)conversionTime:(NSInteger)time;
@end
