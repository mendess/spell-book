__bspc_dir() {
    echo "north west south east"
}

__bspc_cycle_dir() {
    echo "next prev"
}

__bspc_node() {
    local options=(
        --focus
        --activate
        --to-desktop
        --to-monitor
        --to-node
        --swap
        --presel-dir
        --presel-ratio
        --move
        --resize
        --ratio
        --rotate
        --flip
        --equalize
        --balance
        --circulate
        --state
        --flag
        --layer
        --insert-receptacle
        --close
        --kill)
    case "$1" in
        -p | --presel-dir)
            echo -n "$(__bspc_dir) $(__bspc_dir | sed 's/^/~/g') cancel"
            ;;
        -z | --resize)
            echo "top left bottom right top_left top_right bottom_right bottom_left"
            ;;
        -R | --rotate)
            echo "90 270 180"
            ;;
        -F | --flip)
            echo "horizontal vertical"
            ;;
        -c | --circulate)
            echo "forward backward"
            ;;
        -t | --state)
            echo -n "~tiled ~pseudo_tiled ~floating ~fullscreen"
            echo "tiled pseudo_tiled floating fullscreen"
            ;;
        -g | --flag)
            echo -n "hidden sticky private locked marked"
            echo -n "hidden=on sticky=on private=on locked=on marked=on"
            echo "hidden=off sticky=off private=off locked=off marked=off"
            ;;
        -l | --layer)
            echo "below normal above"
            ;;
        *)
            echo "${options[*]}"
            ;;
    esac
}

__bspc_desktop() {
    local options=(
        --focus
        --activate
        --to-monitor
        --swap
        --layout
        --rename
        --bubble
        --remove
    )
    case "$1" in
        -l | --layout)
            echo "$(__bspc_cycle_dir) monocle tiled"
            ;;
        -b | --bubble)
            __bspc_cycle_dir
            ;;
        *)
            echo "${options[*]}"
            ;;
    esac
}

__bspc_monitor() {
    local options=(
        --focus
        --swap
        --add-desktops
        --reorder-desktops
        --reset-desktops
        --rectangle
        --rename
        --remove
    )
    echo "${options[*]}"
}

__bspc_query() {
    local options=(
        --nodes
        --desktops
        --monitors
        --tree
        --names)
    echo "${options[*]}"
}

__bspc_wm() {
    local options=(
        --dump-state
        --load-state
        --add-monitor
        --reorder-monitors
        --adopt-orphans
        --record-history
        --get-status
        --restart)
}

__bspc_rule() {
    local options=(
        --add
        --remove
        --list)

    echo "${options[*]}"
}

__bspc_config() {
    local options=(
        -m
        -d
        -n)
    case "$1" in
        -m)
            config_opts=(top_padding right_padding bottom_padding left_padding)
            ;;
        -d)
            config_opts=(window_gap)
            ;;
        -n)
            config_opts=(border_width)
            ;;
        *color)
            config_opts=(\#)
            ;;
        automatic_scheme)
            config_opts=(longest_side alternate spiral)
            ;;
        initial_polarity)
            config_opts=(first_child second_child)
            ;;
        directional_focus_tightness)
            config_opts=(high low)
            ;;
        *padding | mapping_events_count) ;;

        pointer_modifier)
            config_opts=(shift control lock mod1 mod2 mod3 mod4 mod5)
            ;;
        pointer_action?)
            config_opts=(move resize_side resize_corner focus none)
            ;;
        click_to_focus)
            config_opts=(button1 button2 button3 any none)
            ;;
        ignore_ewmh_fullscreen)
            config_opts=(none all enter exit enter,exit exit,ented)
            ;;
        *)
            config_opts=(
                top_padding
                right_padding
                bottom_padding
                left_padding
                window_gap
                border_width
                normal_border_color
                active_border_color
                focused_border_color
                presel_feedback_color
                split_ratio
                status_prefix
                external_rules_command
                automatic_scheme
                initial_polarity
                directional_focus_tightness
                removal_adjustment
                presel_feedback
                borderless_monocle
                gapless_monocle
                top_monocle_padding
                right_monocle_padding
                bottom_monocle_padding
                left_monocle_padding
                single_monocle
                pointer_motion_interval
                pointer_modifier
                pointer_action1
                pointer_action2
                pointer_action3
                click_to_focus
                swallow_first_click
                focus_follows_pointer
                pointer_follows_focus
                pointer_follows_monitor
                mapping_events_count
                ignore_ewmh_focus
                ignore_ewmh_fullscreen
                ignore_ewmh_struts
                center_pseudo_tiled
                honor_size_hints
                remove_disabled_monitors
                remove_unplugged_monitors
                merge_overlapping_monitors)
            ;;
    esac
    echo "${config_opts[*]}"
}

__bspc_subscribe() {
    local options=(
        --fifo
        --count
        report
        monitor_add
        monitor_rename
        monitor_remove
        monitor_swap
        monitor_focus
        monitor_geometry
        desktop_add
        desktop_rename
        desktop_remove
        desktop_swap
        desktop_transfer
        desktop_focus
        desktop_activate
        desktop_layout
        node_add
        node_remove
        node_swap
        node_transfer
        node_focus
        node_activate
        node_presel
        node_stack
        node_geometry
        node_state
        node_flag
        node_layer
        pointer_action
    )
    echo "${options[*]}"
}

__bspc() {
    local domains=(node desktop monitor query wm rule config subscribe quit)
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD - 1]}"
    domain="${COMP_WORDS[1]}"
    if [ "$COMP_CWORD" -eq 1 ]; then
        mapfile -t COMPREPLY < <(compgen -W "${domains[*]}" -- "$cur")
    else
        case "$domain" in
            node)
                mapfile -t COMPREPLY < <(compgen -W "$(__bspc_node "$prev")" -- "$cur")
                ;;
            desktop)
                mapfile -t COMPREPLY < <(compgen -W "$(__bspc_desktop "$prev")" -- "$cur")
                ;;
            monitor)
                mapfile -t COMPREPLY < <(compgen -W "$(__bspc_monitor "$prev")" -- "$cur")
                ;;
            query)
                mapfile -t COMPREPLY < <(compgen -W "$(__bspc_monitor "$prev")" -- "$cur")
                ;;
            wm)
                mapfile -t COMPREPLY < <(compgen -W "$(__bspc_wm "$prev")" -- "$cur")
                ;;
            rule)
                mapfile -t COMPREPLY < <(compgen -W "$(__bspc_rule "$prev")" -- "$cur")
                ;;
            config)
                mapfile -t COMPREPLY < <(compgen -W "$(__bspc_config "$prev")" -- "$cur")
                ;;
            subscribe)
                mapfile -t COMPREPLY < <(compgen -W "$(__bspc_subscribe "$prev")" -- "$cur")
                ;;
            quit)
                mapfile -t COMPREPLY < <(compgen -W "$(seq 0 255)" -- "$cur")
                ;;
        esac
    fi
}

complete -F __bspc bspc
