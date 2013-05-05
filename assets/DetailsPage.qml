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
        /* Doesn't work currently
        ActionItem {
            title: qsTr("Share")
            imageSource: "asset:///images/share.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: app.shareWallpaper()
        },
        */
        
        ActionItem {
            title: qsTr("Edit")
            imageSource: "asset:///images/edit.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                editSheet.open()
            }
        },
        
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
                img.visible = true
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
    
    attachedObjects: [
        Sheet {
            id: editSheet

            content: Page {
                
                titleBar: TitleBar {
                    title: qsTr("Edit")
                    
                    acceptAction: ActionItem {
                        title: qsTr("Save")
                        onTriggered: {
                            activityIndicator.start() // Currently not working probably because applyEffect() is blocking

                            var o1 = imgOverlay1.visible ? imgOverlay1.opacity : 0
                            var o2 = imgOverlay2.visible ? imgOverlay2.opacity : 0
                            var o3 = imgOverlay3.visible ? imgOverlay3.opacity : 0
                            var o4 = imgOverlay4.visible ? imgOverlay4.opacity : 0

                            app.applyEffect(img2.viewableArea, img2.contentScale, o1, o2, o3, o4)
                            activityIndicator.stop()
                            editSheet.close()
                        }
                    }
                    
                    dismissAction: ActionItem {
                        title: qsTr("Cancel")
                        onTriggered: editSheet.close()
                    }
                }

                Container {
                    layout: DockLayout {}
	                
	                ScrollView {
	                    id: img2
	                    horizontalAlignment: HorizontalAlignment.Fill
	                    verticalAlignment: VerticalAlignment.Fill
	
	                    scrollViewProperties {
	                        scrollMode: ScrollMode.Both
	                        pinchToZoomEnabled: true
	                        minContentScale: 1.0
	                        maxContentScale: 4.0
	                    }
	
	                    ImageView {
	                        image: app.bigImage
	                    }
	                }
	                
	                ImageView {
	                    id: imgOverlay1
	                    visible: ckBut1.checked
	                    opacity: 0.5
	                    imageSource: "images/effect1.png"
	                    overlapTouchPolicy: OverlapTouchPolicy.Allow
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Fill
                    }

                    ImageView {
                        id: imgOverlay2
                        visible: ckBut2.checked
                        opacity: 0.5
                        imageSource: "images/effect2.png"
                        overlapTouchPolicy: OverlapTouchPolicy.Allow
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Fill
                    }

                    ImageView {
                        id: imgOverlay3
                        visible: ckBut3.checked
                        opacity: 0.5
                        imageSource: "images/effect3.png"
                        overlapTouchPolicy: OverlapTouchPolicy.Allow
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Fill
                    }

                    ImageView {
                        id: imgOverlay4
                        visible: ckBut4.checked
                        opacity: 0.5
                        imageSource: "images/effect4.png"
                        overlapTouchPolicy: OverlapTouchPolicy.Allow
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Fill
                    }

                    // UI-Controls
					Container {
						layout: DockLayout {}
						horizontalAlignment: HorizontalAlignment.Fill
						verticalAlignment: VerticalAlignment.Fill
                        overlapTouchPolicy: OverlapTouchPolicy.Allow

						Container {
                            layout: DockLayout {}
                            horizontalAlignment: HorizontalAlignment.Fill
                            verticalAlignment: VerticalAlignment.Bottom
                            preferredHeight: 280

                            Slider {
	                            id: slider
	                            visible: ckBut1.active || ckBut2.active || ckBut3.active || ckBut4.active
	                            fromValue: 0
	                            toValue: 1
	                            value: 0.5
	                            horizontalAlignment: HorizontalAlignment.Fill
	                            verticalAlignment: VerticalAlignment.Top
	                            
	                            onImmediateValueChanged: {
	                                if (ckBut1.active) {
	                                    imgOverlay1.opacity = immediateValue
	                                    return
	                                }
	                                if (ckBut2.active) {
	                                    imgOverlay2.opacity = immediateValue
	                                    return
	                                }
	                                if (ckBut3.active) {
	                                    imgOverlay3.opacity = immediateValue
	                                    return
	                                }
	                                if (ckBut4.active) {
	                                    imgOverlay4.opacity = immediateValue
	                                    return
	                                }
                             	}
	                        }
                            
                            Container {
                                layout: DockLayout {}
                                horizontalAlignment: HorizontalAlignment.Fill
                                verticalAlignment: VerticalAlignment.Bottom

                                Container {
                                    layout: DockLayout {}
                                    horizontalAlignment: HorizontalAlignment.Fill
	                                verticalAlignment: VerticalAlignment.Fill
	                                topPadding: 40 // Margin not possible here so we add this container with extra padding
	                                
	                                Container {
                                        background: Color.create("#ff252525")
                                        horizontalAlignment: HorizontalAlignment.Fill
                                        verticalAlignment: VerticalAlignment.Fill
                                    }
	                            }
		
		                        Container {
		                            layout: StackLayout {
		                                orientation: LayoutOrientation.LeftToRight
		                            }
	                                horizontalAlignment: HorizontalAlignment.Fill
	                                verticalAlignment: VerticalAlignment.Bottom
	
	                                CheckButton {
	                                    id: ckBut1
	                                    text: qsTr("Noise")
	                                	onActiveChanged: {
	                                    	if (active) {
	                                    	    ckBut2.active = false
	                                    	    ckBut3.active = false
	                                    	    ckBut4.active = false
	                                            slider.value = imgOverlay1.opacity
	                                        }
	                                    }
	                                }
	
	                                CheckButton {
	                                    id: ckBut2
	                                    text: qsTr("Vignetting")
	                                    onActiveChanged: {
	                                        if (active) {
	                                            ckBut1.active = false
	                                            ckBut3.active = false
	                                            ckBut4.active = false
	                                            slider.value = imgOverlay2.opacity
	                                        }
	                                    }
	                                }
	
	                                CheckButton {
	                                    id: ckBut3
	                                    text: qsTr("Fills")
	                                    onActiveChanged: {
	                                        if (active) {
	                                            ckBut1.active = false
	                                            ckBut2.active = false
	                                            ckBut4.active = false
	                                            slider.value = imgOverlay3.opacity
	                                        }
	                                    }
	                                }
	
	                                CheckButton {
	                                    id: ckBut4
	                                    text: qsTr("Outlines")
	                                    onActiveChanged: {
	                                        if (active) {
	                                            ckBut1.active = false
	                                            ckBut2.active = false
	                                            ckBut3.active = false
	                                            slider.value = imgOverlay4.opacity
	                                        }
	                                    }
	                                }
		                        }
	                        }
	                    }
		            }

                    ActivityIndicator {
                        id: activityIndicator
                        running: false
                        visible: running
                        preferredWidth: 200.0
                        preferredHeight: 200.0
                        horizontalAlignment: HorizontalAlignment.Center
                        verticalAlignment: VerticalAlignment.Center
                    }
                }
            }
        }
    ]
}
