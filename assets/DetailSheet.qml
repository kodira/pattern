import bb.cascades 1.0

Sheet {
    id: root
    property variant pattern
    
    onOpened: {
        indicator.running = true
        app.createBigImage(pattern.patternUrl)
    }
    
    onClosed: {
        indicator.running = false
        img.visible = false
    }
    
    Page {
        actions: [ 
            ActionItem {
                title: qsTr("Back")
                imageSource: "asset:///images/close_stop.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: root.close()
            },
            ActionItem {
                title: qsTr("As Wallpaper")
                imageSource: "asset:///images/photos.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: app.setWallpaper()
            },
            ActionItem {
                title: qsTr("Share")
                imageSource: "asset:///images/share.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: app.shareWallpaper()
            }
        ]
                
        Container {
            layout: DockLayout {}
            
            ImageView {
                id: img
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                image: app.bigImage
                
                onImageChanged: {
                    indicator.running = false
                    visible = true
                }
            }
            
            Container {
                background: Color.Black
                opacity: 0.5
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Top
                preferredHeight: 180
            }
            
            Container {
                layout: StackLayout {}
                topPadding: 20
                leftPadding: 20

                Label {
                    text: root.pattern ? root.pattern.title : ""
                    textStyle.fontWeight: FontWeight.Bold
                    textStyle.fontSize: FontSize.Medium
                    textStyle.color: Color.White
                }
                
                Label {
                    text: qsTr("by") + " " + (root.pattern ? root.pattern.userName : "")
                    textStyle.fontWeight: FontWeight.Bold
                    textStyle.fontSize: FontSize.Small
                    textStyle.color: Color.White
                }
            }
            
            ActivityIndicator {
                id: indicator
                running: false
                visible: running
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
            }
            
        }
    }
}
