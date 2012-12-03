import bb.cascades 1.0

Page {
    id: root
    
    property string type: ""
    property variant model
    
    // Caching
    property int page: model.page
    property int results: model.results

    Container {
        layout: DockLayout {}
        
        Container {
            layout: StackLayout {}
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            background: Color.create("#333333")
            
            SegmentedControl {
                id: segmented1
                
                horizontalAlignment: HorizontalAlignment.Center
                
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
                    console.debug("Selected value: " + value);
                    root.model.category = value;
                }
            }
            
            ListView {
                visible: !indicator.visible
                
                onCreationCompleted: {
                    root.model.start()
                }
                
                // dataModel comming from C++
                dataModel: root.model
                
                listItemComponents: [
                    ListItemComponent {
                        type: "listItem"
                        PatternItem {
                            id: mainPatternItem
                            initialized: ListItem.initialized
                            bottomMargin: 20
                        }
                    },
                    
                    ListItemComponent {
                        type: "topItem"    
                        Container {
                            id: headerItem
                            Button {
                                text: qsTr("Load previous page")
                                horizontalAlignment: HorizontalAlignment.Center
                                onClicked: headerItem.ListItem.view.dataModel.loadPreviousPage()
                            }
                            PatternItem {
                                initialized: parent.ListItem.initialized
                            }
                        }
                    },
                    
                    ListItemComponent {
                        type: "bottomItem"    
                        Container {
                            id: footerItem
                            bottomPadding: 20
                            PatternItem {
                                preferredHeight: 200
                                initialized: parent.ListItem.initialized
                            }
                            Button {
                                text: qsTr("Load next page")
                                horizontalAlignment: HorizontalAlignment.Center
                                onClicked: footerItem.ListItem.view.dataModel.loadNextPage()
                            }
                        }
                    }
                ]
                
                onTriggered: {
                    var chosenItem = dataModel.data(indexPath);
                    console.log(chosenItem.patternUrl);
                    mySheet.pattern = chosenItem;
                    mySheet.open();
                }
                
                function itemType(data, indexPath) {
                    // Always use listItem, we don't want headers for grouping
                    // First and last items can be special ones to load more data
                    
                    if (indexPath[0] == 0 && root.page > 0) {
                        return "topItem";
                    }
                    
                    if (indexPath[0] == root.results - 1) {
                        return "bottomItem";
                    }
                    
                    return "listItem";
                }
                
                attachedObjects: [
	                // This handler is tracking the scroll state of the ListView.
	                ListScrollStateHandler {
	                    id: scrollStateHandler
//	                    onScrollingChanged: {
//	                        if (scrolling) {
//	                            console.log("XXX scrolling")
//	                        } else {
//	                            console.log("XXX NOT scrolling")
//	                        }
//	                    }
                        // TODO: Does not currently work in Beta-4
	                    //onAtEndChanged: {
	                    //    console.log("XXX on end of list")
	                    //}
	                }
	            ]           
            }
        }
        
        ActivityIndicator {
            id: indicator
            running: root.model.loading
            visible: running
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            preferredWidth: 200.0
            preferredHeight: 200.0
        }
    }
}

