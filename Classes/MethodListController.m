#import "MethodListController.h"
#import <objc/runtime.h>

@implementation MethodListController

@synthesize instanceMethods;
@synthesize classMethods;
@synthesize ivars;
@synthesize protocols;
@synthesize cls;
@synthesize tableView;

enum sections {
  s_superclass,
  s_protocols,
  s_ivars,
  s_cmeths,
  s_imeths
};

- (NSString *)title {
  return cls;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 40;
}

- (NSString *)superclassName {
  return [[theCls superclass] description];
}

- (id)initWithClassNamed:(NSString *)name {
  self = [self initWithNibName:@"MethodListController" bundle:nil];
  [self setCls:name];
  return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch(section) {
    case s_superclass:
      return [self superclassName] != nil;
    case s_protocols:
      return protocols.count;
    case s_ivars:
      return ivars.count;
    case s_cmeths:
      return classMethods.count;
    case s_imeths:
      return instanceMethods.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  switch (section) {
    case s_superclass:
      return @"Superclass";
    case s_protocols:
      return @"Implemented protocols";
    case s_ivars:
      return @"Instance variables";
    case s_cmeths:
      return @"Class methods";
    case s_imeths:
      return @"Instance methods";
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
  UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
  
  NSArray *array = nil;
  
  switch (indexPath.section) {
    case s_superclass:
      array = [NSArray arrayWithObject:[self superclassName]];
      break;
    case s_protocols:
      array = protocols; break;
    case s_ivars:
      array = ivars; break;
    case s_cmeths:
      array = classMethods; break;
    case s_imeths:
      array = instanceMethods; break;
  }
   
  [cell setText:[array objectAtIndex:indexPath.row]];
     
  return cell;
}

- (void)viewWillAppear:(BOOL)animated {
  if([tableView indexPathForSelectedRow]) {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
  }
  
  if([theCls instancesRespondToSelector:@selector(initWithFrame:)])
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Draw"
                                                                      style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(drawView)];
}

- (void)drawView {  
  ThingerController *tc = [[ThingerController alloc] initWithNibName:@"ViewThinger" bundle:nil];
  @try {
    [tc setTheView:[[theCls alloc] initWithFrame:CGRectMake(20, 100, 50, 50)]];
    [self.navigationController pushViewController:tc animated:YES];
  } @catch (NSException *e) {
    [[UIAlertView alloc] initWithTitle:@"Drawing Error"
                         message:[e description]
                         delegate:self
                         cancelButtonTitle:@"Back"
                         otherButtonTitles:nil];
  }
  [tc release];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  return indexPath.section == s_superclass ? indexPath : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if(indexPath.section == s_superclass) {
    MethodListController *mlc = [[MethodListController alloc] initWithClassNamed:[self superclassName]];                                
    [self.navigationController pushViewController:mlc animated:YES];    
    [mlc release];
  }
}

- (void)setCls:(NSString *)c {
  cls = [c retain];
  theCls = objc_getClass([cls UTF8String]);
  
  int iMethods, cMethods, i;
  
  Method *iMethList = class_copyMethodList(theCls, &iMethods);
  Method *cMethList = class_copyMethodList(object_getClass(theCls), &cMethods);
  
  instanceMethods = [NSMutableArray new];
  for(i = 0; i < iMethods; i++) {
    [instanceMethods addObject:[NSString stringWithCString:sel_getName(method_getName(iMethList[i]))]];
  }
  [instanceMethods sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
  free(iMethList);
  
  classMethods = [NSMutableArray new];
  for(i = 0; i < cMethods; i++) {
    [classMethods addObject:[NSString stringWithCString:sel_getName(method_getName(cMethList[i]))]];
  }
  [classMethods sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
  free(cMethList);
  
  int protCount;
  Protocol **protLst = class_copyProtocolList(theCls, &protCount);
  protocols = [NSMutableArray new];  
  for(i = 0; i < protCount; i++) {
    [protocols addObject:[NSString stringWithCString:protocol_getName(protLst[i])]];
  }  
  free(protLst);
  
  ivars = [NSMutableArray new];
  int ivarCount;
  Ivar **ivarLst = class_copyIvarList(theCls, &ivarCount);
  for(i = 0; i < ivarCount; i++) {
    [ivars addObject:[NSString stringWithCString:ivar_getName(ivarLst[i])]];
  }  
  free(ivarLst);
}

- (void)dealloc {
  [instanceMethods dealloc];
  [classMethods dealloc];
  [ivars dealloc];
  [cls release];
  [super dealloc];
}

@end
