import bb.cascades 1.0

TabbedPane {
    id: root
    showTabsOnActionBar: true
    
    Tab {
        title: qsTr("Patterns")
        imageSource: "asset:///images/patterns.png"
        
        PatternsPage {
	        type: "patterns"
	        model: listModel
        }
    }
    
    Tab {
        title: qsTr("Colors")
        imageSource: "asset:///images/colors.png"
        
        PatternsPage {
	        type: "colors"
	        model: colorModel
	    }
    }
    
    Tab {
        title: qsTr("About")
        imageSource: "asset:///images/about.png"
        AboutPage {}
    }
    
    attachedObjects: [
        DetailSheet {
            id: mySheet
        }
    ]
}

