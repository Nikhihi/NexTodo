import QtQuick
import QtQuick.Controls

Item {
    id: root

    ListView {
        id: listView
        anchors.fill: parent
        clip: true
        model: todoModel

        delegate: Row {
            width: ListView.view.width
            height: 40
            spacing: 8

            Text {
                id: titleText
                text: title
                width: 160
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                height: parent.height
            }

            Text {
                id: categoryText
                text: category
                width: 100
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                height: parent.height
            }
        }
    }
}
