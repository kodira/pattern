import bb.cascades 1.0

Page {
    id: root
    
    property string type: ""
    property variant model
    
    titleBar: TitleBar {
        kind: TitleBarKind.Segmented
        title: ""
        branded: TriBool.False
        
        options: [
	        Option {
	            text: qsTr("Top Rated")
	            value: "top"
	        },
	        Option {
	            text: qsTr("Newest")
	            value: "new"
	        }
	    ]
	    
        onSelectedIndexChanged: {
            console.debug("XXX Selected value: " + selectedValue);
            delegate.control.model.category = selectedValue;
        }
        
    }

    ControlDelegate {
        id: delegate
        source: "PatternsPageContent.qml"
        delegateActive: false
        onControlChanged: {
            if (control) {
                console.log("XXX DELEGATE LOADED")
                control.app = app
                control.type = root.type
                control.model = root.model
                control.model.start()
            }
        }
    }
    
    function loadContent() {
        console.log("XXX LOAD CONTENT")
        if (!delegate.delegateActive) {
            console.log("XXX START LOADING DELEGATE")
            delegate.delegateActive = true
        }
    }
    
}

