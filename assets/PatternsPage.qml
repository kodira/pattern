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
                // For some reason we cannot access root.model directly from ListItemComponent. So we cache it here.
                property variant modelCache: root.model
                
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
                            initialized: ListItem.initialized
                            bottomMargin: 20
                        }
                    },
                    ListItemComponent {
                        type: "listItemFooter"
                        PatternItem {
                            initialized: ListItem.initialized
                            bottomMargin: 20
                            isFooter: true
                            isLoading: parent.modelCache.loading
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
                    // If we are at the bottom of the list, display footer item
                    if (indexPath[0] == root.model.length() - 1) {
                        return "listItemFooter";
                    }
                    // Else return the normal item
                    return "listItem";
                }
                
                attachedObjects: [
	                // This handler is tracking the scroll state of the ListView.
	                ListScrollStateHandler {
	                    onAtEndChanged: {
	                        if (atEnd && (root.model.length() > 0)) {
	                            root.model.loadNextPage()
	                        }
	                    }
	                }
	            ]           
            }
        }
        
        // Only show if we are loading XML and the list is completely empty
        ActivityIndicator {
            id: indicator
            running: root.model.loading && root.model.length() === 0
            visible: running
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            preferredWidth: 200.0
            preferredHeight: 200.0
        }
    }
}

