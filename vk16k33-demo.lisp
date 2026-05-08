(load "./vk16k33.lisp")

; Setup
(i2c-vk16k33:system-setup i2c-vk16k33:TURN_ON_SYSTEM)
(i2c-vk16k33:display-setup i2c-vk16k33:BLINKING_OFF i2c-vk16k33:DISPLAY_ON)
(i2c-vk16k33:set-dimming i2c-vk16k33:DIM_1_16_DUTY)

; Set display-memory
(loop for i from 0 below 16 do
    (i2c-vk16k33:set-display-memory i #x00))

(i2c-vk16k33:set-digits i2c-vk16k33:DIG_1 i2c-vk16k33:SEGMENT_1)
(i2c-vk16k33:set-digits i2c-vk16k33:DIG_2 i2c-vk16k33:SEGMENT_2)
(i2c-vk16k33:set-digits i2c-vk16k33:DIG_3 i2c-vk16k33:SEGMENT_3)
(i2c-vk16k33:set-digits i2c-vk16k33:DIG_4 i2c-vk16k33:SEGMENT_4)
(i2c-vk16k33:send-display-memory)

(sleep 1)

(i2c-vk16k33:set-digits-number i2c-vk16k33:DIG_1 9)
(i2c-vk16k33:set-digits-number i2c-vk16k33:DIG_2 8)
(i2c-vk16k33:set-digits-number i2c-vk16k33:DIG_3 7)
(i2c-vk16k33:set-digits-number i2c-vk16k33:DIG_4 6)
(i2c-vk16k33:send-display-memory)

