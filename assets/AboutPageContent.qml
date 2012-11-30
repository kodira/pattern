import bb.cascades 1.0

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
    
    /*
    Container {
        topPadding: 20
        
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        
        Button {
            text: qsTr("Website")
        }
        
        Button {
            text: qsTr("More apps")
            
            // Invoke with
            // appworld://vendor/<vendorid>
            // 
        }
    }
    */
}

