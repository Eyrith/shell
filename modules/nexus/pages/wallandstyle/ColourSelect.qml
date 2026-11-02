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

    title: Tr.tr("Colours & Schemes")
    isSubPage: true

    property string activeSchemeName: "dynamic"
    property string activeFlavour: "default"
    property string activeMode: Colours.light ? "light" : "dark"
    property string activeVariant: "tonalspot"

    function loadScheme(raw: string): void {
        try {
            const data = JSON.parse(raw);
            if (data.name) root.activeSchemeName = String(data.name);
            if (data.flavour) root.activeFlavour = String(data.flavour);
            if (data.mode) root.activeMode = String(data.mode);
            if (data.variant) root.activeVariant = String(data.variant);
        } catch (e) {
            console.warn("Failed to parse scheme:", e);
        }
    }

    function applyScheme(name: string, flavour: string): void {
        root.activeSchemeName = name;
        const args = ["debonair", "scheme", "set", "-n", name];
        if (flavour && flavour.length > 0) {
            root.activeFlavour = flavour;
            args.push("-f", flavour);
        }
        Quickshell.execDetached(args);
    }

    function applyVariant(variant: string): void {
        root.activeVariant = variant;
        Quickshell.execDetached(["debonair", "scheme", "set", "-v", variant]);
    }

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.medium

        FileView {
            path: `${Paths.state}/scheme.json`
            watchChanges: true
            onFileChanged: root.loadScheme(text())
            onLoaded: root.loadScheme(text())
        }

        // Palette Preview Card
        ConnectedRect {
            Layout.fillWidth: true
            first: true
            last: true
            color: Colours.tPalette.m3surfaceContainer
            radius: Tokens.rounding.large
            implicitHeight: previewLayout.implicitHeight + Tokens.padding.extraLarge * 2

            ColumnLayout {
                id: previewLayout
                anchors.fill: parent
                anchors.margins: Tokens.padding.extraLarge
                spacing: Tokens.spacing.medium

                RowLayout {
                    Layout.fillWidth: true

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        StyledText {
                            text: (root.activeSchemeName === "dynamic" ? "Adaptive Wallpaper" : root.activeSchemeName.toUpperCase()) + " Scheme"
                            font: Tokens.font.title.medium
                            color: Colours.palette.m3onSurface
                        }

                        StyledText {
                            text: root.activeMode.toUpperCase() + " · " + root.activeVariant
                            font: Tokens.font.body.small
                            color: Colours.palette.m3onSurfaceVariant
                        }
                    }

                    Rectangle {
                        implicitWidth: 28
                        implicitHeight: 28
                        radius: 14
                        color: Colours.palette.m3primary
                        border.color: Colours.palette.m3outline
                        border.width: 1
                    }
                }

                // Swatch Row
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Tokens.spacing.small

                    Repeater {
                        model: [
                            { label: "Primary", col: Colours.palette.m3primary },
                            { label: "Secondary", col: Colours.palette.m3secondary },
                            { label: "Tertiary", col: Colours.palette.m3tertiary },
                            { label: "Surface", col: Colours.palette.m3surface },
                            { label: "Container", col: Colours.palette.m3primaryContainer },
                            { label: "Error", col: Colours.palette.m3error },
                        ]

                        Rectangle {
                            required property var modelData
                            Layout.fillWidth: true
                            implicitHeight: 44
                            radius: Tokens.rounding.small
                            color: modelData.col

                            StyledText {
                                anchors.centerIn: parent
                                text: modelData.label
                                font: Tokens.font.label.small
                                color: Colours.light ? "#000000" : "#ffffff"
                                style: Text.Outline
                                styleColor: Colours.light ? "#ffffff" : "#000000"
                            }
                        }
                    }
                }
            }
        }

        SectionHeader {
            text: Tr.tr("Base Schemes")
            first: false
        }

        // Scheme Selector Grid
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: Tokens.spacing.small
            columnSpacing: Tokens.spacing.small

            Repeater {
                model: [
                    { id: "dynamic", name: "Dynamic Wallpaper", icon: "auto_awesome", desc: "Auto-extract from wallpaper" },
                    { id: "catppuccin", name: "Catppuccin Mocha", icon: "palette", desc: "Soothing pastel dark" },
                    { id: "gruvbox", name: "Gruvbox", icon: "brush", desc: "Warm retro groove" },
                    { id: "everforest", name: "Everforest", icon: "nature", desc: "Comfortable natural green" },
                    { id: "nord", name: "Nord", icon: "ac_unit", desc: "Arctic cold palette" },
                    { id: "tokyonight", name: "Tokyo Night", icon: "nightlife", desc: "Vibrant neon cyberpunk" },
                    { id: "rosepine", name: "Rosé Pine", icon: "local_florist", desc: "All natural pine & rose" },
                    { id: "onedark", name: "One Dark", icon: "dark_mode", desc: "Classic modern dark" },
                    { id: "dracula", name: "Dracula", icon: "wb_twilight", desc: "Dark theme for vampires" },
                    { id: "solarized", name: "Solarized", icon: "wb_sunny", desc: "Precision lab colours" }
                ]

                ConnectedRect {
                    required property var modelData
                    Layout.fillWidth: true
                    implicitHeight: 64
                    first: true
                    last: true
                    color: root.activeSchemeName === modelData.id ? Colours.tPalette.m3primaryContainer : Colours.tPalette.m3surfaceContainer

                    StateLayer {
                        anchors.fill: parent
                        onClicked: root.applyScheme(modelData.id, "")
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Tokens.padding.medium
                        spacing: Tokens.spacing.medium

                        MaterialIcon {
                            text: modelData.icon
                            color: root.activeSchemeName === modelData.id ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3primary
                            fontStyle: Tokens.font.icon.medium
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1

                            StyledText {
                                text: modelData.name
                                font: Tokens.font.body.medium
                                color: root.activeSchemeName === modelData.id ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurface
                            }

                            StyledText {
                                text: modelData.desc
                                font: Tokens.font.label.small
                                color: root.activeSchemeName === modelData.id ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurfaceVariant
                                elide: Text.ElideRight
                            }
                        }

                        MaterialIcon {
                            visible: root.activeSchemeName === modelData.id
                            text: "check_circle"
                            color: Colours.palette.m3primary
                            fontStyle: Tokens.font.icon.small
                        }
                    }
                }
            }
        }

        SectionHeader {
            text: Tr.tr("Material You Variant")
            first: false
        }

        ConnectedRect {
            Layout.fillWidth: true
            first: true
            last: true
            implicitHeight: varCol.implicitHeight + Tokens.padding.medium * 2

            ColumnLayout {
                id: varCol
                anchors.fill: parent
                anchors.margins: Tokens.padding.largeIncreased
                spacing: Tokens.spacing.small

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Tokens.spacing.small

                    Repeater {
                        model: [
                            { id: "tonalspot", name: "Tonal Spot" },
                            { id: "vibrant", name: "Vibrant" },
                            { id: "expressive", name: "Expressive" },
                            { id: "rainbow", name: "Rainbow" }
                        ]

                        IconTextButton {
                            required property var modelData
                            Layout.fillWidth: true
                            text: modelData.name
                            type: modelData.id === root.activeVariant ? IconTextButton.Filled : IconTextButton.Tonal
                            font: Tokens.font.label.medium
                            onClicked: root.applyVariant(modelData.id)
                        }
                    }
                }
            }
        }
    }
}
