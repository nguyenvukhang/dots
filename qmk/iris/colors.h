/* Copyright 2021 Nguyen Vu Khang <brew4k@gmail.com>
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

#pragma once

/* for startup/initial colorscheme */
#define MINIMAL_FRONTx(hue, sat, lum) \
    rgblight_sethsv_range(0, 0, 0, 0, 12); \
    rgblight_sethsv_range(hue, sat, lum, 0, 3); \
    rgblight_sethsv_range(hue, sat, lum, 9, 12);

#define MINIMAL_FRONT(hue, sat, lum) \
    {0, 12, 0, 0, 0}, \
    {0,  3, hue, sat, lum}, \
    {9,  3, hue, sat, lum}

#define MINIMAL_OUT(hue, sat, lum) \
    {0, 12, 0, 0, 0}, \
    {3,  1, hue, sat, lum}, \
    {8,  1, hue, sat, lum}

#define MINIMAL_IN(hue, sat, lum) \
    {0, 12, 0, 0, 0}, \
    {5,  2, hue, sat, lum}

const int yellow = 30;
const int green = 99;
const int blue = 130;
const int pink = 235;
const int red = 252;
const int base_sat = 120;

#define  base  MINIMAL_FRONT(pink, 250, 100)
#define basex MINIMAL_FRONTx(pink, 250, 100)
#define  func MINIMAL_IN(green, 250, 100)
#define  sudo MINIMAL_IN(red, 250, 100)

const rgblight_segment_t PROGMEM _BL_rgblayer[] = RGBLIGHT_LAYER_SEGMENTS(base);
const rgblight_segment_t PROGMEM _FN_rgblayer[] = RGBLIGHT_LAYER_SEGMENTS(func);
const rgblight_segment_t PROGMEM _SL_rgblayer[] = RGBLIGHT_LAYER_SEGMENTS(sudo);

/* order matters here
 * for use later in 
 * default_layer_state_set_user and layer_state_set_user
 */
const rgblight_segment_t* const PROGMEM my_rgb_layers[] = RGBLIGHT_LAYERS_LIST(
    _BL_rgblayer,
    _FN_rgblayer,
    _SL_rgblayer
);

/* default on startup */
void keyboard_post_init_user(void) {
    basex;
    rgblight_layers = my_rgb_layers;
}

/* color after returning from first change */
layer_state_t default_layer_state_set_user(layer_state_t state) {
    // rgblight_set_layer_state(<index>, layer_state_cmp(state, <keymap>));
    rgblight_set_layer_state(0, layer_state_cmp(state, _BL));
    return state;
}

/* other layers */
layer_state_t layer_state_set_user(layer_state_t state) {
    // rgblight_set_layer_state(<index>, layer_state_cmp(state, <keymap>));
    rgblight_set_layer_state(1, layer_state_cmp(state, _FN));
    rgblight_set_layer_state(2, layer_state_cmp(state, _SL));
    return state;
}
