#import "ClassesController.h"
#import "ExplorerAppDelegate.h"
#import <objc/objc.h>
#import <objc/runtime.h>

const int kMaxClasses = 10000;
NSMutableArray *objCClasses;

@implementation ClassesController

+ (void)initialize {
  Class *clsList = malloc(sizeof(Class) * kMaxClasses);
  
  if(!clsList) {
    NSLog(@"Couldn't allocate space for %d classes", kMaxClasses);
    exit(1);
  }
  
  int numClasses = objc_getClassList(clsList, kMaxClasses);
  int i;
  
  objCClasses = [NSMutableArray arrayWithCapacity:27];
  
  [objCClasses addObject:[NSMutableArray new]];  
  for(i = 0; i < 26; i++) {
    [objCClasses addObject:[NSMutableArray new]];
  }
  
  for(i = 0; i < numClasses; i++) {
    char *name = class_getName(clsList[i]);
    NSString *str = [NSString stringWithCString:name];
    
    if(name[0] >= 'A' && name[0] <= 'Z')
      [[objCClasses objectAtIndex:((name[0] - 'A') + 1)] addObject:str];
    else
      [[objCClasses objectAtIndex:0] addObject:str];
  }
  
  NSMutableArray *sorted = [NSMutableArray new];
  NSMutableArray *subArray;
  for(subArray in objCClasses) {
    [sorted addObject:[subArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
  }
  
  free(clsList);
  
  objCClasses = sorted;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[objCClasses objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return objCClasses.count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  return [NSArray arrayWithObjects:@"*", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K",
                                   @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W",
                                   @"X", @"Y", @"Z", nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
  static NSString *MyIdentifier = @"MyIdentifier";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if(!cell)
      cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
  
  [cell setText:[[objCClasses objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
  
  return cell;
}

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *clsName = [[objCClasses objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  MethodListController *mlc = [[MethodListController alloc] initWithClassNamed:clsName];
  [self.navigationController pushViewController:mlc animated:YES];
  [mlc release];
}

- (void)awakeFromNib {
  self.title = @"Classes";
}

@end

