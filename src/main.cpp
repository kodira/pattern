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

#include "app.hpp"

#include <QLocale>
#include <QTranslator>

#include <bb/cascades/Application>

using ::bb::cascades::Application;

int main(int argc, char **argv)
{
    //-- this is where the server is started etc
    Application app(argc, argv);
    
    //-- localization support
    QTranslator translator;
    QString locale_string = QLocale().name();
    QString filename = QString( "Pattern_%1" ).arg( locale_string );
    if (translator.load(filename, "app/native/qm")) {
        app.installTranslator( &translator );
    }
    
    App mainApp;
    
    //-- we complete the transaction started in the app constructor and start the client event loop here
    return Application::exec();
    //-- when loop is exited the Application deletes the scene which deletes all its children (per qt rules for children)
}
