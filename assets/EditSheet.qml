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
                    root.close()
                }
            }

            dismissAction: ActionItem {
                title: qsTr("Cancel")
                onTriggered: root.close()
            }
        }

        Container {
            layout: DockLayout {
            }

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
                layout: DockLayout {
                }
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                overlapTouchPolicy: OverlapTouchPolicy.Allow

                Container {
                    layout: DockLayout {
                    }
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
                        layout: DockLayout {
                        }
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Bottom

                        Container {
                            layout: DockLayout {
                            }
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
