import bb.cascades 1.0

Page {
    titleBar: TitleBar {
        title : "Pattern and Color Wallpapers"
        branded: TriBool.False
    }
    
    Container {
        layout: StackLayout {}
        leftPadding: 40
        rightPadding: 40
        topPadding: 40
        bottomPadding: 40
        
        ImageView {
            imageSource: "asset:///images/kodira.png"
            horizontalAlignment: HorizontalAlignment.Center             
        }
        
        Label {
            multiline: true
            // TODO: Add link to gitorous or github.
            text: qsTr("Pattern lets you set your wallpaper to beautiful patterns and colors. Written by Cornelius Hald for Kodira.\nThis program uses the COLOURlovers.com API. All patterns are licensed under CC-BY-NC-SA.")
        }
        
        Container {
            topPadding: 20
            
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            
            Button {
                text: qsTr("Website")
                onClicked: invoke.trigger("bb.action.OPEN")
                
                attachedObjects: [
                    Invocation {
	                    id: invoke
	                    query: InvokeQuery {
	                        invokeTargetId: "sys.browser"
	                        uri: "http://kodira.de"
	                    }
                    }
	            ]
            }
            
            Button {
                text: qsTr("More Apps")
                onClicked: invoke2.trigger("bb.action.OPEN")
                
                attachedObjects: [
                    Invocation {
	                    id: invoke2
	                    query: InvokeQuery {
	                        invokeTargetId: "sys.appworld"
	                        uri: "appworld://vendor/41217"
	                    }
                    }
                ]
            }
        }
    }
}
