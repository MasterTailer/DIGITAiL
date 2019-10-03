/*
 *   Copyright 2018 Dan Leinir Turthra Jensen <admin@leinir.dk>
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

#ifndef BTDEVICEMODEL_H
#define BTDEVICEMODEL_H

#include <QAbstractListModel>
#include <QBluetoothDeviceInfo>
#include <QBluetoothAddress>
#include <QLowEnergyController>
#include <QTimer>

class AppSettings;
class BTDevice;

class BTDeviceModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit BTDeviceModel(QObject* parent = nullptr);
    ~BTDeviceModel() override;

    enum Roles {
        Name = Qt::UserRole + 1,
        DeviceID,
        BatteryLevel,
        CurrentCall,
        IsConnected
    };

    AppSettings* appSettings() const;
    void setAppSettings(AppSettings* appSettings);

    QHash< int, QByteArray > roleNames() const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;

    /**
     * Add a new device to the model.
     * The new device is added at the start of the unsorted model
     * The model takes ownership of the device, and deletion should not
     * be done manually.
     * @param newDevice The new device to show in the model
     */
    Q_SLOT void addDevice(const QBluetoothDeviceInfo& deviceInfo);
    /**
     * Remove a device from the model.
     * The entry will be deleted by this function, and you should not attempt to
     * use the instance afterwards.
     * If the device is not maintained by this model, it will still be deleted!
     */
    void removeDevice(BTDevice* device);

    void updateItem(const QString& deviceID);

    int count();
    Q_SIGNAL void countChanged();

    BTDevice* getDevice(const QString& deviceID) const;
    Q_INVOKABLE QString getDeviceID(int deviceIndex) const;

    Q_SIGNAL void deviceMessage(const QString& deviceID, const QString& message);
private:
    class Private;
    Private* d;
};

#endif//BTDEVICEMODEL_H
