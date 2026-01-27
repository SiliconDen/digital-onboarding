//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class defines the variables required for an fsm_out
//    transaction.  Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class fsm_out_transaction  extends uvmf_transaction_base;

  `uvm_object_utils( fsm_out_transaction )

  bit idle_o ;
  bit auto_zero_o ;
  bit integrate_o ;
  bit deintegrate_o ;
  bit ref_sign_o ;
  bit interrupt_o ;
  bit [11:0] measurement_count_o ;

  //Constraints for the transaction variables:

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  //*******************************************************************
  //*******************************************************************
  // Macros that define structs and associated functions are
  // located in fsm_out_macros.svh

  //*******************************************************************
  // Monitor macro used by fsm_out_monitor and fsm_out_monitor_bfm
  // This struct is defined in fsm_out_macros.svh
  `fsm_out_MONITOR_STRUCT
    fsm_out_monitor_s fsm_out_monitor_struct;
  //*******************************************************************
  // FUNCTION: to_monitor_struct()
  // This function packs transaction variables into a fsm_out_monitor_s
  // structure.  The function returns the handle to the fsm_out_monitor_struct.
  // This function is defined in fsm_out_macros.svh
  `fsm_out_TO_MONITOR_STRUCT_FUNCTION 
  //*******************************************************************
  // FUNCTION: from_monitor_struct()
  // This function unpacks the struct provided as an argument into transaction 
  // variables of this class.
  // This function is defined in fsm_out_macros.svh
  `fsm_out_FROM_MONITOR_STRUCT_FUNCTION 

  //*******************************************************************
  // Initiator macro used by fsm_out_driver and fsm_out_driver_bfm
  // to communicate initiator driven data to fsm_out_driver_bfm.
  // This struct is defined in fsm_out_macros.svh
  `fsm_out_INITIATOR_STRUCT
    fsm_out_initiator_s fsm_out_initiator_struct;
  //*******************************************************************
  // FUNCTION: to_initiator_struct()
  // This function packs transaction variables into a fsm_out_initiator_s
  // structure.  The function returns the handle to the fsm_out_initiator_struct.
  // This function is defined in fsm_out_macros.svh
  `fsm_out_TO_INITIATOR_STRUCT_FUNCTION  
  //*******************************************************************
  // FUNCTION: from_initiator_struct()
  // This function unpacks the struct provided as an argument into transaction 
  // variables of this class.
  // This function is defined in fsm_out_macros.svh
  `fsm_out_FROM_INITIATOR_STRUCT_FUNCTION 

  //*******************************************************************
  // Responder macro used by fsm_out_driver and fsm_out_driver_bfm
  // to communicate Responder driven data to fsm_out_driver_bfm.
  // This struct is defined in fsm_out_macros.svh
  `fsm_out_RESPONDER_STRUCT
    fsm_out_responder_s fsm_out_responder_struct;
  //*******************************************************************
  // FUNCTION: to_responder_struct()
  // This function packs transaction variables into a fsm_out_responder_s
  // structure.  The function returns the handle to the fsm_out_responder_struct.
  // This function is defined in fsm_out_macros.svh
  `fsm_out_TO_RESPONDER_STRUCT_FUNCTION 
  //*******************************************************************
  // FUNCTION: from_responder_struct()
  // This function unpacks the struct provided as an argument into transaction 
  // variables of this class.
  // This function is defined in fsm_out_macros.svh
  `fsm_out_FROM_RESPONDER_STRUCT_FUNCTION 
  // ****************************************************************************
  // FUNCTION : new()
  // This function is the standard SystemVerilog constructor.
  //
  function new( string name = "" );
    super.new( name );
  endfunction

  // ****************************************************************************
  // FUNCTION: convert2string()
  // This function converts all variables in this class to a single string for 
  // logfile reporting.
  //
  virtual function string convert2string();
    // pragma uvmf custom convert2string begin
    // UVMF_CHANGE_ME : Customize format if desired.
    return $sformatf("idle_o:0x%x auto_zero_o:0x%x integrate_o:0x%x deintegrate_o:0x%x ref_sign_o:0x%x interrupt_o:0x%x measurement_count_o:0x%x ",idle_o,auto_zero_o,integrate_o,deintegrate_o,ref_sign_o,interrupt_o,measurement_count_o);
    // pragma uvmf custom convert2string end
  endfunction

  //*******************************************************************
  // FUNCTION: do_print()
  // This function is automatically called when the .print() function
  // is called on this class.
  //
  virtual function void do_print(uvm_printer printer);
    // pragma uvmf custom do_print begin
    // UVMF_CHANGE_ME : Current contents of do_print allows for the use of UVM 1.1d, 1.2 or P1800.2.
    // Update based on your own printing preference according to your preferred UVM version
    $display(convert2string());
    // pragma uvmf custom do_print end
  endfunction

  //*******************************************************************
  // FUNCTION: do_compare()
  // This function is automatically called when the .compare() function
  // is called on this class.
  //
  virtual function bit do_compare (uvm_object rhs, uvm_comparer comparer);
    fsm_out_transaction  RHS;
    if (!$cast(RHS,rhs)) return 0;
    // pragma uvmf custom do_compare begin
    // UVMF_CHANGE_ME : Eliminate comparison of variables not to be used for compare
    return (super.do_compare(rhs,comparer)
            &&(this.idle_o == RHS.idle_o)
            &&(this.auto_zero_o == RHS.auto_zero_o)
            &&(this.integrate_o == RHS.integrate_o)
            &&(this.deintegrate_o == RHS.deintegrate_o)
            &&(this.ref_sign_o == RHS.ref_sign_o)
            &&(this.interrupt_o == RHS.interrupt_o)
            &&(this.measurement_count_o == RHS.measurement_count_o)
            );
    // pragma uvmf custom do_compare end
  endfunction

  //*******************************************************************
  // FUNCTION: do_copy()
  // This function is automatically called when the .copy() function
  // is called on this class.
  //
  virtual function void do_copy (uvm_object rhs);
    fsm_out_transaction  RHS;
    if(!$cast(RHS,rhs))begin
      `uvm_fatal("CAST","Transaction cast in do_copy() failed!")
    end
    // pragma uvmf custom do_copy begin
    super.do_copy(rhs);
    this.idle_o = RHS.idle_o;
    this.auto_zero_o = RHS.auto_zero_o;
    this.integrate_o = RHS.integrate_o;
    this.deintegrate_o = RHS.deintegrate_o;
    this.ref_sign_o = RHS.ref_sign_o;
    this.interrupt_o = RHS.interrupt_o;
    this.measurement_count_o = RHS.measurement_count_o;
    // pragma uvmf custom do_copy end
  endfunction

  // ****************************************************************************
  // FUNCTION: add_to_wave()
  // This function is used to display variables in this class in the waveform 
  // viewer.  The start_time and end_time variables must be set before this 
  // function is called.  If the start_time and end_time variables are not set
  // the transaction will be hidden at 0ns on the waveform display.
  // 
  virtual function void add_to_wave(int transaction_viewing_stream_h);
    `ifdef QUESTA
    if (transaction_view_h == 0) begin
      transaction_view_h = $begin_transaction(transaction_viewing_stream_h,"fsm_out_transaction",start_time);
    end
    super.add_to_wave(transaction_view_h);
    // pragma uvmf custom add_to_wave begin
    // UVMF_CHANGE_ME : Color can be applied to transaction entries based on content, example below
    // case()
    //   1 : $add_color(transaction_view_h,"red");
    //   default : $add_color(transaction_view_h,"grey");
    // endcase
    // UVMF_CHANGE_ME : Eliminate transaction variables not wanted in transaction viewing in the waveform viewer
    $add_attribute(transaction_view_h,idle_o,"idle_o");
    $add_attribute(transaction_view_h,auto_zero_o,"auto_zero_o");
    $add_attribute(transaction_view_h,integrate_o,"integrate_o");
    $add_attribute(transaction_view_h,deintegrate_o,"deintegrate_o");
    $add_attribute(transaction_view_h,ref_sign_o,"ref_sign_o");
    $add_attribute(transaction_view_h,interrupt_o,"interrupt_o");
    $add_attribute(transaction_view_h,measurement_count_o,"measurement_count_o");
    // pragma uvmf custom add_to_wave end
    $end_transaction(transaction_view_h,end_time);
    $free_transaction(transaction_view_h);
    `endif // QUESTA
  endfunction

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

