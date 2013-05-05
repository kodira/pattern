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
	                    visible: slider.visible
	                    imageSource: "images/effect1.png"
	                    overlapTouchPolicy: OverlapTouchPolicy.Allow
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Fill
                    }

                    ImageView {
                        id: imgOverlay2
                        visible: slider.visible
                        imageSource: "images/effect2.png"
                        overlapTouchPolicy: OverlapTouchPolicy.Allow
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Fill
                    }

                    ImageView {
                        id: imgOverlay3
                        visible: slider.visible
                        imageSource: "images/effect3.png"
                        overlapTouchPolicy: OverlapTouchPolicy.Allow
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Fill
                    }

                    ImageView {
                        id: imgOverlay4
                        visible: slider.visible
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
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            background: Color.create(0, 0, 0, 0.5)

                            horizontalAlignment: HorizontalAlignment.Center
                            verticalAlignment: VerticalAlignment.Top

                            Button {
                                text: "Cancel"
                                onClicked: editSheet.close()
                            }

                            Button {
                                text: "Save"
                                onClicked: {
                                    activityIndicator.start() // Currently not working probably because applyEffect() is blocking
                                    app.applyEffect(img2.viewableArea,
                                        	img2.contentScale,
                                        	imgOverlay1.opacity,
                                        	imgOverlay2.opacity,
                                        	imgOverlay3.opacity,
                                        	imgOverlay4.opacity)
                                    activityIndicator.stop()
                                    editSheet.close()
                                }
                            }
                        }

						Container {
                            layout: StackLayout {}
                            background: Color.create(0, 0, 0, 0.5)
                            horizontalAlignment: HorizontalAlignment.Fill
                            verticalAlignment: VerticalAlignment.Bottom
                            leftPadding: 40
                            rightPadding: 40

                            Slider {
	                            id: slider
	                            visible: tBut1.checked || tBut2.checked || tBut3.checked || tBut4.checked
	                            fromValue: 0
	                            toValue: 1
	                            value: 0.5
	                            horizontalAlignment: HorizontalAlignment.Fill
	                            topPadding: 20
	                            onImmediateValueChanged: {
	                                if (tBut1.checked) {
	                                    imgOverlay1.opacity = immediateValue
	                                    return
	                                }
	                                if (tBut2.checked) {
	                                    imgOverlay2.opacity = immediateValue
	                                    return
	                                }
	                                if (tBut3.checked) {
	                                    imgOverlay3.opacity = immediateValue
	                                    return
	                                }
	                                if (tBut4.checked) {
	                                    imgOverlay4.opacity = immediateValue
	                                    return
	                                }
                             	}
	                        }
	
	                        Container {
	                            layout: StackLayout {
	                                orientation: LayoutOrientation.LeftToRight
	                            }
	                            
	                            topPadding: 20
	                            bottomPadding: 20
	
	                            horizontalAlignment: HorizontalAlignment.Fill
	
	                            ImageToggleButton {
	                                id: tBut1
	                                imageSourceDefault: "images/toggle_unchecked.png"
	                                imageSourceChecked: "images/toggle_checked.png"
	                                rightMargin: 50
	                                onCheckedChanged: {
	                                    if (checked) {
	                                        tBut2.checked = false
	                                        tBut3.checked = false
	                                        tBut4.checked = false
	                                        slider.value = imgOverlay1.opacity
	                                    }
	                                }
	                            }
	                            
	                            ImageToggleButton {
	                                id: tBut2
	                                imageSourceDefault: "images/toggle_unchecked.png"
	                                imageSourceChecked: "images/toggle_checked.png"
	                                rightMargin: 50
	                                onCheckedChanged: {
	                                    if (checked) {
	                                        tBut1.checked = false
	                                        tBut3.checked = false
	                                        tBut4.checked = false
                                            slider.value = imgOverlay2.opacity
                                        }
	                                }
	                            }
	                            
	                            ImageToggleButton {
	                                id: tBut3
	                                imageSourceDefault: "images/toggle_unchecked.png"
	                                imageSourceChecked: "images/toggle_checked.png"
	                                rightMargin: 50
	                                onCheckedChanged: {
	                                    if (checked) {
	                                        tBut1.checked = false
	                                        tBut2.checked = false
	                                        tBut4.checked = false
                                            slider.value = imgOverlay3.opacity
                                        }
	                                }
	                            }
	                            
	                            ImageToggleButton {
	                                id: tBut4
	                                imageSourceDefault: "images/toggle_unchecked.png"
	                                imageSourceChecked: "images/toggle_checked.png"
	                                rightMargin: 50
	                                onCheckedChanged: {
	                                    if (checked) {
	                                        tBut1.checked = false
	                                        tBut2.checked = false
	                                        tBut3.checked = false
                                            slider.value = imgOverlay4.opacity
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
