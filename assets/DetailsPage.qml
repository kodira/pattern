/*
 * Copyright (C) 2013 Cornelius Hald <cornelius.hald@kodira.de>
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

    actionBarVisibility: ChromeVisibility.Overlay

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
        
        ActionItem {
            // Those properties are used persist data while EditSheet is destroyed
            property bool savedState: false
            property variant viewableArea
            property real contentScale
            property real o1
            property real o2
            property real o3
            property real o4

            title: qsTr("Edit")
            imageSource: "asset:///images/edit.png"
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                app.resetEditImage()
                var editSheet = editSheetDefinition.createObject()
                editSheet.open()
                
                // If we have a saved state, restore it
                if (savedState) {
                	editSheet.restoreState(viewableArea, contentScale, o1, o2, o3, o4)
                }
                
                // If the sheet gets closed. Save the state and destroy it
                editSheet.closed.connect(function() {
                    if (!editSheet.canceled) {
	                    savedState = true
	                    viewableArea = editSheet.viewableArea
                        contentScale = editSheet.contentScale
                        o1 = editSheet.o1
	                    o2 = editSheet.o2
	                    o3 = editSheet.o3
	                    o4 = editSheet.o4
                    }
                    console.log("INFO: Destroying sheet: " + editSheet)
                    editSheet.destroy()
                })
            }
        },
        
        // TODO: Is it possible to write to protected_media/wallpapers? probably not, but check.
        // We could do "Export to Wallpapers".
        ActionItem {
            title: qsTr("Save")
            imageSource: "asset:///images/save.png"
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: app.saveWallpaper(pattern.id)
        },
        
        ActionItem {
            title: qsTr("Share")
            imageSource: "asset:///images/share.png"
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: app.shareWallpaper()
        }//,

        /* Should open image in image viewer - but does not find a target currently. Gold SDK */
        
//        ActionItem {
//            title: "Open in editor"
//            imageSource: "asset:///images/share.png"
//            ActionBar.placement: ActionBarPlacement.OnBar
//            onTriggered: app.openWallpaper()
//        }
        
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
                img.visible = true
            }
        }
        
        Container {
            background: Color.Black
            opacity: 0.5
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Top
            preferredHeight: containerLayout.layoutFrame.height
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
    
    attachedObjects: [
        ComponentDefinition {
            id: editSheetDefinition
            source: "EditSheet.qml"
        }
    ]
}
