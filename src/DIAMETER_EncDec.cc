/******************************************************************************
* Copyright (c) 2004, 2014  Ericsson AB
* All rights reserved. This program and the accompanying materials
* are made available under the terms of the Eclipse Public License v1.0
* which accompanies this distribution, and is available at
* http://www.eclipse.org/legal/epl-v10.html
*
* Contributors:
*   Roland Gecse - initial implementation and initial documentation
*   Akos Pernek
*   Antal Wuh.Hen.Chang
*   Attila Fulop
*   Balazs Barcsik
*   Bence Molnar
*   Csaba Koppany
*   David Juhasz
*   Eduard Czimbalmos
*   Elemer Lelik
*   Endre Kiss
*   Endre Kulcsar
*   Gabor Szalai
*   Gabor Tatarka
*   Gergely Futo
*   Istvan Sandor
*   Krisztian Pandi
*   Kulcsár Endre
*   Laszlo Tamas Zeke
*   Norbert Pinter
*   Roland Gecse
*   Tibor Bende
*   Tibor Szabo
*   Timea Moder
*   Zoltan Medve
*   Zsolt Nandor Torok
*   Zsolt Szalai
******************************************************************************/
//
//  File:               DIAMETER_EncDec.cc
//  Description:	Encoder/Decoder and external functions for DPMG
//  Rev:                R29A
//  Prodnr:             CNL 113 462
///////////////////////////////////////////////

#include "DIAMETER_Types.hh"
//#include <sys/timeb.h>
#include <sys/time.h>

namespace DIAMETER__Types{
static const unsigned char os_h_or_e_id_octets[] = { 0, 0, 0, 0 };
static const OCTETSTRING os_h_or_e_id_oct(4, os_h_or_e_id_octets);

INTEGER f__DIAMETER__genHopByHop__int()
{
  INTEGER ret = 0;
  //timeb precise;                        // requires <sys/timeb.h>
  timeval precise;                        // requires <sys/time.h>
/*  if ( ftime(&precise) != -1 ) {
    srand48(precise.time + precise.millitm);
    ret = int2oct(lrand48(),4);
  }*/
  if ( gettimeofday(&precise, NULL) != -1 ) {
    srand48(precise.tv_sec + precise.tv_usec);
    ret.set_long_long_val(lrand48());
  }
  else TTCN_warning("f_DIAMETER_genHopByHop() returns with 0");
  return ret;
}
  


OCTETSTRING f__DIAMETER__genHopByHop__oct()
{
//  OCTETSTRING ret = os_h_or_e_id_oct;
  //timeb precise;                        // requires <sys/timeb.h>
//  timeval precise;                        // requires <sys/time.h>
/*  if ( ftime(&precise) != -1 ) {
    srand48(precise.time + precise.millitm);
    ret = int2oct(lrand48(),4);
  }*/
//  if ( gettimeofday(&precise, NULL) != -1 ) {
//    srand48(precise.tv_sec + precise.tv_usec);
//    ret = int2oct(lrand48(),4);
//  }
//  else TTCN_warning("f_DIAMETER_genHopByHop() returns with \'00000000\'O");
  return int2oct(f__DIAMETER__genHopByHop__int(),4);
}

INTEGER f__DIAMETER__genEndToEnd__int()
{
  INTEGER ret = 0;
  //timeb precise;                        // requires <sys/timeb.h>
  timeval precise;                        // requires <sys/time.h>
  /*if ( ftime(&precise) != -1 ) {
    srand48(precise.time + precise.millitm);
    int l_value = (precise.time << 20) + (lrand48() >> 12);
    if (l_value < 0) l_value *= -1;
    ret = int2oct(l_value,4);
  }*/
  if ( gettimeofday(&precise, NULL) != -1 ) {
    srand48(precise.tv_sec + precise.tv_usec);
    unsigned int l_value = (precise.tv_sec << 20) + (lrand48() >> 12);
    ret.set_long_long_val(l_value);
  }
  else TTCN_warning("f_DIAMETER_genHopByHop() returns with 0");
  return ret;
}


OCTETSTRING f__DIAMETER__genEndToEnd__oct()
{
//  OCTETSTRING ret = os_h_or_e_id_oct;
  //timeb precise;                        // requires <sys/timeb.h>
//  timeval precise;                        // requires <sys/time.h>
  /*if ( ftime(&precise) != -1 ) {
    srand48(precise.time + precise.millitm);
    int l_value = (precise.time << 20) + (lrand48() >> 12);
    if (l_value < 0) l_value *= -1;
    ret = int2oct(l_value,4);
  }*/
//  if ( gettimeofday(&precise, NULL) != -1 ) {
//    srand48(precise.tv_sec + precise.tv_usec);
//    int l_value = (precise.tv_sec << 20) + (lrand48() >> 12);
//    if (l_value < 0) l_value *= -1;
//    ret = int2oct(l_value,4);
//  }
//  else TTCN_warning("f_DIAMETER_genHopByHop() returns with \'00000000\'O");
//  return ret;
  return int2oct(f__DIAMETER__genEndToEnd__int(),4);
}

bool chk_zero(INTEGER var) {return var==0;}
bool chk_zero(OCTETSTRING var) {return var==os_h_or_e_id_oct;}

OCTETSTRING f__DIAMETER__Enc(const PDU__DIAMETER& pl__pdu)
{
  PDU__DIAMETER* par=NULL;
  
  if (chk_zero(pl__pdu.hop__by__hop__id()) && f__get__R__bit(pl__pdu) ){
    par = new PDU__DIAMETER(pl__pdu);
    par->hop__by__hop__id() = f__DIAMETER__genHopByHop();
  }
  
  if (chk_zero(pl__pdu.end__to__end__id()) && f__get__R__bit(pl__pdu) ){
    if(par==NULL) par = new PDU__DIAMETER(pl__pdu);
    par->end__to__end__id() = f__DIAMETER__genEndToEnd();
  }
  
  TTCN_Buffer buf;
  TTCN_EncDec::error_type_t err;
  buf.clear();
  TTCN_EncDec::clear_error();
  TTCN_EncDec::set_error_behavior(TTCN_EncDec::ET_ALL, TTCN_EncDec::EB_WARNING);
  if(par)
    par->encode(PDU__DIAMETER_descr_, buf, TTCN_EncDec::CT_RAW);
  else 
    pl__pdu.encode(PDU__DIAMETER_descr_, buf, TTCN_EncDec::CT_RAW);
  err = TTCN_EncDec::get_last_error_type();
  if(err != TTCN_EncDec::ET_NONE)
    TTCN_warning("Encoding error: %s\n", TTCN_EncDec::get_error_str());
  delete par;
  return OCTETSTRING(buf.get_len(), buf.get_data());
}

void f__DIAMETER__Enc__fast(const PDU__DIAMETER& pl__pdu, OCTETSTRING &pl__oct )
{
  PDU__DIAMETER* par=NULL;
  
  if (chk_zero(pl__pdu.hop__by__hop__id()) && f__get__R__bit(pl__pdu) ){
    par = new PDU__DIAMETER(pl__pdu);
    par->hop__by__hop__id() = f__DIAMETER__genHopByHop();
  }
  
  if (chk_zero(pl__pdu.end__to__end__id()) && f__get__R__bit(pl__pdu) ){
    if(par==NULL) par = new PDU__DIAMETER(pl__pdu);
    par->end__to__end__id() = f__DIAMETER__genEndToEnd();
  }
  
  TTCN_Buffer buf;
  TTCN_EncDec::error_type_t err;
  buf.clear();
  TTCN_EncDec::clear_error();
  TTCN_EncDec::set_error_behavior(TTCN_EncDec::ET_ALL, TTCN_EncDec::EB_WARNING);
  if(par)
    par->encode(PDU__DIAMETER_descr_, buf, TTCN_EncDec::CT_RAW);
  else 
    pl__pdu.encode(PDU__DIAMETER_descr_, buf, TTCN_EncDec::CT_RAW);
  err = TTCN_EncDec::get_last_error_type();
  if(err != TTCN_EncDec::ET_NONE)
    TTCN_warning("Encoding error: %s\n", TTCN_EncDec::get_error_str());
  delete par;
  pl__oct=OCTETSTRING(buf.get_len(), buf.get_data());
}

PDU__DIAMETER f__DIAMETER__Dec(const OCTETSTRING& pl__oct) 
{
  PDU__DIAMETER pdu;
  TTCN_Buffer buf;
  TTCN_EncDec::error_type_t err;
  TTCN_EncDec::clear_error();
  buf.clear();
  buf.put_os(pl__oct);
  TTCN_EncDec::set_error_behavior(TTCN_EncDec::ET_ALL, TTCN_EncDec::EB_WARNING);
  pdu.decode(PDU__DIAMETER_descr_, buf, TTCN_EncDec::CT_RAW);
  err = TTCN_EncDec::get_last_error_type();
  if(err != TTCN_EncDec::ET_NONE)
    TTCN_warning("Decoding error: %s\n", TTCN_EncDec::get_error_str());
  return pdu;
}

INTEGER f__DIAMETER__Dec__fast(const OCTETSTRING& pl__oct, PDU__DIAMETER &pl__pdu ) 
{
  TTCN_Buffer buf;
  TTCN_EncDec::error_type_t err;
  TTCN_EncDec::clear_error();
  buf.clear();
  buf.put_os(pl__oct);
  TTCN_EncDec::set_error_behavior(TTCN_EncDec::ET_ALL, TTCN_EncDec::EB_WARNING);
  pl__pdu.decode(PDU__DIAMETER_descr_, buf, TTCN_EncDec::CT_RAW);
  err = TTCN_EncDec::get_last_error_type();
  if(err != TTCN_EncDec::ET_NONE)
    TTCN_warning("Decoding error: %s\n", TTCN_EncDec::get_error_str());
  return 0;
}

OCTETSTRING f_GetAVPByListOfCodesFromGroupedAVP(const unsigned char *temp, int data_len,  const integerList& pl__codeList, const bool orderedList, int& bestFromGrouped){
  const unsigned char *endp=temp+data_len;
  int avpLength = 0;
  unsigned int avpCode = 0;

  int codelist_size=pl__codeList.size_of();
  
  bool avpFound = false;
  unsigned char* bestAVP;
  int   bestAVP_length = 0;
  
  //if the f_GetAVPByListOfCodesFromGroupedAVP function was called, the bestFromGrouped variable will be initialized, else:
  if(bestFromGrouped < 0)bestFromGrouped = codelist_size;
     
  while(temp < endp)
  { 
    /* reading the avp code value*/
    avpCode = ((unsigned int)(*temp) << 24) + ((unsigned int)(*(temp + 1)) << 16)	+ ((unsigned int)(*(temp + 2)) << 8) + (unsigned int)(*(temp + 3));
    
    temp+=5; // AVP code & VMPxxxxx octets (checked later)
             // tmp now points to the first length octet

    /* calculating the length of the next AVP*/
    avpLength = ((unsigned int)(*temp) << 16) + ((unsigned int)(*(temp + 1)) << 8)	+ (unsigned int)(*(temp + 2));
    avpLength-=8;          // length of AVP data = AVP length - 4 - Vendor ID length (calculated below)
    if(*(temp-1) & 0x80){  // skip vendor id, VMPxxxxx is just before the first length octet
      avpLength-=4;
      temp+=4;
    }
    temp+=3;  // skip length octets
             // Now temp points to the AVP data and avpLength holds the length of the data part
    
    if(orderedList){
      /*checks whether the avp code value equals with one of the given avp code values or not*/
      for(int i = 0; i < bestFromGrouped; i++)
      {
        if((const int)(pl__codeList[i]) == (int)avpCode)
        {
          if(i == 0)return OCTETSTRING(avpLength, temp); //Found AVP with highest priority
          avpFound = true;
          bestAVP = (unsigned char *)temp;
          bestAVP_length = avpLength;
          bestFromGrouped = i; //Already found an AVP, no need to check lower priority AVPs in the future
        }
      };
    } else {
      /*checks whether the avp code value equals with one of the given avp code values or not*/
      for(int i = 0; i < codelist_size; i++)
      {
        if((const int)(pl__codeList[i]) == (int)avpCode)
        {
          return OCTETSTRING(avpLength, temp);
        }
      }
    };
    
    // skip to the next avp
    if(avpLength % 4 != 0)  // AVP padding
    { 
      avpLength = avpLength + (4 - (avpLength % 4));
    }
    temp+=avpLength;  
  }  
  if(avpFound){
    return OCTETSTRING(bestAVP_length, bestAVP);
  } else {
    /* no AVP was found, returns an empty octetstring*/  
    unsigned char noResult[0];      
    return OCTETSTRING(0, noResult);
  };
}

OCTETSTRING f__DIAMETER__GetAVPByListOfCodesCombined(const OCTETSTRING& pl__oct, const integerList& pl__codeList, const integerList& pl__groupcodeList) 
{
  const unsigned char *temp= (const unsigned char *)pl__oct;
  const unsigned char *endp=temp+pl__oct.lengthof();
  
  temp += 20; // skip the DIAMETER header
  int avpLength = 0;
  unsigned int avpCode = 0;

  int codelist_size=pl__codeList.size_of();
  int groupcodeList_size=pl__groupcodeList.size_of();
  
  unsigned char noResult[0];      
  OCTETSTRING result = OCTETSTRING(0, noResult);
  
  bool avpFound = false;
  unsigned char* bestAVP;
  int   bestAVP_length = 0;
  int   bestFromGrouped = codelist_size; //Initializing the bestFromGrouped variable for the f_GetAVPByListOfCodesFromGroupedAVP function
     
  while(temp < endp)
  { 
    /* reading the avp code value*/
    avpCode = ((unsigned int)(*temp) << 24) + ((unsigned int)(*(temp + 1)) << 16)	+ ((unsigned int)(*(temp + 2)) << 8) + (unsigned int)(*(temp + 3));
    temp+=5; // AVP code & VMPxxxxx octets
             // tmp now points to the first length octet

    /* calculating the length of the next AVP*/
    avpLength = ((unsigned int)(*temp) << 16) + ((unsigned int)(*(temp + 1)) << 8)	+ (unsigned int)(*(temp + 2));
    avpLength-=8;          // length of AVP data = AVP length - 4 - Vendor ID length (calculated below)
    if(*(temp-1) & 0x80){  // skip vendor id, VMPxxxxx is just before the first length octet
      avpLength-=4;
      temp+=4;
    }
    temp+=3;  // skip length octets
             // Now temp points to the AVP data and avpLength holds the length of the data part
    /*checks whether the avp code value equals with one of the given avp code values or not*/
    for(int i = 0; i < codelist_size; i++)
    {
      if((const int)(pl__codeList[i]) == (int)avpCode)
      {
        if(i == 0)return OCTETSTRING(avpLength, temp); //Found AVP with highest priority
        avpFound = true;
        bestAVP = (unsigned char *)temp;
        bestAVP_length = avpLength;
        codelist_size = i; //Already found an AVP, no need to check lower priority AVPs in the future
      }
    }
    
    if(avpFound == false && bestFromGrouped != 0){//Simple AVPs have higher priority, so if we found one, it is not necessary to search in the grouped AVPs.
      //Chek for the groupped AVP to search in
      for(int i = 0; i < groupcodeList_size; i++)
      {
        if((const int)(pl__groupcodeList[i]) == (int)avpCode)
        {
          OCTETSTRING ret_val=f_GetAVPByListOfCodesFromGroupedAVP(temp,avpLength,pl__codeList, true, bestFromGrouped);
          if(ret_val.lengthof()>0){
            result = ret_val;
          }
          break;  // escape from the for loop
        }
      }
    };
       
    // skip to the next avp
    if(avpLength % 4 != 0)  // AVP padding
    {
      avpLength = avpLength + (4 - (avpLength % 4));
    }
    temp+=avpLength;  
  }
  
  bestFromGrouped = -1;
      
  if(avpFound){
    return OCTETSTRING(bestAVP_length, bestAVP);
  } else {
    /* Grouped AVP or no AVP was found, returns an empty octetstring*/   
    return result;
  };
}
OCTETSTRING f__DIAMETER__GetAVPByListOfCodes(const OCTETSTRING& pl__oct, const integerList& pl__codeList) 
{
  static const integerList glist=NULL_VALUE;
  return f__DIAMETER__GetAVPByListOfCodesCombined(pl__oct,pl__codeList,glist);
}

OCTETSTRING f__DIAMETER__GetAVPByListOfCodesFromGroupedAVP(const OCTETSTRING& pl__oct, const integerList& pl__codeList) 
{
  int bestFromGrouped = -1;
  return f_GetAVPByListOfCodesFromGroupedAVP((const unsigned char *)pl__oct,pl__oct.lengthof(),pl__codeList, false, bestFromGrouped);
}


}
TTCN_Module DIAMETER_EncDec("DIAMETER_EncDec", __DATE__, __TIME__);
