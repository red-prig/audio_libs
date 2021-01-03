//
//COPYRIGHT:   LGPL, See LGPL.txt in the top level directory
//PROJECT:     ReactOS CRT library
//FILE:        lib/sdk/crt/time/gmtime.c
//PURPOSE:     Implementation of gmtime, _gmtime32, _gmtime64
//PROGRAMERS:  Timo Kreuzer
//
//Free pascal port by Red_prig (2020)

type
 Ptm = ^tm;
 tm = record
  tm_sec   : longint;
  tm_min   : longint;
  tm_hour  : longint;
  tm_mday  : longint;
  tm_mon   : longint;
  tm_year  : longint;
  tm_wday  : longint;
  tm_yday  : longint;
  tm_isdst : longint;
  tm_gmtoff: longint;
  tm_zone  : Pchar;
 end;

const
 g_monthdays:array[0..12] of cuint=(0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365);
 g_lpmonthdays:array[0..12] of cuint=(0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366);

 SECONDSPERHOUR=(60*60);
 SECONDSPERDAY=(24*60*60);
 DAYSPERYEAR=365;
 DAYSPER4YEARS=(4*DAYSPERYEAR+1);
 DAYSPER100YEARS=(25*DAYSPER4YEARS-1);
 DAYSPER400YEARS=(4*DAYSPER100YEARS+1);
 DIFFDAYS=(3 * DAYSPER100YEARS + 17 * DAYSPER4YEARS + 1 * DAYSPERYEAR);
 LEAPDAY=59;

function leapyears_passed(days:clong):clong; inline;
var
 quadcenturies,centuries,quadyears:clong;
begin
 quadcenturies:=days div DAYSPER400YEARS;
 days:=days-quadcenturies;
 centuries:=days div DAYSPER100YEARS;
 days:=days+centuries;
 quadyears:=days div DAYSPER4YEARS;
 Result:=quadyears - centuries + quadcenturies;
end;

function leapdays_passed(days:clong):clong; inline;
begin
 Result:=leapyears_passed(days + DAYSPERYEAR - LEAPDAY + 1);
end;

function _gmtime_worker(tm:ptm;time:Int64):ptm;
var
 days, daystoyear, dayinyear, leapdays, leapyears, years, month:cuint;
 secondinday, secondinhour:cuint;
 yeartime:cint;
 padays:Pcuint;
begin
 if (time < 0) then Exit(nil);

 // Divide into date and time
 days:= cint(time div SECONDSPERDAY);
 secondinday:= time mod SECONDSPERDAY;

 // Shift to days from 1.1.1601
 days:=days+DIFFDAYS;

 // Calculate leap days passed till today
 leapdays:= leapdays_passed(days);

 // Calculate number of full leap years passed
 leapyears:= leapyears_passed(days);

 // Are more leap days passed than leap years?
 if (leapdays > leapyears) then
 begin
  // Yes, we're in a leap year
  padays:=@g_lpmonthdays;
 end else
 begin
  // No, normal year
  padays:=@g_monthdays;
 end;

 // Calculate year
 years:= (days - leapdays) div 365;
 tm^.tm_year:= years - 299;

 // Calculate number of days till 1.1. of this year
 daystoyear:= years * 365 + leapyears;

 // Calculate the day in this year
 dayinyear:= days - daystoyear;

 tm^.tm_yday:= dayinyear;

 /// dayinyear < 366 => terminates with i <= 11
 month:=0;
 While (dayinyear >= padays[month+1]) do Inc(month);

 // Set month and day in month
 tm^.tm_mon := month;
 tm^.tm_mday:= 1 + dayinyear - padays[month];

 // Get weekday
 tm^.tm_wday:= (days + 1) mod 7;

 // Calculate hour and second in hour
 tm^.tm_hour:= secondinday div SECONDSPERHOUR;
 secondinhour:= secondinday mod SECONDSPERHOUR;

 // Calculate minute and second
 tm^.tm_min:= secondinhour div 60;
 tm^.tm_sec:= secondinhour mod 60;

 Result:=tm;
end;

threadvar
 time_buffer:tm;

function _gmtime32(__timer:Pint64):Ptm; cdecl; {$IFNDEF gmtime_export} export; {$ENDIF}
begin
 if __timer=nil then Exit(nil);
 time_buffer:=Default(tm);
 Result:=_gmtime_worker(@time_buffer,__timer^);
end;

function __gmtime32(__timer:Pint64):Ptm; cdecl; {$IFNDEF gmtime_export} export; {$ENDIF}
begin
 if __timer=nil then Exit(nil);
 time_buffer:=Default(tm);
 Result:=_gmtime_worker(@time_buffer,__timer^);
end;

function _gmtime64(__timer:Pint64):Ptm; cdecl; {$IFNDEF gmtime_export} export; {$ENDIF}
begin
 if __timer=nil then Exit(nil);
 time_buffer:=Default(tm);
 Result:=_gmtime_worker(@time_buffer,__timer^);
end;

function __gmtime64(__timer:Pint64):Ptm; cdecl; {$IFNDEF gmtime_export} export; {$ENDIF}
begin
 if __timer=nil then Exit(nil);
 time_buffer:=Default(tm);
 Result:=_gmtime_worker(@time_buffer,__timer^);
end;



