import QtQuick
import QtQuick.Controls

Item {
    id: searchBox

    property alias text: innerInput.text
    property string placeholderText: "搜索任务..."

    signal textEdited(string text)
    signal accepted(string text)

    implicitWidth: 250      //只读，控件天然推荐尺寸
    implicitHeight: 38

    TextField {
        id: innerInput
        anchors.fill: parent
        placeholderText: searchBox.placeholderText
        placeholderTextColor: "#172033"
        leftPadding: 12
        rightPadding: 12
        verticalAlignment: TextInput.AlignVCenter
        font.pixelSize: 15
        selectByMouse: true


        background: Rectangle {
            radius: 8
            color: "#f6f8fb"
            border.width: 1
            border.color: innerInput.activeFocus ? "#2563eb" : "#d8e0ec"
        }

        onTextEdited: {
            searchBox.textEdited(text)
        }

        onAccepted: {
            searchBox.accepted(text)
        }
    }
}
