/*
 * Copyright (C) 2012 Cornelius Hald <cornelius.hald@kodira.de>
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

TabbedPane {
    id: root
    showTabsOnActionBar: true
    
    Tab {
        title: qsTr("Patterns")
        imageSource: "asset:///images/patterns.png"
        objectName: "PatternsTab"
        
        PatternsPage {
	        type: "patterns"
	        model: patternModel
	        searchModel: patternSearchModel
        }
    }
    
    Tab {
        title: qsTr("Colors")
        imageSource: "asset:///images/colors.png"
        objectName: "ColorsTab"
        
        PatternsPage {
	        type: "colors"
	        model: colorModel
	        searchModel: colorSearchModel
	    }
    }
    
    Tab {
        title: qsTr("About")
        imageSource: "asset:///images/about.png"
        
        AboutPage {}
    }
    
    // Upon startup we load the pattern model
    onCreationCompleted: {
        patternModel.start()
    }
    
    // If the second tab gets activated we load the color model
    // TODO: It would be even better defere loading of the tab completely 
    onActiveTabChanged: {
        if (activeTab.objectName === "ColorsTab") {
            colorModel.start()
        }
    }
}

