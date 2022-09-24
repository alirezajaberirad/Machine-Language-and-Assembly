#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np
import pandas as pd
import struct


# In[2]:


def hextobin(op):
    num=''
    for i in op:
        if i=='0':
            num+='0000'
        elif i=='1':
            num+='0001'
        elif i=='2':
            num+='0010'
        elif i=='3':
            num+='0011'
        elif i=='4':
            num+='0100'
        elif i=='5':
            num+='0101'
        elif i=='6':
            num+='0110'
        elif i=='7':
            num+='0111'
        elif i=='8':
            num+='1000'
        elif i=='9':
            num+='1001'
        elif i=='a':
            num+='1010'
        elif i=='b':
            num+='1011'
        elif i=='c':
            num+='1100'
        elif i=='d':
            num+='1101'
        elif i=='e':
            num+='1110'
        elif i=='f':
            num+='1111'
    return num


# ## Tables

# In[3]:


#mov opcode table
table={'type':['regtoreg','memtoreg','regtomem','imtoreg','imtomem'],
      'opcode':['1000100','1000101','1000100','1011','1100011']}
movopcodetable=pd.DataFrame(table)

#add opcode table
table={'type':['regtoreg','memtoreg','regtomem','imtoreg','imtomem'],
      'opcode':['0000000','0000001','0000000','100000sw11000','100000swmod000']}
addopcodetable=pd.DataFrame(table)

#adc opcode table
table={'type':['regtoreg','memtoreg','regtomem','imtoreg','imtomem'],
      'opcode':['0001000','0001001','0001000','100000sw11010','100000']}
adcopcodetable=pd.DataFrame(table)

#operand size table
table={'name':['al','cl','dl','bl','ah','ch','dh','bh',
               'ax','cx','dx','bx','sp','bp','si','di',
               'eax','ecx','edx','ebx','esp','ebp','esi','edi',
               'r8w','r9w','r10w','r11w','r12w','r13w','r14w','r15w',
               'r8d','r9d','r10d','r11d','r12d','r13d','r14d','r15d',
               'r8','r9','r10','r11','r12','r13','r14','r15',
               'rax','rcx','rdx','rbx','rsp','rbp','rsi','rdi',
               'r8b','r9b','r10b','r11b','r12b','r13b','r14b','r15b'
              ],
      'size':[8,8,8,8,8,8,8,8,
             16,16,16,16,16,16,16,16,
             32,32,32,32,32,32,32,32,
             16,16,16,16,16,16,16,16,
             32,32,32,32,32,32,32,32,
             64,64,64,64,64,64,64,64,
             64,64,64,64,64,64,64,64,
              8,8,8,8,8,8,8,8
             ],
      'rexrb':['0','0','0','0','0','0','0','0',
               '0','0','0','0','0','0','0','0',
               '0','0','0','0','0','0','0','0',
               '1','1','1','1','1','1','1','1',
               '1','1','1','1','1','1','1','1',
               '1','1','1','1','1','1','1','1',
               '0','0','0','0','0','0','0','0',
               '1','1','1','1','1','1','1','1'
              ],
       'reg':['000','001','010','011','100','101','110','111',
             '000','001','010','011','100','101','110','111',
             '000','001','010','011','100','101','110','111',
             '000','001','010','011','100','101','110','111',
             '000','001','010','011','100','101','110','111',
             '000','001','010','011','100','101','110','111',
             '000','001','010','011','100','101','110','111',
             '000','001','010','011','100','101','110','111'
             ]
      }
opsizetable=pd.DataFrame(table)
 
#16 and 32 bit register codes table
table={'reg':['000','001','010','011','100','101','110','111',
             '000','001','010','011','100','101','110','111',
             '000','001','010','011','100','101','110','111'],
       'name':['ax','cx','dx','bx','sp','bp','si','di',
              'al','cl','dl','bl','ah','ch','dh','bh',
              'eax','ecx','edx','ebx','esp','ebp','esi','edi']
      }
regCode1632table=pd.DataFrame(table)

#mod
table={'mod':['00','01','10','10','11'],
      'disp':['noDisp',8,16,32,'reg']}
modtable=pd.DataFrame(table)

#prefix
table={'rexw':['0','0','0','0','0','1','1','1','1'],
      'opsize':[8,32,32,16,16,64,64,64,64],
      'adrsize':[8,64,32,64,32,64,32,64,32],
      '66':['','','','01100110','01100110','','','01100110','01100110'],
       '67':['','','01100111','','01100111','','01100111','','01100111']
      }
prefixtable=pd.DataFrame(table)

#w
table={'w':['0','1','1','1'],
      'opsize':[8,16,32,64]}
wtable=pd.DataFrame(table)

#scale
table={'scale':['00','01','10','11'],
      'zarib':['1','2','4','8']}
scaletable=pd.DataFrame(table)

#new registers
table={'reg':['r8b','r9b','r10b','r11b','r12b','r13b','r14b','r15b',
               'r8w','r9w','r10w','r11w','r12w','r13w','r14w','r15w',
               'r8d','r9d','r10d','r11d','r12d','r13d','r14d','r15d',
               'r8','r9','r10','r11','r12','r13','r14','r15',
               'rax','rcx','rdx','rbx','rsp','rbp','rsi','rdi'
              ]}
newreg=pd.DataFrame(table)

#tttn for jump
table={'name':['o','no','b','nae','nb','ae','e','z','ne','nz','be','na','nbe','a'],
       'code':['0000','0001','0010','0010','0011','0011','0100','0100','0101','0101','0110','0110','0111','0111']}

tttntable=pd.DataFrame(table)

#memory operation
table={'name':['QWORD','DWORD','WORD','BYTE'],
       'size':[64,32,16,8]}

memopsizetable=pd.DataFrame(table)


# ## Refering to instruction

# In[4]:


def instruction(s,i):
    if s[0:i]=='mov':
        return mov(s)
    elif s[0:i]=='add':
        return add(s)
    elif s[0:i]=='adc':
        return adc(s)
    elif s[0:i]=='sub':
        return sub(s)
    elif s[0:i]=='sbb':
        return sbb(s)
    elif s[0:i]=='and':
        return andfunc(s)
    elif s[0:i]=='or' : 
        return orfunc(s)
    elif s[0:i]=='xor':
        return xorfunc(s)
    elif s[0:i]=='dec':
        return dec(s)
    elif s[0:i]=='inc':
        return inc(s)
    elif s[0:i]=='cmp':
        return cmp(s)
    elif s[0:i]=='test':
        return test(s)
    elif s[0:i]=='xchg':
        return xchg(s)
    elif s[0:i]=='xadd':
        return xadd(s)
    elif s[0:i]=='imul':
        return imul(s)
    elif s[0:i]=='idiv':
        return idiv(s)
    elif s[0:i]=='bsf': 
        return bsf(s)
    elif s[0:i]=='bsr':
        return bsr(s)
    elif s[0:i]=='stc':
        return stc(s)
    elif s[0:i]=='clc':
        return clc(s)
    elif s[0:i]=='std':
        return std(s)
    elif s[0:i]=='cld':
        return cld(s)
    elif s[0:i]=='jmp':
        return jmp(s)
    elif s[0:i].find('jr')+1:
        return jrcxz(s)
    elif s[0:i].find('j')+1:
        return jcc(s,i)
    elif s[0:i]=='shl':
        return shl(s)
    elif s[0:i]=='shr':
        return shr(s)
    elif s[0:i]=='neg':
        return neg(s)
    elif s[0:i]=='not':
        return notfunc(s)
    elif s[0:i]=='call':
        return call(s)
    elif s[0:i]=='ret':
        return ret(s)
    elif s[0:i]=='syscall':
        return syscall(s)
    elif s[0:i]=='push':
        return push(s)
    elif s[0:i]=='pop':
        return pop(s)
    return


# In[5]:


def operandsize(string):
    return opsizetable.loc[opsizetable['name']==string,'size'].iloc[0]
def operandrexrb(string):
    return opsizetable.loc[opsizetable['name']==string,'rexrb'].iloc[0]
def operandreg(string):
    return opsizetable.loc[opsizetable['name']==string,'reg'].iloc[0]
def findtttn(string):
    return tttntable.loc[tttntable['name']==string,'code'].iloc[0]
def memopsize(string):
    return memopsizetable.loc[memopsizetable['name']==string, 'size'].iloc[0]


# In[6]:


def stc(string):
    return '11111001'


# In[7]:


def clc(string):
    return '11111000'


# In[8]:


def std(string):
    return '11111101'


# In[9]:


def cld(string):
    return '11111100'


# In[10]:


def syscall(string):
    return '0000111100000101'


# In[11]:


def mov(string):
    op1endIndex=string.find(',')
    op1=string[3:op1endIndex]
    op2=string[op1endIndex+1:]
    op1size=operandsize(op1)
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    
    if opsizetable.isin([op1]).any().any() and opsizetable.isin([op2]).any().any():#reg to reg
        op2size=operandsize(op2)
        opcode+=movopcodetable.loc[movopcodetable['type']=='regtoreg','opcode'].iloc[0]
        prefix+=prefixtable.loc[prefixtable['opsize']==op1size , '66'].iloc[0]
        mod+='11'
        w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]
        regop=opsizetable.loc[opsizetable['name']==op2,'reg'].iloc[0]
        rm=opsizetable.loc[opsizetable['name']==op1,'reg'].iloc[0]
        
    elif not(op2.find('[')+1):#immediate to register
        opcode+=movopcodetable.loc[movopcodetable['type']=='imtoreg','opcode'].iloc[0]
        prefix+=prefixtable.loc[prefixtable['opsize']==op1size , '66'].iloc[0]
        w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]
        regop=opsizetable.loc[opsizetable['name']==op1,'reg'].iloc[0]
        op2=op2.replace('0x','')
        for i in range(len(op2),0,-2):
            var=op2[i-2]+op2[i-1]
            displacement+=hextobin(var)
            
    elif op2.find('[')+1:#indirect addressing
        op2=op2.replace('[','')
        op2=op2.replace(']','')
        op2=op2.split('+')
        opcode+=movopcodetable.loc[movopcodetable['type']=='memtoreg','opcode'].iloc[0]
        prefix+=prefixtable.loc[prefixtable['opsize']==op1size , '66'].iloc[0]
        regop=opsizetable.loc[opsizetable['name']==op1,'reg'].iloc[0]
        if len(op2)==1:#reg*scale or ...
            op2=op2[0]
            op2=op2.split('*')
            if len(op2)==2:#reg*scale
                base='101'
                inx=op2[0]
                index=opsizetable.loc[opsizetable['name']==inx,'reg'].iloc[0]
                op2size=operandsize(inx)
                w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]
                mod='00'
                rm='100'
                prefix+=prefixtable.loc[prefixtable['adrsize']==op2size , '67'].iloc[0]
                scale=scaletable.loc[scaletable['zarib']==op2[1],'scale'].iloc[0]
                for i in range(op2size):
                    displacement+='0'
                
            elif op2[0].find('0x')+1:#displacement
                disp=op2[0].replace('0x','')
                w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]
                mod='00'
                rm='100'
                scale='00'
                index='100'
                base='101'
                for i in range(len(disp),0,-2):
                    var=disp[i-2]+disp[i-1]
                    displacement+=hextobin(var)
                
                
                
        elif len(op2)==2:#reg+reg or reg+disp or reg*disp+...
            if(opsizetable.isin([op2[0]]).any().any() and opsizetable.isin([op2[1]]).any().any()):#reg+reg
                bas=op2[0]
                inx=op2[1]
                op2size=operandsize(bas)
                index=opsizetable.loc[opsizetable['name']==inx,'reg'].iloc[0]
                base=opsizetable.loc[opsizetable['name']==bas,'reg'].iloc[0]
                prefix+=prefixtable.loc[prefixtable['adrsize']==op2size , '67'].iloc[0]
                rm='100'
                mod='00'
                scale+='00'
                prefix+=prefixtable.loc[prefixtable['opsize']==op1size , '66'].iloc[0]
                w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]
            elif(opsizetable.isin([op2[0].split('*')[0]]).any().any()) and op2[1].find('0x')+1:#reg*scale+disp
                indexscale=op2[0].split('*')
                inx=indexscale[0]
                disp=op2[1]
                op2size=operandsize(inx)
                ss=indexscale[1]
                w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]
                prefix+=prefixtable.loc[prefixtable['adrsize']==op2size , '67'].iloc[0]
                mod+='00'
                rm='100'
                scale=scaletable.loc[scaletable['zarib']==ss,'scale'].iloc[0]
                index=opsizetable.loc[opsizetable['name']==inx,'reg'].iloc[0]
                base='101'
                disp=disp.replace('0x','')
                for i in range(len(disp),0,-2):
                    var=disp[i-2]+disp[i-1]
                    displacement+=hextobin(var)
                for i in range(op2size-len(disp)*4):
                    displacement+='0'
            elif opsizetable.loc[opsizetable['name']==op2[0],'reg'].iloc[0]=='101':#bp+reg*scale
                bas=op2[0]
                op2size=operandsize(bas)
                prefix+=prefixtable.loc[prefixtable['adrsize']==op2size , '67'].iloc[0]
                w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]
                mod='01'
                rm='100'
                inxss=op2[1].split('*')
                inx=inxss[0]
                ss=inxss[1]
                scale=scaletable.loc[scaletable['zarib']==ss,'scale'].iloc[0]
                index=opsizetable.loc[opsizetable['name']==inx,'reg'].iloc[0]
                base='101'
                for i in range(8):
                    displacement+='0'
                    
            elif opsizetable.isin([op2[0]]).any().any():#reg+reg*scale
                bas=op2[0]
                op2size=operandsize(bas)
                prefix+=prefixtable.loc[prefixtable['adrsize']==op2size , '67'].iloc[0]
                w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]
                mod='00'
                rm='100'
                inxss=op2[1].split('*')
                inx=inxss[0]
                ss=inxss[1]
                scale=scaletable.loc[scaletable['zarib']==ss,'scale'].iloc[0]
                index=opsizetable.loc[opsizetable['name']==inx,'reg'].iloc[0]
                base=opsizetable.loc[opsizetable['name']==bas,'reg'].iloc[0]

        
        elif len(op2)==3:#base+index+disp
            if(opsizetable.isin([op2[0]]).any().any() and opsizetable.isin([op2[1]]).any().any()) and op2[2].find('0x')+1:#reg+reg+disp
                bas=op2[0]
                inx=op2[1]
                disp=op2[2]
                disp=disp.replace('0x','')
                op2size=operandsize(bas)
                prefix+=prefixtable.loc[prefixtable['adrsize']==op2size , '67'].iloc[0]
                index=opsizetable.loc[opsizetable['name']==inx,'reg'].iloc[0]
                base=opsizetable.loc[opsizetable['name']==bas,'reg'].iloc[0]
                dispsize=len(disp)*4
                mod=modtable.loc[modtable['disp']==dispsize, 'mod'].iloc[0]
                w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]
                rm='100'
                scale='00'
                disp=disp.replace('0x','')
                for i in range(len(disp),0,-2):
                    var=disp[i-2]+disp[i-1]
                    displacement+=hextobin(var)
                
            elif(opsizetable.isin([op2[0]]).any().any() and opsizetable.isin([op2[1].split('*')[0]]).any().any()) and op2[2].find('0x')+1:#reg + reg*scale + disp
                bas=op2[0]
                inxss=op2[1].split('*')
                inx=inxss[0]
                ss=inxss[1]
                disp=op2[2]
                disp=disp.replace('0x','')
                if len(disp)<=2:
                    dispsize=8
                elif len(disp)<=4:
                    dispsize=16
                elif len(disp)<=8:
                    dispsize=32
                elif len(disp)<=16:
                    dispsize=64
                op2size=operandsize(bas)
                prefix+=prefixtable.loc[prefixtable['adrsize']==op2size , '67'].iloc[0]
                w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]
                rm='100'
                mod=modtable.loc[modtable['disp']==dispsize, 'mod'].iloc[0]
                scale=scaletable.loc[scaletable['zarib']==ss,'scale'].iloc[0]
                index=opsizetable.loc[opsizetable['name']==inx,'reg'].iloc[0]
                base=opsizetable.loc[opsizetable['name']==bas,'reg'].iloc[0]
                for i in range(len(disp),0,-2):
                    var=disp[i-2]+disp[i-1]
                    displacement+=hextobin(var)

    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[12]:


def add(string):
    op1endIndex=string.find(',')
    op1=string[3:op1endIndex]
    op2=string[op1endIndex+1:]
    op1size=operandsize(op1)
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    
    if opsizetable.isin([op1]).any().any() and opsizetable.isin([op2]).any().any():#reg to reg
        op2size=operandsize(op2)
        opcode+=addopcodetable.loc[addopcodetable['type']=='regtoreg','opcode'].iloc[0]
        prefix+=prefixtable.loc[prefixtable['opsize']==op1size , '66'].iloc[0]
        mod+='11'
        w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]
        regop=opsizetable.loc[opsizetable['name']==op2,'reg'].iloc[0]
        rm=opsizetable.loc[opsizetable['name']==op1,'reg'].iloc[0]
        
    elif not(op2.find('[')+1):#immediate to register
        opcode+=addopcodetable.loc[addopcodetable['type']=='imtoreg','opcode'].iloc[0]
        prefix+=prefixtable.loc[prefixtable['opsize']==op1size , '66'].iloc[0]
        opcode=opcode.replace('w',wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0])
        regop='010'
        op2=op2.replace('0x','')
        while len(op2)==2:
            op2='0'+op2
            opcode=opcode.replace('s','1')
        opcode=opcode.replace('s','0')
        for i in range(len(op2),0,-2):
            var=op2[i-2]+op2[i-1]
            displacement+=hextobin(var)
            
    elif op2.find('[')+1:#indirect addressing
        op2=op2.replace('[','')
        op2=op2.replace(']','')
        op2=op2.split('+')
        if len(op2)==1:# register addressing or immediate data addressing
            op2=op2[0]
            if opsizetable.isin([op2]).any().any():
                op2size=operandsize(op2)
                opcode+=addopcodetable.loc[addopcodetable['type']=='memtoreg','opcode'].iloc[0]
                prefix+=prefixtable.loc[prefixtable['opsize']==op1size , '66'].iloc[0]
                prefix+=prefixtable.loc[prefixtable['adrsize']==op2size , '67'].iloc[0]
                w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]
                mod+='00'
                regop=opsizetable.loc[opsizetable['name']==op1,'reg'].iloc[0]
                rm=opsizetable.loc[opsizetable['name']==op2,'reg'].iloc[0]

    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[13]:


def adc(string):
    op1endIndex=string.find(',')
    op1=string[3:op1endIndex]
    op2=string[op1endIndex+1:]
    op1size=operandsize(op1)
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    
    if opsizetable.isin([op1]).any().any() and opsizetable.isin([op2]).any().any():#reg to reg
        op2size=operandsize(op2)
        opcode+=adcopcodetable.loc[adcopcodetable['type']=='regtoreg','opcode'].iloc[0]
        prefix+=prefixtable.loc[prefixtable['opsize']==op1size , '66'].iloc[0]
        mod+='11'
        w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]
        regop=opsizetable.loc[opsizetable['name']==op2,'reg'].iloc[0]
        rm=opsizetable.loc[opsizetable['name']==op1,'reg'].iloc[0]
        
    elif not(op2.find('[')+1):#immediate to register
        opcode+=adcopcodetable.loc[addopcodetable['type']=='imtoreg','opcode'].iloc[0]
        prefix+=prefixtable.loc[prefixtable['opsize']==op1size , '66'].iloc[0]
        opcode=opcode.replace('w',wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0])
        regop='010'
        op2=op2.replace('0x','')
        while len(op2)==2:
            op2='0'+op2
            opcode=opcode.replace('s','1')
        opcode=opcode.replace('s','0')
        for i in range(len(op2),0,-2):
            var=op2[i-2]+op2[i-1]
            displacement+=hextobin(var)
            
    elif op2.find('[')+1:#indirect addressing
        op2=op2.replace('[','')
        op2=op2.replace(']','')
        op2=op2.split('+')
        if len(op2)==1:# register addressing or immediate data addressing
            op2=op2[0]
            if opsizetable.isin([op2]).any().any():
                op2size=operandsize(op2)
                opcode+=adcopcodetable.loc[adcopcodetable['type']=='memtoreg','opcode'].iloc[0]
                prefix+=prefixtable.loc[prefixtable['opsize']==op1size , '66'].iloc[0]
                prefix+=prefixtable.loc[prefixtable['adrsize']==op2size , '67'].iloc[0]
                w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]
                mod+='00'
                regop=opsizetable.loc[opsizetable['name']==op1,'reg'].iloc[0]
                rm=opsizetable.loc[opsizetable['name']==op2,'reg'].iloc[0]
        
        
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[14]:


def cmp(string):
    op1endIndex=string.find(',')
    op1=string[3:op1endIndex]
    op2=string[op1endIndex+1:]
    op1size=operandsize(op1)
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    opcode='0011100'
    if newreg.isin([op1]).any().any() or newreg.isin([op2]).any().any():#64bit comparison
        rex='0100'
        w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]  
        prefix=prefixtable.loc[prefixtable['opsize']==op1size,'66'].iloc[0]
        rexw=prefixtable.loc[prefixtable['opsize']==op1size,'rexw'].iloc[0]
        rexr=operandrexrb(op2)
        rexx='0'
        rexb=operandrexrb(op1)
        rex+=rexw+rexr+rexx+rexb
        mod='11'
        regop=operandreg(op2)
        rm=operandreg(op1)
        
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[15]:


def test(string):
    op1endIndex=string.find(',')
    op1=string[4:op1endIndex]
    op2=string[op1endIndex+1:]
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    opcode='1000010'
    if opsizetable.isin([op1]).any().any() and opsizetable.isin([op2]).any().any():#reg with reg comparison
        if newreg.isin([op1]).any().any() or newreg.isin([op2]).any().any():#64bit comparison
            op1size=operandsize(op1)
            rex='0100'
            w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]  
            prefix=prefixtable.loc[prefixtable['opsize']==op1size,'66'].iloc[0]
            rexw=prefixtable.loc[prefixtable['opsize']==op1size,'rexw'].iloc[0]
            rexr=operandrexrb(op2)
            rexx='0'
            rexb=operandrexrb(op1)
            rex+=rexw+rexr+rexx+rexb
            mod='11'
            regop=operandreg(op2)
        rm=operandreg(op1)
    if op1.find('[')+1:#test [address],register
        op=op2
        op2=op1
        op1=op
    op1size=operandsize(op1)
    if op2.find('[')+1:#test register,[address]
        op2=op2.replace('[','')
        op2=op2.replace(']','')
        op2=op2.split('+')
        if(len(op2)==2):#test register,[reg+disp]
            bas=op2[0]
            disp=op2[1]
            disp=disp.replace('0x','')
            if len(disp)<=2:
                dispsize=8
            elif len(disp)<=4:
                dispsize=16
            elif len(disp)<=8:
                dispsize=32
            elif len(disp)<=16:
                dispsize=64
            mod=modtable.loc[modtable['disp']==dispsize,'mod'].iloc[0]
            if opsizetable.isin([bas]).any().any() or opsizetable.isin([op1]).any().any():#xchg newreg,[newreg+disp] or ...
                rex='0100'
                rexw=prefixtable.loc[prefixtable['opsize']==op1size,'rexw'].iloc[0]  
                rexr=operandrexrb(op1)
                rexx='0'
                rexb='0'
                rex+=rexw+rexr+rexx+rexb
                opcode='1000010'
                w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]
                regop=operandreg(op1)
                rm=operandreg(bas)
                for i in range(len(disp),0,-2):
                    var=disp[i-2]+disp[i-1]
                    displacement+=hextobin(var)
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[16]:


def imul(string):
    op1endIndex=string.find(',')
    op1=string[4:op1endIndex]
    op2=string[op1endIndex+1:]
    op1size=operandsize(op1)
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    opcode='000011111010111'
    if op2.find('[')+1:# imul reg,address
        op2=op2.replace('[','')
        op2=op2.replace(']','')
        if opsizetable.isin([op2]).any().any():#imul reg,[reg]
            if newreg.isin([op1]).any().any() or newreg.isin([op2]).any().any():#imul newReg,[newReg] or ...
                prefix=prefixtable.loc[prefixtable['opsize']==op1size,'66'].iloc[0]
                w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]
                rex='0100'
                rexw=prefixtable.loc[prefixtable['opsize']==op1size,'rexw'].iloc[0]
                rexr=operandrexrb(op2)
                rexx='0'
                rexb=operandrexrb(op1)
                rex+=rexw+rexr+rexx+rexb
                mod='00'
                regop=operandreg(op1)
                rm=operandreg(op2)
                
                
                
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[17]:


def xorfunc(string):
    op1endIndex=string.find(',')
    op1=string[3:op1endIndex]
    op2=string[op1endIndex+1:]
    op1size=operandsize(op1)
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    opcode='0011001'
    if op2.find('[')+1:# xor reg,address
        op2=op2.replace('[','')
        op2=op2.replace(']','')
        if opsizetable.isin([op2]).any().any():#xor reg,[reg]
            if newreg.isin([op1]).any().any() or newreg.isin([op2]).any().any():#xor newReg,[newReg] or ...
                prefix=prefixtable.loc[prefixtable['opsize']==op1size,'66'].iloc[0]
                w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]
                rex='0100'
                rexw=prefixtable.loc[prefixtable['opsize']==op1size,'rexw'].iloc[0]
                rexr=operandrexrb(op1)
                rexx='0'
                rexb=operandrexrb(op2)
                rex+=rexw+rexr+rexx+rexb
                mod=modtable.loc[modtable['disp']==op1size,'mod'].iloc[0]
                regop=operandreg(op1)
                rm=operandreg(op2)
                for i in range(8):
                    displacement+='0'
                    
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[18]:


def xadd(string):
    op1endIndex=string.find(',')
    op1=string[4:op1endIndex]
    op2=string[op1endIndex+1:]
    op2size=operandsize(op2)
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    opcode='000011111100000'
    if op1.find('[')+1 and opsizetable.isin([op2]).any().any():# xadd address,reg
        op1=op1.replace('[','')
        op1=op1.replace(']','')
        op1=op1.split('+')
        if len(op1)==2:# xadd [something+something],reg
            if opsizetable.isin([op1[0]]).any().any() and op1[1].find('0x')+1:#xadd [reg+disp],reg
                if newreg.isin([op1[0]]).any().any() or newreg.isin([op2]).any().any():#xadd [newReg+disp],newReg or ...
                    prefix=prefixtable.loc[prefixtable['opsize']==op2size,'66'].iloc[0]
                    w+=wtable.loc[wtable['opsize']==op2size , 'w'].iloc[0]
                    rex='0100'
                    rexw=prefixtable.loc[prefixtable['opsize']==op2size,'rexw'].iloc[0]
                    rexr=operandrexrb(op2)
                    rexx='0'
                    rexb=operandrexrb(op1[0])
                    rex+=rexw+rexr+rexx+rexb
                    disp=op1[1]
                    disp=disp.replace('0x','')
                    if len(disp)<=2:
                        dispsize=8
                    elif len(disp)<=4:
                        dispsize=16
                    elif len(disp)<=8:
                        dispsize=32
                    elif len(disp)<=16:
                        dispsize=64
                    for i in range(len(disp),0,-2):
                        var=disp[i-2]+disp[i-1]
                        displacement+=hextobin(var)
                    mod=modtable.loc[modtable['disp']==dispsize,'mod'].iloc[0]
                    regop=operandreg(op2)
                    rm=operandreg(op1[0])
    if opsizetable.isin([op1]).any().any() and opsizetable.isin([op2]).any().any():
        if newreg.isin([op1]).any().any() or newreg.isin([op2]).any().any():
            rex='0100'
            rexw=prefixtable.loc[prefixtable['opsize']==op2size,'rexw'].iloc[0]                
            rexr='0'
            rexx='0'
            rexb='0'
            rex+=rexw+rexr+rexx+rexb
            opcode='000011111100000111101001'
    
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[19]:


def bsf(string):
    op1endIndex=string.find(',')
    op1=string[3:op1endIndex]
    op2=string[op1endIndex+1:]
    op1size=operandsize(op1)
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    opcode+='000011111011110'
    if opsizetable.isin([op1]).any().any() and op2.find('[')+1:#bsf reg,address
        op2=op2.replace('[','')
        op2=op2.replace(']','')
        op2=op2.split('+')
        if(opsizetable.isin([op2[0]]).any().any() and opsizetable.isin([op2[1].split('*')[0]]).any().any()) and op2[2].find('0x')+1:#reg + reg*scale + disp
            bas=op2[0]
            inxss=op2[1].split('*')
            inx=inxss[0]
            ss=inxss[1]
            disp=op2[2]
            disp=disp.replace('0x','')
            if len(disp)<=2:
                dispsize=8
            elif len(disp)<=4:
                dispsize=16
            elif len(disp)<=8:
                dispsize=32
            elif len(disp)<=16:
                dispsize=64
            mod=modtable.loc[modtable['disp']==dispsize,'mod'].iloc[0]
            if newreg.isin([op1]).any().any() or newreg.isin([bas]).any().any() or newreg.isin([inx]).any().any():#bsf reg64,[reg64+reg64*scale+disp] or ...
                rex='0100'
                rexw=prefixtable.loc[prefixtable['opsize']==op1size,'rexw'].iloc[0]                
                rex+=rexw+'111'
                w+='0'
                mod=modtable.loc[modtable['disp']==dispsize,'mod'].iloc[0]
                regop=operandreg(op1)
                rm='100'
                scale=scaletable.loc[scaletable['zarib']==ss,'scale'].iloc[0]
                index=opsizetable.loc[opsizetable['name']==inx,'reg'].iloc[0]
                base=opsizetable.loc[opsizetable['name']==bas,'reg'].iloc[0]
                for i in range(len(disp),0,-2):
                    var=disp[i-2]+disp[i-1]
                    displacement+=hextobin(var)

                
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[20]:


def idiv(string):
    op=string[4:]
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    opsize=operandsize(op)
    prefix+=prefixtable.loc[prefixtable['opsize']==opsize , '66'].iloc[0]
    opcode='1111011'
    w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]  
    mod='11'
    regop='111'
    rm='000'
    if op1size==64:
        rex='01001000'
    
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[21]:


def jmp(string):
    op=string[3:]
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    if opsizetable.isin([op]).any().any():#jmp reg
        mod='11'
        if newreg.isin([op]).any().any():# jmp newreg
            opsize=operandsize(op)
            prefix+=prefixtable.loc[prefixtable['opsize']==opsize , '66'].iloc[0]
            opcode+='1111111'
            rex+='0100'
            w+=wtable.loc[wtable['opsize']==opsize , 'w'].iloc[0]
            rexw=prefixtable.loc[prefixtable['opsize']==32,'rexw'].iloc[0]                
            rexr='0'
            rexx='0'
            rexb=operandrexrb(op)
            rex+=rexw+rexr+rexx+rexb
            regop='100'
            rm=operandreg(op)
            
    elif op.find('[')+1:
        op=op.replace('[','')
        op=op.replace(']','')
        op=op.split('+')
        if len(op)==3:
            if newreg.isin([op[0]]).any().any() or newreg.isin([op[1].split('*')[0]]):
                opcode+='1111111'
                bas=op[0]
                opsize=operandsize(bas)
                inxss=op[1].split('*')
                inx=inxss[0]
                ss=inxss[1]
                disp=op[2]
                disp=disp.replace('0x','')
                rex='0100'
                rexw='0'
                rexr='0'
                rexx=operandrexrb(inx)
                rexb=operandrexrb(bas)
                rex+=rexw+rexr+rexx+rexb
                w+=wtable.loc[wtable['opsize']==opsize , 'w'].iloc[0]
                mod='10'
                regop='100'
                rm='100'
                scale=scaletable.loc[scaletable['zarib']==ss,'scale'].iloc[0]
                index=opsizetable.loc[opsizetable['name']==inx,'reg'].iloc[0]
                base=opsizetable.loc[opsizetable['name']==bas,'reg'].iloc[0]
                for i in range(len(disp),0,-2):
                    var=disp[i-2]+disp[i-1]
                    displacement+=hextobin(var)
                for i in range(8-len(disp)):
                    displacement+='0000'
            
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[22]:


def jcc(string,i):
    instruction=string[0:i]
    case=instruction[instruction.find('j')+1:]
    disp=string[i+1:]
    if disp.find('0x')+1:
        disp=disp.replace('0x','')
    opcode='0111'
    displacement=''
    tttn=findtttn(case)
    for i in range(len(disp),0,-2):
        var=disp[i-2]+disp[i-1]
        displacement+=hextobin(var)
    return opcode+tttn+displacement


# In[23]:


def xchg(string):
    op1endIndex=string.find(',')
    op1=string[4:op1endIndex]
    op2=string[op1endIndex+1:]
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    if op1.find('[')+1:#xchg [address],register
        op=op2
        op2=op1
        op1=op
    op1size=operandsize(op1)
    if op2.find('[')+1:#xchg register,[address]
        op2=op2.replace('[','')
        op2=op2.replace(']','')
        op2=op2.split('+')
        if(len(op2)==2) and op2[1].find('0x')+1:#xchg register,[reg+disp]
            bas=op2[0]
            disp=op2[1]
            disp=disp.replace('0x','')
            if len(disp)<=2:
                dispsize=8
            elif len(disp)<=4:
                dispsize=16
            elif len(disp)<=8:
                dispsize=32
            elif len(disp)<=16:
                dispsize=64
            mod=modtable.loc[modtable['disp']==dispsize,'mod'].iloc[0]
            if opsizetable.isin([bas]).any().any() or opsizetable.isin([op1]).any().any():#xchg newreg,[newreg+disp] or ...
                rex='0100'
                rexw=prefixtable.loc[prefixtable['opsize']==op1size,'rexw'].iloc[0]  
                rexr=operandrexrb(op1)
                rexx='0'
                rexb='0'
                rex+=rexw+rexr+rexx+rexb
                opcode='1000011'
                w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]
                regop=operandreg(op1)
                rm=operandreg(bas)
                for i in range(len(disp),0,-2):
                    var=disp[i-2]+disp[i-1]
                    displacement+=hextobin(var)
                
    
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[24]:


def bsr(string):
    op1endIndex=string.find(',')
    op1=string[3:op1endIndex]
    op2=string[op1endIndex+1:]
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    op1size=operandsize(op1)
    if op2.find('[')+1:#xchg register,[address]
        op2=op2.replace('[','')
        op2=op2.replace(']','')
        op2=op2.split('+')
        if(len(op2)==2) and opsizetable.isin([op2[1]]).any().any():#xchg register,[reg+disp]
            bas=op2[0]
            inx=op2[1]
            if opsizetable.isin([bas]).any().any() or opsizetable.isin([op1]).any().any():#xchg newreg,[newreg+reg] or ...
                rex='0100'
                rexw=prefixtable.loc[prefixtable['opsize']==op1size,'rexw'].iloc[0]  
                rexr=operandrexrb(bas)
                rexx=operandrexrb(inx)
                rexb='0'
                rex+=rexw+rexr+rexx+rexb
                opcode='000011111011110'
                w+=wtable.loc[wtable['opsize']==op1size , 'w'].iloc[0]
                mod='00'
                regop=operandreg(op1)
                rm='100'
                scale='00'
                base=operandreg(bas)
                index=operandreg(inx)
                
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[25]:


def sub(string):
    op1endIndex=string.find(',')
    op1=string[3:op1endIndex]
    op2=string[op1endIndex+1:]
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    
    if op1.find("[")+1 and opsizetable.isin([op2]).any().any():#sub address,reg
        op1=op1.replace('[','')
        op1=op1.replace(']','')
        op1=op1.split('+')
        if len(op1)==2:#sub [sth+sth],reg
            if opsizetable.isin([op1[0]]).any().any() and opsizetable.isin([op1[1].split('*')[0]]).any().any():#sub [reg+reg*scale(or without scale)],reg
                bas=op1[0]
                inx=op1[1].split('*')[0]
                if len(op1[1].split('*'))==2:
                    ss=op1[1].split('*')[1]
                if (newreg.isin([bas]).any().any() or newreg.isin([inx]).any().any() or newreg.isin([op1]).any().any()) and len(op1[1].split('*'))==2:#sub [reg64+reg64*scale],reg64 or ...
                    opsize=operandsize(op2)
                    rex='0100'
                    rexw=prefixtable.loc[prefixtable['opsize']==opsize,'rexw'].iloc[0]  
                    rex+=rexw+'000'
                    opcode='0010100'
                    w+=wtable.loc[wtable['opsize']==opsize , 'w'].iloc[0]
                    mod=modtable.loc[modtable['disp']==8,'mod'].iloc[0]
                    regop=operandreg(op2)
                    rm='100'
                    scale=scaletable.loc[scaletable['zarib']==ss,'scale'].iloc[0]
                    base=operandreg(bas)
                    index=operandreg(inx)
                    displacement='00000000'
                    
                elif len(op1[1].split('*'))==2:#sub [oldreg+oldreg*scale],oldreg
                    opcode+='0010100'
                    opsize=operandsize(bas)
                    w+=wtable.loc[wtable['opsize']==opsize , 'w'].iloc[0]
                    prefix+=prefixtable.loc[prefixtable['adrsize']==opsize , '67'].iloc[0]
                    mod=modtable.loc[modtable['disp']==8,'mod'].iloc[0]
                    regop=operandreg(op2)
                    rm='100'
                    scale=scaletable.loc[scaletable['zarib']==ss,'scale'].iloc[0]
                    base=operandreg(bas)
                    index=operandreg(inx)
                    displacement='00000000'
    
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[26]:


def sbb(string):
    op1endIndex=string.find(',')
    op1=string[3:op1endIndex]
    op2=string[op1endIndex+1:]
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    
    if op1.find("[")+1 and opsizetable.isin([op2]).any().any():#sub address,reg
        op1=op1.replace('[','')
        op1=op1.replace(']','')
        op1=op1.split('+')
        if len(op1)==2:#sub [sth+sth],reg
            if opsizetable.isin([op1[0]]).any().any() and opsizetable.isin([op1[1].split('*')[0]]).any().any():#sub [reg+reg*scale(or without scale)],reg
                bas=op1[0]
                inx=op1[1].split('*')[0]
                if len(op1[1].split('*'))==2:
                    ss=op1[1].split('*')[1]
                if (newreg.isin([bas]).any().any() or newreg.isin([inx]).any().any() or newreg.isin([op1]).any().any()) and len(op1[1].split('*'))==2:#sub [reg64+reg64*scale],reg64 or ...
                    opsize=operandsize(op2)
                    rex='0100'
                    rexw=prefixtable.loc[prefixtable['opsize']==opsize,'rexw'].iloc[0]  
                    rex+=rexw+'000'
                    opcode='0001100'
                    w+=wtable.loc[wtable['opsize']==opsize , 'w'].iloc[0]
                    mod=modtable.loc[modtable['disp']==8,'mod'].iloc[0]
                    regop=operandreg(op2)
                    rm='100'
                    scale=scaletable.loc[scaletable['zarib']==ss,'scale'].iloc[0]
                    base=operandreg(bas)
                    index=operandreg(inx)
                    displacement='00000000'
                    
                elif len(op1[1].split('*'))==2:#sub [oldreg+oldreg*scale],oldreg
                    opcode+='0010100'
                    opsize=operandsize(bas)
                    w+=wtable.loc[wtable['opsize']==opsize , 'w'].iloc[0]
                    prefix+=prefixtable.loc[prefixtable['adrsize']==opsize , '67'].iloc[0]
                    mod=modtable.loc[modtable['disp']==8,'mod'].iloc[0]
                    regop=operandreg(op2)
                    rm='100'
                    scale=scaletable.loc[scaletable['zarib']==ss,'scale'].iloc[0]
                    base=operandreg(bas)
                    index=operandreg(inx)
                    displacement='00000000'
                    
                    
                    
        if len(op1)==3:#sub [sth+sth+disp],reg
            bas=op1[0]
            inx=op1[1].split('*')[0]
            if len(op1[1].split('*'))==2:
                ss=op1[1].split('*')[1]
            if (newreg.isin([bas]).any().any() or newreg.isin([inx]).any().any() or newreg.isin([op1]).any().any()) and len(op1[1].split('*'))==2:#sub [reg64+reg64*scale],reg64 or ...
                disp=op1[2]
                disp=disp.replace('0x','')
                opsize=operandsize(op2)
                rex='0100'
                rexw=prefixtable.loc[prefixtable['opsize']==opsize,'rexw'].iloc[0]  
                rex+=rexw+'000'
                opcode='0001100'
                w+=wtable.loc[wtable['opsize']==opsize , 'w'].iloc[0]
                mod=modtable.loc[modtable['disp']==32,'mod'].iloc[0]
                regop=operandreg(op2)
                rm='100'
                scale=scaletable.loc[scaletable['zarib']==ss,'scale'].iloc[0]
                base=operandreg(bas)
                index=operandreg(inx)
                for i in range(len(disp),0,-2):
                    var=disp[i-2]+disp[i-1]
                    displacement+=hextobin(var)
                for i in range(8-len(disp)):
                    displacement+='0000'

    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[27]:


def inc(string):
    op=string[3:]
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    if opsizetable.isin([op]).any().any():#inc reg
        mod='11'
        if newreg.isin([op]).any().any():# inc newreg
            opsize=operandsize(op)
            prefix+=prefixtable.loc[prefixtable['opsize']==opsize , '66'].iloc[0]
            opcode+='1111111'
            rex+='0100'
            w+=wtable.loc[wtable['opsize']==opsize , 'w'].iloc[0]
            rexw=prefixtable.loc[prefixtable['opsize']==opsize,'rexw'].iloc[0]                
            rexr='0'
            rexx='0'
            rexb=operandrexrb(op)
            rex+=rexw+rexr+rexx+rexb
            regop='000'
            rm=operandreg(op)
            
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[28]:


def neg(string):
    op=string[3:]
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    if opsizetable.isin([op]).any().any():#inc reg
        mod='11'
        if newreg.isin([op]).any().any():# inc newreg
            opsize=operandsize(op)
            prefix+=prefixtable.loc[prefixtable['opsize']==opsize , '66'].iloc[0]
            opcode+='1111011'
            rex+='0100'
            w+=wtable.loc[wtable['opsize']==opsize , 'w'].iloc[0]
            rexw=prefixtable.loc[prefixtable['opsize']==opsize,'rexw'].iloc[0]                
            rexr='0'
            rexx='0'
            rexb=operandrexrb(op)
            rex+=rexw+rexr+rexx+rexb
            regop='011'
            rm=operandreg(op)
            
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[29]:


def notfunc(string):
    op=string[3:]
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    if opsizetable.isin([op]).any().any():#inc reg
        mod='11'
        if newreg.isin([op]).any().any():# inc newreg
            opsize=operandsize(op)
            prefix+=prefixtable.loc[prefixtable['opsize']==opsize , '66'].iloc[0]
            opcode+='1111011'
            rex+='0100'
            w+=wtable.loc[wtable['opsize']==opsize , 'w'].iloc[0]
            rexw=prefixtable.loc[prefixtable['opsize']==opsize,'rexw'].iloc[0]                
            rexr='0'
            rexx='0'
            rexb=operandrexrb(op)
            rex+=rexw+rexr+rexx+rexb
            regop='010'
            rm=operandreg(op)
            
    elif op.find('[')+1:
        op=op.split('[')
        opsize=memopsize(op[0])
        op=op[1].replace(']','')
        mod='00'
        if newreg.isin([op]).any().any():# inc newreg
            opsize=operandsize(op)
            prefix+=prefixtable.loc[prefixtable['opsize']==opsize , '66'].iloc[0]
            opcode+='1111011'
            rex+='0100'
            w+=wtable.loc[wtable['opsize']==opsize , 'w'].iloc[0]
            rexw=prefixtable.loc[prefixtable['opsize']==opsize,'rexw'].iloc[0]                
            rexr='0'
            rexx='0'
            rexb=operandrexrb(op)
            rex+=rexw+rexr+rexx+rexb
            regop='010'
            rm=operandreg(op)
    
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[30]:


def ret(string):
    op=string[3:]
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    if op=='':
        opcode+='11000011'
    else:
        opcode+='11000010'
        disp=int(op,10)
        disp=hex(disp)
        disp=str(disp)
        disp=disp.replace('0x','')
        if(len(disp)==1 or len(disp)==3):
            disp='0'+disp
        for i in range(len(disp),0,-2):
            var=disp[i-2]+disp[i-1]
            displacement+=hextobin(var)
        for i in range(4-len(disp)):
            displacement+='0000'
        
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[31]:


def push(string):
    op=string[4:]
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    if opsizetable.isin([op]).any().any():
        opcode+='01010'
        regop=operandreg(op)
        if newreg.isin([op]).any().any():
            opsize=operandsize(op)
            rex+='0100'
            rexw=prefixtable.loc[prefixtable['opsize']==opsize,'rexw'].iloc[0]
            rexr='0'
            rexx='0'
            rexb=operandrexrb(op)
            rex+=rexw+rexr+rexx+rexb
        
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[32]:


def pop(string):
    op=string[3:]
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    if opsizetable.isin([op]).any().any():
        opcode+='01011'
        regop=operandreg(op)
        if newreg.isin([op]).any().any():
            opsize=operandsize(op)
            rex+='0100'
            rexw=prefixtable.loc[prefixtable['opsize']==opsize,'rexw'].iloc[0]
            rexr='0'
            rexx='0'
            rexb=operandrexrb(op)
            rex+=rexw+rexr+rexx+rexb
        
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[33]:


def dec(string):
    op=string[3:]
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    
    if op.find('[')+1:
        op=op.split('[')
        opsize=memopsize(op[0])
        op=op[1].replace(']','')
        mod='00'
        if newreg.isin([op]).any().any():# inc newreg
            opsize=operandsize(op)
            prefix+=prefixtable.loc[prefixtable['opsize']==opsize , '66'].iloc[0]
            opcode+='1111011'
            rex+='0100'
            w+=wtable.loc[wtable['opsize']==opsize , 'w'].iloc[0]
            rexw=prefixtable.loc[prefixtable['opsize']==opsize,'rexw'].iloc[0]                
            rexr='0'
            rexx='0'
            rexb=operandrexrb(op)
            rex+=rexw+rexr+rexx+rexb
            regop='010'
            rm=operandreg(op)
            
        if op.find('0x')+1 and len(op.split('+'))==1:#dec xword[hexnumber]
            prefix+=prefixtable.loc[prefixtable['opsize']==opsize , '66'].iloc[0]
            opcode+='1111111'
            rex+='0100'
            w+=wtable.loc[wtable['opsize']==opsize , 'w'].iloc[0]
            rexw=prefixtable.loc[prefixtable['opsize']==opsize,'rexw'].iloc[0]                
            rexr='0'
            rexx='0'
            rexb='0'
            rex+=rexw+rexr+rexx+rexb
            mod='00'
            regop='001'
            rm='100'
            scale='00'
            index='100'
            base=operandreg('rbp')
            disp=op
            disp=disp.replace('0x','')
            for i in range(len(disp),0,-2):
                var=disp[i-2]+disp[i-1]
                displacement+=hextobin(var)
            for i in range(8-len(disp)):
                displacement+='0000'
            
    
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[34]:


def shl(string):
    op1endIndex=string.find(',')
    op1=string[3:op1endIndex]
    op2=string[op1endIndex+1:]
    prefix=''; rex=''; opcode=''; w=''; mod=''; regop='';
    rm=''; scale=''; index=''; base=''; displacement=''; data='';
    if op1.find('[')+1:
        op1=op1.split('[')
        opsize=memopsize(op1[0])
        op=op[1].replace(']','')
        mod+=modtable.loc[modtable['disp']==opsize,'mod'].iloc[0]
        
#         if not(opsizetable.isin([op2]).any().any()) and 
    
    return prefix+rex+opcode+w+mod+regop+rm+scale+index+base+displacement+data


# In[35]:


def jrcxz(string):
    return


# In[36]:


def andfunc(string):
    return


# In[37]:


def orfunc(string):
    return


# In[38]:


def shr(string):
    return


# In[39]:


def call(string):
    return


# ## Program Manager

# In[40]:


def progmanager(string):
    instructionLength=string.find(' ')
    if instructionLength==-1:
        instructionLength=len(string) #when we have 0 input instructions
    string=string.replace('ptr','')
    string=string.replace(' ','')
    a=instruction(string,instructionLength)
    i=0
    k=0
    while a[i]!='1':
        i+=1
    i=int(i/4)
    a=int(a,2)
    a= hex(a)
    a=str(a)
    a= a.replace('0x','')
    aa=''
    for j in range(i):
        aa+='0'
    a=aa+a
    return a


# ## Main

# In[41]:


result=progmanager(input())
print(result)

