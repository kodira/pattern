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

Sheet {
    id: root
    
    property bool canceled: false
    property alias viewableArea: mainImg.viewableArea
    property alias contentScale: mainImg.contentScale
    property alias o1: imgOverlay1.opacity
    property alias o2: imgOverlay2.opacity
    property alias o3: imgOverlay3.opacity
    property alias o4: imgOverlay4.opacity
    
    // Function to restore the previous state
    // Currently a bit slow due to image loading.
    function restoreState(viewableArea, contentScale, o1, o2, o3, o4) {
        if (o1 > 0) {
            imgOverlay1.opacity = o1
            ckBut1.checked = true
        }
        
        if (o2 > 0) {
            imgOverlay2.opacity = o2
            ckBut2.checked = true
        }
        
        if (o3 > 0) {
            imgOverlay3.opacity = o3
            ckBut3.checked = true
        }
        
        if (o4 > 0) {
            imgOverlay4.opacity = o4
            ckBut4.checked = true
        }

		// Works somehow but is not very precise
        mainImg.zoomToRect(viewableArea, ScrollAnimation.None)
    }

    content: Page {

        titleBar: TitleBar {
            title: qsTr("Edit")

            acceptAction: ActionItem {
                title: qsTr("Apply")
                onTriggered: {
                    activityIndicator.start() // Currently not working probably because applyEffect() is blocking
                    app.applyEffect(viewableArea, contentScale, o1, o2, o3, o4)
                    activityIndicator.stop()
                    root.close()
                }
            }

            dismissAction: ActionItem {
                title: qsTr("Cancel")
                onTriggered: {
                    root.canceled = true
                    root.close()
                }
            }
        }

        Container {
            layout: DockLayout {}

            ScrollView {
                id: mainImg
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill

                scrollViewProperties {
                    scrollMode: ScrollMode.Both
                    pinchToZoomEnabled: true
                    minContentScale: 1.0
                    maxContentScale: 3.5 // Higher zoom gets too ugly
                }

				Container {
				    // This container is here to give the image a fixed size.
				    // Needed, because the image takes some time to load so height and width are
				    // not reliable. But in restoreState() we need fixed sizes.
				    minWidth: app.displayWidth
                    minHeight: app.displayHeight
                    maxWidth: minWidth
				    maxHeight: minHeight
				
	                ImageView {
                        implicitLayoutAnimationsEnabled: false
                        image: app.editImage
	                }
                }
            }

            ImageView {
                id: imgOverlay1
                visible: ckBut1.checked
                opacity: visible ? 0.5 : 0
                imageSource: "images/effect1.png"
                overlapTouchPolicy: OverlapTouchPolicy.Allow
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
            }

            ImageView {
                id: imgOverlay2
                visible: ckBut2.checked
                opacity: visible ? 0.5 : 0
                imageSource: "images/effect2.png"
                overlapTouchPolicy: OverlapTouchPolicy.Allow
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
            }

            ImageView {
                id: imgOverlay3
                visible: ckBut3.checked
                opacity: visible ? 0.5 : 0
                imageSource: "images/effect3.png"
                overlapTouchPolicy: OverlapTouchPolicy.Allow
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
            }

            ImageView {
                id: imgOverlay4
                visible: ckBut4.checked
                opacity: visible ? 0.5 : 0
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
