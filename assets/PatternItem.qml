import bb.cascades 1.0
import de.kodira 1.0
    
Container {
    id: root
    layout: AbsoluteLayout {}
    preferredHeight: 220
    
    /*
    RemoteImageView {
        url: ListItemData.patternUrl
        preferredHeight: 200
    }
    */
    
    Container {
        preferredWidth: 768
        preferredHeight: 70
        background: Color.Black
        opacity: 0.5
        layoutProperties: AbsoluteLayoutProperties {
            positionX: 0
            positionY: 130
        }
    }
    
    Label {
        text: ListItemData.title + " " + qsTr("by") + " " + ListItemData.userName
        textStyle.fontWeight: FontWeight.Bold
        textStyle.fontSize: FontSize.Medium
        textStyle.color: Color.White
        layoutProperties: AbsoluteLayoutProperties {
            positionX: 20
            positionY: 147
        }
    }
    
    ActivityIndicator {
        running: ListItemData.loading
        visible: running
        preferredWidth: 100
        preferredHeight: 100
        layoutProperties: AbsoluteLayoutProperties {
            positionX: 335
            positionY: 0
        }                
    }
    
    Container {
        id: listItemOverlay
        preferredWidth: 768
        preferredHeight: 200
        background: Color.Black
        opacity: 0
    }
    
    onTouch: {
        // convert to select case
        if (event.touchType == TouchType.Down) {
            listItemOverlay.opacity = 0.5;
        } else if (event.touchType == TouchType.Up ||
                event.touchType == TouchType.Cancel) {
            listItemOverlay.opacity = 0;
        }
    }
}

