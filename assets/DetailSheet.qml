import bb.cascades 1.0

Sheet {
    id: root
    property variant pattern
    
    content: Page {
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
                onTriggered: app.setWallpaper(pattern)
            },
            ActionItem {
                title: qsTr("Share")
                imageSource: "asset:///images/share.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: app.shareWallpaper(pattern)
            }
            /*
            ,
            InvokeActionItem {
                query {
                    mimeType: "image/png"
                    uri: "file:///accounts/1000/appdata/de.kodira.Pattern.testDev_ira_Pattern61335d67/data/wallpaper.png"
                    invokeActionId: "bb.action.SHARE"
                }
            }
            */
        ]
                
        Container {
            layout: AbsoluteLayout {}
            
            ImageView {
                preferredWidth: 768
                preferredHeight: 1280
                image: app.bigImage
            }
            
            Container {
                background: Color.Black
                opacity: 0.5
                preferredWidth: 768
                preferredHeight: 180
            }
            
            Container {
                layoutProperties: AbsoluteLayoutProperties {
                   positionX: 20
                   positionY: 20
                }

                Label {
                    text: root.pattern.title
                    textStyle.fontWeight: FontWeight.Bold
                    textStyle.fontSize: FontSize.Medium
                    textStyle.color: Color.White
                }
                Label {
                    text: qsTr("by") + " " + root.pattern.userName
                    textStyle.fontWeight: FontWeight.Bold
                    textStyle.fontSize: FontSize.Small
                    textStyle.color: Color.White
                }
            }
        }
    }
}
