import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../pages" as Pages
import "../components" as MyComponents

Item {
    id: root

    property string searchText: ""

    signal addTodoRequested()
    signal searchTextChangedByUser(string text)

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        MyComponents.AppHeader {
            id: header
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            searchText: root.searchText

            onAddRequested: root.addTodoRequested()
            onSearchTextChangedByUser: function(text) {
                root.searchText = text
                root.searchTextChangedByUser(text)
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            //color: "#e5e7eb"
            color: "red"
        }
        MyComponents.FilterBar{
            id: filter
            Layout.fillWidth: true
            Layout.preferredHeight: 58
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            //color: "#e5e7eb"
            color: "red"
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Pages.TaskListPage {
                anchors.fill: parent
                visible: true
            }
        }
    }
}
