#include <stdio.h>
#include <iostream>
#include "svdpi.h"

using namespace std;

char sub(char , char );
char add(char , char );
extern "C" char test(char A,char B, char rst_n, char alu_en, char a_en, char b_en, char b_op, char a_op)
{
    int C;
    if(!rst_n){
      C = 0;

    }
    else{
      if(alu_en == 1){
        if(a_en == 1 && b_en ==0) {
            switch(a_op){
              case 0:
                  C = add(A, B);
                  break;
              case 1:
                  C = sub(A, B);
                  break;
              case 2:
                  C = A ^ B;
                  break;
              case 3:
                  C = A & B;
                  break;
              case 4:
                  C = A & B;
                  break;
              case 5:
                  C = A || B;
                  break;
              case 6:
                  C = ~(A ^ B);
                  break;
              default:
                  C = 0;
                  break;
                }

        }         // a_op
        else if(b_en == 1 && a_en == 0) {
          switch(b_op){
            case 0:
                C = ~(A & B);
                break;
            case 1:
                C = add(A , B);
                break;
            case 2:
                C = add(A , B);
                break;
            default:
                C = 0;
                break;
              }

        }   // b_op (SET 1)
        else if(b_en == 1 && a_en == 1)  {
          switch(b_op){
            case 0:
                C = A ^ B;
                break;
            case 1:
                C = ~(A ^ B);
                break;
            case 2:
                C = sub(A , 1);
                break;
            case 3:
                C = add(B , 2);
                break;
              }

        }  // b_op (SET 2)
      }
      else{
        C=0;
      }

    }




    return C;
}

char add(char in1, char in2){
    char A = ((in1& 0x0F)>=(in2& 0x0F))? (in1& 0x0F) : (in2& 0x0F);
    //printf("\n"BYTE_TO_BINARY_PATTERN,BYTE_TO_BINARY(A));
    char B = ((in1& 0x0F)<(in2& 0x0F))? (in1& 0x0F) : (in2& 0x0F);
    //printf("\n"BYTE_TO_BINARY_PATTERN,BYTE_TO_BINARY(B));
    char sign  = ((in1 &0x10)==(in2&0x10)) ? (in1 &0x10) : ((in1& 0x0F)>(in2& 0x0F)? (in1 &0x10) :(in2 &0x10) );
    
    sign = sign <<1;
    //printf("\n"BYTE_TO_BINARY_PATTERN,BYTE_TO_BINARY(sign));
    //printf("\n"BYTE_TO_BINARY_PATTERN,BYTE_TO_BINARY(((~B)&0x0F)));
    char res =  ((in1 &0x10)==(in2&0x10)) ? sign+A+B:sign + ((1+(A&0x0F)+((~B)&0x0F))&0x0F);
    //printf("\n"BYTE_TO_BINARY_PATTERN,BYTE_TO_BINARY(res));
    return res;
}
char sub(char in1, char in2){
    in2 = in2  ^ 0x10;
    //printf("\n"BYTE_TO_BINARY_PATTERN,BYTE_TO_BINARY(in1));
    //printf("\n"BYTE_TO_BINARY_PATTERN,BYTE_TO_BINARY(in2));
    return add(in1,in2);
      
}
/*
char sub(char in1, char in2){//, char sign_A, char sign_B
  //sign =  ~in2[4];
  //return add(in1,!sign_B,in2);
  return in1 - in2;
}

char add(char in1, char in2){//, char sign_A, char sign_B
  return in1 + in2;
}
*/
