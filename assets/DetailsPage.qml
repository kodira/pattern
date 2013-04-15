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

Page {
    id: root
    property variant pattern
    
    function loadPattern() {
        indicator.running = true
        app.createBigImage(pattern.patternUrl)
    }
    
    // Looks like this page gets recycled. Therefore we need to hide the image here again.
    onCreationCompleted: {
        img.visible = false
    }
    
    actions: [ 
        ActionItem {
            title: qsTr("As Wallpaper")
            imageSource: "asset:///images/photos.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: app.setWallpaper()
        },
        /* Doesn't work currently
        ActionItem {
            title: qsTr("Share")
            imageSource: "asset:///images/share.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: app.shareWallpaper()
        },
        */
        InvokeActionItem {
            ActionBar.placement: ActionBarPlacement.OnBar
                        
            query {
                invokeActionId: "bb.action.SHARE"
                mimeType: "image/png"
                // This is a hack. We need the full absolute path and can only get them from C++
                uri: app.wallpaperUrl()
	        }
	        onTriggered: {
		        // On clicked we create the wallpaper as file
		        app.createWallpaperForSharing()
	        }
        }//,
        /* Should open image in image viewer - but does not find a target currently.
           Gold SDK
        InvokeActionItem {
            ActionBar.placement: ActionBarPlacement.InOverflow
            title: qsTr("Open in image viewer")
            query {
                invokeActionId: "bb.action.OPEN"
                mimeType: "image/png"
                uri: app.wallpaperUrl()
	        }
	        onTriggered: {
		        app.createWallpaperForSharing()
	        }
        }
        */
    ]
            
    Container {
        layout: DockLayout {}
        
        ImageView {
            id: img
            visible: false
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            image: app.bigImage
            
            onImageChanged: {
                indicator.running = false
                visible = true
            }
        }
        
        Container {
            background: Color.Black
            opacity: 0.5
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Top
            preferredHeight: containerLayout.layoutFrame.height
            //preferredWidth: containerLayout.layoutFrame.width
        }
        
        Container {
            layout: StackLayout {}
            topPadding: 15
            bottomPadding: 25
            leftPadding: 20
            rightPadding: 20

            attachedObjects: [
                LayoutUpdateHandler {
                    id: containerLayout
                }
            ]

            Label {
                text: root.pattern ? root.pattern.title : ""
                textStyle.fontWeight: FontWeight.Bold
                textStyle.fontSize: FontSize.Medium
                textStyle.color: Color.White
            }
            
            Label {
                text: qsTr("by") + " " + (root.pattern ? root.pattern.userName : "")
                textStyle.fontWeight: FontWeight.Bold
                textStyle.fontSize: FontSize.Small
                textStyle.color: Color.White
            }
        }
        
        ActivityIndicator {
            id: indicator
            running: false
            visible: running
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
        }
    }
}
