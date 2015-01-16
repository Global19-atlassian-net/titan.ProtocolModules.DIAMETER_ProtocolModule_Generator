###############################################################################
# Copyright (c) 2004, 2014  Ericsson AB
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
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
##############################################################################
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
  # Number of deleted AVP types
  deleted_avp_types = 0
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
    while ((getline < enum_2_Unsigned32_list)>0)
    {
      split($0,el," ")
      enum_replace_list["(" el[1] ")" SP "(" el[2] ")"]=1
    }
    close(enum_2_Unsigned32_list);
  } 


  print "int encode_AVP_Grouped(unsigned char* & p, const AVP__Grouped& avp){" 
  print "  int avp_len=0;"
  print "  unsigned char* start =p;"
  print " 	for (int count = 0; count < avp.size_of(); count++) {"
  print "    switch(avp[count].get_selection()){"
  print "      case GenericAVP::ALT_avp__undefined:{"
  print "        const Undefined__AVP& avptype=avp[count].avp__undefined();"
  print "        encode_octets(4,p,avptype.avp__code());"
  print "#ifdef DPMG_USE_DETAILED_BITS"
  print "          encode_bits_1byte(p, avptype.V__bit(), avptype.M__bit(), avptype.P__bit(),"
  print "	                         avptype.r__bits());"
  print "#else"
  print "          encode_octets(p, bit2oct(avptype.VMPxxxxx()));"
  print "#endif "
  print "          unsigned int avp_size = 8 + 4 * (avptype.vendor__id().ispresent()) + avptype.avp__data().lengthof();"
  print "          encode_int_3byte(p, avp_size);"
  print "          if (avptype.vendor__id().ispresent()){"
  print "             encode_octets(p, avptype.vendor__id()());"
  print "          }"
  print "        encode_octets(p,avptype.avp__data());"
  print "        }"
  print "        break;"
  print "      case GenericAVP::ALT_avp__UNKNOWN:"
  print "        encode_octets(p, avp[count].avp__UNKNOWN());"
  print "        break;"
  print "      case GenericAVP::ALT_avp:{"
  print "          const AVP& avptype=avp[count].avp();"
  print "          const AVP__Header& avphdr=avptype.avp__header();"
	        
  print "          encode_int_4byte(p, get_AVP_code_val(avphdr.avp__code()));"
  print "#ifdef DPMG_USE_DETAILED_BITS"
  print "          encode_bits_1byte(p, avphdr.V__bit(), avphdr.M__bit(), avphdr.P__bit(),"
  print "	 		                         avphdr.r__bits());"
  print "#else"
  print "          encode_octets(p, bit2oct(avphdr.VMPxxxxx()));"
  print "#endif "         
  print "          unsigned char* length_field=p;"
  print "          p+=3;"
  print "          if (avphdr.vendor__id().ispresent()){"
  print "             encode_int_4byte(p, avphdr.vendor__id()());"
  print "          }"
          
  print "          int encoded_octets=0;"
  print "          switch(avptype.avp__data().get_selection()){"


} #BEGIN

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
  gsub(/-/, "_", new_avp_vendor_id)
  avp_descriptors++ 
}

/\<type/ {
  # TTCN-3 type definition MUST be in a single line!
  # <type> <kind> <identifier>
  if($3 == new_avp_name && (new_avp_code SP new_avp_vendor_id_code) in AVP) {
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
      if(enum_2_Unsigned32 || ((new_avp_code SP new_avp_vendor_id_code) in enum_replace_list)) {
        AVP_type[new_avp_code SP new_avp_vendor_id_code] = "AVP_Unsigned32"
        BUFFER = "(p, "
        TYPE = "AVP_Unsigned32"
        printCaseCommand(BUFFER, TYPE)

      } else {
        AVP_type[new_avp_code SP new_avp_vendor_id_code] = "enumerated"
        BUFFER = "(p,(int)"
        TYPE = "AVP_enumerated"
        printCaseCommand(BUFFER, TYPE)
      }
      next
    } else {
        AVP_type[new_avp_code SP new_avp_vendor_id_code] = $2
        BUFFER = "(p,"
        TYPE = $2
        printCaseCommand(BUFFER, TYPE)
    }
  } 
}

END {
  print "            default:"
  print "              break;"
  print "          }"
  print "          int avphdr_size = 8 + 4 * (avphdr.vendor__id().ispresent());"
  print "          avp_len=avphdr_size+encoded_octets;"
  print "          encode_int_3byte(length_field, (unsigned int) avp_len);"
  print "   "       
  print "        }"
  print "        break;"
  print "      default:"
  print "        break;"
  print "     "
  print "    }"
  print "	} // for AVPs"
  print " "
  print "return p-start;" 
  print "}"
  print ""
  print "int get_AVP_code_val(const AVP__Code& avpcodes){"
  print "  int ret_val=0;"
  print "  switch(avpcodes.get_selection()){"
  len = length(VENDORID)
  for (i in VENDORID) {
    vid=VENDORID[i]
    gsub("_", "__", vid)
    
  print "case AVP__Code::ALT_vendor__id__" vid ":"
  print HT HT "ret_val=avpcodes.vendor__id__" vid "();"
  print HT HT "break;"
  }	


  print "    default:"
  print "      break;"
  print "  }"
  print "  return ret_val;"
  print "}"

  print "bool decode_AVP(const unsigned char* &p, AVP &avptype, const unsigned char* buf_end){"
  print "  "
  print "  const unsigned char* start=p;"
  print "  bool ret_val=false;"
  print " " 
  print "  if(decode_header(p,avptype.avp__header(),buf_end)){"
  print "    Vendor__Id vendor_id;"
  print ""
  print "    int data_len=avptype.avp__header().avp__length()-8;"
  print "    if(avptype.avp__header().vendor__id().ispresent()){"
  print "      data_len-=4;"
  print "      vendor_id=avptype.avp__header().vendor__id()();"
  print "    } else {"
  print "      vendor_id=Vendor__Id::vendor__id__NONE;"
  print "    }"
  print "    switch(vendor_id){"
  print ""
  
  for (i in VENDORID ){
    ii=VENDORID[i]
    gsub("_", "__", ii)
    print "     case Vendor__Id::vendor__id__" ii ":"
    print "       switch(avptype.avp__header().avp__code().vendor__id__" ii "()){"
    for (k in AVP) {
      split(k,j,SP)
      if(j[2] == i){
        l=AVP[k]
        gsub("_", "__", l)
        print "         case AVP__Code__" ii "::avp__code__" l ": {"
        if(AVP_type[k]=="enumerated"){
          print "             int enum_val=-1;"
          print "             if(decode_AVP_" AVP_type[k] "(p,enum_val ,data_len) ){"
          print "               if(" l "::is_valid_enum(enum_val)){"
          print "                 avptype.avp__data().avp__" l "()=enum_val;"
          print "                 ret_val=true;"
          print "               } else {"
        	print "                 p = start;"
	        print "                 ret_val=false;"
          print "               }"

          print "             } else {"
        	print "               p = start;"
	        print "               ret_val=false;"
          print "             }"
          
        } else {
          print "           if(decode_" AVP_type[k] "(p,avptype.avp__data().avp__" l "(),data_len) ){"
          print "             ret_val=true;"
          print "           } else {"
        	print "             p = start;"
	        print "             ret_val=false;"
          print "           }"
        }
          print "           }"
        print "           break;"
      }
    }
    print "         default:"
  	print "           p = start;"
	  print "           ret_val=false;"
    print "           break;"
    
    print "       }"
    print "       break;"
  }
  print ""

  print "         default:"
  print "           p = start;"
  print "           ret_val=false;"
  print "           break;"
  print "       }"
  print "  } else {"
  print "    p=start;"
  print "    ret_val=false;"
  print "  }"
  print "  if(ret_val){"
  print "    int paddlength=(3 - (avptype.avp__header().avp__length() - 1) % 4);"
  print "    if(buf_end-p>=paddlength){  // padding"
  print "      p+=paddlength;"
  print "    }"
  print "  }"
  print "  return ret_val;"
  print "}"
  print ""
  print "bool decode_header(const unsigned char* &p, AVP__Header &head, const unsigned char* buf_end) {"
  print "	if (buf_end - p < 8) {"
  print "		return false;"
  print "	}"

  print "  const unsigned char* start=p;"
  print "	int avp_code_val = ((*p) << 24) + ((*(p + 1)) << 16) + ((*(p + 2)) << 8)"
  print "			+ *(p + 3);"
  print "	p += 4; // advance by size of avpcode"

  print "	unsigned char flagvalue = 0;"


  print "#ifdef DPMG_USE_DETAILED_BITS"
  print "	flagvalue += (((*p) & 0x10) >> 4); // 0001 0000"
  print "	flagvalue += (((*p) & 0x08) >> 2); // 0000 1000"
  print "	flagvalue += (((*p) & 0x04)); // 0000 0100"
  print "	flagvalue += (((*p) & 0x02) << 2); // 0000 0010"
  print "	flagvalue += (((*p) & 0x01) << 4); // 0000 0001"
  print "	head.r__bits() = BITSTRING(5, &flagvalue);"
  print "	flagvalue = ((*p) >> 5); // removes reserved bits"
  print "	head.P__bit() = BITSTRING(1, &flagvalue);"
  print "	flagvalue = (flagvalue >> 1); // removes P bit"
  print "	head.M__bit() = BITSTRING(1, &flagvalue);"
  print "	flagvalue = (flagvalue >> 1); // removes M bit"
  print "	head.V__bit() = BITSTRING(1, &flagvalue);"
  print "#else"
  print "  head.VMPxxxxx()=oct2bit(OCTETSTRING(1,p));"
  print "  flagvalue=(*p)>>7;"
  print "#endif  "


  print "	p++; // advance by size of flags"

  print "	int avplength = ((*p) << 16) + ((*(p + 1)) << 8) + *(p + 2);"
  print "	head.avp__length() = avplength;"
  print "	p += 3; // advance by size of length"
  print "	if ((avplength < 8) || (avplength>(buf_end-start))) {"
  print "		p = start;"
  print "		return false;"
  print "	}"

  print "	if (flagvalue) { // contains value of V-bit"
  print "		if (avplength < 12) { // possible for octetstring!"
  print "		  p = start;"
  print "		  return false;"
  print "		} else {// ASSUME next 4-byte is a Vendor-ID!"
  print "			if (buf_end - p >= 4) {"
  print "	      int vendor_id_val = ((*p) << 24) + ((*(p + 1)) << 16) + ((*(p + 2)) << 8)"
  print "			      + *(p + 3);"
        
  print "				if (Vendor__Id::is_valid_enum(vendor_id_val)) {"
  print "					head.vendor__id()= vendor_id_val;"
  print "				} else {"
  print "  		    p = start;"
  print "	  	    return false;"
  print "				}"
  print "				p += 4;"
  print "			} else {"
  print "  		  p = start;"
  print "	  	  return false;"
  print "			}"
  print "		}"
  print "    switch(head.vendor__id()()){"


  for (i in VENDORID) {
    vid=VENDORID[i]
    gsub("_", "__", vid)
    print "      case Vendor__Id::vendor__id__" vid ":"
    print "				if (AVP__Code__" vid "::is_valid_enum(avp_code_val)) {"
    print "					head.avp__code().vendor__id__" vid "()= avp_code_val;"
    print "				} else {"
    print "  		    p = start;"
    print "	  	    return false;"
    print "				}"
    print "        break;"
    
  }	


  print "      default:"
  print "  		  p = start;"
  print "	  	  return false;"
  print "        break;"
  print "    }"
  print "	} else {// DON'T read any Vendor-ID at all..!"
  print "		head.vendor__id() = OMIT_VALUE;"
  print "		if (AVP__Code__NONE::is_valid_enum(avp_code_val)) {"
  print "			head.avp__code().vendor__id__NONE()= avp_code_val;"
  print "		} else {"
  print "  		p = start;"
  print "	  	return false;"
  print "		}"
    
  print "	}"
  print "	return true;"
  print "}"


  print "}"
  print "TTCN_Module DIAMETER_EncDec(\"DIAMETER_EncDec\", __DATE__, __TIME__);"
  print ""


  exit(1)

}

function printCaseCommand(BUFFER, TYPE) {
  gsub("_", "__", new_avp_id)
  print "case AVP__Data::ALT_avp__" new_avp_id ":"
  print HT HT "encoded_octets=encode_" TYPE BUFFER "avptype.avp__data().avp__" new_avp_id "());"
  print HT HT "break;"
}

