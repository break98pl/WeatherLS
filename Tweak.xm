#include <UIKit/UIKit.h>
@interface SBIcon
- (void)setOverrideBadgeNumberOrString:(id)arg1 ;
@end
@interface SBIconModel
- (SBIcon *)applicationIconForBundleIdentifier:(id)arg1 ;
@end

@interface SBIconController : UIViewController
+(id)sharedInstance;
-(SBIconModel *)model;
@end

@interface SBFLockScreenDateViewController : UIViewController
@property (assign, nonatomic) BOOL isUpdated;
@end

@interface SBFLockScreenDateView : UIView
@property (nonatomic, strong) UIImageView *conditionImageView;
@property (nonatomic, strong) UILabel *tempLabel;

- (void)updateWeather;
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

%hook SBFLockScreenDateView
%property (nonatomic, strong) UIImageView *conditionImageView;
%property (nonatomic, strong) UILabel *tempLabel;

- (instancetype)initWithFrame:(CGRect)frame {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWeather) name:@"WeatherLS_updateWeather" object:nil];
	return %orig;
}

-(void)_setDate:(id)arg1 inTimeZone:(id)arg2{
	%orig;
	if(!self.tempLabel && !self.conditionImageView){
		float imgSize = 70;

		if ([self viewWithTag:6] == nil) {
			self.conditionImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
			self.conditionImageView.tag = 6;
			self.conditionImageView.translatesAutoresizingMaskIntoConstraints = NO;
			[self addSubview:self.conditionImageView];

			self.tempLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			self.tempLabel.tag = 6;
			self.tempLabel.textColor = [UIColor whiteColor];
			self.tempLabel.font = [UIFont systemFontOfSize:28];
			self.tempLabel.textAlignment = NSTextAlignmentCenter;
			self.tempLabel.translatesAutoresizingMaskIntoConstraints = NO;
			[self addSubview:self.tempLabel];
		}
		self.tempLabel.hidden = NO;
		self.conditionImageView.hidden = NO;
		[self.conditionImageView.widthAnchor constraintEqualToConstant:imgSize].active = YES;
		[self.conditionImageView.heightAnchor constraintEqualToConstant:imgSize].active = YES;
		[self.conditionImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:15].active = YES;
		[self.conditionImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:-15].active = YES;

		[self.tempLabel.centerXAnchor constraintEqualToAnchor:self.conditionImageView.centerXAnchor].active = YES;
		[self.tempLabel.topAnchor constraintEqualToAnchor:self.conditionImageView.bottomAnchor constant:0].active = YES;

		[[NSNotificationCenter defaultCenter] postNotificationName:@"WeatherLS_updateWeather" object:nil];
	}
}

%new - (void)updateWeather {
	[[PDDokdo sharedInstance] refreshWeatherData];
	self.conditionImageView.image = [[PDDokdo sharedInstance] currentConditionsImage];
	self.tempLabel.text = [[PDDokdo sharedInstance] currentTemperature];
	SBIcon *icon = [((SBIconController *)[objc_getClass("SBIconController") sharedInstance]).model applicationIconForBundleIdentifier:@"com.apple.weather"];
    if(icon)
    {
        [icon setOverrideBadgeNumberOrString: self.tempLabel.text];
    }
}

%end

%hook SBFLockScreenDateViewController
%property (assign, nonatomic) BOOL isUpdated;
- (void)_startUpdateTimer {
	%orig;
	if(!self.isUpdated){
		self.isUpdated = true;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"WeatherLS_updateWeather" object:nil];
		dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1800);
		dispatch_after(delay, dispatch_get_main_queue(), ^(void){
			self.isUpdated = false;
		});
	}
}
%end

%hook SBFLockScreenDateView
-(void)setAlignmentPercent:(double)arg1{
	%orig(1);
}
%end