//
// Copyright 2011 Jeff Verkoeyen
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "NICellFactory.h"
#import "PDBorderTableViewCell.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NICellFactory


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UITableViewCell *)tableViewModel: (NITableViewModel *)tableViewModel
                   cellForTableView: (UITableView *)tableView
                        atIndexPath: (NSIndexPath *)indexPath
                         withObject: (id)object {
  UITableViewCell* cell = nil;

  // Only NICellObject-conformant objects may pass.
  if ([object respondsToSelector:@selector(cellClass)]) {
    Class cellClass = [object cellClass];
    NSString* identifier = NSStringFromClass(cellClass);
    
    // DISABLED DEQUEUE BECAUSE OF BORDERS FOR NOW
    /* 
     nimbus cell factory uses the cell class name as dequeue identifier. that means that
     if i want to use dequeuing, every type of cell (backgroundcolor / border setting) needs to be a class of it's own.
     that is not the case currently, because in the tableViewController, i add background and border setting after the factory returned a dequeued cell.
     that means that those changes are made to all the cells and not just the one i want to.
     possible solutions:
     - make one cell class for every style
     - clean up cell in prepareForReuse method
     - disable dequeuing in nimbus cell factory
    */
    //cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (nil == cell) {
      UITableViewCellStyle style = UITableViewCellStyleDefault;
      if ([object respondsToSelector:@selector(cellStyle)]) {
        style = [object cellStyle];
      }
      cell = [[[cellClass alloc] initWithStyle:style reuseIdentifier:identifier] autorelease];
    }
      
    else{
        //cell was dequeued
        DLog(@"\n--- cell was dequeued with identifier: %@ ---",identifier);
    }

    // Allow the cell to configure itself with the object's information.
      
      //first see if cell is a PDBorderTableViewCell:
      if ([cell respondsToSelector:@selector(shouldUpdateCellWithObject:andIndexPath:andCellRect:)]) {
          [(id)cell shouldUpdateCellWithObject:object andIndexPath:indexPath andCellRect:[tableView rectForRowAtIndexPath:indexPath]];
      }
      //if not, call normal NICell Method
      else if ([cell respondsToSelector:@selector(shouldUpdateCellWithObject:)]) {
          [(id<NICell>)cell shouldUpdateCellWithObject:object];
    }
  }

  return cell;
}


@end
