//
//  NewslettersController.m
//  Mobitransit
//
//  Created by Daniel Soro Coicaud on 29/03/11.
//  Copyright 2011 Okode. All rights reserved.
//

#import "NewslettersController.h"
#import "NewsCell.h"

@implementation NewslettersController

@synthesize delegate;
@synthesize newsletters;
@synthesize targetedLines;
@synthesize disruptions;
@synthesize adviceText;
@synthesize newAdvices;
@synthesize showingAdvices;
@synthesize unreadNewsletter;

- (void)dealloc {
    [newsletters release];
    [targetedLines release];
    [disruptions release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)requestNews{
    NSData *xmlInfo = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
	if([[languages objectAtIndex:0] isEqualToString:@"fi"]){
        //xmlInfo = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://dl.dropbox.com/u/3351117/okode/mobitransit/newsletters/fi.xml"]];
        xmlInfo = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.poikkeusinfo.fi/xml/v2/fi"]];
    }else{
        //xmlInfo = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://dl.dropbox.com/u/3351117/okode/mobitransit/newsletters/en.xml"]];
        xmlInfo = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.poikkeusinfo.fi/xml/v2/en"]];
    }
    adviceText = NO;
    newAdvices = NO;
    showingAdvices = NO;
    unreadNewsletter = 0;
    
    if(xmlInfo){
        NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:xmlInfo] autorelease];
	
        [parser setDelegate:self]; 
        [parser setShouldProcessNamespaces:NO]; 
        [parser setShouldReportNamespacePrefixes:NO]; 
        [parser setShouldResolveExternalEntities:NO]; 
        [parser parse]; 
    }
}

-(void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(newsletters)
        return [newsletters count];
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    NewsCell *cell = (NewsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if(newsletters){
        [cell.textView setText:[newsletters objectAtIndex:[indexPath row]]];
        if(showingAdvices){
            [cell.line setText:[targetedLines objectAtIndex:[indexPath row]]];
            [cell.imgDecor setImage:[UIImage imageNamed:@"bgnum-warning.png"]];
        }else{
            [cell.line setText:nil];
            [cell.imgDecor setImage:nil];
        }
    }else{
        [cell.textView setText:NSLocalizedString(@"LOADING",@"")];
        [cell.line setText:@"!"];
        [cell.imgDecor setImage:[UIImage imageNamed:@"bgnum-warning.png"]];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if([elementName isEqualToString:@"TEXT"]){
        adviceText = YES;
    }
    if([elementName isEqualToString:@"INFO"]){
    }
    if([elementName isEqualToString:@"VALIDITY"]){
        adviceText = [[attributeDict objectForKey:@"status"] boolValue];
    }
    if([elementName isEqualToString:@"LINE"]){
        [targetedLines addObject:[attributeDict objectForKey:@"id"]];
    }
    if([elementName isEqualToString:@"DISRUPTIONS"]){
        int nAdvices = [[attributeDict objectForKey:@"valid"] intValue];
        if(nAdvices == 0) {
            newsletters = [[NSMutableArray alloc] initWithCapacity:1];  
            targetedLines = nil;
            disruptions = nil;
            showingAdvices = NO;
        }else{
            newsletters = [[NSMutableArray alloc] initWithCapacity:nAdvices];
            targetedLines = [[NSMutableArray alloc] initWithCapacity:nAdvices];
            disruptions = [[NSMutableArray alloc] initWithCapacity:nAdvices];
            showingAdvices = YES;
        }
    }
    if([elementName isEqualToString:@"DISRUPTION"]){
        [disruptions addObject:[attributeDict objectForKey:@"id"]];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if(adviceText){
        NSString *result = nil;
        if([string length] > 120){
            result = [NSString stringWithFormat:@"%@...",[string substringToIndex:120]];
        }else{
            result = string;
        }
        [newsletters addObject:result];
    }
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"TEXT"]){
    }
    if([elementName isEqualToString:@"INFO"]){
        adviceText = NO;
    }
    if([elementName isEqualToString:@"DISRUPTIONS"]){        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *lastDisruptions = [prefs objectForKey:@"Helsinki_Disruptions"];
        NSArray *readedDisruptions = [lastDisruptions componentsSeparatedByString: @";"];
        NSString *newDisruptions = [[[NSString alloc] initWithString:@"Disruptions;"] autorelease];

        for(NSString *nDis in disruptions){
            BOOL readed = NO;
            for(NSString *rDis in readedDisruptions){
                if([nDis isEqualToString:rDis]){readed = YES;break;}
            }
            if(!readed){
                unreadNewsletter++;
                [self setNewAdvices:YES];
            }
            newDisruptions = [newDisruptions stringByAppendingFormat:@"%@;",nDis];
        }
        [prefs setObject:newDisruptions forKey:@"Helsinki_Disruptions"];
        [delegate updateInfoBadgeValue];
        NSLog(@"Advices readed!");
    }
}



@end
