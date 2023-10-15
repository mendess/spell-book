#!/bin/bash
# Configure multi monitors

directions() {
    cat <<EOF
left-of
right-of
above
below
EOF
}

# A UI for detecting and selecting all displays.
# Probes xrandr for connected displays and lets user select one to use.
# User may also select "manual selection" which opens arandr.

twoscreen() { # If multi-monitor is selected and there are two screens.

    mirror=$(printf "no\\nyes" | picker -i -l 10 -p "Mirror displays?")
    # Mirror displays using native resolution of external display and a scaled
    # version for the internal display
    if [ "$mirror" = "yes" ]; then
        external=$(echo "$screens" | dmenu -l 10 -i -p "Optimize resolution for:")
        internal=$(echo "$screens" | grep -v "$external")

        res_external=$(xrandr --query | sed -n "/^$external/,/\+/p" | tail -n 1 | awk '{print $1}')
        res_internal=$(xrandr --query | sed -n "/^$internal/,/\+/p" | tail -n 1 | awk '{print $1}')

        res_ext_x=${res_external/x*//} # $(echo $res_external | sed 's/x.*//')
        res_ext_y=${res_external/*x//} # $(echo $res_external | sed 's/.*x//')
        res_int_x=${res_internal/x*//} # $(echo $res_internal | sed 's/x.*//')
        res_int_y=${res_internal/*x//} # $(echo $res_internal | sed 's/.*x//')

        scale_x=$(echo "$res_ext_x / $res_int_x" | bc -l)
        scale_y=$(echo "$res_ext_y / $res_int_y" | bc -l)

        xrandr \
            --output "$external" \
            --auto \
            --scale 1.0x1.0 \
            --output "$internal" \
            --auto \
            --same-as "$external" \
            --scale "$scale_x"x"$scale_y"
    else

        primary=$(echo "$screens" | dmenu -l 10 -i -p "Select primary display:")
        secondary=$(echo "$screens" | grep -v "$primary")
        direction=$(directions | dmenu -l 10 -i -p "${secondary} should be _____ ${primary}?")
        xrandr \
            --output "$primary" \
            --auto \
            --scale 1.0x1.0 \
            --output "$secondary" \
            --"$direction" "$primary" \
            --auto \
            --scale 1.0x1.0
    fi
}

morescreen() { # If multi-monitor is selected and there are more than two screens.
    primary=$(echo "$screens" | dmenu -l 10 -i -p "Select primary display:")
    secondary=$(echo "$screens" | grep -v "$primary" | dmenu -l 10 -i -p "Select secondary display:")
    direction=$(directions | dmenu -l 10 -i -p "What side of $primary should $secondary be on?")
    tertiary=$(echo "$screens" | grep -v "$primary" | grep -v "$secondary" | dmenu -l 10 -i -p "Select third display:")
    xrandr \
        --output "$primary" \
        --auto \
        --output "$secondary" \
        --"$direction" "$primary" \
        --auto \
        --output "$tertiary" \
        --"$(directions | grep -v "$direction" | head -1)" "$primary" \
        --auto
}

multimon() { # Multi-monitor handler.
    #shellcheck disable=2046
    case "$(echo "$screens" | wc -l)" in
        1) xrandr $(echo "$allposs" | awk '{print "--output", $1, "--off"}' | tr '\n' ' ') ;;
        2) twoscreen ;;
        *) morescreen ;;
    esac
}

# Get all possible displays
allposs=$(xrandr -q | grep "connected")

# Get all connected screens.
screens=$(echo "$allposs" | grep " connected" | awk '{print $1}')

LAYOUTS_DIR="${XDG_CONFIG_HOME:-~/.config}/screenlayouts"
preset_layouts="$(
    cd "$LAYOUTS_DIR" || exit
    find . ! -type d -exec basename {} \; | sed -E 's/^/l:/g'
)"

# Get user choice including multi-monitor and manual selection:
#shellcheck disable=2046
chosen=$(printf "%s\\nmulti-monitor\\nmanual selection\\n%s" "$screens" "$preset_layouts" |
    dmenu -l 20 -i -p "Select display arangement:") &&
    case "$chosen" in
        "manual selection")
            arandr
            exit
            ;;
        "multi-monitor") multimon ;;
        l:*)
            sh "$LAYOUTS_DIR/${chosen#l:}"
            ;;
        '') false ;;
        *) xrandr \
            --output "$chosen" \
            --auto \
            --scale 1.0x1.0 \
            $(echo "$screens" |
                grep -v "$chosen" |
                awk '{print "--output", $1, "--off"}' |
                tr '\n' ' ') ;;
    esac &&
    # Fix background if screen size/arangement has changed.
    changeMeWall
# Re-remap keys if keyboard added (for laptop bases)
#remaps
