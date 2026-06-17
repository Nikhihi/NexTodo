import QtQuick
import QtQuick.Controls

Item {
    id: searchBox

    property alias text: innerInput.text
    property string placeholderText: "搜索任务..."

    signal textEdited(string text)
    signal accepted(string text)

    implicitWidth: 280      //只读，控件天然推荐尺寸
    implicitHeight: 40

    TextField {
        id: innerInput
        anchors.fill: parent
        placeholderText: searchBox.placeholderText
        selectByMouse: true

        onTextEdited: {
            searchBox.textEdited(text)
        }

        onAccepted: {
            searchBox.accepted(text)
        }
    }
}
