import QtQuick
import QtQuick.Controls
import QtQml
import QtQuick.Layouts

/**
 * CalendarPicker - 可复用的日历选择组件
 * 适用于 Qt 6.x
 */
Rectangle {
    id: root

    // ============================================================
    // 对外属性
    // ============================================================

    property date selectedDate: new Date()
    property bool expanded: false
    property string title: "选择日期"
    property string dateFormat: "yyyy-MM-dd"
    property var locale: Qt.locale("zh_CN")
    property color selectedColor: "#2196F3"
    property color hoverColor: "#E3F2FD"
    property color todayColor: "#FFF9C4"
    property real otherMonthOpacity: 0.3
    property int animationDuration: 300
    property bool autoClose: true

    // ============================================================
    // 信号
    // ============================================================

    signal dateSelected(date date)

    // ============================================================
    // 内部属性（修复：使用 readonly 替代 alias）
    // ============================================================

    readonly property int __headerHeight: 45

    // 修复：将 __contentHeight 定义为 readonly property
    readonly property int __contentHeight: {
        var h = 20 // padding top
        h += 24    // 星期行
        h += 24    // 月份导航
        h += 35 * 5 // 日期网格 (6行)
        h += 10    // padding bottom
        return h
    }

    // ============================================================
    // UI
    // ============================================================

    width: 350
    height: __headerHeight + (expanded ? __contentHeight : 0)
    color: "white"
    radius: 8
    clip: true

    Behavior on height {
        NumberAnimation {
            duration: root.animationDuration
            easing.type: Easing.InOutQuad
        }
    }

    // ---- 标题头 ----
    Rectangle {
        id: headerRect
        width: parent.width
        height: __headerHeight
        //color: root.expanded ? root.selectedColor : "#F5F5F5"
        color: root.expanded ? "#F5F5F5" : "#ffffff"
        border.width: 1
        border.color: "#d8e0ec"
        radius: 8

        Row {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 8

            Text {
                id: titleText
                text: {
                    if (root.selectedDate.getFullYear() === 1970) {
                        return root.title
                    }
                    return Qt.formatDate(root.selectedDate, root.dateFormat)
                }
                color: "#333333"
                font.pixelSize: 14
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
                width: parent.width - 50
            }

            Item {
                width: 10
                Layout.fillWidth: true
            }

            // 切换按钮
            Rectangle {
                width: 30
                height: 30
                radius: 15
                color: "#E0E0E0"
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text: root.expanded ? "▲" : "▼"
                    color: "#666666"
                    font.pixelSize: 12
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.expanded = !root.expanded
                    }
                }
            }
        }
    }

    // ---- 内容区域 ----
    Rectangle {
        id: contentArea
        width: parent.width
        height: root.expanded ? root.__contentHeight : 0
        anchors.top: headerRect.bottom
        color: "white"
        clip: true
        border.width: 1
        border.color: "#d8e0ec"
        radius: 8

        Behavior on height {
            NumberAnimation {
                duration: root.animationDuration
                easing.type: Easing.InOutQuad
            }
        }

        Column {
            width: parent.width - 20
            anchors.centerIn: parent
            spacing: 8

            // ---- 月份导航 ----
            Row {
                width: parent.width
                height: 26
                spacing: 10

                Rectangle {
                    width: 30
                    height: 26
                    radius: 15
                    color: leftArrowMouse.containsMouse ? "#E0E0E0" : "transparent"

                    Text {
                        text: "<"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#666666"
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        id: leftArrowMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            var d = new Date(monthGrid.year, monthGrid.month - 1, 1)
                            monthGrid.month = d.getMonth()
                            monthGrid.year = d.getFullYear()
                        }
                    }
                }

                Text {
                    text: monthGrid.title
                    font.pixelSize: 16
                    font.bold: true
                    color: "#333333"
                    horizontalAlignment: Text.AlignHCenter
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 80
                }

                Rectangle {
                    width: 30
                    height: 26
                    radius: 15
                    color: rightArrowMouse.containsMouse ? "#E0E0E0" : "transparent"

                    Text {
                        text: ">"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#666666"
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        id: rightArrowMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            var d = new Date(monthGrid.year, monthGrid.month + 1, 1)
                            monthGrid.month = d.getMonth()
                            monthGrid.year = d.getFullYear()
                        }
                    }
                }
            }

            // ---- 星期行 ----
            Row {
                id: weekRow
                width: parent.width
                height: 24
                spacing: 0

                Repeater {
                    model: {
                        var names = []
                        var firstDay = root.locale.firstDayOfWeek
                        for (var i = 0; i < 7; i++) {
                            var dayIndex = (firstDay + i) % 7
                            names.push(root.locale.dayName(dayIndex, Locale.ShortFormat))
                        }
                        return names
                    }

                    Rectangle {
                        width: (weekRow.width) / 7
                        height: 30
                        color: "transparent"

                        Text {
                            text: modelData
                            anchors.centerIn: parent
                            font.pixelSize: 12
                            font.bold: true
                            color: "#999999"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }

            // ---- 月网格 ----
            Grid {
                id: monthGrid
                width: parent.width
                columns: 7
                columnSpacing: 0
                rowSpacing: 0

                property int month: root.selectedDate.getMonth()
                property int year: root.selectedDate.getFullYear()
                property string title: {
                    var d = new Date(year, month, 1)
                    return Qt.formatDate(d, "yyyy年MM月")
                }

                // 生成当前月的日期数据（不包含前后月填充）
                property var days: {
                    var result = []
                    var lastDay = new Date(year, month + 1, 0)  // 当月最后一天
                    var firstDayOfWeek = new Date(year, month, 1).getDay()
                    var localeFirstDay = root.locale.firstDayOfWeek
                    var offset = (firstDayOfWeek - localeFirstDay + 7) % 7

                    // 只在前面插入空白占位，不填充上个月的日期
                    for (var i = 0; i < offset; i++) {
                        result.push({
                            date: null,
                            day: "",
                            month: month,
                            year: year,
                            isCurrentMonth: false,
                            isEmpty: true  // 标记为空白
                        })
                    }

                    // 当前月所有日期
                    for (var j = 1; j <= lastDay.getDate(); j++) {
                        var d = new Date(year, month, j)
                        result.push({
                            date: d,
                            day: j,
                            month: month,
                            year: year,
                            isCurrentMonth: true,
                            isEmpty: false
                        })
                    }

                    // 后面补空白占位，凑满 42 个格子
                    var remaining = 42 - result.length
                    for (var k = 0; k < remaining; k++) {
                        result.push({
                            date: null,
                            day: "",
                            month: month,
                            year: year,
                            isCurrentMonth: false,
                            isEmpty: true
                        })
                    }

                    return result
                }

                Repeater {
                    model: monthGrid.days

                    Rectangle {
                        required property var modelData

                        width: (monthGrid.width) / 7
                        height: 35
                        radius: 4

                        // 如果是空白占位，不显示任何内容
                        visible: !modelData.isEmpty

                        readonly property bool isToday: {
                            if (modelData.isEmpty || modelData.date === null) return false
                            var today = new Date()
                            var d = modelData.date
                            return d.getFullYear() === today.getFullYear() &&
                                   d.getMonth() === today.getMonth() &&
                                   d.getDate() === today.getDate()
                        }

                        readonly property bool isSelected: {
                            if (modelData.isEmpty || modelData.date === null) return false
                            var d = modelData.date
                            return d.getFullYear() === root.selectedDate.getFullYear() &&
                                   d.getMonth() === root.selectedDate.getMonth() &&
                                   d.getDate() === root.selectedDate.getDate()
                        }

                        color: {
                            if (isSelected) return root.selectedColor
                            if (isToday && !isSelected) return root.todayColor
                            if (dateMouseArea.containsMouse) return root.hoverColor
                            return "transparent"
                        }

                        Text {
                            text: modelData.day
                            anchors.centerIn: parent
                            font.pixelSize: 13
                            font.bold: isSelected || isToday
                            color: {
                                if (isSelected) return "white"
                                if (isToday) return "#1976D2"
                                return "#333333"
                            }
                        }

                        // 选中标记点
                        Rectangle {
                            visible: isSelected && !isToday
                            width: 4
                            height: 4
                            radius: 2
                            color: "white"
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 3
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        MouseArea {
                            id: dateMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                if (!modelData.isEmpty && modelData.isCurrentMonth) {
                                    root.dateSelected(modelData.date)
                                    console.log("Date selected:", Qt.formatDate(modelData.date, root.dateFormat))

                                    if (root.autoClose) {
                                        root.expanded = false
                                    }
                                }
                            }
                        }
                    }
                }
            }

        }
    }

    // ============================================================
    // 辅助方法
    // ============================================================

    function goToToday() {
        var today = new Date()
        monthGrid.month = today.getMonth()
        monthGrid.year = today.getFullYear()
    }

    function goToDate(date) {
        monthGrid.month = date.getMonth()
        monthGrid.year = date.getFullYear()
    }

    function clearSelection() {
        selectedDate = new Date(1970, 0, 1)
    }

    function open() {
        expanded = true
        expandedChanged(expanded)
    }

    function close() {
        expanded = false
        expandedChanged(expanded)
    }

    function toggle() {
        expanded = !expanded
        expandedChanged(expanded)
    }
}
