//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This file contains macros used with the fsm_in package.
//   These macros include packed struct definitions.  These structs are
//   used to pass data between classes, hvl, and BFM's, hdl.  Use of 
//   structs are more efficient and simpler to modify.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_struct
//      and from_struct methods defined in the macros below that are used in  
//      the fsm_in_configuration class.
//
  `define fsm_in_CONFIGURATION_STRUCT \
typedef struct packed  { \
     uvmf_active_passive_t active_passive; \
     uvmf_initiator_responder_t initiator_responder; \
     } fsm_in_configuration_s;

  `define fsm_in_CONFIGURATION_TO_STRUCT_FUNCTION \
  virtual function fsm_in_configuration_s to_struct();\
    fsm_in_configuration_struct = \
       {\
       this.active_passive,\
       this.initiator_responder\
       };\
    return ( fsm_in_configuration_struct );\
  endfunction

  `define fsm_in_CONFIGURATION_FROM_STRUCT_FUNCTION \
  virtual function void from_struct(fsm_in_configuration_s fsm_in_configuration_struct);\
      {\
      this.active_passive,\
      this.initiator_responder  \
      } = fsm_in_configuration_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_monitor_struct
//      and from_monitor_struct methods of the fsm_in_transaction class.
//
  `define fsm_in_MONITOR_STRUCT typedef struct packed  { \
  bit comp_i ; \
  bit analog_ready_i ; \
  bit trigger_i ; \
  bit interrupt_clear_i ; \
     } fsm_in_monitor_s;

  `define fsm_in_TO_MONITOR_STRUCT_FUNCTION \
  virtual function fsm_in_monitor_s to_monitor_struct();\
    fsm_in_monitor_struct = \
            { \
            this.comp_i , \
            this.analog_ready_i , \
            this.trigger_i , \
            this.interrupt_clear_i  \
            };\
    return ( fsm_in_monitor_struct);\
  endfunction\

  `define fsm_in_FROM_MONITOR_STRUCT_FUNCTION \
  virtual function void from_monitor_struct(fsm_in_monitor_s fsm_in_monitor_struct);\
            {\
            this.comp_i , \
            this.analog_ready_i , \
            this.trigger_i , \
            this.interrupt_clear_i  \
            } = fsm_in_monitor_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_initiator_struct
//      and from_initiator_struct methods of the fsm_in_transaction class.
//      Also update the comments in the driver BFM.
//
  `define fsm_in_INITIATOR_STRUCT typedef struct packed  { \
  bit comp_i ; \
  bit analog_ready_i ; \
  bit trigger_i ; \
  bit interrupt_clear_i ; \
     } fsm_in_initiator_s;

  `define fsm_in_TO_INITIATOR_STRUCT_FUNCTION \
  virtual function fsm_in_initiator_s to_initiator_struct();\
    fsm_in_initiator_struct = \
           {\
           this.comp_i , \
           this.analog_ready_i , \
           this.trigger_i , \
           this.interrupt_clear_i  \
           };\
    return ( fsm_in_initiator_struct);\
  endfunction

  `define fsm_in_FROM_INITIATOR_STRUCT_FUNCTION \
  virtual function void from_initiator_struct(fsm_in_initiator_s fsm_in_initiator_struct);\
           {\
           this.comp_i , \
           this.analog_ready_i , \
           this.trigger_i , \
           this.interrupt_clear_i  \
           } = fsm_in_initiator_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_responder_struct
//      and from_responder_struct methods of the fsm_in_transaction class.
//      Also update the comments in the driver BFM.
//
  `define fsm_in_RESPONDER_STRUCT typedef struct packed  { \
  bit comp_i ; \
  bit analog_ready_i ; \
  bit trigger_i ; \
  bit interrupt_clear_i ; \
     } fsm_in_responder_s;

  `define fsm_in_TO_RESPONDER_STRUCT_FUNCTION \
  virtual function fsm_in_responder_s to_responder_struct();\
    fsm_in_responder_struct = \
           {\
           this.comp_i , \
           this.analog_ready_i , \
           this.trigger_i , \
           this.interrupt_clear_i  \
           };\
    return ( fsm_in_responder_struct);\
  endfunction

  `define fsm_in_FROM_RESPONDER_STRUCT_FUNCTION \
  virtual function void from_responder_struct(fsm_in_responder_s fsm_in_responder_struct);\
           {\
           this.comp_i , \
           this.analog_ready_i , \
           this.trigger_i , \
           this.interrupt_clear_i  \
           } = fsm_in_responder_struct;\
  endfunction
// pragma uvmf custom additional begin
// pragma uvmf custom additional end
