{ Resolve static dependencies without msvcrt and other (Windows only)

  Copyright (C) 2021 Red_prig

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.
}

unit libaudio_static;

{$mode objfpc}{$H+}

interface

uses
 Windows,MMSystem,CTypes;

implementation

{$IFNDEF LS_NOT_chkstk_ms}
procedure ___chkstk_ms; cdecl; export;
begin
end;
{$ENDIF}

{$IFNDEF LS_NOT_assert}
procedure _assert(__assertion,__file,__line:PChar); cdecl; export;
Var
 lineno:longint;
 Error:word;
begin
 if Assigned(AssertErrorProc) then
 begin
  lineno:=0;
  Val(__line,lineno,Error);
  AssertErrorProc(__assertion,__file,lineno,get_caller_addr(get_frame));
 end;
end;

procedure __assert(__assertion,__file,__line:PChar); cdecl; export;
Var
 lineno:longint;
 Error:word;
begin
 if Assigned(AssertErrorProc) then
 begin
  lineno:=0;
  Val(__line,lineno,Error);
  AssertErrorProc(__assertion,__file,lineno,get_caller_addr(get_frame));
 end;
end;
{$ENDIF}

{$IFNDEF LS_NOT_memset}
function memset(ptr:Pointer;value:cint;num:size_t):Pointer; cdecl; export;
begin
 Result:=ptr;
 FillChar(ptr^,num,byte(value));
end;

function _memset(ptr:Pointer;value:cint;num:size_t):Pointer; cdecl; export;
begin
 Result:=ptr;
 FillChar(ptr^,num,byte(value));
end;
{$ENDIF}

{$IFNDEF LS_NOT_memcpy}
function _memcpy(dst,src:Pointer;len:size_t):Pointer; cdecl; export;
begin
 Result:=dst;
 Move(src^,dst^,len);
end;

function memcpy(dst,src:Pointer;len:size_t):Pointer; cdecl; export;
begin
 Result:=dst;
 Move(src^,dst^,len);
end;
{$ENDIF}

{$IFNDEF LS_NOT_memchr}
function memchr(memptr:Pointer;val:cint;num:size_t):Pointer; cdecl; export;
var
 i:SizeInt;
begin
 Result:=nil;
 i:=System.IndexByte(memptr^,num,Byte(val));
 if (i<>-1) then
  Result:=memptr+i;
end;

function _memchr(memptr:Pointer;val:cint;num:size_t):Pointer; cdecl; export;
var
 i:SizeInt;
begin
 Result:=nil;
 i:=System.IndexByte(memptr^,num,Byte(val));
 if (i<>-1) then
  Result:=memptr+i;
end;
{$ENDIF}

{$IFNDEF LS_NOT_memmove}
function memmove(dst,src:Pointer;num:size_t):Pointer; cdecl; export;
begin
 Result:=dst;
 Move(src^,dst^,num);
end;

function _memmove(dst,src:Pointer;num:size_t):Pointer; cdecl; export;
begin
 Result:=dst;
 Move(src^,dst^,num);
end;
{$ENDIF}

{$IFNDEF LS_NOT_memcmp}
function memcmp(buf1,buf2:Pointer;count:size_t):cint; cdecl; export;
begin
 Result:=CompareByte(buf1^,buf2^,count);
end;

function _memcmp(buf1,buf2:Pointer;count:size_t):cint; cdecl; export;
begin
 Result:=CompareByte(buf1^,buf2^,count);
end;
{$ENDIF}

{$IFNDEF LS_NOT_strncpy}
function strncpy(destptr,srcptr:PChar;num:size_t):PChar; cdecl; export;
var
 count:size_t;
begin
 count:=System.strlen(srcptr);
 if (num>count) then
  count:=count+1
 else
  count:=num;
 Move(srcptr^,destptr^,count);
 Result:=destptr;
end;

function _strncpy(destptr,srcptr:PChar;num:size_t):PChar; cdecl; export;
var
 count:size_t;
begin
 count:=System.strlen(srcptr);
 if (num>count) then
  count:=count+1
 else
  count:=num;
 Move(srcptr^,destptr^,count);
 Result:=destptr;
end;
{$ENDIF}

{$IFNDEF LS_NOT_strcpy}
function strcpy(destptr,srcptr:PChar):PChar; cdecl; export;
var
 count:size_t;
begin
 count:=System.strlen(srcptr)+1;
 Move(srcptr^,destptr^,count);
 Result:=destptr;
end;

function _strcpy(destptr,srcptr:PChar):PChar; cdecl; export;
var
 count:size_t;
begin
 count:=System.strlen(srcptr)+1;
 Move(srcptr^,destptr^,count);
 Result:=destptr;
end;
{$ENDIF}

{$IFNDEF LS_NOT_strlen}
function strlen(P:PChar):size_t; cdecl; export;
begin
 Result:=System.strlen(P);
end;

function _strlen(P:PChar):size_t; cdecl; export;
begin
 Result:=System.strlen(P);
end;
{$ENDIF}

{$IFNDEF LS_NOT_atoi}
function atoi(str:PChar):cint; cdecl; export;
var
 Code:Integer;
begin
 Result:=0;
 Val(str,Result,Code);
end;

function _atoi(str:PChar):cint; cdecl; export;
var
 Code:Integer;
begin
 Result:=0;
 Val(str,Result,Code);
end;
{$ENDIF}

{$IFNDEF LS_NOT_atof}
function atof(str:PChar):double; cdecl; export;
var
 Code:Integer;
begin
 Result:=0;
 Val(str,Result,Code);
end;

function _atof(str:PChar):double; cdecl; export;
var
 Code:Integer;
begin
 Result:=0;
 Val(str,Result,Code);
end;
{$ENDIF}

{$IFNDEF LS_NOT_strchr}
function strchr(str:PChar;c:cint):PChar; cdecl; export;
begin
Result:=nil;
if (str<>nil) then
 While (str^<>#0) do
 begin
  if (ord(str^)=c) then Exit(str);
  Inc(str);
 end;
end;

function _strchr(str:PChar;c:cint):PChar; cdecl; export;
begin
Result:=nil;
if (str<>nil) then
 While (str^<>#0) do
 begin
  if (ord(str^)=c) then Exit(str);
  Inc(str);
 end;
end;
{$ENDIF}

{$IFNDEF LS_NOT_strrchr}
function strrchr(str:PChar;c:cint):PChar; cdecl; export;
Begin
 Result:=nil;
 if (str<>nil) then
  While (str^<>#0) do
  begin
   if (ord(str^)=c) then Result:=str;
   Inc(str);
  end;
End;

function _strrchr(str:PChar;c:cint):PChar; cdecl; export;
Begin
 Result:=nil;
 if (str<>nil) then
  While (str^<>#0) do
  begin
   if (ord(str^)=c) then Result:=str;
   Inc(str);
  end;
End;
{$ENDIF}

{$IFNDEF LS_NOT_strcmp}
function strcmp(str1,str2:PChar):cint; cdecl; export;
begin
 Result:=0;
 if (str1=nil) or (str2=nil) then Exit;
 while (str1^<>#0) and (str2^<>#0) do
 begin
  if (str1^>str2^) then
   Exit(1)
  else
  if (str1^<str2^) then
   Exit(-1);
  Inc(str1);
  Inc(str2);
 end;
end;

function _strcmp(str1,str2:PChar):cint; cdecl; export;
begin
 Result:=0;
 if (str1=nil) or (str2=nil) then Exit;
 while (str1^<>#0) and (str2^<>#0) do
 begin
  if (str1^>str2^) then
   Exit(1)
  else
  if (str1^<str2^) then
   Exit(-1);
  Inc(str1);
  Inc(str2);
 end;
end;
{$ENDIF}

function stricmp(str1,str2:PChar):cint; cdecl; {$IFNDEF LS_NOT_stricmp} export; {$ENDIF}
begin
 Result:=0;
 if (str1=nil) or (str2=nil) then Exit;
 while (str1^<>#0) and (str2^<>#0) do
 begin
  if (LowerCase(str1^)>LowerCase(str2^)) then
   Exit(1)
  else
  if (LowerCase(str1^)<LowerCase(str2^)) then
   Exit(-1);
  Inc(str1);
  Inc(str2);
 end;
end;

function _stricmp(str1,str2:PChar):cint; cdecl; {$IFNDEF LS_NOT_stricmp} export; {$ENDIF}
begin
 Result:=0;
 if (str1=nil) or (str2=nil) then Exit;
 while (str1^<>#0) and (str2^<>#0) do
 begin
  if (str1^>str2^) then
   Exit(1)
  else
  if (str1^<str2^) then
   Exit(-1);
  Inc(str1);
  Inc(str2);
 end;
end;

{$IFNDEF LS_NOT_strncmp}
function strncmp(str1,str2:PChar;num:size_t):cint; cdecl; export;
begin
 Result:=0;
 if (str1=nil) or (str2=nil) then Exit;
 while (str1^<>#0) and (str2^<>#0) and (num<>0) do
 begin
  if (str1^>str2^) then
   Exit(1)
  else
  if (str1^<str2^) then
   Exit(-1);
  Inc(str1);
  Inc(str2);
  Dec(num);
 end;
end;

function _strncmp(str1,str2:PChar;num:size_t):cint; cdecl; export;
begin
 Result:=0;
 if (str1=nil) or (str2=nil) then Exit;
 while (str1^<>#0) and (str2^<>#0) and (num<>0) do
 begin
  if (str1^>str2^) then
   Exit(1)
  else
  if (str1^<str2^) then
   Exit(-1);
  Inc(str1);
  Inc(str2);
  Dec(num);
 end;
end;
{$ENDIF}

function strnicmp(str1,str2:PChar;num:size_t):cint; cdecl;
begin
 Result:=0;
 if (str1=nil) or (str2=nil) then Exit;
 while (str1^<>#0) and (str2^<>#0) and (num<>0) do
 begin
  if (LowerCase(str1^)>LowerCase(str2^)) then
   Exit(1)
  else
  if (LowerCase(str1^)<LowerCase(str2^)) then
   Exit(-1);
  Inc(str1);
  Inc(str2);
  Dec(num);
 end;
end;

{$IFNDEF LS_NOT_strstr}
function strstr(haystack,needle:PChar):PChar; cdecl; export;
var
 i:Integer;
begin
 Result:=nil;
 i:=Pos(needle,haystack);
 if (i<>0) then
  Result:=@haystack[i-1];
end;

function _strstr(haystack,needle:PChar):PChar; cdecl; export;
var
 i:Integer;
begin
 Result:=nil;
 i:=Pos(needle,haystack);
 if (i<>0) then
  Result:=@haystack[i-1];
end;
{$ENDIF}

{$IFNDEF LS_NOT_strtol}
function strtol(str,endptr:PChar;base:cint):clong; cdecl; export; {$ifdef WIN32} [alias: '_strtol']; {$endif}
var
 s:longint;
begin
 Result:=0;
 if (str=nil) or (endptr=nil) then Exit;
 s:=1;
 while (str^<>#0) and (str<endptr) do
 begin
  case str^ of
   '-':s:=-s;
   '+':;
   '0'..'9':Result:=(result*base)+(byte(ansichar(str^))-byte(ansichar('0')));
   'a'..'z':Result:=(result*base)+((byte(ansichar(str^))-byte(ansichar('a')))+$a);
   'A'..'Z':Result:=(result*base)+((byte(ansichar(str^))-byte(ansichar('A')))+$a);
  end;
  inc(str^);
 end;
end;
{$ENDIF}

{$IFNDEF LS_NOT_strncat}
function strncat(dest,src:PChar;n:size_t):PChar; cdecl; export;
var
 d,s:size_t;
begin
 if (dest=nil) or (src=nil) then Exit(nil);
 d:=System.StrLen(dest);
 s:=System.StrLen(src)+1;
 if s>n then s:=n;
 Move(src^,dest[d],s);
 Result:=dest;
end;

function _strncat(dest,src:PChar;n:size_t):PChar; cdecl; export;
var
 d,s:size_t;
begin
 if (dest=nil) or (src=nil) then Exit(nil);
 d:=System.StrLen(dest);
 s:=System.StrLen(src)+1;
 if s>n then s:=n;
 Move(src^,dest[d],s);
 Result:=dest;
end;
{$ENDIF}

{$IFNDEF LS_NOT___strtod}
function __strtod(s,endptr:PChar):double; cdecl; export;
var
 t:RawByteString;
 Error:word;
begin
 t:=s;
 if Assigned(endptr) then
 begin
  SetLength(t,endptr-s);
 end;
 Result:=0;
 val(t,Result,Error);
end;

function ___strtod(s,endptr:PChar):double; cdecl; export;
var
 t:RawByteString;
 Error:word;
begin
 t:=s;
 if Assigned(endptr) then
 begin
  SetLength(t,endptr-s);
 end;
 Result:=0;
 val(t,Result,Error);
end;
{$ENDIF}

function _beginthreadex(security:Pointer;
                        stack_size:cuint;
                        tthreadfunc:tthreadfunc;
                        arglist:Pointer;
                        initflag:cuint;
                        thrdaddr:Pcuint):PtrUint; stdcall;
Var
 I:TThreadID;
begin
 Result:=System.BeginThread(security,stack_size,tthreadfunc,arglist,initflag,I);
 if thrdaddr<>nil then thrdaddr^:=I;
end;

function  GetFileSizeEx(hFile:HANDLE;pFileSize:PLARGE_INTEGER):BOOL; external 'kernel32' name 'GetFileSizeEx';
function  SetFilePointerEx(hFile:HANDLE;
                           liDistanceToMove:LARGE_INTEGER;
                           lpNewFilePointer:PLARGE_INTEGER;
                           dwMoveMethod:DWORD):DWORD; stdcall; external 'kernel32' name 'SetFilePointerEx';
function  GetTimeZoneInformation(var lpTimeZoneInformation: TTimeZoneInformation): DWORD; stdcall; external 'kernel32' name 'GetTimeZoneInformation';
procedure GetSystemTimeAsFileTime(var lpSystemTimeAsFileTime:TFILETIME); stdcall; external 'kernel32' name 'GetSystemTimeAsFileTime';
procedure InitializeCriticalSection(var CriticalSection : TRTLCriticalSection); stdcall; external 'kernel32' name 'InitializeCriticalSection';
procedure EnterCriticalSection(var CriticalSection : TRTLCriticalSection); stdcall; external 'kernel32' name 'EnterCriticalSection';
procedure LeaveCriticalSection(var CriticalSection : TRTLCriticalSection); stdcall; external 'kernel32' name 'LeaveCriticalSection';
procedure DeleteCriticalSection(var CriticalSection : TRTLCriticalSection); stdcall; external 'kernel32' name 'DeleteCriticalSection';
function  GetModuleHandleW(lpModuleName:LPCWSTR):HMODULE; stdcall; external 'kernel32' name 'GetModuleHandleW';

function  QueryPerformanceCounter(var lpPerformanceCount:TLargeInteger):BOOL; stdcall; external 'kernel32' name 'QueryPerformanceCounter';
function  QueryPerformanceFrequency(var lpFrequency:TLargeInteger):BOOL;      stdcall; external 'kernel32' name 'QueryPerformanceFrequency';
function  GetVersionExA(var lpVersionInformation:TOSVersionInfo):BOOL;        stdcall; external 'kernel32' name 'GetVersionExA';

const
 {$IFNDEF LS_NOT___imp__beginthreadex}
  __imp__beginthreadex:Pointer=(@_beginthreadex); export;
 __imp___beginthreadex:Pointer=(@_beginthreadex); export;
 {$ENDIF}

{$IFNDEF LS_NOT_imp_winkernel}
 __imp_GlobalAlloc              :Pointer=(@Windows.GlobalAlloc            ); export {$ifdef WIN32} name '__imp__GlobalAlloc@8'               {$endif};
 __imp_GlobalFree               :Pointer=(@Windows.GlobalFree             ); export {$ifdef WIN32} name '__imp__GlobalFree@4'                {$endif};
 __imp_Sleep                    :Pointer=(@Windows.Sleep                  ); export {$ifdef WIN32} name '__imp__Sleep@4'                     {$endif};
 __imp_QueryPerformanceFrequency:Pointer=(@QueryPerformanceFrequency      ); export {$ifdef WIN32} name '__imp__QueryPerformanceFrequency@4' {$endif};
 __imp_QueryPerformanceCounter  :Pointer=(@QueryPerformanceCounter        ); export {$ifdef WIN32} name '__imp__QueryPerformanceCounter@4'   {$endif};
 __imp_FormatMessageA           :Pointer=(@Windows.FormatMessageA         ); export {$ifdef WIN32} name '__imp__FormatMessageA@28'           {$endif};
 __imp_LocalFree                :Pointer=(@Windows.LocalFree              ); export {$ifdef WIN32} name '__imp__LocalFree@4'                 {$endif};
 __imp_SetEvent                 :Pointer=(@Windows.SetEvent               ); export {$ifdef WIN32} name '__imp__SetEvent@4'                  {$endif};
 __imp_WaitForSingleObject      :Pointer=(@Windows.WaitForSingleObject    ); export {$ifdef WIN32} name '__imp__WaitForSingleObject@8'       {$endif};
 __imp_CloseHandle              :Pointer=(@Windows.CloseHandle            ); export {$ifdef WIN32} name '__imp__CloseHandle@4'               {$endif};
 __imp_ResetEvent               :Pointer=(@Windows.ResetEvent             ); export {$ifdef WIN32} name '__imp__ResetEvent@4'                {$endif};
 __imp_SetThreadPriority        :Pointer=(@Windows.SetThreadPriority      ); export {$ifdef WIN32} name '__imp__SetThreadPriority@8'         {$endif};
 __imp_GetLastError             :Pointer=(@Windows.GetLastError           ); export {$ifdef WIN32} name '__imp__GetLastError@0'              {$endif};
 __imp_WaitForMultipleObjects   :Pointer=(@Windows.WaitForMultipleObjects ); export {$ifdef WIN32} name '__imp__WaitForMultipleObjects@16'   {$endif};
 __imp_CreateEventA             :Pointer=(@Windows.CreateEventA           ); export {$ifdef WIN32} name '__imp__CreateEventA@16'             {$endif};
 __imp_GetVersionExA            :Pointer=(@GetVersionExA                  ); export {$ifdef WIN32} name '__imp__GetVersionExA@4'             {$endif};
 __imp_GetEnvironmentVariableA  :Pointer=(@Windows.GetEnvironmentVariableA); export {$ifdef WIN32} name '__imp__GetEnvironmentVariableA@12'  {$endif};

 __imp_CreateFileW              :Pointer=(@Windows.CreateFileW);             export {$ifdef WIN32} name '__imp__CreateFileW@28'              {$endif};
 __imp_CreateFileA              :Pointer=(@Windows.CreateFileA);             export {$ifdef WIN32} name '__imp__CreateFileA@28'              {$endif};
 __imp_GetFileSizeEx            :Pointer=(@GetFileSizeEx);                   export {$ifdef WIN32} name '__imp__GetFileSizeEx@8'             {$endif};
 __imp_GetStdHandle             :Pointer=(@Windows.GetStdHandle);            export {$ifdef WIN32} name '__imp__GetStdHandle@4'              {$endif};
 __imp_SetFilePointerEx         :Pointer=(@SetFilePointerEx);                export {$ifdef WIN32} name '__imp__SetFilePointerEx@20'         {$endif};
 __imp_ReadFile                 :Pointer=(@Windows.ReadFile);                export {$ifdef WIN32} name '__imp__ReadFile@20'                 {$endif};
 __imp_WriteFile                :Pointer=(@Windows.WriteFile);               export {$ifdef WIN32} name '__imp__WriteFile@20'                {$endif};
 __imp_GetFileType              :Pointer=(@Windows.GetFileType);             export {$ifdef WIN32} name '__imp__GetFileType@4'               {$endif};
 __imp_FlushFileBuffers         :Pointer=(@Windows.FlushFileBuffers);        export {$ifdef WIN32} name '__imp__FlushFileBuffers@4'          {$endif};
 __imp_SetEndOfFile             :Pointer=(@Windows.SetEndOfFile);            export {$ifdef WIN32} name '__imp__SetEndOfFile@4'              {$endif};
 __imp_MultiByteToWideChar      :Pointer=(@Windows.MultiByteToWideChar);     export {$ifdef WIN32} name '__imp__MultiByteToWideChar@24'      {$endif};
 __imp_GetTimeZoneInformation   :Pointer=(@GetTimeZoneInformation);          export {$ifdef WIN32} name '__imp__GetTimeZoneInformation@4'    {$endif};
 __imp_GetSystemTimeAsFileTime  :Pointer=(@GetSystemTimeAsFileTime);         export {$ifdef WIN32} name '__imp__GetSystemTimeAsFileTime@4'   {$endif};
 __imp_IsDBCSLeadByteEx         :Pointer=(@Windows.IsDBCSLeadByteEx);        export {$ifdef WIN32} name '__imp__IsDBCSLeadByteEx@8'          {$endif};
 __imp_WideCharToMultiByte      :Pointer=(@Windows.WideCharToMultiByte);     export {$ifdef WIN32} name '__imp__WideCharToMultiByte@32'      {$endif};
 __imp_InitializeCriticalSection:Pointer=(@InitializeCriticalSection);       export {$ifdef WIN32} name '__imp__InitializeCriticalSection@4' {$endif};
 __imp_EnterCriticalSection     :Pointer=(@EnterCriticalSection);            export {$ifdef WIN32} name '__imp__EnterCriticalSection@4'      {$endif};
 __imp_DeleteCriticalSection    :Pointer=(@DeleteCriticalSection);           export {$ifdef WIN32} name '__imp__DeleteCriticalSection@4'     {$endif};
 __imp_LeaveCriticalSection     :Pointer=(@LeaveCriticalSection);            export {$ifdef WIN32} name '__imp__LeaveCriticalSection@4'      {$endif};
 __imp_GetModuleHandleW         :Pointer=(@Windows.GetModuleHandleW);        export {$ifdef WIN32} name '__imp__GetModuleHandleW@4'          {$endif};
 __imp_GetProcAddress           :Pointer=(@Windows.GetProcAddress);          export {$ifdef WIN32} name '__imp__GetProcAddress@8'            {$endif};
{$ENDIF}

{$IFNDEF LS_NOT_imp_winmm}
 __imp_timeGetTime              :Pointer=(@MMSystem.timeGetTime           ); export {$ifdef WIN32} name '__imp__timeGetTime@0'               {$endif};
 __imp_waveOutWrite             :Pointer=(@MMSystem.waveOutWrite          ); export {$ifdef WIN32} name '__imp__waveOutWrite@12'             {$endif};
 __imp_waveOutGetErrorTextA     :Pointer=(@MMSystem.waveOutGetErrorTextA  ); export {$ifdef WIN32} name '__imp__waveOutGetErrorTextA@12'     {$endif};
 __imp_waveInAddBuffer          :Pointer=(@MMSystem.waveInAddBuffer       ); export {$ifdef WIN32} name '__imp__waveInAddBuffer@12'          {$endif};
 __imp_waveInGetErrorTextA      :Pointer=(@MMSystem.waveInGetErrorTextA   ); export {$ifdef WIN32} name '__imp__waveInGetErrorTextA@12'      {$endif};
 __imp_waveOutReset             :Pointer=(@MMSystem.waveOutReset          ); export {$ifdef WIN32} name '__imp__waveOutReset@4'              {$endif};
 __imp_waveInReset              :Pointer=(@MMSystem.waveInReset           ); export {$ifdef WIN32} name '__imp__waveInReset@4'               {$endif};
 __imp_waveInPrepareHeader      :Pointer=(@MMSystem.waveInPrepareHeader   ); export {$ifdef WIN32} name '__imp__waveInPrepareHeader@12'      {$endif};
 __imp_waveOutPrepareHeader     :Pointer=(@MMSystem.waveOutPrepareHeader  ); export {$ifdef WIN32} name '__imp__waveOutPrepareHeader@12'     {$endif};
 __imp_waveInUnprepareHeader    :Pointer=(@MMSystem.waveInUnprepareHeader ); export {$ifdef WIN32} name '__imp__waveInUnprepareHeader@12'    {$endif};
 __imp_waveOutUnprepareHeader   :Pointer=(@MMSystem.waveOutUnprepareHeader); export {$ifdef WIN32} name '__imp__waveOutUnprepareHeader@12'   {$endif};
 __imp_waveOutGetDevCapsA       :Pointer=(@MMSystem.waveOutGetDevCapsA    ); export {$ifdef WIN32} name '__imp__waveOutGetDevCapsA@12'       {$endif};
 __imp_waveOutOpen              :Pointer=(@MMSystem.waveOutOpen           ); export {$ifdef WIN32} name '__imp__waveOutOpen@24'              {$endif};
 __imp_waveInGetDevCapsA        :Pointer=(@MMSystem.waveInGetDevCapsA     ); export {$ifdef WIN32} name '__imp__waveInGetDevCapsA@12'        {$endif};
 __imp_waveInOpen               :Pointer=(@MMSystem.waveInOpen            ); export {$ifdef WIN32} name '__imp__waveInOpen@24'               {$endif};
 __imp_waveOutPause             :Pointer=(@MMSystem.waveOutPause          ); export {$ifdef WIN32} name '__imp__waveOutPause@4'              {$endif};
 __imp_waveInStart              :Pointer=(@MMSystem.waveInStart           ); export {$ifdef WIN32} name '__imp__waveInStart@4'               {$endif};
 __imp_waveOutRestart           :Pointer=(@MMSystem.waveOutRestart        ); export {$ifdef WIN32} name '__imp__waveOutRestart@4'            {$endif};
 __imp_waveOutGetPosition       :Pointer=(@MMSystem.waveOutGetPosition    ); export {$ifdef WIN32} name '__imp__waveOutGetPosition@12'       {$endif};
 __imp_waveOutClose             :Pointer=(@MMSystem.waveOutClose          ); export {$ifdef WIN32} name '__imp__waveOutClose@4'              {$endif};
 __imp_waveInClose              :Pointer=(@MMSystem.waveInClose           ); export {$ifdef WIN32} name '__imp__waveInClose@4'               {$endif};
 __imp_waveInMessage            :Pointer=(@MMSystem.waveInMessage         ); export {$ifdef WIN32} name '__imp__waveInMessage@16'            {$endif};
 __imp_waveOutMessage           :Pointer=(@MMSystem.waveOutMessage        ); export {$ifdef WIN32} name '__imp__waveOutMessage@16'           {$endif};
 __imp_waveInGetNumDevs         :Pointer=(@MMSystem.waveInGetNumDevs      ); export {$ifdef WIN32} name '__imp__waveInGetNumDevs@0'          {$endif};
 __imp_waveOutGetNumDevs        :Pointer=(@MMSystem.waveOutGetNumDevs     ); export {$ifdef WIN32} name '__imp__waveOutGetNumDevs@0'         {$endif};
{$ENDIF}

{$ifdef WIN32}
{$IFNDEF LS_NOT_divdi3}
function ___divdi3(a,b:cint64):cint64; cdecl; export;
begin
 if (b=0) then Exit(0);
 Result:=a div b;
end;
{$endif}

{$IFNDEF LS_NOT_moddi3}
function ___moddi3(a,b:cint64):cint64; cdecl; export;
begin
 if (b=0) then Exit(0);
 Result:=a mod b;
end;
{$endif}

{$IFNDEF LS_NOT_udivdi3}
function ___udivdi3(a,b:cuint64):cuint64; cdecl; export;
begin
 if (b=0) then Exit(0);
 Result:=a div b;
end;
{$endif}

{$IFNDEF LS_NOT_umoddi3}
function ___umoddi3(a,b:cuint64):cuint64; cdecl; export;
begin
 if (b=0) then Exit(0);
 Result:=a mod b;
end;
{$endif}
{$endif}

{$IFNDEF LS_NOT_mingw_raise_matherr}
procedure __mingw_raise_matherr(typ:longint;name:pansichar;a1,a2,rslt:double); cdecl; export; {$ifdef WIN32} [alias: '___mingw_raise_matherr']; {$endif}
begin
 System.Error(reInvalidOp);
end;
{$endif}

{$IFNDEF LS_NOT_atexit}
function atexit(P:TProcedure):cint; cdecl; export; {$ifdef WIN32} [alias: '_atexit']; {$endif}
begin
 Result:=0;
 System.AddExitProc(P);
end;
{$endif}

{$IFNDEF LS_NOT_CMEM}
{$IFDEF USE_CMEM}
function __calloc(nelem,elsize:size_t):Pointer; cdecl; export; alias:'calloc';
begin
 Result:=CAlloc(nelem,elsize);
end;

function _calloc(nelem,elsize:size_t):Pointer; cdecl; export;
begin
 Result:=CAlloc(nelem,elsize);
end;

procedure __free(P:Pointer); cdecl; export; alias:'free';
begin
 Free(P);
end;

procedure _free(P:Pointer); cdecl; export;
begin
 Free(P);
end;

function __malloc(size:size_t):Pointer; cdecl; export; alias:'malloc';
begin
 Result:=malloc(size);
end;

function _malloc(size:size_t):Pointer; cdecl; export;
begin
 Result:=malloc(size);
end;

function __realloc(ptr:Pointer;newsize:size_t):Pointer; cdecl; export; alias:'realloc';
begin
 Result:=realloc(ptr,newsize);
end;

function _realloc(ptr:Pointer;newsize:size_t):Pointer; cdecl; export;
begin
 Result:=realloc(ptr,newsize);
end;

{$ELSE}
function calloc(nelem,elsize:size_t):Pointer; cdecl; export;
begin
 Result:=AllocMem(nelem*elsize);
end;

function _calloc(nelem,elsize:size_t):Pointer; cdecl; export;
begin
 Result:=AllocMem(nelem*elsize);
end;

procedure free(P:Pointer); cdecl; export;
begin
 FreeMem(P);
end;

procedure _free(P:Pointer); cdecl; export;
begin
 FreeMem(P);
end;

function malloc(size:size_t):Pointer; cdecl; export;
begin
 Result:=GetMem(size);
end;

function _malloc(size:size_t):Pointer; cdecl; export;
begin
 Result:=GetMem(size);
end;

function realloc(ptr:Pointer;newsize:size_t):Pointer; cdecl; export;
begin
 Result:=ReAllocMem(ptr,newsize);
end;

function _realloc(ptr:Pointer;newsize:size_t):Pointer; cdecl; export;
begin
 Result:=ReAllocMem(ptr,newsize);
end;
{$ENDIF}
{$ELSE}
function _malloc(size:size_t):Pointer; cdecl; external name 'malloc';
{$ENDIF}

{$IFNDEF LS_NOT_qsort}

{$I qsort.inc}

Procedure _qsort(pbase:Pointer;total_elems,size:size_t;cmp:Tqsort_comparator); cdecl; export;
begin
 qsort(pbase,total_elems,size,cmp);
end;

{$ENDIF}

{$IFNDEF LS_NOT_strdup}
function strdup(s:PChar):PChar; cdecl; export;
var
 l:size_t;
begin
 if (s=nil) then Exit(nil);
 l:=System.StrLen(s)+1;
 Result:=_malloc(l);
 Move(s^,Result^,l);
end;

function _strdup(s:PChar):PChar; cdecl; export;
var
 l:size_t;
begin
 if (s=nil) then Exit(nil);
 l:=System.StrLen(s)+1;
 Result:=_malloc(l);
 Move(s^,Result^,l);
end;
{$ENDIF}

{$IFNDEF LS_NOT_abort}
procedure abort; cdecl; export;
begin
 System.Halt;
end;

procedure _abort; cdecl; export;
begin
 System.Halt;
end;
{$endif}

{$IFNDEF LS_NOT_exit}
procedure __exit(status:cint); cdecl; export; [alias: 'exit'];
begin
 System.Halt(status);
end;

procedure ___exit(status:cint); cdecl; export; [alias: '_exit'];
begin
 System.Halt(status);
end;
{$endif}

{$IFNDEF LS_NOT_mingw_vsnprintf}
function __mingw_vsnprintf(d:PChar;n:size_t;format:PChar;arg:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;

function ___mingw_vsnprintf(d:PChar;n:size_t;format:PChar;arg:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;
{$endif}

{$IFNDEF LS_NOT_mingw_vprintf}
function __mingw_vprintf(format:PChar;arg_ptr:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;

function ___mingw_vprintf(format:PChar;arg_ptr:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;
{$endif}

{$IFNDEF LS_NOT_mingw_vfprintf}
function __mingw_vfprintf(stream:Pointer;format:PChar;arg_ptr:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;

function ___mingw_vfprintf(stream:Pointer;format:PChar;arg_ptr:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;
{$endif}

{$IFNDEF LS_NOT_mingw_vsscanf}
function __mingw_vsscanf(buf,format:PChar;arg_ptr:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;

function ___mingw_vsscanf(buf,format:PChar;arg_ptr:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;
{$endif}

{$IFNDEF LS_NOT_sscanf}
function sscanf(s,format:PChar;arg_ptr:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;

function _sscanf(s,format:PChar;arg_ptr:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;
{$endif}

{$IFNDEF LS_NOT_printf}
function printf(format:PChar;arg:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;

function _printf(format:PChar;arg:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;
{$endif}

{$IFNDEF LS_NOT_fprintf}
function fprintf(stream:Pointer;format:PChar;arg_ptr:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;

function _fprintf(stream:Pointer;format:PChar;arg_ptr:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;
{$ENDIF}

{$IFNDEF LS_NOT_log10}
function log10(x:double):double; cdecl; export;
begin
 Result:=System.ln(x)*0.43429448190325182765;
end;

function _log10(x:double):double; cdecl; export;
begin
 Result:=System.ln(x)*0.43429448190325182765;
end;
{$ENDIF}

{$IFNDEF LS_NOT_atan}
function atan(x:double):double; cdecl; export;
begin
 Result:=System.ArcTan(x);
end;

function _atan(x:double):double; cdecl; export;
begin
 Result:=System.ArcTan(x);
end;
{$ENDIF}

{$IFNDEF LS_NOT_tan}
function tan(x:double):double; cdecl; export;
begin
 Result:=System.Sin(x)/System.Cos(x);
end;

function _tan(x:double):double; cdecl; export;
begin
 Result:=System.Sin(x)/System.Cos(x);
end;
{$ENDIF}

{$IFNDEF LS_NOT_acos}
function acos(x:double):double; cdecl; export;
begin
 Result:=System.ArcTan(System.sqrt((1-x)*(1+x))/x);
end;

function _acos(x:double):double; cdecl; export;
begin
 Result:=System.ArcTan(System.sqrt((1-x)*(1+x))/x);
end;
{$ENDIF}

{$IFNDEF LS_NOT_lrintf}
function lrintf(arg:Single):clong; cdecl; export;
begin
 Result:=Round(arg);
end;

function _lrintf(arg:Single):clong; cdecl; export;
begin
 Result:=Round(arg);
end;
{$ENDIF}

{$IFNDEF LS_NOT_lrint}
function lrint(arg:Double):clong; cdecl; export;
begin
 Result:=Round(arg);
end;

function _lrint(arg:Double):clong; cdecl; export;
begin
 Result:=Round(arg);
end;
{$ENDIF}

{$IFNDEF LS_NOT_floor}
function floor(num:double):double; cdecl; export;
begin
 Result:=Trunc(num)-ord(Frac(num)<0);
end;

function _floor(num:double):double; cdecl; export;
begin
 Result:=Trunc(num)-ord(Frac(num)<0);
end;
{$ENDIF}

function intpower(base:double;const exponent:Integer):double;
var
 i:longint;
begin
 if (base=0.0) and (exponent=0) then
   result:=1
 else
 begin
  if exponent<0 then
    base:=1.0/base;
  i:=abs(exponent);
  intpower:=1.0;
  while i>0 do
  begin
   while (i and 1)=0 do
   begin
    i:=i shr 1;
    base:=sqr(base);
   end;
   i:=i-1;
   intpower:=intpower*base;
  end;
 end;
end;

{$IFNDEF LS_NOT_pow}
function pow(base,Exponent:double):double; cdecl; export;
begin
 if Exponent=0.0 then
   result:=1.0
 else if (base=0.0) and (exponent>0.0) then
   result:=0.0
 else if (abs(exponent)<=maxint) and (frac(exponent)=0.0) then
   result:=intpower(base,trunc(exponent))
 else
   result:=exp(exponent * ln (base));
end;

function _pow(base,Exponent:double):double; cdecl; export;
begin
 if Exponent=0.0 then
   result:=1.0
 else if (base=0.0) and (exponent>0.0) then
   result:=0.0
 else if (abs(exponent)<=maxint) and (frac(exponent)=0.0) then
   result:=intpower(base,trunc(exponent))
 else
   result:=exp(exponent * ln (base));
end;
{$ENDIF}

{$IFNDEF LS_NOT_log}
function log(agl:double):double; cdecl; export;
begin
 Result:=System.Ln(agl);
end;

function _log(agl:double):double; cdecl; export;
begin
 Result:=System.Ln(agl);
end;
{$ENDIF}

{$IFNDEF LS_NOT_cos}
function cos(agl:double):double; cdecl; export;
begin
 Result:=System.Cos(agl);
end;

function _cos(agl:double):double; cdecl; export;
begin
 Result:=System.Cos(agl);
end;
{$ENDIF}

{$IFNDEF LS_NOT_sin}
function sin(agl:double):double; cdecl; export;
begin
 Result:=System.Sin(agl);
end;

function _sin(agl:double):double; cdecl; export;
begin
 Result:=System.Sin(agl);
end;
{$ENDIF}

{$IFNDEF LS_NOT_ldexp}
function ldexp(x:double;exp:cint):double; cdecl; export;
begin
 Result:=x*intpower(2.0,exp);
end;

function _ldexp(x:double;exp:cint):double; cdecl; export;
begin
 Result:=x*intpower(2.0,exp);
end;
{$ENDIF}

{$IFNDEF LS_NOT_frexp}
function frexp(x:double;exp:Pcint):double; cdecl; export;
begin
 exp^:=0;
 if (X<>0) then
  if (abs(X)<0.5) then
   repeat
    X:=X*2;
    Dec(exp^);
   until (abs(X)>=0.5)
  else
   while (abs(X)>=1) do
   begin
    X:=X/2;
    Inc(exp^);
   end;
 Result:=X;
end;

function _frexp(x:double;exp:Pcint):double; cdecl; export;
begin
 exp^:=0;
 if (X<>0) then
  if (abs(X)<0.5) then
   repeat
    X:=X*2;
    Dec(exp^);
   until (abs(X)>=0.5)
  else
   while (abs(X)>=1) do
   begin
    X:=X/2;
    Inc(exp^);
   end;
 Result:=X;
end;
{$ENDIF}

{$IFNDEF LS_NOT_fmod}
function fmod(a,b:double):double; cdecl; export;
begin
 Result:=a-b*Int(a/b);
end;

function _fmod(a,b:double):double; cdecl; export;
begin
 Result:=a-b*Int(a/b);
end;
{$ENDIF}

{$IFNDEF LS_NOT_exp}
function exp(x:double):double; cdecl; export;
begin
 Result:=System.Exp(x);
end;

function _exp(x:double):double; cdecl; export;
begin
 Result:=System.Exp(x);
end;
{$ENDIF}

{$IFNDEF LS_NOT_sqrt}
function sqrt(x:double):double; cdecl; export;
begin
 Result:=System.sqrt(x);
end;

function _sqrt(x:double):double; cdecl; export;
begin
 Result:=System.sqrt(x);
end;
{$ENDIF}

{$IFNDEF LS_NOT_ceil}
function ceil(x:double):double; cdecl; export;
begin
 Result:=Trunc(x)+ord(Frac(x)>0);
end;

function _ceil(x:double):double; cdecl; export;
begin
 Result:=Trunc(x)+ord(Frac(x)>0);
end;
{$ENDIF}

{$IFNDEF LS_NOT_lround}
function lround(x:double):clong; cdecl; export;
begin
 Result:=System.Round(x);
end;

function _lround(x:double):clong; cdecl; export;
begin
 Result:=System.Round(x);
end;
{$ENDIF}

{$IFNDEF LS_NOT_strerror}
function strerror(errnum:cint):PChar; cdecl; export;
begin
 Result:=nil
end;

function _strerror(errnum:cint):PChar; cdecl; export;
begin
 Result:=nil
end;
{$ENDIF}

{$IFNDEF LS_NOT_remove}
function remove(filename:PChar):cint; cdecl; export;
begin
 Result:=-1;
end;

function _remove(filename:PChar):cint; cdecl; export;
begin
 Result:=-1;
end;
{$ENDIF}

{$IFNDEF LS_NOT_read}
function read(fd:THandle;buf:Pointer;nbyte:size_t):PtrInt; cdecl; export;
begin
 Result:=-1;
end;

function _read(fd:THandle;buf:Pointer;nbyte:size_t):PtrInt; cdecl; export;
begin
 Result:=-1;
end;
{$ENDIF}

{$IFNDEF LS_NOT_lseek64}
function lseek64(fd:THandle;offset:clonglong;whence:cint):clonglong; cdecl; export;
begin
 Result:=-1;
end;

function _lseek64(fd:THandle;offset:clonglong;whence:cint):clonglong; cdecl; export;
begin
 Result:=-1;
end;
{$ENDIF}

{$IFNDEF LS_NOT_close}
function close(fd:THandle):cint; cdecl; export;
begin
 CloseHandle(fd);
 Result:=GetLastError;
end;

function _close(fd:THandle):cint; cdecl; export;
begin
 CloseHandle(fd);
 Result:=GetLastError;
end;
{$ENDIF}

{$IFNDEF LS_NOT_puts}
function puts(str:PChar):cint; cdecl; export;
begin
 Result:=-1;
end;

function _puts(str:PChar):cint; cdecl; export;
begin
 Result:=-1;
end;
{$ENDIF}

{$IFNDEF LS_NOT_getenv}
function getenv(name:PChar):PChar; cdecl; export;
begin
 Result:=nil;
end;

function _getenv(name:PChar):PChar; cdecl; export;
begin
 Result:=nil;
end;
{$ENDIF}

{$IFNDEF LS_NOT_access}
function access(path:PChar;amode:cint):cint; cdecl; export;
begin
 Result:=-1;
end;

function _access(path:PChar;amode:cint):cint; cdecl; export;
begin
 Result:=-1;
end;
{$ENDIF}

{$IFNDEF LS_NOT_rename}
function rename(old_filename,new_filename:PChar):cint; cdecl; export;
begin
 Result:=-1;
end;

function _rename(old_filename,new_filename:PChar):cint; cdecl; export;
begin
 Result:=-1;
end;
{$ENDIF}

{$IFNDEF LS_NOT_setvbuf}
function setvbuf(stream:Pointer;buffer:Pointer;mode:cint;size:size_t):cint; cdecl; export;
begin
 Result:=0;
end;

function _setvbuf(stream:Pointer;buffer:Pointer;mode:cint;size:size_t):cint; cdecl; export;
begin
 Result:=0;
end;
{$ENDIF}

{$IFNDEF LS_NOT_fopen}
function fopen(filename,mode:PChar):Pointer; cdecl; export;
begin
 Result:=nil;
end;

function _fopen(filename,mode:PChar):Pointer; cdecl; export;
begin
 Result:=nil;
end;
{$ENDIF}

{$IFNDEF LS_NOT_fseek}
function fseek(stream:Pointer;offset:clong;origin:cint):cint; cdecl; export;
begin
 Result:=-1;
end;

function _fseek(stream:Pointer;offset:clong;origin:cint):cint; cdecl; export;
begin
 Result:=-1;
end;
{$ENDIF}

{$IFNDEF LS_NOT_fseeko64}
function fseeko64(stream:Pointer;offset:clonglong;origin:cint):cint; cdecl; export;
begin
 Result:=-1;
end;

function _fseeko64(stream:Pointer;offset:clonglong;origin:cint):cint; cdecl; export;
begin
 Result:=-1;
end;
{$ENDIF}

{$IFNDEF LS_NOT_ftello64}
function ftello64(stream:Pointer):clonglong; cdecl; export;
begin
 Result:=-1;
end;

function _ftello64(stream:Pointer):clonglong; cdecl; export;
begin
 Result:=-1;
end;
{$ENDIF}

{$IFNDEF LS_NOT_fread}
function fread(buffer:Pointer;size,count:size_t;stream:Pointer):size_t; cdecl; export;
begin
 Result:=0;
end;

function _fread(buffer:Pointer;size,count:size_t;stream:Pointer):size_t; cdecl; export;
begin
 Result:=0;
end;
{$ENDIF}

{$IFNDEF LS_NOT_fwrite}
function fwrite(buffer:Pointer;size,count:size_t;stream:Pointer):size_t; cdecl; export;
begin
 Result:=0;
end;

function _fwrite(buffer:Pointer;size,count:size_t;stream:Pointer):size_t; cdecl; export;
begin
 Result:=0;
end;
{$ENDIF}

{$IFNDEF LS_NOT_fputc}
function fputc(ch:cint;stream:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;

function _fputc(ch:cint;stream:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;
{$ENDIF}

{$IFNDEF LS_NOT_fclose}
function fclose(stream:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;

function _fclose(stream:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;
{$ENDIF}

{$IFNDEF LS_NOT_feof}
function feof(stream:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;

function _feof(stream:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;
{$ENDIF}

{$IFNDEF LS_NOT_ferror}
function ferror(stream:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;

function _ferror(stream:Pointer):cint; cdecl; export;
begin
 Result:=-1;
end;
{$ENDIF}

{$IFNDEF LS_NOT_fileno}
function fileno(stream:Pointer):THandle; cdecl; export;
begin
 Result:=THandle(-1);
end;

function _fileno(stream:Pointer):THandle; cdecl; export;
begin
 Result:=THandle(-1);
end;
{$ENDIF}

type
 Putimbuf=^_utimbuf;
 _utimbuf=record
  actime,modtime:Int64;
 end;

{$IFNDEF LS_NOT_utime}
function _utime(filename:PChar;times:Putimbuf):cint; cdecl; export;
begin
 Result:=-1;
end;
{$ENDIF}

type
 timeval = record
  tv_sec: int64;
  tv_usec: int64;
 end;
 Ptimeval=^timeval;

 timezone = record
  tz_minuteswest: cint;
  tz_dsttime: cint;
 end;
 Ptimezone=^timezone;

Function _EncodeDate(Year,Month,Day:Word):longint; inline;
var
 c,ya:cardinal;
begin
 if month > 2 then
  Dec(Month,3)
 else
 begin
  Inc(Month,9);
  Dec(Year);
 end;
 c:= Year DIV 100;
 ya:= Year - 100*c;
 Result := (146097*c) SHR 2 + (1461*ya) SHR 2 + (153*cardinal(Month)+2) DIV 5 + cardinal(Day);
end;

const
 SecsPerDay=86400;
 delta_time=62162121600;

{$IFNDEF LS_NOT_gettimeofday}
function gettimeofday(tv:Ptimeval;tz:Ptimezone):cint;cdecl; export; {$ifdef WIN32} [alias: '_gettimeofday']; {$endif}

 function GetLocalTimeOffset:Integer;
 var
  TZInfo:TTimeZoneInformation;
 begin
  case GetTimeZoneInformation(TZInfo) of
    TIME_ZONE_ID_UNKNOWN:
      Result := TZInfo.Bias;
    TIME_ZONE_ID_STANDARD:
      Result := TZInfo.Bias + TZInfo.StandardBias;
    TIME_ZONE_ID_DAYLIGHT:
      Result := TZInfo.Bias + TZInfo.DaylightBias;
    else
      Result := 0;
  end;
 end;

Var
 SystemTime:TSystemTime;
 _Time:int64;

begin
 if tv<>nil then
 begin
  SystemTime:=Default(TSystemTime);
  GetLocalTime(SystemTime);
  _Time:=cardinal(SystemTime.Hour)*3600+cardinal(SystemTime.Minute)*60+cardinal(SystemTime.Second)
         +Int64(_EncodeDate(SystemTime.Year,SystemTime.Month,SystemTime.Day))*SecsPerDay
         -delta_time;
  tv^.tv_sec :=_Time;
  tv^.tv_usec:=SystemTime.wMilliseconds*1000;
 end;
 if tz<>nil then
 begin
  tz^.tz_minuteswest:=GetLocalTimeOffset;
  tz^.tz_dsttime:=0;
 end;
 Result:=0;
end;
{$ENDIF}

{$IFNDEF LS_NOT_time}
function _time(dst:Pint64):int64;cdecl; export; {$ifdef WIN32} [alias: '__time32']; {$endif}
Var
 SystemTime:TSystemTime;
begin
 SystemTime:=Default(TSystemTime);
 GetLocalTime(SystemTime);
 Result:=cardinal(SystemTime.Hour)*3600+cardinal(SystemTime.Minute)*60+cardinal(SystemTime.Second)
         +Int64(_EncodeDate(SystemTime.Year,SystemTime.Month,SystemTime.Day))*SecsPerDay
         -delta_time;
 if dst<>nil then
 begin
  dst^:=Result;
 end;
end;
{$ENDIF}

{$IF (not defined(LS_NOT_gmtime)) or (not defined(LS_NOT_imp__gmtime64))}
 {$IFNDEF LS_NOT_gmtime}
  {$DEFINE gmtime_export}
 {$ENDIF}
 {$I gmtime.inc}
 {$UNDEF gmtime_export}
{$ENDIF}

function tolower(ch:cint):cint; cdecl;
begin
 Result:=cint(System.LowerCase(Char(ch)));
end;

function toupper(ch:cint):cint; cdecl;
begin
 Result:=cint(System.UpCase(Char(ch)));
end;

function isprint(ch:cint):cint; cdecl;
begin
 Case ch of
  $20..$7E:Result:=1;
  else     Result:=0;
 end;
end;

const
 {$IFNDEF LS_NOT_imp___iob}
 __imp___iob          :Pointer=nil; export;
 __imp___iob_func     :Pointer=nil; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp__stricmp}
 __imp__stricmp       :Pointer=@stricmp; export;
 __imp___stricmp      :Pointer=@stricmp; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp__strnicmp}
 __imp__strnicmp      :Pointer=@strnicmp; export;
 __imp___strnicmp     :Pointer=@strnicmp; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp_tolower}
 __imp_tolower        :Pointer=@tolower; export;
 __imp__tolower       :Pointer=@tolower; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp_toupper}
 __imp_toupper        :Pointer=@toupper; export;
 __imp__toupper       :Pointer=@toupper; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp_isprint}
 __imp_isprint        :Pointer=@isprint; export;
 __imp__isprint       :Pointer=@isprint; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp_errno}
 __imp__errno         :Pointer=nil; export;
 __imp___errno        :Pointer=nil; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp_get_osfhandle}
 __imp__get_osfhandle :Pointer=nil; export;
 __imp___get_osfhandle:Pointer=nil; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_time}
 __imp__time64        :Pointer=@_time; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp__gmtime64}
 __imp__gmtime64      :Pointer=@_gmtime64; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp__fstat64}
 __imp__fstat64       :Pointer=nil; export;
 __imp___fstat64      :Pointer=nil; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp__fileno}
 __imp__fileno        :Pointer=@fileno; export;
 __imp___fileno       :Pointer=@_fileno; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp__setmode}
 __imp__setmode       :Pointer=nil; export;
 __imp___setmode      :Pointer=nil; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp__wfopen}
 __imp__wfopen        :Pointer=nil; export;
 __imp___wfopen       :Pointer=nil; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp__wstat64}
 __imp__wstat64       :Pointer=nil; export;
 __imp___wstat64      :Pointer=nil; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp__stat64}
 __imp__stat64        :Pointer=nil; export;
 __imp___stat64       :Pointer=nil; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp__wchmod}
 __imp__wchmod        :Pointer=nil; export;
 __imp___wchmod       :Pointer=nil; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp__chmod}
 __imp__chmod         :Pointer=nil; export;
 __imp___chmod        :Pointer=nil; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp__wutime64}
 __imp__wutime64      :Pointer=nil; export;
 __imp___wutime64     :Pointer=nil; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp__utime64}
 __imp__utime64       :Pointer=@_utime; export;
 __imp___utime64      :Pointer=@_utime; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp__wunlink}
 __imp__wunlink       :Pointer=nil; export;
 __imp___wunlink      :Pointer=nil; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp__unlink}
 __imp__unlink        :Pointer=nil; export;
 __imp___unlink       :Pointer=nil; export;
 {$ENDIF}
 {$IFNDEF LS_NOT_imp__wrename}
 __imp__wrename       :Pointer=nil; export;
 __imp___wrename      :Pointer=nil; export;
 {$ENDIF}


end.

