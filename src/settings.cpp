/*
 *   Copyright 2019 Dan Leinir Turthra Jensen <admin@leinir.dk>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 3, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>
 */

#include "settings.h"

class AppSettings::Private
{
public:
    Private()
        : advancedMode(false)
        , idleMode(false)
        , idleMinPause(10)
        , idleMaxPause(30)
    {}
    ~Private() {}

    bool advancedMode;
    bool idleMode;
    QStringList idleCategories;
    int idleMinPause;
    int idleMaxPause;
};

AppSettings::AppSettings(QObject* parent)
    : SettingsProxySource(parent)
    , d(new Private)
{
}

AppSettings::~AppSettings()
{
    delete d;
}

bool AppSettings::advancedMode() const
{
    return d->advancedMode;
}

void AppSettings::setAdvancedMode(bool newValue)
{
    d->advancedMode = newValue;
    emit advancedModeChanged();
}

bool AppSettings::idleMode() const
{
    return d->idleMode;
}

void AppSettings::setIdleMode(bool newValue)
{
    d->idleMode = newValue;
    emit idleModeChanged();
}

QStringList AppSettings::idleCategories() const
{
    return d->idleCategories;
}

void AppSettings::setIdleCategories(QStringList newCategories)
{
    d->idleCategories = newCategories;
    emit idleCategoriesChanged();
}

int AppSettings::idleMinPause() const
{
    return d->idleMinPause;
}

void AppSettings::setIdleMinPause(int pause)
{
    d->idleMinPause = pause;
    emit idleMinPauseChanged();
}

int AppSettings::idleMaxPause() const
{
    return d->idleMaxPause;
}

void AppSettings::setIdleMaxPause(int pause)
{
    d->idleMaxPause = pause;
    emit idleMaxPauseChanged();
}