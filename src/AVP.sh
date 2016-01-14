#!/bin/sh
##############################################################################
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
#set -x

# AVP.sh [OPTION] ... DDF-FILEs
# {-v <variable-name>=<value>} {DDF-files} 

AVPSCRIPT="AVP.awk"
AVPENCDECSCRIPT="AVP_encdec.awk"
TTCN3FILE="DIAMETER_Types"
CUSTOMENC=""
USEBIGINT=""
USEDETAILED_BITS=""
ENCDECFILE="DIAMETER_EncDec.cc"
UTF8ENC=""


if [ $# -lt 1 ]; then 
  echo "ERROR: Too few arguments"
  echo "Usage: $0 [-vNAME=VALUE] ... DDF-FILEs"
  echo "Where: -v sets variable NAME to VALUE"
  echo ""
  echo "Supported variables:"
  echo "  module_id ................ Name of generated TTCN-3 module"
  echo "  use_application_revision . Use revision prefix in AVP identifier"
  echo "  enum_2_Unsigned32 ........ Replace enumeration AVPs with Unsigned32"
  echo "  use_UTF8_encoding ........ Use UTF8 encoding for AVP_UTF8String"  
  exit 1
fi

     # check gawk version
     FIRSTLINE=`gawk --version|head -1`
     PRODUCT=`echo ${FIRSTLINE} | gawk '{ print $1 $2 }'`
     VERSION=`echo ${FIRSTLINE} | gawk '{ print $3 }'`
     if [ ${PRODUCT} != "GNUAwk" ]; then
       echo "ERROR: GNU Awk required"
       exit 1
     fi
     RESULT=`echo ${VERSION} | gawk '{ print ($0 < "3.1.6") }'`
     if [ ${RESULT} != 0 ]; then
       echo "ERROR: GNU Awk version >3.1.6 required (${VERSION} found)"
       exit 1
     fi

# Process arguments

AWKARGS=$@
while [ $# -ge 1 ]; do
  case $1 in
  -v)
      shift; 
      case $1 in
      module_id=*)
        TTCN3FILE=`echo $1 | sed 's/module_id=//'`
        if [ -f "DIAMETER_EncDec.cc" ]; then 
          cmd="s/#include \"DIAMETER_Types.hh\"/#include \"${TTCN3FILE}.hh\"/
               s/namespace DIAMETER__Types/namespace ${TTCN3FILE}/
               s/DIAMETER_EncDec/${TTCN3FILE}_DIAMETER_EncDec/g"
          cat "DIAMETER_EncDec.cc" \
              | sed "${cmd}" > ${TTCN3FILE}"_DIAMETER_EncDec.cc"
        else
          echo "ERROR: Missing DIAMETER_EncDec.cc file"
          exit 1
        fi
        ;;
      use_application_revision=*)
        ;;
      use_bigint=*)
        USEBIGINT="YES"
        ;;
      detailed_bits=*)
        USEDETAILED_BITS="YES"
        ;;
      enum_2_Unsigned32=*) 
        ;;
      enum_2_Unsigned32_list=*) 
        ;;
      disable_prefix=*) 
        ;;
      custom_enc=*)
        CUSTOMENC="YES"
        ;;
      use_UTF8_encoding=*)
	UTF8ENC="YES"
	;;	
      *) echo "ERROR: Unknown variable $1!"; exit 1;;
      esac
      ;;
  *) 
     # end of options
     if [ $# -lt 1 ]; then
       echo "ERROR: No input DDF file"
       exit 1
     fi
     # check if custom_enc is defined when use_UTF8_encoding is used
     if [ "$UTF8ENC" = "YES" ]; then
       if [ "$CUSTOMENC" = "" ]; then     
        echo "ERROR: No custom_enc defined. It is needed for use_UTF8_encoding!"
        exit 1       
       fi  
     fi
     ddf_files=$@
     # check gawk existence
     which gawk > /dev/null 2> /dev/null
     if [ ! $? ]; then
      echo "ERROR: GNU awk can not be found"
      exit 1
     fi
     # check input awk script
     comm_name=`which $0`
     comm_dir_name=`dirname $comm_name`
     if [ -f "${comm_dir_name}/${AVPSCRIPT}" ]; then
       echo "// Generated with command:" > ${TTCN3FILE}".ttcn"
       echo "// AVP.sh ${AWKARGS}"  >> ${TTCN3FILE}".ttcn"
       gawk -f ${comm_dir_name}/${AVPSCRIPT} ${AWKARGS} >> ${TTCN3FILE}".ttcn"
     else
       echo "ERROR: AVP.awk not found"
       exit 1
     fi
     if [ "$CUSTOMENC" = "YES" ]; then
       echo "" > $ENCDECFILE
       if [ "$USEBIGINT" = "YES" ]; then
         echo "#define DPMG_USE_INTEGER_FOR_UINT32_INT64" >> $ENCDECFILE
       fi
       if [ "$USEDETAILED_BITS" = "YES" ]; then
         echo "#define DPMG_USE_DETAILED_BITS" >> $ENCDECFILE
       fi
       if [ "$UTF8ENC" = "YES" ]; then
         echo "#define DPMG_USE_UTF8_ENC" >> $ENCDECFILE
       fi
       cat $comm_dir_name/DIAMETER_EncDec.tpl >> $ENCDECFILE
       
       ext_cc_tpls=`grep -h "EXT_CC:" $ddf_files | cut -d : -f 2`
       if [ "$ext_cc_tpls" ]
       then
         for i in $ext_cc_tpls
         do
           if [ -f $i ]
           then 
             cat $i >> $ENCDECFILE
           else 
             cat $comm_dir_name/$i >> $ENCDECFILE
           fi
         done
       fi
       gawk -f  ${comm_dir_name}/${AVPENCDECSCRIPT} ${AWKARGS} >> ${ENCDECFILE}
     fi
     break
     ;;
  esac
  shift
done
