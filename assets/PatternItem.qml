import bb.cascades 1.0
import de.kodira 1.0
    
Container {
    id: root
    
    property bool initialized: false
    property bool isFooter: false
    property bool isLoading: false

    layout: DockLayout {}
    //horizontalAlignment: HorizontalAlignment.Fill // Does not work
    preferredWidth: 768
    preferredHeight: 200
    
    RemoteImageView {
        id: image
        visible: !(isLoading && isFooter)
        // If not initialized the item might be currently in a recycled state - we should not show the image
        url: root.initialized ? ListItemData.patternUrl : ""
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        
        attachedObjects: [
	        LayoutUpdateHandler {
	            onLayoutFrameChanged: {
	                image.preferredWidth = layoutFrame.width
	                image.preferredHeight = layoutFrame.height
	            }
	        }
        ]
    }
    
    Container {
        preferredHeight: 70
        background: Color.Black
        opacity: 0.5
        verticalAlignment: VerticalAlignment.Bottom
        horizontalAlignment: HorizontalAlignment.Fill
    }
    
    Container {
        layout: DockLayout {}
        preferredHeight: 70
        verticalAlignment: VerticalAlignment.Bottom
        horizontalAlignment: HorizontalAlignment.Fill
        leftPadding: 20
        bottomPadding: 10
        
        Label {
            text: isLoading ? qsTr("Loading more patterns...") : ListItemData.title + " " + qsTr("by") + " " + ListItemData.userName
            textStyle.fontWeight: FontWeight.Bold
            textStyle.fontSize: FontSize.Medium
            textStyle.color: Color.White
            horizontalAlignment: HorizontalAlignment.Left
            verticalAlignment: VerticalAlignment.Bottom
        }
    }
    
    Container {
        layout: DockLayout {}
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        bottomPadding: 70
        
	    ActivityIndicator {
	        running: initialized && image.loading != 1
	        visible: running
	        preferredWidth: 100
	        preferredHeight: 100
	        horizontalAlignment: HorizontalAlignment.Center
	        verticalAlignment: VerticalAlignment.Center
	    }
	}
    
    Container {
        id: listItemTouchOverlay
        background: Color.Black
        opacity: 0
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
    }
    
    onTouch: {
        if (isLoading) {
            return;
        }
        
        // convert to select case
        if (event.touchType == TouchType.Down) {
            listItemTouchOverlay.opacity = 0.5;
        } else if (event.touchType == TouchType.Up || event.touchType == TouchType.Cancel) {
            listItemTouchOverlay.opacity = 0;
        }
    }
    
    // Overlay that is only visible if this item is used as footer item
    /*
    Container {
        visible: isFooter && isLoading
        //background: Color.create("#333333")
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        layout: DockLayout {}
        ActivityIndicator {
            running: parent.visible
	        preferredWidth: 100
	        preferredHeight: 100
            horizontalAlignment: HorizontalAlignment.Center
	        verticalAlignment: VerticalAlignment.Center   
        }
        
        Label {
            text: qsTr("Loading more patterns")
            textStyle.fontWeight: FontWeight.Bold
            textStyle.fontSize: FontSize.Medium
            textStyle.color: Color.White
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Bottom
        }
    }
    */
}

