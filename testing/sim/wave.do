onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /dcpirq_test/rst_n
add wave -noupdate -radix binary /dcpirq_test/irq_trigger
add wave -noupdate -radix binary /dcpirq_test/irq_address
add wave -noupdate -radix binary /dcpirq_test/int_output
add wave -noupdate -radix binary /dcpirq_test/enable
add wave -noupdate -radix binary /dcpirq_test/clk
add wave -noupdate -radix binary -childformat {{{/dcpirq_test/i_dcpirq/irq_trigger[3]} -radix binary} {{/dcpirq_test/i_dcpirq/irq_trigger[2]} -radix binary} {{/dcpirq_test/i_dcpirq/irq_trigger[1]} -radix binary} {{/dcpirq_test/i_dcpirq/irq_trigger[0]} -radix binary}} -subitemconfig {{/dcpirq_test/i_dcpirq/irq_trigger[3]} {-height 15 -radix binary} {/dcpirq_test/i_dcpirq/irq_trigger[2]} {-height 15 -radix binary} {/dcpirq_test/i_dcpirq/irq_trigger[1]} {-height 15 -radix binary} {/dcpirq_test/i_dcpirq/irq_trigger[0]} {-height 15 -radix binary}} /dcpirq_test/i_dcpirq/irq_trigger
add wave -noupdate -radix binary /dcpirq_test/i_dcpirq/irq_reg_3
add wave -noupdate -radix binary /dcpirq_test/i_dcpirq/irq_reg_2
add wave -noupdate -radix binary /dcpirq_test/i_dcpirq/irq_reg_1
add wave -noupdate -radix binary /dcpirq_test/i_dcpirq/irq_reg_0
add wave -noupdate -radix binary /dcpirq_test/i_dcpirq/irq_line
add wave -noupdate -radix binary /dcpirq_test/i_dcpirq/ack_irq
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1 us}
