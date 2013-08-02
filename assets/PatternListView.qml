import bb.cascades 1.0

ListView {
    id: root
    
    property variant parentPane
    
    onCreationCompleted: {
        dataModel.start()
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
                isLoading: dataModel.loading
            }
        }
    ]
    
    onTriggered: {
        var chosenItem = dataModel.data(indexPath);        
        var	page = detailsPageDefinition.createObject();
        page.objectName = "detailsPage"
        page.pattern = chosenItem;
        page.loadPattern();
        parentPane.push(page);
    }
    
    function itemType(data, indexPath) {
        // If we are at the bottom of the list, display footer item
        if (indexPath[0] == root.dataModel.length() - 1) {
            return "listItemFooter";
        }
        // Else return the normal item
        return "listItem";
    }
    
    attachedObjects: [
        // This handler is tracking the scroll state of the ListView.
        ListScrollStateHandler {
            onAtEndChanged: {
                if (atEnd && (root.dataModel.length() > 0)) {
                    root.dataModel.loadNextPage()
                }
            }
        },
        
        ComponentDefinition {
            id: detailsPageDefinition;
            source: "DetailsPage.qml"
        }
    ]           
}
