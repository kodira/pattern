import bb.cascades 1.0

Container {
	id: root
	property alias checked: checkBox.checked
	property bool active: false
	property alias text: label.text

	preferredWidth: 300
	
    layout: DockLayout {}
    
    ImageView {
        visible: root.active 
        imageSource: "images/triangle.png"
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Top
    }
    
    Container {
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Top
        touchPropagationMode: TouchPropagationMode.None // Don't propagate touch to checkbox. Handled by outer container
        topPadding: 50

        CheckBox {
	        id: checkBox
	    }
    }
    
    Container {
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Top
        touchPropagationMode: TouchPropagationMode.None
        topPadding: 100

        Label {
            id: label
	        textStyle.fontSize: FontSize.Small
            overlapTouchPolicy: OverlapTouchPolicy.Allow
            touchPropagationMode: TouchPropagationMode.None
        }
    }

    onTouch: {
        // There should be a better way to redirect touch from parent to client
        // With this code we don't get proper touch down behavior on checkBox
        if (event.touchType == TouchType.Up) {
            
            if (checkBox.checked && root.active) {
                checkBox.checked = false
                root.active = false
                return
            }
            
            if (checkBox.checked && !root.active) {
                root.active = true
                return
            }
            
            if (!checkBox.checked) {
                checkBox.checked = true
                root.active = true
                return
            }
        }
    }
}
