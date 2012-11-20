TEMPLATE = app
TARGET = Pattern

QT += opengl
CONFIG += qt warn_on debug_and_release cascades
LIBS += -lbbplatform -lbbsystem

INCLUDEPATH += ../src
SOURCES += ../src/*.cpp
HEADERS += ../src/*.hpp ../src/*.h

lupdate_inclusion {
    SOURCES += ../assets/*.qml
}

device {
	CONFIG(release, debug|release) {
		DESTDIR = o.le-v7
	}
	CONFIG(debug, debug|release) {
		DESTDIR = o.le-v7-g
	}
}

simulator {
	CONFIG(release, debug|release) {
		DESTDIR = o
	}
	CONFIG(debug, debug|release) {
		DESTDIR = o-g
	}
}

OBJECTS_DIR = $${DESTDIR}/.obj
MOC_DIR = $${DESTDIR}/.moc
RCC_DIR = $${DESTDIR}/.rcc
UI_DIR = $${DESTDIR}/.ui

TRANSLATIONS = \
    $${TARGET}_en.ts \    
    $${TARGET}_de.ts \
    $${TARGET}.ts

