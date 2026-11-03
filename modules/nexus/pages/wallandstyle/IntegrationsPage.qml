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
import qs.utils
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("App Integrations")
    isSubPage: true

    property bool enableKitty: true
    property bool enableNvim: true
    property bool enableYazi: true
    property bool enableCava: true
    property bool enableBtop: true
    property bool enableFastfetch: true
    property bool enableGtk: true
    property bool enableQt: true
    property bool enableDiscord: true
    property bool enableSpicetify: true

    function loadConfig(raw: string): void {
        try {
            const data = JSON.parse(raw);
            const theme = data.theme ?? {};
            if (theme.enableKitty !== undefined) root.enableKitty = Boolean(theme.enableKitty);
            if (theme.enableNvim !== undefined) root.enableNvim = Boolean(theme.enableNvim);
            if (theme.enableYazi !== undefined) root.enableYazi = Boolean(theme.enableYazi);
            if (theme.enableCava !== undefined) root.enableCava = Boolean(theme.enableCava);
            if (theme.enableBtop !== undefined) root.enableBtop = Boolean(theme.enableBtop);
            if (theme.enableFastfetch !== undefined) root.enableFastfetch = Boolean(theme.enableFastfetch);
            if (theme.enableGtk !== undefined) root.enableGtk = Boolean(theme.enableGtk);
            if (theme.enableQt !== undefined) root.enableQt = Boolean(theme.enableQt);
            if (theme.enableDiscord !== undefined) root.enableDiscord = Boolean(theme.enableDiscord);
            if (theme.enableSpicetify !== undefined) root.enableSpicetify = Boolean(theme.enableSpicetify);
        } catch (e) {
            console.warn("Failed to parse cli config:", e);
        }
    }

    function setIntegration(key: string, enabled: bool): void {
        Quickshell.execDetached(["debonair", "integration", key, enabled ? "true" : "false"]);
    }

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.small

        FileView {
            path: `${Paths.config}/cli.json`
            watchChanges: true
            onFileChanged: root.loadConfig(text())
            onLoaded: root.loadConfig(text())
        }

        // Hero Card
        ConnectedRect {
            Layout.fillWidth: true
            first: true
            last: true
            color: Colours.tPalette.m3surfaceContainer
            radius: Tokens.rounding.large
            implicitHeight: heroCol.implicitHeight + Tokens.padding.extraLarge * 2

            ColumnLayout {
                id: heroCol
                anchors.fill: parent
                anchors.margins: Tokens.padding.extraLarge
                spacing: Tokens.spacing.small

                RowLayout {
                    spacing: Tokens.spacing.medium

                    MaterialIcon {
                        text: "hub"
                        color: Colours.palette.m3primary
                        fontStyle: Tokens.font.icon.large
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        StyledText {
                            text: Tr.tr("Desktop Ecosystem Theming")
                            font: Tokens.font.title.medium
                            color: Colours.palette.m3onSurface
                        }

                        StyledText {
                            text: Tr.tr("Debonair automatically propagates wallpaper palettes into your favorite applications.")
                            font: Tokens.font.body.small
                            color: Colours.palette.m3onSurfaceVariant
                            wrapMode: Text.Wrap
                        }
                    }
                }
            }
        }

        SectionHeader {
            text: Tr.tr("Terminal & Shell")
            first: false
        }

        ToggleRow {
            first: true
            text: Tr.tr("Kitty Terminal")
            subtext: Tr.tr("Push live ANSI 16 palette, cursor, selection, tabs & tinted background")
            checked: root.enableKitty
            onToggled: {
                root.enableKitty = checked;
                root.setIntegration("enableKitty", checked);
            }
        }

        ToggleRow {
            last: true
            text: Tr.tr("Fastfetch System Greeting")
            subtext: Tr.tr("Sync animated ASCII/GIF art greeting and terminal accent keys")
            checked: root.enableFastfetch
            onToggled: {
                root.enableFastfetch = checked;
                root.setIntegration("enableFastfetch", checked);
            }
        }

        SectionHeader {
            text: Tr.tr("Code & File Management")
            first: false
        }

        ToggleRow {
            first: true
            text: Tr.tr("Neovim Editor")
            subtext: Tr.tr("Generate debonair.lua colorscheme and notify running nvim instances")
            checked: root.enableNvim
            onToggled: {
                root.enableNvim = checked;
                root.setIntegration("enableNvim", checked);
            }
        }

        ToggleRow {
            last: true
            text: Tr.tr("Yazi File Manager")
            subtext: Tr.tr("Update flavor.toml and theme.toml with adaptive borders and status bar")
            checked: root.enableYazi
            onToggled: {
                root.enableYazi = checked;
                root.setIntegration("enableYazi", checked);
            }
        }

        SectionHeader {
            text: Tr.tr("System Monitors & Audio")
            first: false
        }

        ToggleRow {
            first: true
            text: Tr.tr("Btop System Monitor")
            subtext: Tr.tr("Regenerate debonair.theme graphs and reload via USR2 signal")
            checked: root.enableBtop
            onToggled: {
                root.enableBtop = checked;
                root.setIntegration("enableBtop", checked);
            }
        }

        ToggleRow {
            last: true
            text: Tr.tr("Cava Audio Visualizer")
            subtext: Tr.tr("Adaptive 8-color gradient audio visualizer spectrum")
            checked: root.enableCava
            onToggled: {
                root.enableCava = checked;
                root.setIntegration("enableCava", checked);
            }
        }

        SectionHeader {
            text: Tr.tr("Desktop & GUI")
            first: false
        }

        ToggleRow {
            first: true
            text: Tr.tr("GTK 3 & 4 Styling")
            subtext: Tr.tr("Sync libadwaita gtk.css and analyze Papirus folder icon colors")
            checked: root.enableGtk
            onToggled: {
                root.enableGtk = checked;
                root.setIntegration("enableGtk", checked);
            }
        }

        ToggleRow {
            text: Tr.tr("Qt & Kvantum")
            subtext: Tr.tr("Sync QtEngine color schemes and qt6ct integration")
            checked: root.enableQt
            onToggled: {
                root.enableQt = checked;
                root.setIntegration("enableQt", checked);
            }
        }

        ToggleRow {
            text: Tr.tr("Discord & Vesktop")
            subtext: Tr.tr("Sync Vesktop and client themes with active palette")
            checked: root.enableDiscord
            onToggled: {
                root.enableDiscord = checked;
                root.setIntegration("enableDiscord", checked);
            }
        }

        ToggleRow {
            last: true
            text: Tr.tr("Spotify & Spicetify")
            subtext: Tr.tr("Update Spicetify color.ini with active scheme")
            checked: root.enableSpicetify
            onToggled: {
                root.enableSpicetify = checked;
                root.setIntegration("enableSpicetify", checked);
            }
        }

        SectionHeader {
            text: Tr.tr("Actions")
            first: false
        }

        RowButton {
            first: true
            icon: "sync"
            text: Tr.tr("Sync All Integrations Now")
            subtext: Tr.tr("Re-apply current palette to all active applications and terminals")
            onClicked: {
                Quickshell.execDetached(["debonair", "integration", "sync"]);
            }
        }

        RowButton {
            last: true
            icon: "terminal"
            text: Tr.tr("Launch Kitty Terminal")
            subtext: Tr.tr("Open new terminal window to test active colors and fastfetch greeting")
            onClicked: {
                Quickshell.execDetached(["kitty"]);
            }
        }
    }
}
