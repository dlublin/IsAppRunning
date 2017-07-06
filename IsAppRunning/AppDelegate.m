#import "AppDelegate.h"

id	appNapThing;

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	if (appNapThing != nil)	{
		NSActivityOptions			options = NSActivityAutomaticTerminationDisabled | NSActivityBackground | NSActivityLatencyCritical | NSActivityIdleSystemSleepDisabled;
		appNapThing = [[NSProcessInfo processInfo] beginActivityWithOptions: options reason:@"Keep alive"];
	}
	//	Adjust this value to change how often this checks
	NSTimeInterval		checkFrequencyInSeconds = 5.0;
	timer = [NSTimer scheduledTimerWithTimeInterval:checkFrequencyInSeconds target:self selector:@selector(checkIsRunning:) userInfo:nil repeats:YES];
}

- (void) awakeFromNib	{
	NSUserDefaults		*def = [NSUserDefaults standardUserDefaults];
	NSString			*tmpString = nil;
	tmpString = [def objectForKey:@"appName"];
	if (tmpString != nil)
		[appNameField setStringValue:tmpString];
	tmpString = [def objectForKey:@"fileName"];
	if (tmpString != nil)
		[fileNameField setStringValue:tmpString];
}

- (IBAction)fieldChanged:(id)sender	{
	//NSLog(@"%s",__func__);
	NSString	*appName = [appNameField stringValue];
	NSString	*fileName = [fileNameField stringValue];
	if (appName == nil)
		appName = @"";
	if (fileName == nil)
		fileName = @"";
	NSUserDefaults		*def = [NSUserDefaults standardUserDefaults];
	[def setObject:appName forKey:@"appName"];
	[def setObject:fileName forKey:@"fileName"];
	[def synchronize];
	[self checkIsRunning:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
	[timer invalidate];
}

- (void)checkIsRunning:(NSTimer *)t	{
	//NSLog(@"%s",__func__);
	NSString	*appName = [appNameField stringValue];
	NSString	*fileName = [fileNameField stringValue];
	if ((appName == nil)||([appName isEqualToString:@""]))
		return;
	if ((fileName == nil)||([fileName isEqualToString:@""]))
		return;
	
	NSArray		*runningApps = [[NSWorkspace sharedWorkspace] runningApplications];
	BOOL		isRunning = NO;
	//NSLog(@"\t\t%@",runningApps);
	for (NSRunningApplication *app in runningApps)	{
		if ([[app localizedName] isEqualToString:appName])	{
			isRunning = YES;
			break;
		}
	}
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:[fileName stringByExpandingTildeInPath]] == NO)	{
		NSLog(@"\t\tfile did not exist at %@",[fileName stringByExpandingTildeInPath]);
		return;
	}
	
	if (isRunning == NO)	{
		NSLog(@"\t\t%@ was not open – relauching %@",appName,fileName);
		[[NSWorkspace sharedWorkspace] openFile:[fileName stringByExpandingTildeInPath] withApplication:nil];
	}
}

@end
