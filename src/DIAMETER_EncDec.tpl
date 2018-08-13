/******************************************************************************
* Copyright (c) 2004, 2014  Ericsson AB
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

#include "DIAMETER_Types.hh"
#include <math.h>
#include <stdlib.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdint.h>


namespace DIAMETER__Types{
static const unsigned char os_h_or_e_id_octets[] = { 0, 0, 0, 0 };
static const OCTETSTRING os_h_or_e_id_oct(4, os_h_or_e_id_octets);

int encode_AVP_OctetString(TTCN_Buffer &p, const AVP__OctetString& avp);
int encode_AVP_Integer(TTCN_Buffer &p, const AVP__Integer32& avp);
int encode_AVP_Integer64(TTCN_Buffer &p, const AVP__Integer64& avp);
int encode_AVP_Unsigned32(TTCN_Buffer &p, const AVP__Unsigned32& avp);
int encode_AVP_Unsigned64(TTCN_Buffer &p, const AVP__Unsigned64& avp);
int encode_AVP_Float32(TTCN_Buffer &p, const AVP__Float32& avp);
int encode_AVP_Float64(TTCN_Buffer &p, const AVP__Float64& avp);
int encode_AVP_Grouped(TTCN_Buffer &p, const AVP__Grouped& avp);
int encode_AVP_Address(TTCN_Buffer &p, const AVP__Address& avp);
int encode_AVP_IP_Address(TTCN_Buffer &p, const AVP__IP__Address& avp);
int encode_AVP_Time(TTCN_Buffer &p, const AVP__Time& avp);
int encode_AVP_UTF8String(TTCN_Buffer &p, const AVP__UTF8String& avp);
int encode_AVP_DiameterIdentity(TTCN_Buffer &p, const AVP__DiameterIdentity& avp);
int encode_AVP_DiameterURI(TTCN_Buffer &p, const AVP__DiameterURI& avp);
int encode_AVP_IPFilterRule(TTCN_Buffer &p, const AVP__IPFilterRule& avp);
int encode_AVP_QoSFilterRule(TTCN_Buffer &p, const AVP__QoSFilterRule& avp);
int encode_AVP_enumerated(TTCN_Buffer &p, const int& avp);
bool decode_AVP_OctetString(const unsigned char* & p,  AVP__OctetString& avp, int length);
bool decode_AVP_Integer(const unsigned char* & p,  AVP__Integer32& avp, int length);
bool decode_AVP_Integer64(const unsigned char* & p,  AVP__Integer64& avp, int length);
bool decode_AVP_Unsigned32(const unsigned char* & p,  AVP__Unsigned32& avp, int length);
bool decode_AVP_Unsigned64(const unsigned char* & p,  AVP__Unsigned64& avp, int length);
bool decode_AVP_Float32(const unsigned char* & p,  AVP__Float32& avp, int length);
bool decode_AVP_Float64(const unsigned char* & p,  AVP__Float64& avp, int length);
bool decode_AVP_Grouped(const unsigned char* & p,  AVP__Grouped& avp, int length);
bool decode_AVP_Address(const unsigned char* & p,  AVP__Address& avp, int length);
bool decode_AVP_IP_Address(const unsigned char* & p,  AVP__IP__Address& avp, int length);
bool decode_AVP_Time(const unsigned char* & p,  AVP__Time& avp, int length);
bool decode_AVP_UTF8String(const unsigned char* & p,  AVP__UTF8String& avp, int length);
bool decode_AVP_DiameterIdentity(const unsigned char* & p,  AVP__DiameterIdentity& avp, int length);
bool decode_AVP_DiameterURI(const unsigned char* & p,  AVP__DiameterURI& avp, int length);
bool decode_AVP_IPFilterRule(const unsigned char* & p,  AVP__IPFilterRule& avp, int length);
bool decode_AVP_QoSFilterRule(const unsigned char* & p,  AVP__QoSFilterRule& avp, int length);
bool decode_AVP_enumerated(const unsigned char* & p,  int& avp, int length);
  
bool decode_header(const unsigned char* &p, AVP__Header &head, const unsigned char* buf_end);
bool decode_AVP(const unsigned char* &p, AVP &avptype, const unsigned char* buf_end);


////////////////////////////////////////////////////////////
void encode_bits_1byte(TTCN_Buffer &p,
		const BITSTRING& bit1, const BITSTRING& bit2, const BITSTRING& therest) {
	BITSTRING datas = bit1 + bit2 + therest;
	if (datas.lengthof() != 8){
		TTCN_warning("Bitstring length %d is not exactly a byte.", datas.lengthof());
  }
  p.put_string(bit2oct(datas));
}

////////////////////////////////////////////////////////////
void encode_bits_1byte(TTCN_Buffer &p,
		const BITSTRING& bit1, const BITSTRING& bit2, const BITSTRING& bit3,
		const BITSTRING& therest) {
	BITSTRING datas = bit1 + bit2 + bit3 + therest;
	if (datas.lengthof() != 8){
		TTCN_warning("Bitstring length %d is not exactly a byte.", datas.lengthof());
  }
  p.put_string(bit2oct(datas));
}

////////////////////////////////////////////////////////////
void encode_bits_1byte(TTCN_Buffer &p,
		const BITSTRING& bit1, const BITSTRING& bit2, const BITSTRING& bit3,
		const BITSTRING& bit4, const BITSTRING& therest) {
	BITSTRING datas = bit1 + bit2 + bit3 + bit4 + therest;
	if (datas.lengthof() != 8){
		TTCN_warning("Bitstring length %d is not exactly a byte.", datas.lengthof());
  }
  p.put_string(bit2oct(datas));
}


////////////////////////////////////////////////////////////
void encode_octets(int len, TTCN_Buffer &p,
		const OCTETSTRING& data) {
	if (data.lengthof() > len){
		TTCN_error(
				"Octetstring length mismatch.  Not daring to encode %d octets into %d.",
				data.lengthof(), len);
  }
  int padd=len-data.lengthof();
  for(;padd>0;padd--){
    p.put_c('\0');
  }
  p.put_string(data);
}

////////////////////////////////////////////////////////////
void encode_octets(TTCN_Buffer &p, const OCTETSTRING& data) {
  p.put_string(data);
}

////////////////////////////////////////////////////////////
void pad_oct_if_needed(TTCN_Buffer &p, int unpaddedsize) { //if called, pads unpaddedsize's distance to closest 4-octet boundary
	encode_octets(p, OCTETSTRING((4 - unpaddedsize % 4) % 4,
			(const unsigned char*) "\0\0\0"));
}

////////////////////////////////////////////////////////////
void encode_chars(TTCN_Buffer &p, const CHARSTRING& data) {
  p.put_string(data);
}

////////////////////////////////////////////////////////////
void encode_int_1byte(TTCN_Buffer &p, unsigned int data) {
	if ((data >> 8) != 0)
		TTCN_error("Integer value %d is too long to fit in 1 byte.", data);
  p.put_c(data & 0xFF);
}

////////////////////////////////////////////////////////////
void encode_int_2byte(TTCN_Buffer &p, unsigned int data) {
	if ((data >> 16) != 0)
		TTCN_error("Integer value %d is too long to fit in 2 bytes.", data);
  p.put_c((data >> 8) & 0xFF);
  p.put_c(data & 0xFF);
}

////////////////////////////////////////////////////////////
void encode_int_3byte(TTCN_Buffer &p, unsigned int data) {
	if ((data >> 24) != 0)
		TTCN_error("Integer value %d is too long to fit in 3 bytes.", data);
  p.put_c((data >> 16) & 0xFF);
  p.put_c((data >> 8) & 0xFF);
  p.put_c(data & 0xFF);
}

////////////////////////////////////////////////////////////
void encode_int_4byte(TTCN_Buffer &p, unsigned int data) {
  p.put_c((data >> 24) & 0xFF);
  p.put_c((data >> 16) & 0xFF);
  p.put_c((data >> 8) & 0xFF);
  p.put_c(data & 0xFF);
}

void encode_u32_4byte(TTCN_Buffer &p, const INTEGER& data) {
  p.put_string(int2oct(data, 4));
} // encode_u32_4byte


////////////////////////////////////////////////////////////
void encode_signed_int_4byte(TTCN_Buffer &p, const int data) {
  p.put_c((data >> 24) & 0xFF);
  p.put_c((data >> 16) & 0xFF);
  p.put_c((data >> 8) & 0xFF);
  p.put_c(data & 0xFF);
}

////////////////////////////////////////////////////////////
void encode_float_8byte(TTCN_Buffer &p, const double data) {
	unsigned char* poi = (unsigned char*) &data;
#if defined __sparc__ || defined __sparc
    p.put_s(8,poi);
#else
    for (int i = 0, k = 7; i < 8; i++, k--) p.put_c(poi[k]);
#endif
}


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


bool chk_zero(const INTEGER& var) {return var==0;}
bool chk_zero(const OCTETSTRING& var) {return var==os_h_or_e_id_oct;}



void f__DIAMETER__Enc__fast(const PDU__DIAMETER& pl__pdu, OCTETSTRING& pl__oct){
  
  TTCN_Buffer p;
  p.clear();
 
#ifdef DPMG_USE_DETAILED_BITS
	encode_bits_1byte(p, pl__pdu.R__bit(), pl__pdu.P__bit(), pl__pdu.E__bit(),
			pl__pdu.T__bit(), pl__pdu.r__bits());
    
#else
  encode_octets(1, p, bit2oct(pl__pdu.RPETxxxx()));
#endif  
  
	encode_int_3byte(p, pl__pdu.command__code());
	encode_octets(4, p, pl__pdu.application__id());

  if (chk_zero(pl__pdu.hop__by__hop__id()) && f__get__R__bit(pl__pdu) ){
    INTEGER ret = 0;
    timeval precise;                        // requires <sys/time.h>
    if ( gettimeofday(&precise, NULL) != -1 ) {
      srand48(precise.tv_sec + precise.tv_usec);
      encode_int_4byte(p, lrand48());
    }
    else { 
      TTCN_warning("f_DIAMETER_genHopByHop() returns with 0");
      encode_int_4byte(p, 0);
    }
  } else {
#ifdef DPMG_USE_INTEGER_FOR_UINT32_INT64
	  encode_u32_4byte(p,   pl__pdu.hop__by__hop__id());
#else
	  encode_octets(4, p,  pl__pdu.hop__by__hop__id());
#endif
  }
  
  if (chk_zero(pl__pdu.end__to__end__id()) && f__get__R__bit(pl__pdu) ){
    timeval precise;                        // requires <sys/time.h>
    if ( gettimeofday(&precise, NULL) != -1 ) {
      srand48(precise.tv_sec + precise.tv_usec);
      unsigned int l_value = (precise.tv_sec << 20) + (lrand48() >> 12);
      if (l_value < 0) l_value *= -1;
      encode_int_4byte(p,  l_value);
    } else {
      TTCN_warning("f_DIAMETER_genEndToEnd() returns with 0");
      encode_int_4byte(p,  0);
    }
  } else {
#ifdef DPMG_USE_INTEGER_FOR_UINT32_INT64
	  encode_u32_4byte(p,   pl__pdu.end__to__end__id());
#else
	  encode_octets(4, p,  pl__pdu.end__to__end__id());
#endif
  }

  encode_AVP_Grouped(p, pl__pdu.avps());


  OCTETSTRING tmp; 
  p.get_string(tmp);
  pl__oct = int2oct(pl__pdu.version(),1) + int2oct(tmp.lengthof()+4,3) + tmp;
  return;
}


OCTETSTRING f__DIAMETER__Enc(const PDU__DIAMETER& pl__pdu)
{
  OCTETSTRING ret_val;
  f__DIAMETER__Enc__fast(pl__pdu,ret_val);
  return ret_val;
}

void f_DIAMETER_log_hex(const char *prompt, const unsigned char *msg,
  size_t length)
{
    if (prompt != NULL) TTCN_Logger::log_event_str(prompt);
    TTCN_Logger::log_event("Size: %lu, Msg:", (unsigned long)length);
    for (size_t i = 0; i < length; i++) TTCN_Logger::log_event(" %02x", msg[i]);
}

OCTETSTRING f_GetAVPByListOfCodesFromGroupedAVP(const unsigned char *temp, int data_len,  const integerList& pl__codeList){
  const unsigned char *endp=temp+data_len;
  int avpLength = 0;
  unsigned int avpCode = 0;

  int codelist_size=pl__codeList.size_of();

  // an AVP is at least 8 bytes long - see RFC 3588 / 4.1.  AVP Header
  while(temp + 8 < endp)
  {
    /* reading the avp code value*/
    avpCode = ((unsigned int)(*temp) << 24) + ((unsigned int)(*(temp + 1)) << 16) + ((unsigned int)(*(temp + 2)) << 8) + (unsigned int)(*(temp + 3));

    temp+=5; // AVP code & VMPxxxxx octets (checked later)
             // tmp now points to the first length octet

    /* calculating the length of the next AVP*/
    avpLength = ((unsigned int)(*temp) << 16) + ((unsigned int)(*(temp + 1)) << 8) + (unsigned int)(*(temp + 2));
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
    /*checks whether the avp code value equals with one of the given avp code values or not*/
    for(int i = 0; i < codelist_size; i++)
    {
      if((const int)(pl__codeList[i]) == (int)avpCode)
      {
        return OCTETSTRING(avpLength > 0? avpLength:0, temp);
      }
    }

    // skip to the next avp
    if(avpLength % 4 != 0)  // AVP padding
    {
      avpLength = avpLength + (4 - (avpLength % 4));
    }
    temp+=avpLength;
  }
  /* no AVP was found, returns an empty octetstring*/  
  unsigned char noResult[0];
  return OCTETSTRING(0, noResult);
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

  // an AVP is at least 8 bytes long - see RFC 3588 / 4.1.  AVP Header
  while(temp + 8 < endp)
  {
    /* reading the avp code value*/
    avpCode = ((unsigned int)(*temp) << 24) + ((unsigned int)(*(temp + 1)) << 16) + ((unsigned int)(*(temp + 2)) << 8) + (unsigned int)(*(temp + 3));
    temp+=5; // AVP code & VMPxxxxx octets
             // tmp now points to the first length octet

    /* calculating the length of the next AVP*/
    avpLength = ((unsigned int)(*temp) << 16) + ((unsigned int)(*(temp + 1)) << 8) + (unsigned int)(*(temp + 2));
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
        return OCTETSTRING(avpLength > 0? avpLength:0, temp);
      }
    }

    // Chek for the groupped AVP to search in
    for(int i = 0; i < groupcodeList_size; i++)
    {
      if((const int)(pl__groupcodeList[i]) == (int)avpCode)
      {
         OCTETSTRING ret_val=f_GetAVPByListOfCodesFromGroupedAVP(temp,avpLength,pl__codeList);
         if(ret_val.lengthof()>0){
           return ret_val;
         }
         break;  // escape from the for loop
      }
    }
    // skip to the next avp
    if(avpLength % 4 != 0)  // AVP padding
    { 
      avpLength = avpLength + (4 - (avpLength % 4));
    }
    temp+=avpLength;
  }
  /* no AVP was found, returns an empty octetstring*/
  unsigned char noResult[0];
  return OCTETSTRING(0, noResult);
}

OCTETSTRING f__DIAMETER__GetAVPByListOfCodes(const OCTETSTRING& pl__oct, const integerList& pl__codeList) 
{
  integerList glist=NULL_VALUE;
  return f__DIAMETER__GetAVPByListOfCodesCombined(pl__oct,pl__codeList,glist);
}

OCTETSTRING f__DIAMETER__GetAVPByListOfCodesFromGroupedAVP(const OCTETSTRING& pl__oct, const integerList& pl__codeList) 
{
  return f_GetAVPByListOfCodesFromGroupedAVP((const unsigned char *)pl__oct,pl__oct.lengthof(),pl__codeList);
}


int encode_AVP_OctetString(TTCN_Buffer &p, const AVP__OctetString& avp){ 
  encode_octets(p, avp);
  pad_oct_if_needed(p, avp.lengthof());
  return avp.lengthof() ;
}

int encode_AVP_Integer32(TTCN_Buffer &p, const AVP__Integer32& avp){ 
  encode_signed_int_4byte(p, avp);
  return 4;
}
int encode_AVP_Integer64(TTCN_Buffer &p, const AVP__Integer64& avp){
#ifdef DPMG_USE_INTEGER_FOR_UINT32_INT64
	encode_octets(8, p, int2oct(avp,8));
#else
	encode_octets(8, p, avp);
#endif
  return 8;
}
int encode_AVP_Unsigned32(TTCN_Buffer &p, const AVP__Unsigned32& avp){
#ifdef DPMG_USE_INTEGER_FOR_UINT32_INT64
  encode_octets(4, p, int2oct(avp,4));
#else
	encode_octets(4, p, avp);
#endif
  return 4;
}
int encode_AVP_Unsigned64(TTCN_Buffer &p, const AVP__Unsigned64& avp){
#ifdef DPMG_USE_INTEGER_FOR_UINT32_INT64
	encode_octets(8, p, int2oct(avp,8));
#else
	encode_octets(8, p, avp);
#endif
  return 8;
}
int encode_AVP_Float32(TTCN_Buffer &buff, const AVP__Float32& avp){
    double tmp = avp;
    unsigned char p[4];
    if (tmp == 0.0) memset(p, 0, 4);
    else if (tmp == -0.0) {
      memset(p, 0, 4);
      p[0] |= 0x80;
    }
    else {
#if defined __sparc__ || defined __sparc
      int index=0;
      int adj=1;
#else
      int index = 7;
      int adj = -1;
#endif
      unsigned char *dv = (unsigned char *) &tmp;
      p[0] = dv[index] & 0x80;
      int exponent = dv[index] & 0x7F;
      exponent <<= 4;
      index += adj;
      exponent += (dv[index] & 0xF0) >> 4;
      exponent -= 1023;

      if (exponent > 127) {
        TTCN_warning( "The float value '%f' is out of the range of "
          "the single precision AVP type.", (double)avp);
        tmp = 0.0;
        exponent = 0;
      }
      else if (exponent < -127) {
        TTCN_warning("The float value '%f' is too small to represent it "
          "in single precision AVP type", (double)avp);
        tmp = 0.0;
        exponent = 0;
      }
      else exponent += 127;
      p[0] |= (exponent >> 1) & 0x7F;
      p[1] = ((exponent << 7) & 0x80) | ((dv[index] & 0x0F) << 3)
        | ((dv[index + adj] & 0xE0) >> 5);
      index += adj;
      p[2] = ((dv[index] & 0x1F) << 3) | ((dv[index + adj] & 0xE0) >> 5);
      index += adj;
      p[3] = ((dv[index] & 0x1F) << 3) | ((dv[index + adj] & 0xE0) >> 5);
  }
  buff.put_s(4,p);
  return 4;
}
int encode_AVP_Float64(TTCN_Buffer &p, const AVP__Float64& avp){
  encode_float_8byte(p, avp);
  return 8;
}
int encode_AVP_Address(TTCN_Buffer &p, const AVP__Address& avp){
  encode_int_2byte(p,avp.address__type());
  encode_octets(p, avp.address__data());
  pad_oct_if_needed(p, avp.address__data().lengthof()+2);
  return avp.address__data().lengthof()+2;
}
int encode_AVP_IP_Address(TTCN_Buffer &p, const AVP__IP__Address& avp){
  encode_octets(p, avp);
  pad_oct_if_needed(p, avp.lengthof());
  return avp.lengthof();
}
int encode_AVP_Time(TTCN_Buffer &p, const AVP__Time& avp){
  encode_octets(4,p, avp);
  return 4;
}
int encode_AVP_UTF8String(TTCN_Buffer &p, const AVP__UTF8String& avp){
#ifdef DPMG_USE_UTF8_ENC 
   TTCN_Buffer buf;    
   avp.encode_utf8(buf);
   int length = buf.get_len();
   p.put_buf(buf);
   pad_oct_if_needed(p, length);   
   return length;       
#else 
  encode_octets(p, avp);
  pad_oct_if_needed(p, avp.lengthof());
  return avp.lengthof();
#endif    
  
}
int encode_AVP_DiameterIdentity(TTCN_Buffer &p, const AVP__DiameterIdentity& avp){
  encode_chars(p, avp);
  pad_oct_if_needed(p, avp.lengthof());
  return avp.lengthof();
}
int encode_AVP_DiameterURI(TTCN_Buffer &p, const AVP__DiameterURI& avp){
  encode_chars(p, avp);
  pad_oct_if_needed(p, avp.lengthof());
  return avp.lengthof();
}
int encode_AVP_IPFilterRule(TTCN_Buffer &p, const AVP__IPFilterRule& avp){
  encode_chars(p, avp);
  pad_oct_if_needed(p, avp.lengthof());
  return avp.lengthof();
}
int encode_AVP_QoSFilterRule(TTCN_Buffer &p, const AVP__QoSFilterRule& avp){
  encode_chars(p, avp);
  pad_oct_if_needed(p, avp.lengthof());
  return avp.lengthof();
}
int encode_AVP_enumerated(TTCN_Buffer &p, const int& avp){
  encode_int_4byte(p, avp);
  return 4;
}

int get_AVP_code_val(const AVP__Code&);

bool decode_undefinedAVP(const unsigned char* &p, Undefined__AVP &avptype, const unsigned char* buf_end){
	if (buf_end - p < 8) {
		return false;
	}

  const unsigned char* start=p;
	avptype.avp__code()=OCTETSTRING(4, p);
	p += 4; // advance by size of avpcode

	unsigned char flagvalue = 0;
#ifdef DPMG_USE_DETAILED_BITS
	flagvalue += (((*p) & 0x10) >> 4); // 0001 0000
	flagvalue += (((*p) & 0x08) >> 2); // 0000 1000
	flagvalue += (((*p) & 0x04)); // 0000 0100
	flagvalue += (((*p) & 0x02) << 2); // 0000 0010
	flagvalue += (((*p) & 0x01) << 4); // 0000 0001
	avptype.r__bits() = BITSTRING(5, &flagvalue);
	flagvalue = ((*p) >> 5); // removes reserved bits
	avptype.P__bit() = BITSTRING(1, &flagvalue);
	flagvalue = (flagvalue >> 1); // removes P bit
	avptype.M__bit() = BITSTRING(1, &flagvalue);
	flagvalue = (flagvalue >> 1); // removes M bit
	avptype.V__bit() = BITSTRING(1, &flagvalue);
#else
  avptype.VMPxxxxx()=oct2bit(OCTETSTRING(1,p));
  flagvalue=(*p)>>7;
#endif  
	p++; // advance by size of flags

	int avplength = ((*p) << 16) + ((*(p + 1)) << 8) + *(p + 2);
	avptype.avp__length() = avplength;
	p += 3; // advance by size of length
	if (avptype.avp__length() < 8) {
		p = start;
		return false;
	}

	if (flagvalue) { // contains value of V-bit
		if (avplength < 12) { // possible for octetstring!
		  p = start;
		  return false;
		} else {// ASSUME next 4-byte is a Vendor-ID!
			if (buf_end - p >= 4) {
  			avptype.vendor__id()= OCTETSTRING(4, p);
				p += 4;
			} else {
  		  p = start;
	  	  return false;
			}
		}
	} else {// DON'T read any Vendor-ID at all..!
		avptype.vendor__id() = OMIT_VALUE;
	}
  avplength-=(p-start);
  int avpdatalength =avplength<(buf_end - p)?avplength:(buf_end - p);
  avptype.avp__data()=OCTETSTRING(avpdatalength, p);
  p+=avpdatalength;
  int paddlength=(3 - (avptype.avp__length() - 1) % 4);
  if(buf_end-p>=paddlength){  // padding
    p+=paddlength;
  }
  return true;
}

void extract_AVP(const unsigned char* &p, AVP__list& avplist,
		int avpindex, const unsigned char* buf_end){
    GenericAVP &avptype=avplist[avpindex];
    
    if(decode_AVP(p,avptype.avp(),buf_end)){
      return;
    }
    else if (decode_undefinedAVP(p,avptype.avp__undefined(),buf_end)) {
      return;
    } else {
      // avp_UNKNOWN
      avptype.avp__UNKNOWN()=OCTETSTRING(buf_end-p,p);
      p+=buf_end-p;
    }
  return;
}

INTEGER f__DIAMETER__Dec__fast(const OCTETSTRING& pl__oct,PDU__DIAMETER& pl__pdu) {
  const unsigned char *p=(const unsigned char *)pl__oct;
	const unsigned char *beginning = p;
  int buflen=pl__oct.lengthof();

	if (buflen < 20) {
		TTCN_warning("DIAMETER packet appears to be too small.");
		TTCN_Logger::begin_event( TTCN_PORTEVENT);
		for (int i = 0; i < buflen; i++)
			TTCN_Logger::log_event("%02x ", p[i]);
		TTCN_Logger::log_event("\n");
		TTCN_Logger::end_event();
		return 0;
	}

	pl__pdu.version() = *(p++); // advance by size of version
	p += 3; // advance by size of length
	pl__pdu.message__length() = buflen;

#ifdef DPMG_USE_DETAILED_BITS
	unsigned char flagvalue = 0;
	flagvalue += (((*p) & 0x08) >> 3); // 0000 1000
	flagvalue += (((*p) & 0x04) >> 1); // 0000 0100
	flagvalue += (((*p) & 0x02) << 1); // 0000 0010
	flagvalue += (((*p) & 0x01) << 3); // 0000 0001
	pl__pdu.r__bits() = BITSTRING(4, &flagvalue);
	flagvalue = ((*p) >> 4); // removes reserved bits
	pl__pdu.T__bit() = BITSTRING(1, &flagvalue);
	flagvalue = (flagvalue >> 1); // removes T bit
	pl__pdu.E__bit() = BITSTRING(1, &flagvalue);
	flagvalue = (flagvalue >> 1); // removes E bit
	pl__pdu.P__bit() = BITSTRING(1, &flagvalue);
	flagvalue = (flagvalue >> 1); // removes P bit
	pl__pdu.R__bit() = BITSTRING(1, &flagvalue);
#else
  pl__pdu.RPETxxxx()=oct2bit(OCTETSTRING(1,p));
#endif  
	p++; // advance by size of flags

	pl__pdu.command__code() = ((*p) << 16) + ((*(p + 1)) << 8) + *(p + 2);
	p += 3;

	pl__pdu.application__id() = OCTETSTRING(4, p);
	p += 4;

#ifdef DPMG_USE_INTEGER_FOR_UINT32_INT64
  pl__pdu.hop__by__hop__id().set_long_long_val(((unsigned int)(*p) << 24) + ((unsigned int)(*(p + 1)) << 16)	+ ((unsigned int)(*(p + 2)) << 8) + (unsigned int)(*(p + 3)));
#else
  pl__pdu.hop__by__hop__id()=OCTETSTRING(4, p);
#endif
	p += 4; // advance by size of hbh_id

#ifdef DPMG_USE_INTEGER_FOR_UINT32_INT64
  pl__pdu.end__to__end__id().set_long_long_val(((unsigned int)(*p) << 24) + ((unsigned int)(*(p + 1)) << 16)	+ ((unsigned int)(*(p + 2)) << 8) + (unsigned int)(*(p + 3)));
#else
  pl__pdu.end__to__end__id()=OCTETSTRING(4, p);
#endif
	p += 4; // advance by size of ete_id

	pl__pdu.avps() = NULL_VALUE;
	const unsigned char * buf_end = buflen + beginning;

	for (int count = 0; buf_end > p; count++) {
		extract_AVP(p, pl__pdu.avps(), count, buf_end);
	} // for AVPs

	if (buflen + beginning != p)
		TTCN_warning("Invalid data encoded into data structure.");
  return 1;
}

PDU__DIAMETER f__DIAMETER__Dec(const OCTETSTRING& pl__oct) 
{
  PDU__DIAMETER pdu;
  f__DIAMETER__Dec__fast(pl__oct,pdu);
  return pdu;
}

bool decode_AVP_OctetString(const unsigned char* & p,  AVP__OctetString& avp, int length){
  avp=OCTETSTRING(length, p);
  p+=length;
  return true;
}

bool decode_AVP_Integer32(const unsigned char* & p,  AVP__Integer32& avp, int length){
  if(length!=4) return false;
  avp=((*p) << 24) + ((*(p + 1)) << 16)	+ ((*(p + 2)) << 8) + *(p + 3);
  p+=length;
  return true;
}
bool decode_AVP_Integer64(const unsigned char* & p,  AVP__Integer64& avp, int length){
  if(length!=8) return false;
#ifdef DPMG_USE_INTEGER_FOR_UINT32_INT64
  avp=oct2int(OCTETSTRING(length, p));
#else
  avp=OCTETSTRING(length, p);
#endif
  p+=length;
  return true;
}
bool decode_AVP_Unsigned32(const unsigned char* & p,  AVP__Unsigned32& avp, int length){
  if(length!=4) return false;
#ifdef DPMG_USE_INTEGER_FOR_UINT32_INT64
  if((*p)&0x8f){
    avp.set_long_long_val(((unsigned int)(*p) << 24) + ((unsigned int)(*(p + 1)) << 16)	+ ((unsigned int)(*(p + 2)) << 8) + (unsigned int)(*(p + 3)));
  } else {
    avp=((*p) << 24) + ((*(p + 1)) << 16)	+ ((*(p + 2)) << 8) + *(p + 3);
  }

#else
  avp=OCTETSTRING(length, p);
#endif
  p+=length;
  return true;
}
bool decode_AVP_Unsigned64(const unsigned char* & p,  AVP__Unsigned64& avp, int length){
  if(length!=8) return false;
#ifdef DPMG_USE_INTEGER_FOR_UINT32_INT64
  avp=oct2int(OCTETSTRING(length, p));
#else
  avp=OCTETSTRING(length, p);
#endif
  p+=length;
  return true;
}
bool decode_AVP_Float32(const unsigned char* & p,  AVP__Float32& avp, int length){
  if(length!=4) return false;
  double tmp = 0.0;
    int sign = (p[0] & 0x80) >> 7;
    int exponent = ((p[0] & 0x7F) << 1) | ((p[1] & 0x80) >> 7);
    int fraction = ((p[1] & 0x7F) << 1) | ((p[2] & 0x80) >> 7);
    fraction <<= 8;
    fraction += ((p[2] & 0x7F) << 1) | ((p[3] & 0x80) >> 7);
    fraction <<= 7;
    fraction += p[3] & 0x7F;
    if (exponent == 0 && fraction == 0) tmp = sign ? -0.0 : 0.0;
    else if (exponent == 0xFF && fraction != 0) {
      TTCN_warning( "Not a Number received for type Float32 AVP.");
      tmp = 0.0;
    }
    else if (exponent == 0 && fraction != 0) {
      double sign_v = sign ? -1.0 : 1.0;
      tmp = sign_v * (static_cast<double> (fraction) / 8388608.0)
        * pow(2.0, -126.0);
    }
    else {
      double sign_v = sign ? -1.0 : 1.0;
      exponent -= 127;
      tmp = sign_v * (1.0 + static_cast<double> (fraction) / 8388608.0)
        * pow(2.0, static_cast<double> (exponent));
    }
  avp=tmp;
  p+=length;
  return true;
}
bool decode_AVP_Float64(const unsigned char* & p,  AVP__Float64& avp, int length){
  if(length!=8) return false;
  double val;
  char* poi = (char*) &val;
#if defined SOLARIS8 || SOLARIS
  for (int i=0; i<8; i++) {
		*(poi+i) = *(p++);
	}
#else
	for (int i = 0; i < 8; i++) {
		*(poi + 7 - i) = *(p++);
	}
#endif
  avp=val;
//  p+=length;
  return true;
}
bool decode_AVP_Grouped(const unsigned char* & p,  AVP__Grouped& avp, int length){
	const unsigned char* buf_end=p+length;
  if(length==0) {avp=NULL_VALUE;}
  else {
    for (int count = 0; buf_end > p; count++) {
		  extract_AVP(p, avp, count, buf_end);
	  } // for AVPs
//  p+=length;
  }
  return true;
}
bool decode_AVP_Address(const unsigned char* & p,  AVP__Address& avp, int length){
  if(length<3) return false;
  int type= ((*(p )) << 8)	+ *(p + 1); 
  if(!AddressType::is_valid_enum(type)) return false;
  p+=2;
  avp.address__type()=type;
  avp.address__data()=OCTETSTRING(length-2, p);
  p+=length-2;
  return true;
}
bool decode_AVP_IP_Address(const unsigned char* & p,  AVP__IP__Address& avp, int length){
  avp=OCTETSTRING(length, p);
  p+=length;
  return true;
}
bool decode_AVP_Time(const unsigned char* & p,  AVP__Time& avp, int length){
  if(length!=4) return false;
  avp=OCTETSTRING(length, p);
  p+=length;
  return true;
}
bool decode_AVP_UTF8String(const unsigned char* & p,  AVP__UTF8String& avp, int length){
#ifdef DPMG_USE_UTF8_ENC  
  avp.decode_utf8(length,p);
  p+=length;
  return true;
#else
  avp=OCTETSTRING(length, p);
  p+=length;
  return true;
#endif      
}
bool decode_AVP_DiameterIdentity(const unsigned char* & p,  AVP__DiameterIdentity& avp, int length){
  avp=CHARSTRING(length, (const char*)p);
  p+=length;
  return true;
}
bool decode_AVP_DiameterURI(const unsigned char* & p,  AVP__DiameterURI& avp, int length){
  avp=CHARSTRING(length, (const char*)p);
  p+=length;
  return true;
}
bool decode_AVP_IPFilterRule(const unsigned char* & p,  AVP__IPFilterRule& avp, int length){
  avp=CHARSTRING(length, (const char*)p);
  p+=length;
  return true;
}
bool decode_AVP_QoSFilterRule(const unsigned char* & p,  AVP__QoSFilterRule& avp, int length){
  avp=CHARSTRING(length, (const char*)p);
  p+=length;
  return true;
}

bool decode_AVP_enumerated(const unsigned char* & p,  int& avp, int length){
  if(length!=4) return false;
  avp=((*p) << 24) + ((*(p + 1)) << 16)	+ ((*(p + 2)) << 8) + *(p + 3);
  p+=length;
  return true;
}

