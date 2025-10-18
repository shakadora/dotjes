## TO DO
# imports die greyed out staan opzoeken

# hoe ROFI, GUI Apps (firefox, zim, steam, ...), TUI Apps (nvim, yazi, btop, ...) starten met binds?

# ROFI launcher
# werkt met terminal commands
#   rofi -show keys/drun/filebrowser
#   dus bind voor applaunch en voor filesearch
#   wtf gaan die binds over?

# resolutie of whatever instellen? liefst enigszins globaal


# config.py is het LIVETESTFILE, tussendoor backups
# default.py is de bare minimum start

## imports
import os
import libqtile.resources

# keys
from libqtile.config import Key
from libqtile.lazy import lazy

# mouse
from libqtile.config import Click, Drag

# groups
from libqtile.config import Group, Match

# layout
from libqtile import layout, qtile

# screens
from libqtile.config import Screen
from libqtile import bar, widget

# terminal bepalen
from libqtile.utils import guess_terminal
terminal = guess_terminal()


## keybinds

# mod4 is windows-toets
mod = "mod4"
# alt = "mod1"

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html

    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "Left", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "Right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "Down", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "Up", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod, "control"], "Left", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "Right", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "Down", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "Up", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "m", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),

    # launch terminal
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),

    # kill window
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),

    # fullscreen toggle
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen on the focused window"),

    # toggle floating
    # Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),

    # reload qtile config
    Key([mod, "control"], "m", lazy.reload_config(), desc="Reload the config"),

    # kill qtile
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    # restart qtile
    #Key([mod, "control"], "s", lazy.restart(), lazy.spawn(notify_cmd + ' "Restarting Qtile..."'), desc="Restart Qtile"),

    # command prompt in bar
    Key([mod], "q", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # Launch GUI Apps --
    #Key([mod, "shift"], "f", lazy.spawn("thunar"), desc="Launch Thunar file manager"),
    #Key([mod, "shift"], "w", lazy.spawn("vivaldi"), desc="Launch Vivaldi web browser"),
    #Key([mod, "shift"], "d", lazy.spawn("discord"), desc="Launch Discord"),


    # Launch TUI Apps
    # Neovim
    #Key(
    #    [mod, "control"],
    #    "c",
    #    lazy.spawn("wezterm start --always-new-process --cwd /home/careb0t/dotfiles zsh -c nvim; exit"),
    #    desc="Edit dotfiles",
    #),

    # Yazi
    #Key(
    #    [mod, "shift"],
    #    "y",
    #    lazy.spawn("wezterm start --always-new-process zsh -c yazi; exit"),
    #    desc="Launch Yazi",
    #),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

groups = [Group(i) for i in "azertyuiop"]

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key([mod], i.name, lazy.group[i.name].toscreen(), desc=f"Switch to group {i.name}"),

            # mod + alt + arrows = move from group to group
            Key(["control"], "Right", lazy.screen.next_group(), desc="Move to next workspace"),
            Key(["control"], "Left", lazy.screen.prev_group(), desc="Move to previous workspace"),

            # mod + shift + group number = switch to & move focused window to group
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True), desc=f"Switch to & move focused window to group {i.name}"),

            # mod + control + group number = move focused window to group
            Key([mod, "control"], i.name, lazy.window.togroup(i.name), desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="sans",
    fontsize=30,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        wallpaper='~/Downloads//605086.jpg',
            wallpaper_mode='fill',
        bottom=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                # spacer verdeelt de bar in gelijke delen
                widget.Spacer(),
                widget.TextBox("Mod+Q to enter Command", foreground="#d75f5f"),
                widget.Spacer(),
                widget.Prompt(),
                widget.Spacer(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.Spacer(),
                widget.Systray(),
                widget.Clock(format="%d-%m-%Y %a %I:%M %p"),
                widget.QuickExit(),
            ],
            40,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
focus_previous_on_window_remove = False
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
