###############################################################################
# Copyright (c) 2000-2018 Ericsson Telecom AB
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v2.0
# which accompanies this distribution, and is available at
# https://www.eclipse.org/org/documents/epl-2.0/EPL-2.0.html
#
# Contributors:
#   Roland Gecse - initial implementation and initial documentation
#   Akos Pernek
#   Antal Wuh.Hen.Chang
#   Attila Fulop
#   Balazs Barcsik
#   Bence Molnar
#   Csaba Koppany
#   David Juhasz
#   Eduard Czimbalmos
#   Elemer Lelik
#   Endre Kiss
#   Endre Kulcsar
#   Gabor Szalai
#   Gabor Tatarka
#   Gergely Futo
#   Istvan Sandor
#   Krisztian Pandi
#   Kulcsár Endre
#   Laszlo Tamas Zeke
#   Norbert Pinter
#   Roland Gecse
#   Tibor Bende
#   Tibor Szabo
#   Timea Moder
#   Zoltan Medve
#   Zsolt Nandor Torok
#   Zsolt Szalai
###############################################################################
#                                                                           #
#  File:               AVP.awk                                              #
#  Description:	       Diameter Protocol Module Generator (DPMG) GNU awk    #
#                      script for weaving DDF files                         #
#                      Requires GNU awk 3.1.6                               #
#  Rev:                RnXnn                                                #
#  Prodnr:             CNL 113 462                                          #
#                                                                           #
#############################################################################

BEGIN {
  FS = "[ \t\n;]+"
  HT = "\t"
  SP = " "
  # Number of AVP descriptors found in input DDF file
  avp_descriptors = 0
  # Number of AVP type definitions matching preceeding AVP descriptor
  matching_avp_types = 0
  # Identifier of generated TTCN-3 module
  if(!module_id) module_id = "DIAMETER_Types"
  # Use APPLICATION-REVISION prefix in AVP type identifiers when true
  if(!use_application_revision) use_application_revision = 0
  # Replace all enumeration type AVPs with type Unsigned32 when true
  if(!enum_2_Unsigned32) enum_2_Unsigned32 = 0
  # Use integer for 32 bit unsigned and 64 bit signed types when true
  if(!use_bigint) use_bigint = 0
  # Use detailed description for RPET and VMP bits
  if(!detailed_bits) detailed_bits = 0
  # Disable application name prefix
  if(!disable_prefix) disable_prefix = 0
  # Replace the listed enumeration type AVPs with type Unsigned32
  enum_replace_list["0 0"]=1
  if(enum_2_Unsigned32_list){
    while ((getline < enum_2_Unsigned32_list) > 0)
    {
      split($0,el," ")
      enum_replace_list["(" el[1] ")" SP "(" el[2] ")"]=1
    }
    close(enum_2_Unsigned32_list);
  } 


  print "module " module_id " {"
}

{ 
  # Remove excess WS from beginning and end of EACH record
  sub(/^[ \t]+/, "") 
  sub(/[ \t]+$/, "")
}

/\/\/ APPLICATION-NAME:/ {
  # Will be used to prefix generated AVP type definitions
  if(disable_prefix) {
    application_id = "AVP_"
  } else {
    application_id = $3 "_"
  }
}

/\/\/ APPLICATION-REVISION:/ {
  # Could be used as additional prefix for generated AVP type definitions
  application_revision = $3
  if(use_application_revision && !disable_prefix && application_revision) {
    application_id = application_id application_revision "_"
  }
}

/\/\/ AVP:/ {
  # AVP descriptor line e.g.:
  # // AVP: Official-AVP-Name (Official-AVP-Code) Vendor-Id (Vendor-Id-Code)
  #         <------ $3 -----> <------  $4 ------> <- $5  -> <----- $6 ----->
  new_avp_name = $3
  new_avp_code = $4
  new_avp_vendor_id = $5
  new_avp_vendor_id_code = $6
  if(!new_avp_vendor_id) {
    new_avp_vendor_id = "NONE"
    new_avp_vendor_id_code = "(0)"
  }
  gsub(/-/, "_", new_avp_name)
  gsub(/-/, "_", new_vendor_id)
  avp_descriptors++ 
}

/\<type/ {
  # TTCN-3 type definition MUST be in a single line!
  # <type> <kind> <identifier>
  if($3 == new_avp_name && (new_avp_code SP new_avp_vendor_id_code) in AVP) {
    print "// WARNING: Duplicated AVP definition removed by gawk script!"
    if($2 == "enumerated") { f_ReadTotalEnum() }
    ++deleted_avp_types
    next
  } else if($3 == new_avp_name) {
    ++matching_avp_types
    $3 = new_avp_id = application_id new_avp_vendor_id "_" new_avp_name 
    AVP[new_avp_code SP new_avp_vendor_id_code] = new_avp_id
    if(!(new_avp_vendor_id_code in VENDORID)) {
      VENDORID[new_avp_vendor_id_code] = new_avp_vendor_id
    }
    if($2 == "enumerated") {
      f_ReadTotalEnum()
      if(enum_2_Unsigned32 || ((new_avp_code SP new_avp_vendor_id_code) in enum_replace_list)) {
        print "// WARNING: Enumeration type AVP replaced by Unsigned32!"
        print "type AVP_Unsigned32 " new_avp_id ";"
      } else {
        gsub(/\,/, ",\n", total_enum)
        sub(/\{/, " {\n", total_enum)
        sub(/\}/, "\n}", total_enum)
        f_AddVariant_U32(total_enum)
      }
      next
    }
  } else if($2 == "enumerated" && $3 == "Command_Code") {
    # TODO: check unique entries!
    f_ReadTotalEnum()
    f_ParseStoreTotalEnum("Command_Code")
  }
}

/!2 / {
  if(use_bigint){
    sub(/!2 /,"")
    print
  }
  next
}
/!1 / {
  if(!use_bigint){
    sub(/!1 /,"")
    print
  }
  next
}

/!4 / {
  if(detailed_bits){
    sub(/!4 /,"")
    print
  }
  next
}
/!3 / {
  if(!detailed_bits){
    sub(/!3 /,"")
    print
  }
  next
}

/!5 / {
  if(!use_UTF8_encoding){
    sub(/!5 /,"")
    print
  }
  next
}
/!6 / {
  if(use_UTF8_encoding){
    sub(/!6 /,"")
    print
  }
  next
}





{print}

END {
  print "// STATISTICS: " avp_descriptors " AVP descriptors found"
  print "// STATISTICS: " matching_avp_types \
    " AVP type definitions matching AVP descriptors found"
  print "// STATISTICS: " deleted_avp_types " duplicate AVP definitions deleted"
  if(avp_descriptors != matching_avp_types + deleted_avp_types) {
    print "// ERROR: avp_descriptors " avp_descriptors \
      " != matching_avp_types " matching_avp_types
  exit(1)
  }

  print "type enumerated Command_Code {"
  print ENUM["Command_Code"]
  print "} with {"
  print HT "variant \"FIELDLENGTH(24)\""
  print HT "variant \"BYTEORDER(last)\""
  print "}\n"
	
  print "type enumerated Vendor_Id {"
  len = length(VENDORID)
  for (i in VENDORID) {
    printf ("\tvendor_id_%s %s%s\n", VENDORID[i], i, (--len) ? "," : "")
  }
  f_AddVariant_U32("}")

  for (i in VENDORID) {
    AVP_Code_VENDORID[i] = "type enumerated AVP_Code_" VENDORID[i] " {\n"
  }
  for (i in AVP) {
    split(i, t)
    AVP_Code_VENDORID[t[2]] = \
      AVP_Code_VENDORID[t[2]] HT "avp_code_" AVP[i] SP t[1] ",\n"
  }
  for (i in VENDORID) {
    sub(/\,\n$/, "", AVP_Code_VENDORID[i])
    print AVP_Code_VENDORID[i]
    f_AddVariant_U32("}");
  }

  print "type union AVP_Code {"
  len = length(VENDORID)
  for (i in VENDORID) {
    printf ("\tAVP_Code_%s vendor_id_%s%s\n", \
      VENDORID[i], VENDORID[i], (--len) ? "," : "")
  }	
  print "}"

  print "type record AVP_Header {"
  print HT "AVP_Code avp_code,"
  if(detailed_bits){
    print HT "BIT1 V_bit,"
    print HT "BIT1 M_bit,"
    print HT "BIT1 P_bit,"
    print HT "BIT5 r_bits,"
  } else {  
    print HT "BIT8 VMPxxxxx,"
  }
  print HT "UINT24 avp_length,"
  print HT "Vendor_Id vendor_id optional"
  print "} with {"
  print HT "variant (vendor_id) \"PRESENCE( {"
  if(detailed_bits){
    print HT HT "V_bit = '1'B"
  } else {  
    print HT HT "VMPxxxxx = '10000000'B,"
    print HT HT "VMPxxxxx = '10100000'B,"
    print HT HT "VMPxxxxx = '11000000'B,"
    print HT HT "VMPxxxxx = '11100000'B"
  }
  print HT "} )\""
  print HT "variant (avp_code) \"CROSSTAG("
  for(i in VENDORID) {
    if(VENDORID[i] == "NONE") { tmp = "omit" }
    else { tmp = "vendor_id_" VENDORID[i] }
    print HT HT "vendor_id_" VENDORID[i] ", vendor_id = " tmp ";"
  }
  print HT ")\""
  if(detailed_bits){
    print HT "variant (r_bits, P_bit, M_bit, V_bit) \"FIELDORDER(msb)\""
  }
  print "}"

  print "type union AVP_Data {"
  for (i in AVP) {
    print HT AVP[i] " avp_" AVP[i] ","
  }
  print HT "octetstring", "avp_UNKNOWN"
  print "}"
        
  print "type union GenericAVP {"
  print HT "AVP avp,"
  print HT "Undefined_AVP avp_undefined,"
  print HT "octetstring avp_UNKNOWN"
  print "}"

  print "type record Undefined_AVP {"
  print HT "OCTET4 avp_code,"
  if(detailed_bits){
    print HT "BIT1 V_bit,"
    print HT "BIT1 M_bit,"
    print HT "BIT1 P_bit,"
    print HT "BIT5 r_bits,"
  } else {  
    print HT "BIT8 VMPxxxxx,"
  }
  print HT "UINT24 avp_length,"
  print HT "OCTET4 vendor_id optional,"
  print HT "octetstring avp_data"
  print "} with {"
  print HT "variant \"PADDING(dword32)\""
  print HT "variant (vendor_id) \"PRESENCE( {"
  if(detailed_bits){
    print HT HT "V_bit = '1'B"
  } else {  
    print HT HT "VMPxxxxx = '10000000'B,"
    print HT HT "VMPxxxxx = '10100000'B,"
    print HT HT "VMPxxxxx = '11000000'B,"
    print HT HT "VMPxxxxx = '11100000'B"
  }
  print HT "} )\""
  if(detailed_bits){
    print HT "variant (avp_length) \"LENGTHTO(avp_code, V_bit, M_bit, P_bit, r_bits, avp_length, vendor_id, avp_data)\""
    print HT "variant (r_bits, P_bit, M_bit, V_bit) \"FIELDORDER(msb)\""
  } else {
    print HT "variant (avp_length) \"LENGTHTO(avp_code, VMPxxxxx, avp_length, vendor_id, avp_data)\""
  }
  print "}"

  print "type record AVP {"
  print HT "AVP_Header", "avp_header,"
  print HT "AVP_Data", "avp_data"
  print "} with {"
  print HT "variant \"PADDING(dword32)\""
  print HT "variant (avp_header) \"LENGTHTO(avp_header, avp_data)\""
  print HT "variant (avp_header) \"LENGTHINDEX(avp_length)\""
  print HT "variant (avp_data) \"CROSSTAG("
  for (i in AVP) {
    split(i, t)
    print HT HT "avp_" AVP[i] ", " \
      "avp_header.avp_code.vendor_id_" VENDORID[t[2]] " = " \
      "avp_code_" AVP[i] ";"
  }
  print HT HT "avp_UNKNOWN, OTHERWISE"
  print HT ")\""
  print "}"

  print "type set of GenericAVP AVP_list;"

  # AVP_Code constants' generation 
  for (i in AVP) {
    split(i, t)
    print "const AVP_Code c_AVP_Code_" AVP[i] " := {"
    print HT "vendor_id_" VENDORID[t[2]] " := avp_code_" AVP[i] " };"
  }

  print "} with { encode \"RAW\" } // End module"
  
}

function f_AddVariant_U32(prefix)
{
  print prefix, "with {"
  print HT "variant \"FIELDLENGTH(32)\""
  print HT "variant \"BYTEORDER(last)\""
  print HT "variant \"COMP(2scompl)\""
  print "}"
}

# Read entire type definition into total_enum
function f_ReadTotalEnum()
{
  total_enum = $0
  while(total_enum !~ /\}/) { 
    getline
    sub(/\/\/.*/, "")
    total_enum = total_enum $0
  }	
  gsub(/[ \t]+/, " ", total_enum)
  # Replace $0 contents with data following } 
  idx = index(total_enum, "}")
  $0 = substr(total_enum, idx+1)
  total_enum = substr(total_enum, 1, idx)
}

# Extract and store enumeration items from total_enum into ENUM array for key
function f_ParseStoreTotalEnum(key)
{
  sub(/^[^\{]+\{/, "", total_enum)
  sub(/\}[^\}]*$/, "", total_enum)
  if(ENUM[key]) {
    split(total_enum, t, /,/)
    for(i in t) {
      enum_item = t[i]
      match(enum_item, /(\([0-9]+\))/, enum_code)
      if(!index(ENUM[key], enum_code[1])) { ENUM[key] = ENUM[key] "," t[i] }
      else {
        print "// WARNING: Enumeration item with code", enum_code[1], \
          "exists in type", key
      }
    }
  } else { ENUM[key] = total_enum }
}
