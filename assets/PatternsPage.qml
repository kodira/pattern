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
import "."

NavigationPane {
    id: root
    
    property string type: ""
    property variant model
    property variant searchModel
    
    onPopTransitionEnded: {
        // We need to destroy the details page here, because we always
        // create a new page once the user taps a pattern.
        if (page.objectName === "detailsPage") {
            console.log("INFO: DetailsPage destroyed")
            page.destroy()
        }
    }

    Page {
        
        titleBar: TitleBar {
            kind: TitleBarKind.FreeForm
            kindProperties: FreeFormTitleBarKindProperties {

                Container {
                    layout: StackLayout {
                    	orientation: LayoutOrientation.LeftToRight
                    }
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill
                    leftPadding: 10
                    rightPadding: 10
                   
                    SegmentedControl {
                        id: segmented1
                       
                        horizontalAlignment: HorizontalAlignment.Left
                        verticalAlignment: VerticalAlignment.Center
                       
                        Option {
                            text: qsTr("Top Rated")
                            value: "top"
                            selected: true
                        }
                       
                        Option {
                            text: qsTr("Newest")
                            value: "new"
                        }
                       
                        onSelectedIndexChanged: {
                            var value = segmented1.selectedValue
                            console.debug("Selected value: " + value)
                            root.model.category = value
                            if (searchContainer.showSearchResults) {
                                root.searchModel.category = value
                            }
                        }
                    }
                   
                    ImageToggleButton {
                        id: searchToggle
                        imageSourceDefault: "asset:///images/search.png"
                        imageSourceChecked: "asset:///images/search_checked.png"
                        horizontalAlignment: HorizontalAlignment.Right
                        verticalAlignment: VerticalAlignment.Center
                        minWidth: 81
                        minHeight: 81
                    }
                }
                            
	            expandableArea {
	                content: Container {
	                    id: searchContainer
	                    property bool showSearchResults: false
	                    
                        leftPadding: 10
                        rightPadding: 10
                        bottomPadding: 10
	                    
	                    layout: StackLayout {
                        	orientation: LayoutOrientation.LeftToRight
                        }
	                    
	                    TextField {
	                        id: searchField
                        	horizontalAlignment: HorizontalAlignment.Fill
                        	verticalAlignment: VerticalAlignment.Center
                        	input.submitKey: SubmitKey.Search
                        	input.onSubmitted: searchContainer.search()
                        }
	                    
	                    Button {
                        	text: qsTr("Search")
                        	preferredWidth: 0
                        	horizontalAlignment: HorizontalAlignment.Right
                            verticalAlignment: VerticalAlignment.Center
                            onClicked: searchContainer.search()
                        }
	                    
	                    function search() {
                            if (searchField.text != "") {
                                root.searchModel.setSearchString(searchField.text)
                                root.searchModel.start()
                                showSearchResults = true
                            }
	                    }
	                }
	                
	                indicatorVisibility: TitleBarExpandableAreaIndicatorVisibility.Hidden
                    expanded: searchToggle.checked
	                onExpandedChanged: {
                        searchToggle.checked = expanded
	                    if (expanded) {
	                        searchField.requestFocus()
	                    } else {
	                        searchField.resetText()
	                        searchContainer.showSearchResults = false
	                    }
	                }
	            }
            }
        }
        
	    Container {
	        layout: DockLayout {}
	        
	        Container {
	            layout: DockLayout {}
	            horizontalAlignment: HorizontalAlignment.Fill
	            verticalAlignment: VerticalAlignment.Fill
	            background: Color.create("#333333")
	            
	            PatternListView {
	                dataModel: root.model
                    visible: !searchListView.visible && !indicator.visible && !networkErrorMessage.visible
                    parentPane: root
                    horizontalAlignment: horizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill
	            }
	            
                PatternListView {
                    id: searchListView
                    dataModel: root.searchModel
                    visible: searchContainer.showSearchResults && !indicator.visible && !networkErrorMessage.visible
                    parentPane: root
                    horizontalAlignment: horizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill
                }
	        }
	        
	        // Only show if we are loading XML and the list is completely empty
	        ActivityIndicator {
	            id: indicator
                running: (searchContainer.showSearchResults && app.online && root.searchModel.loading && root.searchModel.length() === 0) ||
                		 (root.model.loading && app.online && root.model.length() === 0) 
	            visible: running
	            horizontalAlignment: HorizontalAlignment.Center
	            verticalAlignment: VerticalAlignment.Center
	            preferredWidth: 200.0
	            preferredHeight: 200.0
	        }
	        
	        
	        Container {
	            id: networkErrorMessage
	            visible: false // !app.online // PROBLEM: app.online is not always right
	            horizontalAlignment: HorizontalAlignment.Fill
	            verticalAlignment: VerticalAlignment.Center
	            
		        Label {
		            text: qsTr("A network error occurred. Please make sure you have a working internet connection.")
		            multiline: true
		            preferredWidth: 600
    	            horizontalAlignment: HorizontalAlignment.Center
		        }
		        
	            Button {
		            text: qsTr("Open network settings")
		            preferredWidth: 600
    	            horizontalAlignment: HorizontalAlignment.Center
    	            onClicked: {
    	                invokeNetworkSettings.trigger("bb.action.OPEN")
    	            }
    	            attachedObjects: [
    	                Invocation {
                            id: invokeNetworkSettings
                            query {
                                invokeTargetId: "sys.settings.target"
                                mimeType: "settings/view"
                                uri: "settings://networkconnections"
                            }
                        }
    	            ]
		        }
		        
		        Button {
		            text: qsTr("Try again")
		            preferredWidth: 600
    	            horizontalAlignment: HorizontalAlignment.Center
    	            onClicked: {
    	                networkErrorMessage.visible = false
    	                root.model.start()
    	            }
		        }
	        }
	    }
	}

    // Connecting signals to display network errors
    // INFO: The reason why app.online does not always work is because
    //       our app needs to be in forground to receive those signals.
    //       We could check for a network connection after each time the app wakes up
    onCreationCompleted: {
        root.model.networkError.connect(showNetworkError)
        app.onlineChanged.connect(onOnlineStateChanged)
    }
    
    function showNetworkError() {
        networkErrorMessage.visible = true
    }
    
    function onOnlineStateChanged() {
        if (app.online) {
            console.log("XXX QML -- APP is online")
            networkErrorMessage.visible = false
            root.model.start()
        }
    }
}

