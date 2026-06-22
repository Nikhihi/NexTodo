import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: root
    width: 430
    height: 630
    modal:true
    spacing: 10

    property string todoID: ""
    property bool editMode: false

    // dataVersion 确保 TodoModel 内部变更时重新求值
    property var todoData: {
        var _ = todoModel.dataVersion
        return editMode ? todoModel.getTodoMap(todoID) : ({})
    }


    background: Rectangle {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.topMargin: 8
        anchors.rightMargin: 8
        anchors.bottomMargin: 8
        radius: 12
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12
            Label {
                id: label
                text: editMode ? "编辑任务" : "新建任务"
                Layout.fillWidth: true;
                font.pixelSize: 20
                font.weight: 780
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: "#e5e7eb"
            }
            Label {
                id: titleForm
                text: "标题"
                font.pixelSize: 13
                color: "#757575"
            }
            TextField {
                id: titleInput
                Layout.preferredHeight: 42
                Layout.fillWidth: true
                font.pixelSize: 16
                placeholderText: "请输入任务标题"
                //horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: todoData.title || ""
                background: Rectangle {
                    radius: 12
                    border.width: 1
                    border.color: "#d8e0ec"
                }
            }
            Label {
                id: categoryForm
                text: "分类"
                font.pixelSize: 13
                color: "#757575"
            }
            ComboBox{
                id: categoryBox
                Layout.preferredHeight: 42
                Layout.fillWidth: true
                contentItem: Text {
                    text: categoryBox.displayText
                    color: "#000000"
                    font.pixelSize: 16
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                currentIndex: find(todoData.category)
                indicator: Text {
                    x: categoryBox.width - width - 12
                    y: (categoryBox.height - height) / 2
                    text: "V"
                    color: "#000000"
                    font.pixelSize: 10
                }
                model: ["学习", "复习", "考试"]
                background: Rectangle {
                    anchors.fill: parent
                    radius: 12
                    border.width: 1
                    border.color: "#d8e0ec"
                }
            }
            //优先级
            Label {
                id: priorityForm
                text: "优先级"
                font.pixelSize: 13
                color: "#757575"
            }
            RowLayout{
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                ButtonGroup{
                    id: buttonGroup
                }

                AbstractButton {
                    id: lowBtn
                    ButtonGroup.group: buttonGroup
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 42

                    checkable: true
                    text: "低"
                    checked: !editMode ? false : todoData.priority === "低" ? true : false
                    background: Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: lowBtn.checked ? "#e8f0ff" : lowBtn.hovered ? "#f6f8fb" : "transparent"
                        border.width: 1
                        border.color: "#d8e0ec"
                    }
                    contentItem: Text {
                        text: lowBtn.text
                        color: lowBtn.checked ? "#2563eb":"#667085";
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                AbstractButton {
                    id: midBtn
                    ButtonGroup.group: buttonGroup
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 42

                    checkable: true
                    text: "中"
                    checked: !editMode ? false : todoData.priority === "中" ? true : false

                    background: Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: midBtn.checked ? "#e8f0ff" : midBtn.hovered ? "#f6f8fb" : "transparent"
                        border.width: 1
                        border.color: "#d8e0ec"
                    }
                    contentItem: Text {
                        text: midBtn.text
                        color: midBtn.checked ? "#2563eb":"#667085";
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                AbstractButton {
                    id: highBtn
                    ButtonGroup.group: buttonGroup
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 42

                    checkable: true
                    text: "高"
                    checked: !editMode ? false : todoData.priority === "高" ? true : false

                    background: Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: highBtn.checked ? "#e8f0ff" : highBtn.hovered ? "#f6f8fb" : "transparent"
                        border.width: 1
                        border.color: "#d8e0ec"
                    }
                    contentItem: Text {
                        text: highBtn.text
                        color: highBtn.checked ? "#2563eb":"#667085";
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }


            }

            //完成日期
            Label {
                id: duedateForm
                text: "完成日期"
                font.pixelSize: 13
                color: "#757575"
            }
            ComboBox{
                id: duedateBox
                Layout.preferredHeight: 42
                Layout.fillWidth: true
                contentItem: Text {
                    text: duedateBox.displayText
                    color: "#000000"
                    font.pixelSize: 16
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                indicator: Text {
                    x: duedateBox.width - width - 12
                    y: (duedateBox.height - height) / 2
                    text: "V"
                    color: "#000000"
                    font.pixelSize: 10
                }
                model: ["今天", "明天", "后天"]
                background: Rectangle {
                    anchors.fill: parent
                    radius: 12
                    border.width: 1
                    border.color: "#d8e0ec"
                }
            }

            //备注
            Label {
                id: noteForm
                text: "备注"
                font.pixelSize: 13
                color: "#757575"
            }
            TextArea {
                Layout.fillWidth: true
                Layout.preferredHeight: 90
                placeholderText: "可选备注"
                font.pixelSize: 14
                wrapMode: Text.WrapAnywhere
                background: Rectangle {
                    anchors.fill: parent
                    radius: 12
                    border.width: 1
                    border.color: "#d8e0ec"
                }
                text: todoData.note || ""
            }

            Item {
                id: item
                Layout.fillHeight: true
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Item {
                    Layout.fillWidth: true
                }
                AbstractButton {
                    id: cancelBtn
                    Layout.preferredWidth: 60
                    Layout.preferredHeight: 42
                    text: "取消"
                    background: Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: "#f6f8fb"
                    }
                    contentItem: Text {
                        text: cancelBtn.text
                        font.pixelSize: 15
                        font.bold: true
                        color: "#000000"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: root.close()
                }
                AbstractButton {
                    id: confirmBtn
                    text: editMode ? "保存修改" : "创建任务"
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 42

                    background: Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: "#2563eb"
                    }
                    contentItem: Text {
                        text: confirmBtn.text
                        font.pixelSize: 15
                        font.bold: true
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: function(){
                        root.close()
                    }
                }
            }
        }
    }

}
