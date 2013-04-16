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
    
    /* Currently scrolling does not work if TitleBar is used with 10.1.138
     * https://www.blackberry.com/jira/browse/BBTEN-1142
     * 
    titleBar: TitleBar {
        title : "Pattern and Color Wallpapers"
        branded: TriBool.False
    }
    */
    
    ScrollView {

        Container {
	        layout: StackLayout {}
	        
	        leftPadding: 10
	        rightPadding: 10

            Label {
                text: "Pattern and Color Wallpapers"
                textStyle.fontSize: FontSize.Large
            }

            ImageView {
                imageSource: "asset:///images/kodira.png"
                minHeight: 150
                maxHeight: 150
                minWidth: 150
                maxWidth: 150
                topMargin: 20
                horizontalAlignment: HorizontalAlignment.Center
            }

            Label {
                multiline: true
                // TODO: Add link to github.
                text: qsTr("Pattern lets you set your wallpaper to beautiful patterns and colors. Written by Cornelius Hald during Kodira's Open-Source-Friday.\n\nPattern is open-source software licensed under GPLv3 and uses the COLOURlovers.com API. All patterns are licensed under CC-BY-NC-SA.")
            }

            Container {
                topPadding: 20
                horizontalAlignment: HorizontalAlignment.Left
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }

                Button {
                    text: qsTr("Website")
                    onClicked: invoke.trigger("bb.action.OPEN")

                    attachedObjects: [
                        Invocation {
                            id: invoke
                            query: InvokeQuery {
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
                            query: InvokeQuery {
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
