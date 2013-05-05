/*
 * Copyright (C) 2013 Cornelius Hald <cornelius.hald@kodira.de>
 * 
 * This file is part of Pattern.
 * 
 * Pattern is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Pattern is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with Pattern. If not, see <http://www.gnu.org/licenses/>.
 */

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
