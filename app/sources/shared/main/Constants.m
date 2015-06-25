#import "Constants.h"
#import "current_svn_revision.h"

#define MOB_BASE_URL "http://www.mobitransit.com/helsinki"

NSString * const kMobHost			= @"www.mobitransit.com";
NSString * const kMobUser			= @"helsinki";
NSString * const kMobPass			= @"h3ls1nk1";
NSString * const kMobQueue			= @"/topic/mobitransit.helsinki";
NSString * const kMobQueueAlerts	= @"/topic/mobitransit.alerts";
NSString * const kMobConfigURL		= @""MOB_BASE_URL"/resources/config.plist.gz";
NSString * const kMobLinesURL		= @""MOB_BASE_URL"/resources/lines.plist.gz";
NSString * const kMobMarkersURL		= @""MOB_BASE_URL"/services/markers.gz";
NSString * const kMobStopsURL		= @""MOB_BASE_URL"/services/stop";
NSString * const kMobDataURL		= @""MOB_BASE_URL"/services/data.gz";
//NSString * const kGANAccountId		= @"UA-9820254-5";	// iphone.mobicityapp.com
NSString * const kGANAccountId		= @"UA-9820254-6";		// iphone.mobitransitapp.com
NSString * const kAppCategory		= @"APPLICATION";
NSString * const kLineCategory		= @"LINE";
NSString * const kRouteCategory		= @"ROUTE";
NSString * const kStopCategory		= @"STOP";
NSString * const kMarkerCategory	= @"MARKER";
NSString * const kUserCategory		= @"USER";
NSString * const kLoadAction		= @"Loading";
NSString * const kFilterAction		= @"Filtering";
NSString * const kSelectAction		= @"Selection";
NSString * const kScheduleAction	= @"Schedule";
NSString * const kLocationAction	= @"Location";
NSString * const kRegionAction		= @"Region";
NSString * const kLinesPage			= @"/LineProperties";
NSString * const kOkodePage			= @"/OkodeInfo";
NSString * const kOkodeMail			= @"/OkodeMail";
NSString * const kOkodeMap			= @"/OkodeMap";
NSString * const kOkodeWeb			= @"/OkodeWeb";
NSString * const kMobFacebook		= @"/MobitransitFacebook";
NSString * const kMobRate			= @"/MobitransitRate";
NSString * const kServerError		= @"/ServerError";
NSString * const kConnectError		= @"/ConnectError";
NSString * const kMobPrefix			= @"mobitransitHelsinki";
NSString * const kMobVersion		= @"Version 1.0 "CURRENT_SVN_REVISION;

NSString * const kMobitransitId		= @"412630444";
