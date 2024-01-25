/* Copyright 2023 Nguyen Vu Khang <brew4k@gmail.com>
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

#include QMK_KEYBOARD_H

enum keyboard_layers {
    BASE_L,
    FUNC_L,
    DANGER_L,
};

#define MY_LAYOUT LAYOUT_60_ansi_split_bs_rshift

#define KC_BSP2 LT(FUNC_L, KC_BSPC)
#define MO_DG MO(DANGER_L)

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    // clang-format off
    [BASE_L] = MY_LAYOUT(
        KC_GRV , KC_1   , KC_2   , KC_3   , KC_4   , KC_5   , KC_6   , KC_7   , KC_8   , KC_9   , KC_0   , KC_MINS, KC_EQL , KC_BSP2, KC_BSPC,
        KC_TAB , KC_Q   , KC_W   , KC_E   , KC_R   , KC_T   , KC_Y   , KC_U   , KC_I   , KC_O   , KC_P   , KC_LBRC, KC_RBRC, KC_BSLS,
        KC_ESC , KC_A   , KC_S   , KC_D   , KC_F   , KC_G   , KC_H   , KC_J   , KC_K   , KC_L   , KC_SCLN, KC_QUOT,          KC_ENT ,
        KC_LSFT, KC_Z   , KC_X   , KC_C   , KC_V   , KC_B   , KC_N   , KC_M   , KC_COMM, KC_DOT , KC_SLSH, MO(FUNC_L), _______,
        KC_LCTL, KC_LALT, KC_LGUI,                   KC_SPC ,                            KC_LEFT, KC_DOWN, KC_UP  , KC_RIGHT
    ),

    //  [  ~  ]  [  1  ]  [  2  ]  [  3  ]  [  4  ]  [  5  ]  [  6  ]  [  7  ]  [  8  ]  [  9  ]  [  0  ]  [  -  ]  [  =  ]  [  ?  ]  [  ?  ]
    //  [ TAB ]  [  Q  ]  [  W  ]  [  E  ]  [  R  ]  [  T  ]  [  Y  ]  [  U  ]  [  I  ]  [  O  ]  [  P  ]  [  {  ]  [  }  ]  [ \|  ]
    //  [ ESC ]  [  A  ]  [  S  ]  [  D  ]  [  F  ]  [  G  ]  [  H  ]  [  J  ]  [  K  ]  [  L  ]  [  ;  ]  [  "  ]  [    ENTER     ]
    //  [ SFT ]  [  Z  ]  [  X  ]  [  C  ]  [  V  ]  [  B  ]  [  N  ]  [  M  ]  [ ,<  ]  [ .>  ]  [  /  ]  [   R SHIFT    ]
    //  [ CTL ]  [ ALT ]  [ CMD ]  [                       SPACE                      ]  [  ←  ]  [  ↓  ]  [  ↑  ]  [  →  ]

    [FUNC_L] = MY_LAYOUT(
        MO_DG  , KC_F1  , KC_F2  , KC_F3  , KC_F4  , KC_F5  , KC_F6  , KC_F7  , KC_F8  , KC_F9  , KC_F10 , KC_F11 , KC_F12 , _______, KC_DEL ,
        _______, _______, _______, _______, RGB_TOG, _______, _______, _______, _______, _______, _______, _______, _______, _______,
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,          _______,
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,
        _______, _______, _______,                   _______,                            _______, _______, _______, _______
    ),

    [DANGER_L] = MY_LAYOUT(
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, QK_BOOT,
        _______, _______, _______, _______, RGB_TOG, _______, _______, _______, _______, _______, _______, _______, _______, _______,
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,          _______,
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,
        _______, _______, _______,                   _______,                            _______, _______, _______, _______
    )
    // clang-format on
};

#define SAT 255 // saturation
#define LUM 180 // luminosity

#define GRADIENT(base, step, offset) (base + step * offset) % 256
#define TUP(i, hue, sat, lum) \
    { i, 1, hue, sat, lum }
#define X16(F) F(0), F(1), F(2), F(3), F(4), F(5), F(6), F(7), F(8), F(9), F(10), F(11), F(12), F(13), F(14), F(15)

#define ONE(i, hue) TUP(i, hue, SAT, LUM)
#define L16(F, a, b, c, d, m, n, p, q, r, s, u, v, w, x, y, z) F(0, a), F(1, b), F(2, c), F(3, d), F(4, m), F(5, n), F(6, p), F(7, q), F(8, r), F(9, s), F(10, u), F(11, v), F(12, w), F(13, x), F(14, y), F(15, z)
#define ROW(a, b, c, d, p, q, r, s) a, b, c, d, p, q, r, s

#define RED_2_ORANGE(i) GRADIENT(7, -1, i)

#define RGB_LAYER(name, ...) const rgblight_segment_t PROGMEM name[] = RGBLIGHT_LAYER_SEGMENTS(L16(ONE, __VA_ARGS__));

RGB_LAYER(BASE_RGB, ROW(190, 196, 202, 208, 214, 220, 226, 236), ROW(6, 9, 11, 14, 16, 19, 21, 24))
RGB_LAYER(DANGER_RGB, X16(RED_2_ORANGE))

const rgblight_segment_t *const PROGMEM my_rgb_layers[] = RGBLIGHT_LAYERS_LIST(BASE_RGB, DANGER_RGB);

void keyboard_post_init_user(void) {
    rgblight_layers = my_rgb_layers;
}

layer_state_t default_layer_state_set_user(layer_state_t state) {
    rgblight_set_layer_state(0, layer_state_cmp(state, BASE_L));
    return state;
}

layer_state_t layer_state_set_user(layer_state_t state) {
    rgblight_set_layer_state(1, layer_state_cmp(state, DANGER_L));
    return state;
}

const key_override_t delete_key_override = ko_make_basic(MOD_MASK_CTRL, KC_BSPC, KC_DEL);

// This globally defines all key overrides to be used
const key_override_t **key_overrides = (const key_override_t *[]){
    &delete_key_override,
    NULL,
};

uint16_t keycode_config(uint16_t keycode) {
    return keycode;
}
uint8_t mod_config(uint8_t mod) {
    return mod;
}
