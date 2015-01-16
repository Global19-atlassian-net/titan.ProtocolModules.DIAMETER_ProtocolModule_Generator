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

void encode_digit(unsigned char* &p, unsigned char digit)
{
  unsigned char hexdigit=(digit>>4)&0x0f;

  if (hexdigit < 10) {*(p++)='0' + hexdigit;}
  else if (hexdigit < 16) {*(p++)= 'A' + hexdigit - 10;}
  else *(p++)=0;
  
  hexdigit=digit&0x0f;

  if (hexdigit < 10) {*(p++)='0' + hexdigit;}
  else if (hexdigit < 16) {*(p++)= 'A' + hexdigit - 10;}
  else *(p++)=0;
  
}
void decode_digit(const unsigned char* &p, unsigned char& digit)
{
  unsigned char lowdigit=0;
  unsigned char highdigit=0;
  if ((*p) >= '0' && (*p) <= '9') highdigit= (*p) - '0';
  else if ((*p) >= 'A' && (*p) <= 'F') highdigit= (*p) - 'A' + 10;
  else if ((*p) >= 'a' && (*p) <= 'f') highdigit= (*p) - 'a' + 10;
  
  if ((*(p+1)) >= '0' && (*(p+1)) <= '9') lowdigit= (*(p+1)) - '0';
  else if ((*(p+1)) >= 'A' && (*(p+1)) <= 'F') lowdigit= (*(p+1)) - 'A' + 10;
  else if ((*(p+1)) >= 'a' && (*(p+1)) <= 'f') lowdigit= (*(p+1)) - 'a' + 10;
  p+=2;
  digit=(highdigit<<4)+lowdigit;
}

void swap_5_bits(const unsigned char ctemp, unsigned char &ret_val){
  ret_val=0;
	ret_val += ((ctemp & 0x10) >> 4); // 0001 0000
	ret_val += ((ctemp & 0x08) >> 2); // 0000 1000
	ret_val += ((ctemp & 0x04)); // 0000 0100
	ret_val += ((ctemp & 0x02) << 2); // 0000 0010
	ret_val += ((ctemp & 0x01) << 4); // 0000 0001
  
}
void swap_3_bits(const unsigned char ctemp, unsigned char &ret_val){
  ret_val=0;
	ret_val += ((ctemp & 0x04) >> 2);      // 0000 0100
	ret_val += ((ctemp & 0x02)); // 0000 0010
	ret_val += ((ctemp & 0x01) << 2); // 0000 0001

  
}
void swap_2_bits(const unsigned char ctemp, unsigned char &ret_val){
  ret_val=0;
	ret_val += ((ctemp & 0x02) >> 1);      // 0000 0010
	ret_val += ((ctemp & 0x01) << 1); // 0000 0001

  
}
void swap_4_bits(const unsigned char ctemp, unsigned char &ret_val){
  ret_val=0;
	ret_val += ((ctemp & 0x08) >> 3); // 0000 1000
	ret_val += ((ctemp & 0x04) >> 1); // 0000 0100
	ret_val += ((ctemp & 0x02) << 1); // 0000 0010
	ret_val += ((ctemp & 0x01) << 3); // 0000 0001
  
}

void swap_6_bits(const unsigned char ctemp, unsigned char &ret_val){
  ret_val=0;
	ret_val += ((ctemp & 0x20) >> 5); // 0010 0000
	ret_val += ((ctemp & 0x10) >> 3); // 0001 0000
	ret_val += ((ctemp & 0x08) >> 1); // 0000 1000
	ret_val += ((ctemp & 0x04) << 1); // 0000 0100
	ret_val += ((ctemp & 0x02) << 3); // 0000 0010
	ret_val += ((ctemp & 0x01) << 5); // 0000 0001
  
}
int encode_GPRS_Negotiated_QoS_Profile_detailed(unsigned char* &p, const GPRS__Negotiated__QoS__Profile &avp){
    unsigned char* start=p;
    switch(avp.QoS__Profile__detailed().qos__profile__data().get_selection()){
      case AVP__qos__profile::ALT_rel98:{
	      memcpy(p, (const char*) "98-", 3);
        p+=3;
        const qos__rel98__t& qos=avp.QoS__Profile__detailed().qos__profile__data().rel98();
        unsigned char temp1=0,temp2=0;
        unsigned char digit=0;
        
        swap_3_bits(*(qos.reliabilityClass()),temp1);
        swap_3_bits(*(qos.delayClass()),temp2);
        digit=temp1;
        digit+= temp2<<3;
        encode_digit(p,digit);

        swap_3_bits(*(qos.precedenceClass()),temp1);
        swap_4_bits(*(qos.peakThroughput()),temp2);
        digit=temp1;
        digit+= temp2<<4;
        encode_digit(p,digit);
        swap_5_bits(*(qos.meanThroughput()),temp1);
        digit=temp1;
        encode_digit(p,digit);
        }
        break;
      case AVP__qos__profile::ALT_rel99:{
	      memcpy(p, (const char*) "99-", 3);
        p+=3;
        const qos__rel99__t& qos=avp.QoS__Profile__detailed().qos__profile__data().rel99();
        unsigned char temp1=0,temp2=0,temp3=0;
        unsigned char digit=0;
        
        swap_3_bits(*(qos.reliabilityClass()),temp1);
        swap_3_bits(*(qos.delayClass()),temp2);
        digit=temp1;
        digit+= temp2<<3;
        encode_digit(p,digit);

        swap_3_bits(*(qos.precedenceClass()),temp1);
        swap_4_bits(*(qos.peakThroughput()),temp2);
        digit=temp1;
        digit+= temp2<<4;
        encode_digit(p,digit);
        swap_5_bits(*(qos.meanThroughput()),temp1);
        digit=temp1;
        encode_digit(p,digit);

        swap_3_bits(*(qos.deliverErroneusSDU()),temp1);
        swap_2_bits(*(qos.deliveryOrder()),temp2);
        swap_3_bits(*(qos.trafficClass()),temp3);
        digit=temp1;
        digit+= temp2<<3;
        digit+= temp3<<5;
        encode_digit(p,digit);
         
        encode_digit(p,*(qos.maxSDUSize()));
        encode_digit(p,*(qos.maxBitrateUplink()));
        encode_digit(p,*(qos.maxBitrateDownlink()));

        swap_4_bits(*(qos.sduErrorRatio()),temp1);
        swap_4_bits(*(qos.residualBER()),temp2);
        digit=temp1;
        digit+= temp2<<4;
        encode_digit(p,digit);

        swap_2_bits(*(qos.trafficHandlingPriority()),temp1);
        swap_6_bits(*(qos.transferDelay()),temp2);
        digit=temp1;
        digit+= temp2<<2;
        encode_digit(p,digit);

        encode_digit(p,*(qos.guaranteedBitRateUplink()));
        encode_digit(p,*(qos.guaranteedBitRateDownlink()));
        }
        break;

      case AVP__qos__profile::ALT_rel05:{
	      memcpy(p, (const char*) "05-", 3);
        p+=3;
        const qos__rel05__t& qos=avp.QoS__Profile__detailed().qos__profile__data().rel05();
        unsigned char temp1=0,temp2=0,temp3=0;
        unsigned char digit=0;
        
        swap_3_bits(*(qos.reliabilityClass()),temp1);
        swap_3_bits(*(qos.delayClass()),temp2);
        digit=temp1;
        digit+= temp2<<3;
        encode_digit(p,digit);

        swap_3_bits(*(qos.precedenceClass()),temp1);
        swap_4_bits(*(qos.peakThroughput()),temp2);
        digit=temp1;
        digit+= temp2<<4;
        encode_digit(p,digit);
        swap_5_bits(*(qos.meanThroughput()),temp1);
        digit=temp1;
        encode_digit(p,digit);

        swap_3_bits(*(qos.deliverErroneusSDU()),temp1);
        swap_2_bits(*(qos.deliveryOrder()),temp2);
        swap_3_bits(*(qos.trafficClass()),temp3);
        digit=temp1;
        digit+= temp2<<3;
        digit+= temp3<<5;
        encode_digit(p,digit);
         
        encode_digit(p,*(qos.maxSDUSize()));
        encode_digit(p,*(qos.maxBitrateUplink()));
        encode_digit(p,*(qos.maxBitrateDownlink()));

        swap_4_bits(*(qos.sduErrorRatio()),temp1);
        swap_4_bits(*(qos.residualBER()),temp2);
        digit=temp1;
        digit+= temp2<<4;
        encode_digit(p,digit);

        swap_2_bits(*(qos.trafficHandlingPriority()),temp1);
        swap_6_bits(*(qos.transferDelay()),temp2);
        digit=temp1;
        digit+= temp2<<2;
        encode_digit(p,digit);

        encode_digit(p,*(qos.guaranteedBitRateUplink()));
        encode_digit(p,*(qos.guaranteedBitRateDownlink()));

        swap_4_bits(*(qos.sourceStatisticsDescriptor()),temp1);
        temp2=(*(qos.signallingIndication()))&0x01;
        digit=temp1;
        digit+= temp2<<4;
        encode_digit(p,digit);

        encode_digit(p,*(qos.maxBitRateDownlinkExtended()));
        encode_digit(p,*(qos.guaranteedBitRateDownlinkExtended()));
        }
        break;
      case AVP__qos__profile::ALT_rel07:{
	      memcpy(p, (const char*) "07-", 3);
        p+=3;
        const qos__rel07__t& qos=avp.QoS__Profile__detailed().qos__profile__data().rel07();
        unsigned char temp1=0,temp2=0,temp3=0;
        unsigned char digit=0;
        swap_3_bits(*(qos.reliabilityClass()),temp1);
        swap_3_bits(*(qos.delayClass()),temp2);
        digit=temp1;
        digit+= temp2<<3;
        encode_digit(p,digit);

        swap_3_bits(*(qos.precedenceClass()),temp1);
        swap_4_bits(*(qos.peakThroughput()),temp2);
        digit=temp1;
        digit+= temp2<<4;
        encode_digit(p,digit);
        swap_5_bits(*(qos.meanThroughput()),temp1);
        digit=temp1;
        encode_digit(p,digit);

        if(!qos.trafficClass().ispresent()) {break;}
        swap_3_bits(*(qos.deliverErroneusSDU()()),temp1);
        swap_2_bits(*(qos.deliveryOrder()()),temp2);
        swap_3_bits(*(qos.trafficClass()()),temp3);
        digit=temp1;
        digit+= temp2<<3;
        digit+= temp3<<5;
        encode_digit(p,digit);
         
        if(!qos.maxSDUSize().ispresent()) {break;}
        encode_digit(p,*(qos.maxSDUSize()()));
        if(!qos.maxBitrateUplink().ispresent()) {break;}
        encode_digit(p,*(qos.maxBitrateUplink()()));
        if(!qos.maxBitrateDownlink().ispresent()) {break;}
        encode_digit(p,*(qos.maxBitrateDownlink()()));

        if(!qos.residualBER().ispresent()) {break;}
        swap_4_bits(*(qos.sduErrorRatio()()),temp1);
        swap_4_bits(*(qos.residualBER()()),temp2);
        digit=temp1;
        digit+= temp2<<4;
        encode_digit(p,digit);

        if(!qos.transferDelay().ispresent()) {break;}
        swap_2_bits(*(qos.trafficHandlingPriority()()),temp1);
        swap_6_bits(*(qos.transferDelay()()),temp2);
        digit=temp1;
        digit+= temp2<<2;
        encode_digit(p,digit);

        if(!qos.guaranteedBitRateUplink().ispresent()) {break;}
        encode_digit(p,*(qos.guaranteedBitRateUplink()()));
        if(!qos.guaranteedBitRateDownlink().ispresent()) {break;}
        encode_digit(p,*(qos.guaranteedBitRateDownlink()()));

        if(!qos.signallingIndication().ispresent()) {break;}
        swap_4_bits(*(qos.sourceStatisticsDescriptor()()),temp1);
        temp2=(*(qos.signallingIndication()()))&0x01;
        digit=temp1;
        digit+= temp2<<4;
        encode_digit(p,digit);

        if(!qos.maxBitRateDownlinkExtended().ispresent()) {break;}
        encode_digit(p,*(qos.maxBitRateDownlinkExtended()()));
        if(!qos.guaranteedBitRateDownlinkExtended().ispresent()) {break;}
        encode_digit(p,*(qos.guaranteedBitRateDownlinkExtended()()));
        
        if(!qos.maxBitRateUplinkExtended().ispresent()) {break;}
        encode_digit(p,*(qos.maxBitRateUplinkExtended()()));
        if(!qos.guaranteedBitRateUplinkExtended().ispresent()) {break;}
        encode_digit(p,*(qos.guaranteedBitRateUplinkExtended()()));
        
        }
        break;
      default:
        break;
    }
    return p-start;
}

int encode_GPRS_Negotiated_QoS_Profile(unsigned char* &p, const GPRS__Negotiated__QoS__Profile &avp){
  int ret_val=0;
  
  
  if(avp.ischosen(GPRS__Negotiated__QoS__Profile::ALT_raw__QoS__Profile)){
    ret_val=encode_AVP_OctetString(p,avp.raw__QoS__Profile());
  } else {
    ret_val=encode_GPRS_Negotiated_QoS_Profile_detailed(p,avp);
    pad_oct_if_needed(p,ret_val);
  }
  return ret_val;
}


bool decode_GPRS_Negotiated_QoS_Profile_detailed(const unsigned char* &p, GPRS__Negotiated__QoS__Profile &avp,int length){

  if(length<9) {return false;}
  if((*p)=='9'){
    if(((*(p+1))=='8') && length==9){
      avp.QoS__Profile__detailed().qos__profile__header()=CHARSTRING(3,(const char*)p);
      p+=3;
      qos__rel98__t& qos=avp.QoS__Profile__detailed().qos__profile__data().rel98();
      unsigned char temp1=0,temp2=0;
      unsigned char digit=0;
      decode_digit(p,digit);
      temp1=digit&0x07;
      swap_3_bits(temp1,temp2);
      qos.reliabilityClass()=BITSTRING(3,&temp2);

      temp1=(digit>>3)&0x07;
      swap_3_bits(temp1,temp2);
      qos.delayClass()=BITSTRING(3,&temp2);
      
      temp2=0;
      qos.spare1()=BITSTRING(2,&temp2);


      decode_digit(p,digit);
      temp1=digit&0x07;
      swap_3_bits(temp1,temp2);
      qos.precedenceClass()=BITSTRING(3,&temp2);
      
      temp2=0;
      qos.spare2()=BITSTRING(1,&temp2);

      temp1=(digit>>4)&0x0f;
      swap_4_bits(temp1,temp2);
      qos.peakThroughput()=BITSTRING(4,&temp2);
      

      decode_digit(p,digit);
      temp1=digit&0x1f;
      swap_5_bits(temp1,temp2);
      qos.meanThroughput()=BITSTRING(5,&temp2);
      temp2=0;
      qos.spare3()=BITSTRING(3,&temp2);

    } else if(((*(p+1))=='9') && length==25){
      avp.QoS__Profile__detailed().qos__profile__header()=CHARSTRING(3,(const char*)p);
      p+=3;
      qos__rel99__t& qos=avp.QoS__Profile__detailed().qos__profile__data().rel99();
      unsigned char temp1=0,temp2=0;
      unsigned char digit=0;
      decode_digit(p,digit);
      temp1=digit&0x07;
      swap_3_bits(temp1,temp2);
      qos.reliabilityClass()=BITSTRING(3,&temp2);

      temp1=(digit>>3)&0x07;
      swap_3_bits(temp1,temp2);
      qos.delayClass()=BITSTRING(3,&temp2);
      
      temp2=0;
      qos.spare1()=BITSTRING(2,&temp2);


      decode_digit(p,digit);
      temp1=digit&0x07;
      swap_3_bits(temp1,temp2);
      qos.precedenceClass()=BITSTRING(3,&temp2);
      
      temp2=0;
      qos.spare2()=BITSTRING(1,&temp2);

      temp1=(digit>>4)&0x0f;
      swap_4_bits(temp1,temp2);
      qos.peakThroughput()=BITSTRING(4,&temp2);
      

      decode_digit(p,digit);
      temp1=digit&0x1f;
      swap_5_bits(temp1,temp2);
      qos.meanThroughput()=BITSTRING(5,&temp2);
      temp2=0;
      qos.spare3()=BITSTRING(3,&temp2);

      decode_digit(p,digit);
      temp1=digit&0x7;
      swap_3_bits(temp1,temp2);
      qos.deliverErroneusSDU()=BITSTRING(3,&temp2);

      temp1=(digit>>3)&0x03;
      swap_2_bits(temp1,temp2);
      qos.deliveryOrder()=BITSTRING(2,&temp2);

      temp1=(digit>>5)&0x07;
      swap_3_bits(temp1,temp2);
      qos.trafficClass()=BITSTRING(3,&temp2);



      decode_digit(p,digit);
      qos.maxSDUSize()=OCTETSTRING(1,&digit);

      decode_digit(p,digit);
      qos.maxBitrateUplink()=OCTETSTRING(1,&digit);

      decode_digit(p,digit);
      qos.maxBitrateDownlink()=OCTETSTRING(1,&digit);

      decode_digit(p,digit);
      temp1=digit&0x0f;
      swap_4_bits(temp1,temp2);
      qos.sduErrorRatio()=BITSTRING(4,&temp2);

      temp1=(digit>>4)&0x0f;
      swap_4_bits(temp1,temp2);
      qos.residualBER()=BITSTRING(4,&temp2);

      decode_digit(p,digit);
      temp1=digit&0x03;
      swap_2_bits(temp1,temp2);
      qos.trafficHandlingPriority()=BITSTRING(2,&temp2);

      temp1=(digit>>2)&0x3f;
      swap_6_bits(temp1,temp2);
      qos.transferDelay()=BITSTRING(6,&temp2);

      decode_digit(p,digit);
      qos.guaranteedBitRateUplink()=OCTETSTRING(1,&digit);

      decode_digit(p,digit);
      qos.guaranteedBitRateDownlink()=OCTETSTRING(1,&digit);

    } else {return false;}
  } else if ((*p)=='0') {
    if(((*(p+1))=='5') && length==31){
      avp.QoS__Profile__detailed().qos__profile__header()=CHARSTRING(3,(const char*)p);
      p+=3;
      qos__rel05__t& qos=avp.QoS__Profile__detailed().qos__profile__data().rel05();
      unsigned char temp1=0,temp2=0;
      unsigned char digit=0;
      decode_digit(p,digit);
      temp1=digit&0x07;
      swap_3_bits(temp1,temp2);
      qos.reliabilityClass()=BITSTRING(3,&temp2);

      temp1=(digit>>3)&0x07;
      swap_3_bits(temp1,temp2);
      qos.delayClass()=BITSTRING(3,&temp2);
      
      temp2=0;
      qos.spare1()=BITSTRING(2,&temp2);


      decode_digit(p,digit);
      temp1=digit&0x07;
      swap_3_bits(temp1,temp2);
      qos.precedenceClass()=BITSTRING(3,&temp2);
      
      temp2=0;
      qos.spare2()=BITSTRING(1,&temp2);

      temp1=(digit>>4)&0x0f;
      swap_4_bits(temp1,temp2);
      qos.peakThroughput()=BITSTRING(4,&temp2);
      

      decode_digit(p,digit);
      temp1=digit&0x1f;
      swap_5_bits(temp1,temp2);
      qos.meanThroughput()=BITSTRING(5,&temp2);
      temp2=0;
      qos.spare3()=BITSTRING(3,&temp2);

      decode_digit(p,digit);
      temp1=digit&0x7;
      swap_3_bits(temp1,temp2);
      qos.deliverErroneusSDU()=BITSTRING(3,&temp2);

      temp1=(digit>>3)&0x03;
      swap_2_bits(temp1,temp2);
      qos.deliveryOrder()=BITSTRING(2,&temp2);

      temp1=(digit>>5)&0x07;
      swap_3_bits(temp1,temp2);
      qos.trafficClass()=BITSTRING(3,&temp2);



      decode_digit(p,digit);
      qos.maxSDUSize()=OCTETSTRING(1,&digit);

      decode_digit(p,digit);
      qos.maxBitrateUplink()=OCTETSTRING(1,&digit);

      decode_digit(p,digit);
      qos.maxBitrateDownlink()=OCTETSTRING(1,&digit);

      decode_digit(p,digit);
      temp1=digit&0x0f;
      swap_4_bits(temp1,temp2);
      qos.sduErrorRatio()=BITSTRING(4,&temp2);

      temp1=(digit>>4)&0x0f;
      swap_4_bits(temp1,temp2);
      qos.residualBER()=BITSTRING(4,&temp2);

      decode_digit(p,digit);
      temp1=digit&0x03;
      swap_2_bits(temp1,temp2);
      qos.trafficHandlingPriority()=BITSTRING(2,&temp2);

      temp1=(digit>>2)&0x3f;
      swap_6_bits(temp1,temp2);
      qos.transferDelay()=BITSTRING(6,&temp2);

      decode_digit(p,digit);
      qos.guaranteedBitRateUplink()=OCTETSTRING(1,&digit);

      decode_digit(p,digit);
      qos.guaranteedBitRateDownlink()=OCTETSTRING(1,&digit);

      decode_digit(p,digit);
      temp1=digit&0x0f;
      swap_4_bits(temp1,temp2);
      qos.sourceStatisticsDescriptor()=BITSTRING(4,&temp2);

      temp1=(digit>>4)&0x01;
      qos.signallingIndication()=BITSTRING(1,&temp1);

      temp2=0;
      qos.spare4()=BITSTRING(3,&temp2);

      decode_digit(p,digit);
      qos.maxBitRateDownlinkExtended()=OCTETSTRING(1,&digit);

      decode_digit(p,digit);
      qos.guaranteedBitRateDownlinkExtended()=OCTETSTRING(1,&digit);

     } else if(((*(p+1))=='7') && length>9 && length <36){
      avp.QoS__Profile__detailed().qos__profile__header()=CHARSTRING(3,(const char*)p);
      p+=3;
      qos__rel07__t& qos=avp.QoS__Profile__detailed().qos__profile__data().rel07();
      unsigned char temp1=0,temp2=0;
      unsigned char digit=0;
      decode_digit(p,digit);
      temp1=digit&0x07;
      swap_3_bits(temp1,temp2);
      qos.reliabilityClass()=BITSTRING(3,&temp2);

      temp1=(digit>>3)&0x07;
      swap_3_bits(temp1,temp2);
      qos.delayClass()=BITSTRING(3,&temp2);
      
      temp2=0;
      qos.spare1()=BITSTRING(2,&temp2);


      decode_digit(p,digit);
      temp1=digit&0x07;
      swap_3_bits(temp1,temp2);
      qos.precedenceClass()=BITSTRING(3,&temp2);
      
      temp2=0;
      qos.spare2()=BITSTRING(1,&temp2);

      temp1=(digit>>4)&0x0f;
      swap_4_bits(temp1,temp2);
      qos.peakThroughput()=BITSTRING(4,&temp2);
      

      decode_digit(p,digit);
      temp1=digit&0x1f;
      swap_5_bits(temp1,temp2);
      qos.meanThroughput()=BITSTRING(5,&temp2);
      temp2=0;
      qos.spare3()=BITSTRING(3,&temp2);

      if(length>9) {
        decode_digit(p,digit);
        temp1=digit&0x7;
        swap_3_bits(temp1,temp2);
        qos.deliverErroneusSDU()=BITSTRING(3,&temp2);
        
        temp1=(digit>>3)&0x03;
        swap_2_bits(temp1,temp2);
        qos.deliveryOrder()=BITSTRING(2,&temp2);
        
        temp1=(digit>>5)&0x07;
        swap_3_bits(temp1,temp2);
        qos.trafficClass()=BITSTRING(3,&temp2);

      } else {
        qos.deliverErroneusSDU()=OMIT_VALUE;
        qos.deliveryOrder()=OMIT_VALUE;
        qos.trafficClass()=OMIT_VALUE;
      }
         

      if(length>11) {
        decode_digit(p,digit);
        qos.maxSDUSize()=OCTETSTRING(1,&digit);
      } else {
        qos.maxSDUSize()=OMIT_VALUE;
      }

      if(length>13) {
        decode_digit(p,digit);
        qos.maxBitrateUplink()=OCTETSTRING(1,&digit);
      } else {
        qos.maxBitrateUplink()=OMIT_VALUE;
      }
      if(length>14) {
        decode_digit(p,digit);
        qos.maxBitrateDownlink()=OCTETSTRING(1,&digit);
      } else {
        qos.maxBitrateDownlink()=OMIT_VALUE;
      }

      if(length>17) {
        decode_digit(p,digit);
        temp1=digit&0x0f;
        swap_4_bits(temp1,temp2);
        qos.sduErrorRatio()=BITSTRING(4,&temp2);
        
        temp1=(digit>>4)&0x0f;
        swap_4_bits(temp1,temp2);
        qos.residualBER()=BITSTRING(4,&temp2);
      } else {
        qos.sduErrorRatio()=OMIT_VALUE;
        qos.residualBER()=OMIT_VALUE;
      }

      if(length>19) {
        decode_digit(p,digit);
        temp1=digit&0x03;
        swap_2_bits(temp1,temp2);
        qos.trafficHandlingPriority()=BITSTRING(2,&temp2);
        
        temp1=(digit>>2)&0x3f;
        swap_6_bits(temp1,temp2);
        qos.transferDelay()=BITSTRING(6,&temp2);
      } else {
        qos.trafficHandlingPriority()=OMIT_VALUE;
        qos.transferDelay()=OMIT_VALUE;
      }

      if(length>21) {
        decode_digit(p,digit);
        qos.guaranteedBitRateUplink()=OCTETSTRING(1,&digit);
      } else {
        qos.guaranteedBitRateUplink()=OMIT_VALUE;
      }
      if(length>23) {
        decode_digit(p,digit);
        qos.guaranteedBitRateDownlink()=OCTETSTRING(1,&digit);
      } else {
        qos.guaranteedBitRateDownlink()=OMIT_VALUE;
      }

      if(length>25) {
        decode_digit(p,digit);
        temp1=digit&0x0f;
        swap_4_bits(temp1,temp2);
        qos.sourceStatisticsDescriptor()=BITSTRING(4,&temp2);
        
        temp1=(digit>>4)&0x01;
        qos.signallingIndication()=BITSTRING(1,&temp1);
        
        temp2=0;
        qos.spare4()=BITSTRING(3,&temp2);
      } else {
        qos.sourceStatisticsDescriptor()=OMIT_VALUE;
        qos.signallingIndication()=OMIT_VALUE;
        qos.spare4()=OMIT_VALUE;
     }

     if(length>27) {
        decode_digit(p,digit);
        qos.maxBitRateDownlinkExtended()=OCTETSTRING(1,&digit);
      } else {
        qos.maxBitRateDownlinkExtended()=OMIT_VALUE;
      }

      if(length>29) {
        decode_digit(p,digit);
        qos.guaranteedBitRateDownlinkExtended()=OCTETSTRING(1,&digit);
      } else {
        qos.guaranteedBitRateDownlinkExtended()=OMIT_VALUE;
      }
      if(length>31) {
        decode_digit(p,digit);
        qos.maxBitRateUplinkExtended()=OCTETSTRING(1,&digit);
      } else {
        qos.maxBitRateUplinkExtended()=OMIT_VALUE;
      }
      if(length>33) {
        decode_digit(p,digit);
        qos.guaranteedBitRateUplinkExtended()=OCTETSTRING(1,&digit);
      } else {
        qos.guaranteedBitRateUplinkExtended()=OMIT_VALUE;
      }
    } else {return false;}
  } else {return false;}

//  avp.raw__QoS__Profile()=OCTETSTRING(length,p);
//  p+=length;
  return true;
}

bool decode_GPRS_Negotiated_QoS_Profile(const unsigned char* &p, GPRS__Negotiated__QoS__Profile &avp,int length){
  if(length<9) {return false;}
  if(!Negotiated__QoS__Profile__decode__as__detailed){
    avp.raw__QoS__Profile()=OCTETSTRING(length,p);
    p+=length;
    return true;
  } else {
    return decode_GPRS_Negotiated_QoS_Profile_detailed(p,avp,length);
  }
}

void f__handle__QoS__Profile(GPRS__Negotiated__QoS__Profile &pl__pdu){
  if(pl__pdu.ischosen(GPRS__Negotiated__QoS__Profile::ALT_raw__QoS__Profile)){
    OCTETSTRING oct=pl__pdu.raw__QoS__Profile();
    const unsigned char* p=oct;
    if(!decode_GPRS_Negotiated_QoS_Profile_detailed(p,pl__pdu,oct.lengthof())){
      TTCN_warning("Can not decode GPRS_Negotiated_QoS_Profile_detailed");
      pl__pdu.raw__QoS__Profile()=oct;
    }
  } else {
    TTCN_Buffer buf;
    buf.clear();
    size_t len=60; // max size of GPRS_Negotiated_QoS_Profile
    unsigned char* p;
    buf.get_end(p,len);
    int message_length=encode_GPRS_Negotiated_QoS_Profile_detailed(p,pl__pdu);
    buf.increase_length(message_length);
    buf.get_string(pl__pdu.raw__QoS__Profile());
    

  }

  

}
