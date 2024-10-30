#import <UIKit/UIKit.h>

@interface _UILegibilitySettings : NSObject
@property (nonatomic, strong, readwrite) UIColor *primaryColor;
@end

@interface SBUILegibilityLabel : UIView
@property (nonatomic, copy, readwrite) UIColor *textColor;
@end

@interface SBFLockScreenDateView : UIView
@property (assign,nonatomic) double alignmentPercent;
@end

@interface SBFLockScreenDateViewController : UIViewController
@end

@interface UIDevice (Private)
+ (BOOL)currentIsIPad;
@end

@interface PDDokdo : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic, copy, readonly) NSString *currentTemperature;
@property (nonatomic, copy, readonly) NSString *currentConditions;
@property (nonatomic, copy, readonly) NSString *currentLocation;
@property (nonatomic, strong, readonly) UIImage *currentConditionsImage;
@property(nonatomic, strong, readonly) NSDate *sunrise;
@property(nonatomic, strong, readonly) NSDate *sunset;
@property (nonatomic, strong, readonly) NSDictionary *weatherData;
-(void)refreshWeatherData;

-(NSString *)highestTemperatureIn:(int)type;
-(NSString *)lowestTemperatureIn:(int)type;
@end

@interface SBIcon : NSObject
@property (nonatomic,copy,readonly) NSString * displayName;
-(void)setOverrideBadgeNumberOrString:(id)arg1 ;
@end

@interface SBIconModel : NSObject
- (SBIcon *)expectedIconForDisplayIdentifier:(id)arg1;
@end

@interface SBIconController : NSObject
@property (nonatomic,retain) SBIconModel * model;
+ (instancetype)sharedInstance;
@end