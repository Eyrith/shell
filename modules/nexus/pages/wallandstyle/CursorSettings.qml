pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Caelestia.Components
import Caelestia.Config
import Caelestia.I18n
import qs.components
import qs.components.controls
import qs.services
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Cursor & Style")
    isSubPage: true

    property bool cursorEnabled: true
    property int cursorSize: 24
    property string cursorColor: Colours.palette.m3primary
    property string cursorTheme: "debonair-cursor"

    function loadState(raw: string): void {
        try {
            const data = JSON.parse(raw);
            if (data.enabled !== undefined)
                root.cursorEnabled = Boolean(data.enabled);
            if (data.size !== undefined)
                root.cursorSize = Number(data.size);
            if (data.color)
                root.cursorColor = String(data.color);
            if (data.theme)
                root.cursorTheme = String(data.theme);
        } catch (e) {
            console.warn("Failed to parse cursor state:", e);
        }
    }

    function setCursorSize(size: int): void {
        root.cursorSize = size;
        Quickshell.execDetached(["debonair", "cursor", "palette", "-s", String(size)]);
        Quickshell.execDetached(["debonair", "integration", "cursorSize", String(size)]);
    }

    function toggleCursor(enabled: bool): void {
        root.cursorEnabled = enabled;
        Quickshell.execDetached(["debonair", "integration", "enableCursor", enabled ? "true" : "false"]);
        if (enabled) {
            Quickshell.execDetached(["debonair", "cursor", "palette", "-s", String(root.cursorSize)]);
        }
    }

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.medium

        FileView {
            path: `${Paths.state}/cursor-state.json`
            watchChanges: true
            onFileChanged: root.loadState(text())
            onLoaded: root.loadState(text())
        }

        // Cursor Preview Card
        ConnectedRect {
            Layout.fillWidth: true
            first: true
            last: true
            color: Colours.tPalette.m3surfaceContainer
            radius: Tokens.rounding.large
            implicitHeight: previewCol.implicitHeight + Tokens.padding.extraLarge * 2

            ColumnLayout {
                id: previewCol
                anchors.fill: parent
                anchors.margins: Tokens.padding.extraLarge
                spacing: Tokens.spacing.medium

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Tokens.spacing.medium

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        StyledText {
                            text: Tr.tr("Adaptive Vector Cursor")
                            font: Tokens.font.title.medium
                            color: Colours.palette.m3onSurface
                        }

                        StyledText {
                            text: root.cursorTheme + " · " + root.cursorSize + "px"
                            font: Tokens.font.body.small
                            color: Colours.palette.m3onSurfaceVariant
                        }
                    }

                    // Color swatch pill
                    Rectangle {
                        implicitWidth: 100
                        implicitHeight: 34
                        radius: 17
                        color: root.cursorColor
                        border.color: Colours.palette.m3outline
                        border.width: 1

                        StyledText {
                            anchors.centerIn: parent
                            text: root.cursorColor.toUpperCase()
                            font: Tokens.font.label.small
                            color: Colours.light ? "#000000" : "#ffffff"
                            style: Text.Outline
                            styleColor: Colours.light ? "#ffffff" : "#000000"
                        }
                    }
                }

                // Interactive preview display
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 90
                    radius: Tokens.rounding.medium
                    color: Colours.tPalette.m3surfaceContainerHigh

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: Tokens.spacing.extraLarge * 1.5

                        ColumnLayout {
                            spacing: 4
                            MaterialIcon {
                                Layout.alignment: Qt.AlignHCenter
                                text: "near_me"
                                color: root.cursorColor
                                fontStyle: Tokens.font.icon.large
                            }
                            StyledText {
                                Layout.alignment: Qt.AlignHCenter
                                text: Tr.tr("Pointer")
                                font: Tokens.font.label.small
                                color: Colours.palette.m3onSurfaceVariant
                            }
                        }

                        ColumnLayout {
                            spacing: 4
                            MaterialIcon {
                                Layout.alignment: Qt.AlignHCenter
                                text: "touch_app"
                                color: root.cursorColor
                                fontStyle: Tokens.font.icon.large
                            }
                            StyledText {
                                Layout.alignment: Qt.AlignHCenter
                                text: Tr.tr("Pointer Hand")
                                font: Tokens.font.label.small
                                color: Colours.palette.m3onSurfaceVariant
                            }
                        }

                        ColumnLayout {
                            spacing: 4
                            MaterialIcon {
                                Layout.alignment: Qt.AlignHCenter
                                text: "edit"
                                color: root.cursorColor
                                fontStyle: Tokens.font.icon.large
                            }
                            StyledText {
                                Layout.alignment: Qt.AlignHCenter
                                text: Tr.tr("I-Beam")
                                font: Tokens.font.label.small
                                color: Colours.palette.m3onSurfaceVariant
                            }
                        }

                        ColumnLayout {
                            spacing: 4
                            MaterialIcon {
                                Layout.alignment: Qt.AlignHCenter
                                text: "open_with"
                                color: root.cursorColor
                                fontStyle: Tokens.font.icon.large
                            }
                            StyledText {
                                Layout.alignment: Qt.AlignHCenter
                                text: Tr.tr("Move")
                                font: Tokens.font.label.small
                                color: Colours.palette.m3onSurfaceVariant
                            }
                        }
                    }
                }
            }
        }

        SectionHeader {
            text: Tr.tr("Configuration")
            first: false
        }

        ToggleRow {
            first: true
            text: Tr.tr("Adaptive wallpaper recoloring")
            subtext: Tr.tr("Extracts accent colour from active wallpaper and recolours vector cursors")
            checked: root.cursorEnabled
            onToggled: root.toggleCursor(checked)
        }

        // Size presets
        ConnectedRect {
            Layout.fillWidth: true
            last: true
            implicitHeight: sizeCol.implicitHeight + Tokens.padding.medium * 2

            ColumnLayout {
                id: sizeCol
                anchors.fill: parent
                anchors.margins: Tokens.padding.largeIncreased
                spacing: Tokens.spacing.small

                RowLayout {
                    Layout.fillWidth: true

                    StyledText {
                        text: Tr.tr("Cursor Size")
                        font: Tokens.font.body.medium
                        color: Colours.palette.m3onSurface
                    }

                    Item { Layout.fillWidth: true }

                    StyledText {
                        text: root.cursorSize + " px"
                        font: Tokens.font.label.large
                        color: Colours.palette.m3primary
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Tokens.spacing.small

                    Repeater {
                        model: [24, 28, 32, 36, 48]

                        IconTextButton {
                            required property int modelData
                            Layout.fillWidth: true
                            text: modelData + "px"
                            type: modelData === root.cursorSize ? IconTextButton.Filled : IconTextButton.Tonal
                            font: Tokens.font.label.medium
                            onClicked: root.setCursorSize(modelData)
                        }
                    }
                }
            }
        }

        SectionHeader {
            text: Tr.tr("Quick Actions")
            first: false
        }

        RowButton {
            first: true
            icon: "refresh"
            text: Tr.tr("Recompile & Apply Cursor")
            subtext: Tr.tr("Force compile vector SVGs with current wallpaper palette")
            onClicked: {
                Quickshell.execDetached(["debonair", "cursor", "palette", "-s", String(root.cursorSize)]);
            }
        }

        RowButton {
            last: true
            icon: "restart_alt"
            text: Tr.tr("Reset to Bibata Modern Classic")
            subtext: Tr.tr("Switch live compositor and GTK back to default theme")
            onClicked: {
                root.cursorEnabled = false;
                Quickshell.execDetached(["debonair", "integration", "enableCursor", "false"]);
                Quickshell.execDetached(["hyprctl", "setcursor", "Bibata-Modern-Classic", String(root.cursorSize)]);
            }
        }
    }
}
