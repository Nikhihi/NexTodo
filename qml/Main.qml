import QtQuick
import QtQuick.Controls
import "layouts" as Layouts

ApplicationWindow{
    id: mainWindow
    visible: true
    visibility: Window.Maximized

    readonly property bool isPhone: width < 600
    readonly property bool isTablet: width >= 600 && width < 1000
    readonly property bool isDesktop: width >= 1000

    Loader {
        anchors.fill: parent
        sourceComponent: mainWindow.isPhone ? phoneLayout
                                            : mainWindow.isDesktop
                                              ? desktopLayout
                                              : tabletLayout
    }

    Component {
        id: phoneLayout
        Layouts.PhoneLayout {
            anchors.fill: parent
        }
    }

    Component {
        id: tabletLayout
        Layouts.TabletLayout {
            anchors.fill: parent
        }
    }

    Component {
        id: desktopLayout
        Layouts.DesktopLayout {
            anchors.fill: parent
        }
    }
}
