onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /interrupt_controller_test/i_interrupt_controller/rst_n_i
add wave -noupdate -radix binary /interrupt_controller_test/i_interrupt_controller/pclk_i
add wave -noupdate -radix unsigned /interrupt_controller_test/i_interrupt_controller/paddr_i
add wave -noupdate -radix binary /interrupt_controller_test/i_interrupt_controller/pwrite_i
add wave -noupdate -radix binary /interrupt_controller_test/i_interrupt_controller/psel_i
add wave -noupdate -radix binary /interrupt_controller_test/i_interrupt_controller/penable_i
add wave -noupdate -radix unsigned /interrupt_controller_test/i_interrupt_controller/pwdata_i
add wave -noupdate -radix unsigned /interrupt_controller_test/i_interrupt_controller/prdata_o
add wave -noupdate -radix binary /interrupt_controller_test/i_interrupt_controller/irq_trigger_i
add wave -noupdate -radix binary /interrupt_controller_test/i_interrupt_controller/irq_wires
add wave -noupdate -radix binary /interrupt_controller_test/i_interrupt_controller/status
add wave -noupdate -radix binary /interrupt_controller_test/i_interrupt_controller/mask
add wave -noupdate -radix binary /interrupt_controller_test/i_interrupt_controller/interrupt_o
add wave -noupdate -radix unsigned /interrupt_controller_test/i_interrupt_controller/priority_threshold
add wave -noupdate -radix binary /interrupt_controller_test/i_interrupt_controller/clear
add wave -noupdate -radix unsigned /interrupt_controller_test/i_interrupt_controller/irq3_reg
add wave -noupdate -radix unsigned /interrupt_controller_test/i_interrupt_controller/irq2_reg
add wave -noupdate -radix unsigned /interrupt_controller_test/i_interrupt_controller/irq1_reg
add wave -noupdate -radix unsigned /interrupt_controller_test/i_interrupt_controller/irq0_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
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
