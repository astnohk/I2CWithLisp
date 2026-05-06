(load "./vk16k33.lisp")

; Setup
(i2c-vk16k33:system-setup i2c-vk16k33:TURN_ON_SYSTEM)
(i2c-vk16k33:display-setup i2c-vk16k33:BLINKING_OFF i2c-vk16k33:DISPLAY_ON)

; Set display-memory
(loop for i from 0 below 16 do
    (i2c-vk16k33:set-display-memory i #x00))
(i2c-vk16k33:set-display-memory #x00
                                (logior i2c-vk16k33:DIG_1A
                                        i2c-vk16k33:DIG_2A
                                        i2c-vk16k33:DIG_3A
                                        i2c-vk16k33:DIG_4A))
(i2c-vk16k33:set-display-memory #x02
                                (logior i2c-vk16k33:DIG_1A
                                        i2c-vk16k33:DIG_2A
                                        i2c-vk16k33:DIG_3A
                                        i2c-vk16k33:DIG_4A))
(i2c-vk16k33:set-display-memory #x04
                                (logior i2c-vk16k33:DIG_1A
                                        i2c-vk16k33:DIG_2A
                                        i2c-vk16k33:DIG_3A
                                        i2c-vk16k33:DIG_4A))
(i2c-vk16k33:set-display-memory #x06
                                (logior i2c-vk16k33:DIG_1A
                                        i2c-vk16k33:DIG_2A
                                        i2c-vk16k33:DIG_3A
                                        i2c-vk16k33:DIG_4A))
(i2c-vk16k33:set-display-memory #x08
                                (logior i2c-vk16k33:DIG_1A
                                        i2c-vk16k33:DIG_2A
                                        i2c-vk16k33:DIG_3A
                                        i2c-vk16k33:DIG_4A))
(i2c-vk16k33:set-display-memory #x0a
                                (logior i2c-vk16k33:DIG_1A
                                        i2c-vk16k33:DIG_2A
                                        i2c-vk16k33:DIG_3A
                                        i2c-vk16k33:DIG_4A))
(i2c-vk16k33:set-display-memory #x0c
                                (logior i2c-vk16k33:DIG_1A
                                        i2c-vk16k33:DIG_3A
                                        i2c-vk16k33:DIG_4A))

(i2c-vk16k33:send-display-memory)

