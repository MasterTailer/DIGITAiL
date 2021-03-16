/*
 *   Copyright 2019 Dan Leinir Turthra Jensen <admin@leinir.dk>
 *   Copyright 2019 Ildar Gilmanov <gil.ildar@gmail.com>
 *   This file based on sample code from Kirigami
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

import QtQuick 2.7
import QtQuick.Controls 2.4 as QQC2
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.13 as Kirigami
import org.thetailcompany.digitail 1.0 as Digitail

Kirigami.ScrollablePage {
    id: control;

    property alias model: commandListView.model
    property Item infoCardFooter: null;

    signal insertCommand(int insertAt, string command, variant destinations);
    signal removeCommand(int index, string command);

    actions {
        main: Kirigami.Action {
            text: qsTr("Add Move To List");
            icon.name: "list-add";
            onTriggered: {
                pickACommand.insertAt = commandListView.count;
                pickACommand.pickCommand();
            }
        }

        right: Kirigami.Action {
            text: qsTr("Add Pause To List");
            icon.name: "accept_time_event";
            onTriggered: {
                commandPausePicker.insertAt = commandListView.count;
                commandPausePicker.pickDuration();
            }
        }
    }

    property var allDurations: []
    Component {
        id: commandListDelegate;

        Item {
            id: listItem;
            Layout.fillWidth: true
            Layout.minimumHeight: Math.max(commandDelegateLabel.height, (command.duration + command.minimumCooldown) / 100);
            Layout.maximumHeight: Layout.minimumHeight;

            property variant command: {
                "name": "",
                "command": "",
                "minimumCooldown": 0,
                "duration": 0
            }

            property string title: command["name"];

            Component.onCompleted: {
                Digitail.Utilities.getCommand(modelData);
            }
            // Silly, yes, but we can't put it at the proper root of SwipeListItem, as it only wants QQuickItems there
            Connections {
                target: Digitail.Utilities;
                onCommandGotten: {
                    if(command.command === modelData) {
                        listItem.command = command;
                        var durations = control.allDurations;
                        durations[model.index] = command.duration + command.minimumCooldown
                        control.allDurations = durations;
                    }
                }
            }

            Rectangle {
                anchors {
                    right: parent.right
                    top: parent.top
                    left: parent.left
                    rightMargin: Kirigami.Units.gridUnit
                    topMargin: radius
                }
                color: Kirigami.Theme.activeTextColor
                height: 2
                radius: 1
                Rectangle {
                    anchors {
                        left: parent.right
                        leftMargin: -1
                        verticalCenter: parent.verticalCenter
                    }
                    height: Kirigami.Units.gridUnit + 2
                    width: height
                    radius: height / 2
                    color: Kirigami.Theme.backgroundColor
                    Kirigami.Theme.colorSet: Kirigami.Theme.Button
                    border {
                        width: 2
                        color: Kirigami.Theme.activeTextColor
                    }
                    QQC2.Label {
                        id: cummulativeDuration
                        anchors {
                            right: parent.left
                            bottom: parent.verticalCenter
                            rightMargin: Kirigami.Units.smallSpacing
                        }
                        Connections {
                            target: control
                            function onAllDurationsChanged() {
                                // Don't mark the first item as having had some cumulative duration
                                if (model.index > 0) {
                                    var cumulative = 0;
                                    for (var i = 0; i < control.allDurations.length ; ++i) {
                                        if (i > model.index - 1) {
                                            break;
                                        }
                                        cumulative += control.allDurations[i];
                                    }
                                    cummulativeDuration.text = cumulative / 1000 + "s";
                                }
                            }
                        }
                    }
                    Rectangle {
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            top: parent.bottom
                            topMargin: -1
                        }
                        height: listItem.height - x
                        width: 2
                        color: Kirigami.Theme.activeTextColor
                        QQC2.ToolButton {
                            anchors {
                                right: parent.left
                                bottom: parent.bottom
                                bottomMargin: Kirigami.Units.smallSpacing
                            }
                            icon.name: "list-add"
                            onClicked: {
                                addCommandMenu.open();
                            }
                            QQC2.Menu {
                                id: addCommandMenu
                                y: parent.height
                                QQC2.Action {
                                    text: qsTr("Add command after");
                                    icon.name: "list-add";

                                    onTriggered: {
                                        pickACommand.insertAt = model.index + 1;
                                        pickACommand.pickCommand();
                                    }
                                }
                                QQC2.Action {
                                    text: qsTr("Add pause after");
                                    icon.name: "accept_time_event";

                                    onTriggered: {
                                        commandPausePicker.insertAt = model.index + 1;
                                        commandPausePicker.pickDuration();
                                    }
                                }
                            }
                        }
                    }
                }
            }
            QQC2.Label {
                id: commandDelegateLabel
                anchors {
                    top: parent.top;
                    left: commandRemovalButton.right;
                    topMargin: Kirigami.Units.largeSpacing
                    leftMargin: Kirigami.Units.largeSpacing
                    right: parent.right
                    rightMargin: Kirigami.Units.largeSpacing
                }
                height: paintedHeight
                color: command["minimumCooldown"] > 0 ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
                text: command["minimumCooldown"] > 0
                        ? qsTr("<strong>%1</strong><br/><small>%2 seconds</small><br/><small>Additional cooldown: %3 seconds</small>").arg(title).arg(command["duration"] / 1000).arg(command["minimumCooldown"] / 1000)
                        : qsTr("<strong>%1</strong><br/><small>%2 seconds</small>").arg(title).arg(command["duration"] / 1000)
            }
            QQC2.ToolButton {
                id: commandRemovalButton
                icon.name: "list-remove";
                anchors {
                    top: parent.top
                    left: parent.left
                }
                onClicked: {
                    control.removeCommand(index, command["command"]);
                }
            }
        }
    }

    ColumnLayout {
        width: control.width - Kirigami.Units.largeSpacing * 4
        InfoCard {
            id: infoCard
            text: qsTr("This is your list of commands. It can include both moves, glows, and pauses. Tip: To add a new command underneath one you have in the list already, click the add actions shown when you swipe left on the items.");
            footer: control.infoCardFooter
        }
        Repeater {
            id: commandListView;
            delegate: commandListDelegate;
        }
        Item {
            Layout.minimumHeight: Kirigami.Units.gridUnit;
            Layout.maximumHeight: Kirigami.Units.gridUnit;
            Layout.fillWidth: true
            Rectangle {
                anchors {
                    right: parent.right
                    top: parent.top
                    left: parent.left
                    rightMargin: Kirigami.Units.gridUnit
                    topMargin: radius
                }
                color: Kirigami.Theme.activeTextColor
                height: 2
                radius: 1
                Rectangle {
                    anchors {
                        left: parent.right
                        leftMargin: -1
                        verticalCenter: parent.verticalCenter
                    }
                    height: Kirigami.Units.gridUnit + 2
                    width: height
                    radius: height / 2
                    Kirigami.Theme.colorSet: Kirigami.Theme.Button
                    color: Kirigami.Theme.backgroundColor
                    border {
                        width: 2
                        color: Kirigami.Theme.activeTextColor
                    }
                    QQC2.Label {
                        id: cummulativeDuration
                        anchors {
                            right: parent.left
                            bottom: parent.verticalCenter
                            rightMargin: Kirigami.Units.smallSpacing
                        }
                        Connections {
                            target: control
                            function onAllDurationsChanged() {
                                var cummulative = 0;
                                for (var i = 0; i < control.allDurations.length ; ++i) {
                                    cummulative += control.allDurations[i];
                                }
                                cummulativeDuration.text = qsTr("Total duration: %1 seconds").arg(cummulative / 1000);
                            }
                        }
                    }
                }
            }
        }
    }

    CommandPausePicker {
        id: commandPausePicker;

        onDurationPicked: {
            control.insertCommand(insertAt, "pause:" + duration);
            commandPausePicker.close();
        }
    }

    PickACommandSheet {
        id: pickACommand;

        property int insertAt;

        onCommandPicked: {
            control.insertCommand(insertAt, "pause:15", destinations);
            control.insertCommand(insertAt, command, destinations);
            pickACommand.close();
        }
    }
}
