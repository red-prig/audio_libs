{  Copyright (C) 1991,1992,1996,1997,1999,2004 Free Software Foundation, Inc.
   This file is part of the GNU C Library.
   Written by Douglas C. Schmidt (schmidt@ics.uci.edu).

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

   If you consider tuning this algorithm, you should consult first:
   Engineering a sort function; Jon Bentley and M. Douglas McIlroy;
   Software - Practice and Experience; Vol. 23 (11), 1249-1265, 1993.  }

//Free pascal port by Red_prig (2020)

type
 Tqsort_comparator=function(a,b:Pointer):cint; cdecl;

Procedure qsort(pbase:Pointer;total_elems,size:size_t;cmp:Tqsort_comparator); cdecl; export;
const
 MAX_THRESH=4;
 STACK_SIZE=8*sizeof(size_t);
type
 pstack_node=^Tstack_node;
 Tstack_node=record
  lo,hi:PByte;
 end;
var
 lo,hi,mid:PByte;
 left_ptr,right_ptr:PByte;
 top:pstack_node;
 stack:array[0..STACK_SIZE-1] of Tstack_node;

 Procedure swap(a,b:Pointer;size:size_t); inline;
 Var
  t,s:SizeUInt;
 begin
  s:=size div SizeOf(SizeUInt);
  While (s>0) do
  begin
   t:=PSizeUInt(a)^;
   PSizeUInt(a)^:=PSizeUInt(b)^;
   PSizeUInt(b)^:=t;
   a:=@PSizeUInt(a)[1];
   b:=@PSizeUInt(b)[1];
   Dec(s);
  end;
  s:=size mod SizeOf(SizeUInt);
  While (s>0) do
  begin
   t:=PByte(a)^;
   PByte(a)^:=PByte(b)^;
   PByte(b)^:=t;
   a:=@PByte(a)[1];
   b:=@PByte(b)[1];
   Dec(s);
  end;
 end;

 procedure push(low,high:Pointer); inline;
 begin
  top^.lo:=low;
  top^.hi:=high;
  top:=top+1;
 end;

 procedure pop(var low,high:Pointer); inline;
 begin
  top:=top-1;
  low:=top^.lo;
  high:=top^.hi;
 end;

 function STACK_NOT_EMPTY:Boolean; inline;
 begin
  Result:=(@stack<top);
 end;

 function min(x,y:Pointer):Pointer; inline;
 begin
  if (x<y) then
   Result:=x
  else
   Result:=y;
 end;

 procedure insertion_sort; inline;
 var
  end_ptr,tmp_ptr,thresh,run_ptr,trav:PByte;
  c:Byte;
 begin
  end_ptr:=@PByte(pbase)[size*(total_elems-1)];
  tmp_ptr:=pbase;
  thresh:=min(end_ptr,pbase+max_thresh);
  run_ptr:=tmp_ptr+size;
  while (run_ptr<=thresh) do
  begin
   if (cmp(run_ptr,tmp_ptr)<0) then
    tmp_ptr:=run_ptr;
   run_ptr:=run_ptr+size;
  end;
  if (tmp_ptr<>pbase) then
   SWAP(tmp_ptr,pbase,size);
  run_ptr:=pbase+size;
  while true do
  begin
   run_ptr:=run_ptr+size;
   if run_ptr>end_ptr then Break;
   tmp_ptr:=run_ptr-size;
   while (cmp(run_ptr,tmp_ptr)<0) do
    tmp_ptr:=tmp_ptr-size;
   tmp_ptr:=tmp_ptr+size;
   if (tmp_ptr<>run_ptr) then
   begin
    trav:=run_ptr+size;
    While true do
    begin
     trav:=trav-1;
     if (trav<run_ptr) then Break;
     c:=trav^;
     hi:=trav;
     lo:=trav;
     While true do
     begin
      lo:=lo-size;
      if lo<tmp_ptr then Break;
      hi^:=lo^;
      hi:=lo;
     end;
     hi^:=c;
    end;
   end;
  end;
 end;

label
 jump_over;

begin
 if (pbase=nil) or
    (total_elems=0) or
    (size=0) or
    (cmp=nil) then Exit;
 if (total_elems>MAX_THRESH) then
 begin
  lo:=pbase;
  hi:=@lo[size*(total_elems-1)];
  top:=@stack;
  push(nil,nil);
  While (STACK_NOT_EMPTY) do
  begin
   mid:=lo+size*((size_t(hi-lo) div size) shr 1);
   if cmp(mid,lo)<0 then
    SWAP(mid,lo,size);
   if cmp(hi,mid)<0 then
    SWAP(mid,hi,size)
   else
    goto jump_over;
   if cmp(mid,lo)<0 then
    SWAP(mid,lo,size);
   jump_over:
   left_ptr :=lo+size;
   right_ptr:=hi-size;
   repeat
    while (cmp(left_ptr,mid)<0) do
     left_ptr:=left_ptr+size;
    while (cmp(mid,right_ptr)<0) do
     right_ptr:=right_ptr-size;
    if (left_ptr<right_ptr) then
    begin
     SWAP(left_ptr,right_ptr,size);
     if (mid=left_ptr) then
       mid:=right_ptr
     else if (mid=right_ptr) then
       mid:=left_ptr;
     left_ptr:=left_ptr+size;
     right_ptr:=right_ptr-size;
    end else
    if (left_ptr=right_ptr) then
    begin
     left_ptr:=left_ptr+size;
     right_ptr:=right_ptr-size;
     break;
    end;
   until (left_ptr>right_ptr);
   if (size_t(right_ptr-lo)<=max_thresh) then
   begin
    if (size_t(hi-left_ptr)<=max_thresh) then
     POP(lo,hi)
    else
     lo:=left_ptr;
   end else
   if (size_t(hi-left_ptr)<=max_thresh) then
   begin
    hi:=right_ptr;
   end else
   if ((right_ptr-lo)>(hi-left_ptr)) then
   begin
    PUSH(lo,right_ptr);
    lo:=left_ptr;
   end else
   begin
    PUSH(left_ptr,hi);
    hi:=right_ptr;
   end;
  end;
 end;
 insertion_sort;
end;

