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
    titleBar: TitleBar {
        title : "Pattern and Color Wallpapers"
    }
    
    ScrollView {
        Container {
            layout: StackLayout {}
            leftPadding: 40
            rightPadding: 40
            topPadding: 40
            bottomPadding: 40

            ImageView {
                imageSource: "asset:///images/kodira.png"
                horizontalAlignment: HorizontalAlignment.Center
            }

            Label {
                multiline: true
                // TODO: Add link to github.
                text: qsTr("Pattern lets you set your wallpaper to beautiful patterns and colors. Written by Cornelius Hald during Kodira's Open-Source-Friday.\n\nPattern is open-source software licensed under GPLv3 and uses the COLOURlovers.com API. All patterns are licensed under CC-BY-NC-SA.")
            }

            Container {
                topPadding: 20

                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }

                Button {
                    text: qsTr("Website")
                    onClicked: invoke.trigger("bb.action.OPEN")

                    attachedObjects: [
                        Invocation {
                            id: invoke
                            query {
                                invokeTargetId: "sys.browser"
                                uri: "http://kodira.de"
                            }
                        }
                    ]
                }

                Button {
                    text: qsTr("More Apps")
                    onClicked: invoke2.trigger("bb.action.OPEN")

                    attachedObjects: [
                        Invocation {
                            id: invoke2
                            query {
                                invokeTargetId: "sys.appworld"
                                uri: "appworld://vendor/41217"
                            }
                        }
                    ]
                }
            }
        }
    }
}
