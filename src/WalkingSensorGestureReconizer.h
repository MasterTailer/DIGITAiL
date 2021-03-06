/*
 *   Copyright 2020 Dan Leinir Turthra Jensen <admin@leinir.dk>
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

#ifndef WALKINGSENSORGESTURERECONIZER_H
#define WALKINGSENSORGESTURERECONIZER_H

#include <QSensorGestureRecognizer>
#include <vector>

class WalkingSensorGestureReconizer : public QSensorGestureRecognizer
{
    Q_OBJECT
public:
    WalkingSensorGestureReconizer(QObject *parent = Q_NULLPTR);
    using ValueList = std::vector<qreal>;
    void create() override;

    QString id() const override;
    bool start() override;
    bool stop() override;
    bool isActive() override;

    ~WalkingSensorGestureReconizer();

Q_SIGNALS:
//     void zValueTick(qreal timeElapsed, qreal zValue);
    void walkingStarted();
    void walkingStopped();
    void stepDetected();
    void evenStepDetected();
    void oddStepDetected();

private:
    class Private;
    Private* d;
};

#endif // WALKINGSENSORGESTURERECONIZER_H
