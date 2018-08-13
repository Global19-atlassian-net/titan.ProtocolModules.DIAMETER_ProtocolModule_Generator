/******************************************************************************
* Copyright (c) 2000-2018 Ericsson Telecom AB
* All rights reserved. This program and the accompanying materials
* are made available under the terms of the Eclipse Public License v2.0
* which accompanies this distribution, and is available at
* https://www.eclipse.org/org/documents/epl-2.0/EPL-2.0.html
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
//  Rev:                R55A
//  Prodnr:             CNL 113 462
///////////////////////////////////////////////

#include "DIAMETER_Types.hh"
//#include <sys/timeb.h>
#include <stdlib.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdint.h>

namespace DIAMETER__Types{
static const unsigned char os_h_or_e_id_octets[] = { 0, 0, 0, 0 };
static const OCTETSTRING os_h_or_e_id_oct(4, os_h_or_e_id_octets);


INTEGER f__DIAMETER__genEndToEnd__int()
{
  timeval precise;                        // requires <sys/time.h>
  static bool inititalized = false;
  static uint32_t l_value = 0;
  if(!inititalized){
    long int seed = getpid();
    if ( gettimeofday(&precise, NULL) != -1 ) {
      seed <<= 8;
      seed +=  (precise.tv_sec) & 0xFF;
      seed <<= 8;
      seed +=  (precise.tv_usec) & 0xFF;
    }
    srand48(seed);
    l_value =lrand48();
    if ( gettimeofday(&precise, NULL) != -1 ) {
      l_value = (((uint32_t)precise.tv_sec) << 20) + ( l_value >> 12);
    }
    inititalized = true;
  }
  
  l_value+=1;  // unsigned int -> can be overflowed safely
  
  if(l_value==0){
    l_value+=1;
  }
  
  INTEGER ret;
  ret.set_long_long_val(l_value);
  return ret;
}


OCTETSTRING f__DIAMETER__genEndToEnd__oct()
{
  return int2oct(f__DIAMETER__genEndToEnd__int(),4);
}

INTEGER f__DIAMETER__genHopByHop__int()
{
  return f__DIAMETER__genEndToEnd__int();
}

OCTETSTRING f__DIAMETER__genHopByHop__oct()
{
  return int2oct(f__DIAMETER__genHopByHop__int(),4);
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

void f_DIAMETER_log_hex(const char *prompt, const unsigned char *msg,
  size_t length)
{
  if (prompt != NULL) TTCN_Logger::log_event_str(prompt);
  TTCN_Logger::log_event("Size: %lu, Msg:", (unsigned long)length);
  for (size_t i = 0; i < length; i++) TTCN_Logger::log_event(" %02x", msg[i]);
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
     
  while(temp + 8 < endp)
  { 
    /* reading the avp code value*/
    avpCode = ((unsigned int)(*temp) << 24) + ((unsigned int)(*(temp + 1)) << 16)	+ ((unsigned int)(*(temp + 2)) << 8) + (unsigned int)(*(temp + 3));
    
    temp+=5; // AVP code & VMPxxxxx octets (checked later)
             // tmp now points to the first length octet

    /* calculating the length of the next AVP*/
    avpLength = ((unsigned int)(*temp) << 16) + ((unsigned int)(*(temp + 1)) << 8)	+ (unsigned int)(*(temp + 2));
    if(avpLength < 8) {
      TTCN_Logger::begin_event( TTCN_WARNING );
      TTCN_Logger::log_event("Invalid AVP length: %d; ",avpLength);
      f_DIAMETER_log_hex("AVP octets: ", temp - 5, endp - (temp + 5));
      TTCN_Logger::end_event();
      break;
    }
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
          return OCTETSTRING(avpLength > 0? avpLength:0, temp);
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
     
  while(temp + 8 < endp)
  { 
    /* reading the avp code value*/
    avpCode = ((unsigned int)(*temp) << 24) + ((unsigned int)(*(temp + 1)) << 16)	+ ((unsigned int)(*(temp + 2)) << 8) + (unsigned int)(*(temp + 3));
    temp+=5; // AVP code & VMPxxxxx octets
             // tmp now points to the first length octet

    /* calculating the length of the next AVP*/
    avpLength = ((unsigned int)(*temp) << 16) + ((unsigned int)(*(temp + 1)) << 8)	+ (unsigned int)(*(temp + 2));
    if(avpLength < 8) {
      TTCN_Logger::begin_event( TTCN_WARNING );
      TTCN_Logger::log_event("Invalid AVP length: %d; msg: ",avpLength);
      pl__oct.log();
      TTCN_Logger::end_event();
      break;
    }
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
        if(i == 0)return OCTETSTRING(avpLength > 0? avpLength:0, temp); //Found AVP with highest priority
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
