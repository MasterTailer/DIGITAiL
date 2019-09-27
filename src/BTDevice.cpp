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

#include "BTDevice.h"

BTDevice::BTDevice(const QBluetoothDeviceInfo& info, QObject* parent)
    : QObject(parent)
    , name(info.name())
    , deviceID(info.address().toString())
    , deviceInfo(info)
{
    connect(commandModel, &TailCommandModel::tailVersionChanged,
        commandModel, [this](){ /*emit tailVersionChanged(commandModel->tailVersion());*/ });
}

BTDevice::~BTDevice()
{ }

bool BTDevice::isConnected()
{
    return btControl;
}
