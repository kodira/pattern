/*
 * Copyright (C) 2012 Cornelius Hald <cornelius.hald@kodira.de>
 *
 * This file is part of Pattern.
 *
 * Pattern is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Pattern is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Pattern. If not, see <http://www.gnu.org/licenses/>.
 */

import bb.cascades 1.0
import de.kodira 1.0
    
Container {
    id: root
    
    property bool initialized: false
    property bool isFooter: false
    property bool isLoading: false

    layout: DockLayout {}
    //horizontalAlignment: HorizontalAlignment.Fill // Does not work
    preferredWidth: 768
    preferredHeight: 200
    
    RemoteImageView {
        id: image
        visible: !(isLoading && isFooter)
        // If not initialized the item might be currently in a recycled state - we should not show the image
        url: root.initialized ? ListItemData.patternUrl : ""
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        
        attachedObjects: [
	        LayoutUpdateHandler {
	            onLayoutFrameChanged: {
	                image.preferredWidth = layoutFrame.width
	                image.preferredHeight = layoutFrame.height
	            }
	        }
        ]
    }
    
    Container {
        preferredHeight: containerLayout.layoutFrame.height
        background: Color.Black
        opacity: 0.5
        verticalAlignment: VerticalAlignment.Bottom
        horizontalAlignment: HorizontalAlignment.Fill
    }
    
    Container {
        layout: DockLayout {}
        verticalAlignment: VerticalAlignment.Bottom
        horizontalAlignment: HorizontalAlignment.Fill
        leftPadding: 20
        rightPadding: 20
        topPadding: 10
        bottomPadding: 10

        attachedObjects: [
            LayoutUpdateHandler {
                id: containerLayout
            }
        ]

        Label {
            visible: !isLoading
            text: ListItemData.title + " " + qsTr("by") + " " + ListItemData.userName
            textStyle.fontWeight: FontWeight.Bold
            textStyle.fontSize: FontSize.Medium
            textStyle.color: Color.White
            horizontalAlignment: HorizontalAlignment.Left
            verticalAlignment: VerticalAlignment.Bottom
        }
        
        Label {
            visible: isFooter && isLoading
            text: qsTr("Loading more patterns...")
            textStyle.fontWeight: FontWeight.Bold
            textStyle.fontSize: FontSize.Medium
            textStyle.color: Color.White
            horizontalAlignment: HorizontalAlignment.Left
            verticalAlignment: VerticalAlignment.Bottom
        }
    }
    
    Container {
        layout: DockLayout {}
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        bottomPadding: 70
        
	    ActivityIndicator {
	        running: initialized && image.loading != 1
	        visible: running
	        preferredWidth: 100
	        preferredHeight: 100
	        horizontalAlignment: HorizontalAlignment.Center
	        verticalAlignment: VerticalAlignment.Center
	    }
	}
    
    Container {
        id: listItemTouchOverlay
        background: Color.Black
        opacity: 0
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
    }
    
    onTouch: {
        if (isLoading) {
            return;
        }
        
        // convert to select case
        if (event.touchType == TouchType.Down) {
            listItemTouchOverlay.opacity = 0.5;
        } else if (event.touchType == TouchType.Up || event.touchType == TouchType.Cancel) {
            listItemTouchOverlay.opacity = 0;
        }
    }
    
    // Overlay that is only visible if this item is used as footer item
    /*
    Container {
        visible: isFooter && isLoading
        //background: Color.create("#333333")
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        layout: DockLayout {}
        ActivityIndicator {
            running: parent.visible
	        preferredWidth: 100
	        preferredHeight: 100
            horizontalAlignment: HorizontalAlignment.Center
	        verticalAlignment: VerticalAlignment.Center   
        }
        
        Label {
            text: qsTr("Loading more patterns")
            textStyle.fontWeight: FontWeight.Bold
            textStyle.fontSize: FontSize.Medium
            textStyle.color: Color.White
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Bottom
        }
    }
    */
}

