import bb.cascades 1.0

TabbedPane {
    id: root
    showTabsOnActionBar: true
    
    onActiveTabChanged: {
        console.log("XXX Active tab: " + activeTab)
        activeTab.loadContent()
    }
    
    // Upon startup load the content of the first tab
    onCreationCompleted: activeTab.loadContent()
    
    Tab {
        title: qsTr("Patterns")
        imageSource: "asset:///images/patterns.png"
                
        PatternsPage {
            id: patternsPage1
	        type: "patterns"
	        model: listModel
        }
        
        // Load content if not already loaded
        function loadContent() {
            patternsPage1.loadContent()
        }
    }
    
    Tab {
        title: qsTr("Colors")
        imageSource: "asset:///images/colors.png"

        PatternsPage {
            id: patternsPage2
	        type: "colors"
	        model: colorModel
	    }
	    
	    // Load content if not already loaded
	    function loadContent() {
            patternsPage2.loadContent()
        }
    }
    
    Tab {
        title: qsTr("About")
        imageSource: "asset:///images/about.png"
        
        Page {
            titleBar: TitleBar {
                kind: TitleBarKind.Default
                title : "Pattern and Color Wallpapers"
                branded: TriBool.False
            }
            
            ControlDelegate {
                id: aboutPageDelegate
                source: "AboutPageContent.qml"
                delegateActive: false
            }
        }
        
        function loadContent() {
            aboutPageDelegate.delegateActive = true
        }
    }
    
//    attachedObjects: [
//        DetailSheet {
//            id: mySheet
//        }
//    ]
}
