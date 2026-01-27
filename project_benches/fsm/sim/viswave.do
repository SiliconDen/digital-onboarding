 

onerror resume
wave tags F0
wave update off

wave spacer -backgroundcolor Salmon { fsm_in }
wave add uvm_test_top.environment.fsm_in.fsm_in_monitor.txn_stream -radix string -tag F0
wave group fsm_in_bus
wave add -group fsm_in_bus hdl_top.fsm_in_bus.* -radix hexadecimal -tag F0
wave group fsm_in_bus -collapse
wave insertion [expr [wave index insertpoint] +1]
wave spacer -backgroundcolor Salmon { fsm_out }
wave add uvm_test_top.environment.fsm_out.fsm_out_monitor.txn_stream -radix string -tag F0
wave group fsm_out_bus
wave add -group fsm_out_bus hdl_top.fsm_out_bus.* -radix hexadecimal -tag F0
wave group fsm_out_bus -collapse
wave insertion [expr [wave index insertpoint] +1]



wave update on
WaveSetStreamView

