#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>	{
	
	IBOutlet NSTextField		*appNameField;
	IBOutlet NSTextField		*fileNameField;
	NSTimer						*timer;
	
}

- (IBAction)fieldChanged:(id)sender;
- (void)checkIsRunning:(NSTimer *)t;

@end

