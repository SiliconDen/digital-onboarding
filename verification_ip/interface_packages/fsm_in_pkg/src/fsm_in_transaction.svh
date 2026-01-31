//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class defines the variables required for an fsm_in
//    transaction.  Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class fsm_in_transaction  extends uvmf_transaction_base;

  `uvm_object_utils( fsm_in_transaction )

  rand bit comp_i ;
  bit [11:0] Measurement_count_1 ;
  bit [11:0] Measurement_count_2 ;
  bit [11:0] Measurement_count_3 ;
  bit [11:0] Measurement_count_4 ;

  rand bit [1:0] autorange_level ;
  rand bit overflow ;
  rand bit noise_sign ;
  rand bit [11:0] normalrange ;
  rand bit [11:0] underrange_1 ;
  rand bit [11:0] underrange_2 ;
  rand bit [11:0] underrange_3 ;
  rand bit [11:0] noise_value_1 ;
  rand bit [11:0] noise_value_2 ;
  rand bit [11:0] noise_value_3 ;
  rand bit [11:0] noise_value_4 ;


  //Constraints for the transaction variables:

  // pragma uvmf custom class_item_additional begin
  constraint range_c {
    normalrange > 12'd360;
    underrange_1 < 12'd360;
    underrange_2 < 12'd360;
    underrange_3 < 12'd360;
    underrange_1 == (normalrange + 5) / 10;      
    underrange_2 == (normalrange + 50) / 100;    
    underrange_3 == (normalrange + 500) / 1000; 
  }

  constraint noise_c {
    noise_value_1 <= (normalrange * 5) / 100;
    noise_value_2 <= (underrange_1 * 5) / 100;
    noise_value_3 <= (underrange_2 * 5) / 100;
    noise_value_4 <= (underrange_3 * 5) / 100;
  }
  // pragma uvmf custom class_item_additional end

  //*******************************************************************
  //*******************************************************************
  // Macros that define structs and associated functions are
  // located in fsm_in_macros.svh

  //*******************************************************************
  // Monitor macro used by fsm_in_monitor and fsm_in_monitor_bfm
  // This struct is defined in fsm_in_macros.svh
  `fsm_in_MONITOR_STRUCT
    fsm_in_monitor_s fsm_in_monitor_struct;
  //*******************************************************************
  // FUNCTION: to_monitor_struct()
  // This function packs transaction variables into a fsm_in_monitor_s
  // structure.  The function returns the handle to the fsm_in_monitor_struct.
  // This function is defined in fsm_in_macros.svh
  `fsm_in_TO_MONITOR_STRUCT_FUNCTION 
  //*******************************************************************
  // FUNCTION: from_monitor_struct()
  // This function unpacks the struct provided as an argument into transaction 
  // variables of this class.
  // This function is defined in fsm_in_macros.svh
  `fsm_in_FROM_MONITOR_STRUCT_FUNCTION 

  //*******************************************************************
  // Initiator macro used by fsm_in_driver and fsm_in_driver_bfm
  // to communicate initiator driven data to fsm_in_driver_bfm.
  // This struct is defined in fsm_in_macros.svh
  `fsm_in_INITIATOR_STRUCT
    fsm_in_initiator_s fsm_in_initiator_struct;
  //*******************************************************************
  // FUNCTION: to_initiator_struct()
  // This function packs transaction variables into a fsm_in_initiator_s
  // structure.  The function returns the handle to the fsm_in_initiator_struct.
  // This function is defined in fsm_in_macros.svh
  `fsm_in_TO_INITIATOR_STRUCT_FUNCTION  
  //*******************************************************************
  // FUNCTION: from_initiator_struct()
  // This function unpacks the struct provided as an argument into transaction 
  // variables of this class.
  // This function is defined in fsm_in_macros.svh
  `fsm_in_FROM_INITIATOR_STRUCT_FUNCTION 

  //*******************************************************************
  // Responder macro used by fsm_in_driver and fsm_in_driver_bfm
  // to communicate Responder driven data to fsm_in_driver_bfm.
  // This struct is defined in fsm_in_macros.svh
  `fsm_in_RESPONDER_STRUCT
    fsm_in_responder_s fsm_in_responder_struct;
  //*******************************************************************
  // FUNCTION: to_responder_struct()
  // This function packs transaction variables into a fsm_in_responder_s
  // structure.  The function returns the handle to the fsm_in_responder_struct.
  // This function is defined in fsm_in_macros.svh
  `fsm_in_TO_RESPONDER_STRUCT_FUNCTION 
  //*******************************************************************
  // FUNCTION: from_responder_struct()
  // This function unpacks the struct provided as an argument into transaction 
  // variables of this class.
  // This function is defined in fsm_in_macros.svh
  `fsm_in_FROM_RESPONDER_STRUCT_FUNCTION 
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
    return $sformatf("comp_i:0x%x Measurement_count_1:0x%x Measurement_count_2:0x%x Measurement_count_3:0x%x Measurement_count_4:0x%x ",comp_i,Measurement_count_1,Measurement_count_2,Measurement_count_3,Measurement_count_4);
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
    fsm_in_transaction  RHS;
    if (!$cast(RHS,rhs)) return 0;
    // pragma uvmf custom do_compare begin
    // UVMF_CHANGE_ME : Eliminate comparison of variables not to be used for compare
    return (super.do_compare(rhs,comparer)
            &&(this.comp_i == RHS.comp_i)
            &&(this.Measurement_count_1 == RHS.Measurement_count_1)
            &&(this.Measurement_count_2 == RHS.Measurement_count_2)
            &&(this.Measurement_count_3 == RHS.Measurement_count_3)
            &&(this.Measurement_count_4 == RHS.Measurement_count_4)
            );
    // pragma uvmf custom do_compare end
  endfunction

  //*******************************************************************
  // FUNCTION: do_copy()
  // This function is automatically called when the .copy() function
  // is called on this class.
  //
  virtual function void do_copy (uvm_object rhs);
    fsm_in_transaction  RHS;
    if(!$cast(RHS,rhs))begin
      `uvm_fatal("CAST","Transaction cast in do_copy() failed!")
    end
    // pragma uvmf custom do_copy begin
    super.do_copy(rhs);
    this.comp_i = RHS.comp_i;
    this.Measurement_count_1 = RHS.Measurement_count_1;
    this.Measurement_count_2 = RHS.Measurement_count_2;
    this.Measurement_count_3 = RHS.Measurement_count_3;
    this.Measurement_count_4 = RHS.Measurement_count_4;
    // pragma uvmf custom do_copy end
  endfunction

  // ****************************************************************************
  // FUNCTION: post_randomize()
  // This function is automatically called after the randomize() function.
  //
  function void post_randomize();
    // pragma uvmf custom post_randomize begin
    // reset measurement counts to 0
    Measurement_count_1 = 12'd0;
    Measurement_count_2 = 12'd0;
    Measurement_count_3 = 12'd0;
    Measurement_count_4 = 12'd0;

    case (autorange_level)
      2'b00: begin
        if(overflow) begin
          Measurement_count_1 = 12'd4000;
        end else begin
          Measurement_count_1 = normalrange;
        end
      end
      2'b01: begin
        if(overflow) begin
          Measurement_count_2 = 12'd4000;
        end else begin
          Measurement_count_2 = normalrange;
        end
        Measurement_count_1 = underrange_1;
      end
      2'b10: begin
        if(overflow) begin
          Measurement_count_3 = 12'd4000;
        end else begin
          Measurement_count_3 = normalrange;
        end
        Measurement_count_2 = underrange_2;
        Measurement_count_1 = underrange_1;
      end
      2'b11: begin
        if(overflow) begin
          Measurement_count_4 = 12'd4000;
        end else begin
          Measurement_count_4 = normalrange;
        end
        Measurement_count_3 = underrange_3;
        Measurement_count_2 = underrange_2;
        Measurement_count_1 = underrange_1;
      end
    endcase
    if(noise_sign) begin
      Measurement_count_1 = Measurement_count_1 + noise_value_1;
      Measurement_count_2 = Measurement_count_2 - noise_value_2;
      Measurement_count_3 = Measurement_count_3 + noise_value_3;
      Measurement_count_4 = Measurement_count_4 + noise_value_4;
    end else begin
      Measurement_count_1 = Measurement_count_1 - noise_value_1;
      Measurement_count_2 = Measurement_count_2 - noise_value_2;
      Measurement_count_3 = Measurement_count_3 + noise_value_3;
      Measurement_count_4 = Measurement_count_4 - noise_value_4;
    end
    // pragma uvmf custom post_randomize end
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
      transaction_view_h = $begin_transaction(transaction_viewing_stream_h,"fsm_in_transaction",start_time);
    end
    super.add_to_wave(transaction_view_h);
    // pragma uvmf custom add_to_wave begin
    // UVMF_CHANGE_ME : Color can be applied to transaction entries based on content, example below
    // case()
    //   1 : $add_color(transaction_view_h,"red");
    //   default : $add_color(transaction_view_h,"grey");
    // endcase
    // UVMF_CHANGE_ME : Eliminate transaction variables not wanted in transaction viewing in the waveform viewer
    $add_attribute(transaction_view_h,comp_i,"comp_i");
    $add_attribute(transaction_view_h,Measurement_count_1,"Measurement_count_1");
    $add_attribute(transaction_view_h,Measurement_count_2,"Measurement_count_2");
    $add_attribute(transaction_view_h,Measurement_count_3,"Measurement_count_3");
    $add_attribute(transaction_view_h,Measurement_count_4,"Measurement_count_4");
    // pragma uvmf custom add_to_wave end
    $end_transaction(transaction_view_h,end_time);
    $free_transaction(transaction_view_h);
    `endif // QUESTA
  endfunction

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

