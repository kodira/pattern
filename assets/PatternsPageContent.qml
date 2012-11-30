import bb.cascades 1.0

Container {
    id: root
    
    property string type: ""
    property variant model
    property variant app
    
    // Caching
    property int page: model.page
    property int results: model.results
    
    layout: DockLayout {}
    background: Color.create("#333333")
    
    ListView {
        visible: !indicator.visible
        
        // dataModel comming from C++
        dataModel: root.model
        
        listItemComponents: [
            ListItemComponent {
                type: "listItem"
                PatternItem {}
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
                    PatternItem {}
                }
            },
            
            ListItemComponent {
                type: "bottomItem"    
                Container {
                    id: footerItem
                    bottomPadding: 20
                    PatternItem {
                        preferredHeight: 200
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
            console.log("XXX: " + chosenItem);
            console.log("XXX: " + chosenItem.imageUrl);
            // We're taking a loop here, maybe directly tell the C++ code to do it all?!
            app.bigImage = chosenItem.createImage(768, 1280);
            // TODO: Refactor last line to
            // app.createBigImage(chosenItem.pattern, 768, 1280)
            /*
            mySheet.pattern = chosenItem;
            mySheet.title = chosenItem.title;
            mySheet.userName = chosenItem.userName;
            mySheet.open();
            */
            console.log("XXX Here");
            sheetDelegate.pattern = chosenItem;
            sheetDelegate.title = chosenItem.title;
            sheetDelegate.userName = chosenItem.userName;
            sheetDelegate.delegateActive = true;
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
    
    ControlDelegate {
        id: sheetDelegate
        
        property string title
        property string userName
        property variant pattern
        
        source: "DetailSheet.qml"
        delegateActive: false
        
        onControlChanged: {
            if (control) {
                console.log("XXX SHEET DELEGATE LOADED")
                control.title = title
                control.userName = userName
                control.pattern = pattern
                control.app = root.app
                control.open()
            }
        }
    }
}