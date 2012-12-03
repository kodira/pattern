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
	                    //    dataModel.loadNextPage()
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

