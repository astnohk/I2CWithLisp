(load "./vk16k33.lisp")

; Setup
(i2c-vk16k33:system-setup i2c-vk16k33:TURN_ON_SYSTEM)
(i2c-vk16k33:display-setup i2c-vk16k33:BLINKING_OFF i2c-vk16k33:DISPLAY_ON)
(i2c-vk16k33:set-dimming i2c-vk16k33:DIM_2_16_DUTY)

; Set display-memory
(loop for i from 0 below 16 do
    (i2c-vk16k33:set-display-memory i #x00))
(i2c-vk16k33:set-digit i2c-vk16k33:DIG_1A #x01)
(i2c-vk16k33:set-digit i2c-vk16k33:DIG_2A #x02)
(i2c-vk16k33:set-digit i2c-vk16k33:DIG_3A #x04)
(i2c-vk16k33:set-digit i2c-vk16k33:DIG_4A #x08)

(i2c-vk16k33:send-display-memory)

