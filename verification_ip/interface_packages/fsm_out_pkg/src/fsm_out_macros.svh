//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4_2
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This file contains macros used with the fsm_out package.
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
//      the fsm_out_configuration class.
//
  `define fsm_out_CONFIGURATION_STRUCT \
typedef struct packed  { \
     uvmf_active_passive_t active_passive; \
     uvmf_initiator_responder_t initiator_responder; \
     } fsm_out_configuration_s;

  `define fsm_out_CONFIGURATION_TO_STRUCT_FUNCTION \
  virtual function fsm_out_configuration_s to_struct();\
    fsm_out_configuration_struct = \
       {\
       this.active_passive,\
       this.initiator_responder\
       };\
    return ( fsm_out_configuration_struct );\
  endfunction

  `define fsm_out_CONFIGURATION_FROM_STRUCT_FUNCTION \
  virtual function void from_struct(fsm_out_configuration_s fsm_out_configuration_struct);\
      {\
      this.active_passive,\
      this.initiator_responder  \
      } = fsm_out_configuration_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_monitor_struct
//      and from_monitor_struct methods of the fsm_out_transaction class.
//
  `define fsm_out_MONITOR_STRUCT typedef struct packed  { \
  bit ref_sign_o ; \
  bit [11:0] measurement_count_1 ; \
  bit [11:0] measurement_count_2 ; \
  bit [11:0] measurement_count_3 ; \
  bit [11:0] measurement_count_4 ; \
     } fsm_out_monitor_s;

  `define fsm_out_TO_MONITOR_STRUCT_FUNCTION \
  virtual function fsm_out_monitor_s to_monitor_struct();\
    fsm_out_monitor_struct = \
            { \
            this.ref_sign_o , \
            this.measurement_count_1 , \
            this.measurement_count_2 , \
            this.measurement_count_3 , \
            this.measurement_count_4  \
            };\
    return ( fsm_out_monitor_struct);\
  endfunction\

  `define fsm_out_FROM_MONITOR_STRUCT_FUNCTION \
  virtual function void from_monitor_struct(fsm_out_monitor_s fsm_out_monitor_struct);\
            {\
            this.ref_sign_o , \
            this.measurement_count_1 , \
            this.measurement_count_2 , \
            this.measurement_count_3 , \
            this.measurement_count_4  \
            } = fsm_out_monitor_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_initiator_struct
//      and from_initiator_struct methods of the fsm_out_transaction class.
//      Also update the comments in the driver BFM.
//
  `define fsm_out_INITIATOR_STRUCT typedef struct packed  { \
  bit ref_sign_o ; \
  bit [11:0] measurement_count_1 ; \
  bit [11:0] measurement_count_2 ; \
  bit [11:0] measurement_count_3 ; \
  bit [11:0] measurement_count_4 ; \
     } fsm_out_initiator_s;

  `define fsm_out_TO_INITIATOR_STRUCT_FUNCTION \
  virtual function fsm_out_initiator_s to_initiator_struct();\
    fsm_out_initiator_struct = \
           {\
           this.ref_sign_o , \
           this.measurement_count_1 , \
           this.measurement_count_2 , \
           this.measurement_count_3 , \
           this.measurement_count_4  \
           };\
    return ( fsm_out_initiator_struct);\
  endfunction

  `define fsm_out_FROM_INITIATOR_STRUCT_FUNCTION \
  virtual function void from_initiator_struct(fsm_out_initiator_s fsm_out_initiator_struct);\
           {\
           this.ref_sign_o , \
           this.measurement_count_1 , \
           this.measurement_count_2 , \
           this.measurement_count_3 , \
           this.measurement_count_4  \
           } = fsm_out_initiator_struct;\
  endfunction

// ****************************************************************************
// When changing the contents of this struct, be sure to update the to_responder_struct
//      and from_responder_struct methods of the fsm_out_transaction class.
//      Also update the comments in the driver BFM.
//
  `define fsm_out_RESPONDER_STRUCT typedef struct packed  { \
  bit ref_sign_o ; \
  bit [11:0] measurement_count_1 ; \
  bit [11:0] measurement_count_2 ; \
  bit [11:0] measurement_count_3 ; \
  bit [11:0] measurement_count_4 ; \
     } fsm_out_responder_s;

  `define fsm_out_TO_RESPONDER_STRUCT_FUNCTION \
  virtual function fsm_out_responder_s to_responder_struct();\
    fsm_out_responder_struct = \
           {\
           this.ref_sign_o , \
           this.measurement_count_1 , \
           this.measurement_count_2 , \
           this.measurement_count_3 , \
           this.measurement_count_4  \
           };\
    return ( fsm_out_responder_struct);\
  endfunction

  `define fsm_out_FROM_RESPONDER_STRUCT_FUNCTION \
  virtual function void from_responder_struct(fsm_out_responder_s fsm_out_responder_struct);\
           {\
           this.ref_sign_o , \
           this.measurement_count_1 , \
           this.measurement_count_2 , \
           this.measurement_count_3 , \
           this.measurement_count_4  \
           } = fsm_out_responder_struct;\
  endfunction
// pragma uvmf custom additional begin
// pragma uvmf custom additional end
