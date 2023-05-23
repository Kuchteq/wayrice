/* Copyright 2022 @ Keychron (https://www.keychron.com)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/* BASED SETTINGS */
#define TAPPING_TERM 200
#define HOLD_ON_OTHER_KEY_PRESS
// This one is very important as it prevents repeting escape after pressing the key twice
#define TAPPING_FORCE_HOLD 

#pragma once

#ifdef RGB_MATRIX_ENABLE
/* RGB Matrix driver configuration */
#    define DRIVER_COUNT 2

#    define DRIVER_ADDR_1 0b1110111
#    define DRIVER_ADDR_2 0b1110100
#    define DRIVER_1_LED_COUNT 46
#    define DRIVER_2_LED_COUNT 38
#    define RGB_MATRIX_LED_COUNT (DRIVER_1_LED_COUNT + DRIVER_2_LED_COUNT)

/* Set to infinit, which is use in USB mode by default */
#define RGB_MATRIX_TIMEOUT RGB_MATRIX_TIMEOUT_INFINITE

/* Allow shutdown of led driver to save power */
#    define RGB_MATRIX_DRIVER_SHUTDOWN_ENABLE
/* Turn off backlight on low brightness to save power */
#    define RGB_MATRIX_BRIGHTNESS_TURN_OFF_VAL 32

#    define DIM_CAPS_LOCK
#    define CAPS_LOCK_INDEX 46
#    define LOW_BAT_IND_INDEX 77

#    ifdef VIA_ENABLE
#        define VIA_QMK_RGBLIGHT_ENABLE
#    endif

/* RGB Matrix Animation modes. Explicitly enabled
 * For full list of effects, see:
 * https://docs.qmk.fm/#/feature_rgb_matrix?id=rgb-matrix-effects
 */

#    define RGB_MATRIX_KEYPRESSES
#    define RGB_MATRIX_FRAMEBUFFER_EFFECTS

// #    define ENABLE_RGB_MATRIX_ALPHAS_MODS
// #    define ENABLE_RGB_MATRIX_GRADIENT_UP_DOWN
// #    define ENABLE_RGB_MATRIX_GRADIENT_LEFT_RIGHT
#    define ENABLE_RGB_MATRIX_BREATHING
// #    define ENABLE_RGB_MATRIX_BAND_SAT
// #    define ENABLE_RGB_MATRIX_BAND_VAL
// #    define ENABLE_RGB_MATRIX_BAND_PINWHEEL_SAT
// #    define ENABLE_RGB_MATRIX_BAND_PINWHEEL_VAL
// #    define ENABLE_RGB_MATRIX_BAND_SPIRAL_SAT
#    define ENABLE_RGB_MATRIX_BAND_SPIRAL_VAL
#    define ENABLE_RGB_MATRIX_CYCLE_ALL
#    define ENABLE_RGB_MATRIX_CYCLE_LEFT_RIGHT
#    define ENABLE_RGB_MATRIX_CYCLE_UP_DOWN
#    define ENABLE_RGB_MATRIX_RAINBOW_MOVING_CHEVRON
#    define ENABLE_RGB_MATRIX_CYCLE_OUT_IN
#    define ENABLE_RGB_MATRIX_CYCLE_OUT_IN_DUAL
#    define ENABLE_RGB_MATRIX_CYCLE_PINWHEEL
#    define ENABLE_RGB_MATRIX_CYCLE_SPIRAL
#    define ENABLE_RGB_MATRIX_DUAL_BEACON
#    define ENABLE_RGB_MATRIX_RAINBOW_BEACON
// #    define ENABLE_RGB_MATRIX_RAINBOW_PINWHEELS
//#    define ENABLE_RGB_MATRIX_RAINDROPS
#    define ENABLE_RGB_MATRIX_JELLYBEAN_RAINDROPS
//#    define ENABLE_RGB_MATRIX_HUE_BREATHING
//#    define ENABLE_RGB_MATRIX_HUE_PENDULUM
//#    define ENABLE_RGB_MATRIX_HUE_WAVE
#    define ENABLE_RGB_MATRIX_PIXEL_RAIN
//#    define ENABLE_RGB_MATRIX_PIXEL_FLOW
//#    define ENABLE_RGB_MATRIX_PIXEL_FRACTAL

/* enabled only if RGB_MATRIX_FRAMEBUFFER_EFFECTS is defined */
#    define ENABLE_RGB_MATRIX_TYPING_HEATMAP
#    define ENABLE_RGB_MATRIX_DIGITAL_RAIN

/*  enabled only of RGB_MATRIX_KEYPRESSES or RGB_MATRIX_KEYRELEASES is defined*/
#    define ENABLE_RGB_MATRIX_SOLID_REACTIVE_SIMPLE
//#    define ENABLE_RGB_MATRIX_SOLID_REACTIVE
//#    define ENABLE_RGB_MATRIX_SOLID_REACTIVE_WIDE
#    define ENABLE_RGB_MATRIX_SOLID_REACTIVE_MULTIWIDE
//#    define ENABLE_RGB_MATRIX_SOLID_REACTIVE_CROSS
//#    define ENABLE_RGB_MATRIX_SOLID_REACTIVE_MULTICROSS
//#    define ENABLE_RGB_MATRIX_SOLID_REACTIVE_NEXUS
#    define ENABLE_RGB_MATRIX_SOLID_REACTIVE_MULTINEXUS
#    define ENABLE_RGB_MATRIX_SPLASH
//#    define ENABLE_RGB_MATRIX_MULTISPLASH
#    define ENABLE_RGB_MATRIX_SOLID_SPLASH
//#    define ENABLE_RGB_MATRIX_SOLID_MULTISPLASH

/* Set LED driver current */
#    define CKLED2001_CURRENT_TUNE   {0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38}

#endif
