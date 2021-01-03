{ Header for libmpg123

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

unit libmpg123;

{$mode objfpc}{$H+}
{$PACKRECORDS C}

interface

uses
 {$if defined(USE_STATIC_MPG123) and defined(WINDOWS)}
 libaudio_static,
 {$ENDIF}
 ctypes;

{$ifdef USE_STATIC_MPG123}
 {$Linklib libmpg123.a, static}
 {$IFDEF unix}
  {$Linklib libm}
  {$Linklib libc}
 {$ENDIF}
{$endif}

const
 libname=
  {$IFDEF unix}
   {$IFDEF darwin}
  'libmpg123.0.dylib';
   {$ELSE}
  'libmpg123.so.0';
   {$ENDIF}
   {$ELSE}
  'libmpg123-0.dll';
  {$ENDIF}

type
{$IFDEF WINDOWS}
 off_t = int64;
 {$ELSE}
 off_t    = clonglong;
 size_t   = culong;
 {$ENDIF}

const
  SEEK_SET  = 0;       //* seek relative to beginning of file */
  SEEK_CUR  = 1;       //* seek relative to current file position */
  SEEK_END  = 2;       //* seek relative to end of file */
  SEEK_DATA = 3;       //* seek to the next data */
  SEEK_HOLE = 4;       //* seek to the next hole */
  SEEK_MAX  = SEEK_HOLE;

const
  MPG123_VERBOSE = 0;  // set verbosity value for enabling messages
  // to stderr, >= 0 makes sense (integer)
  MPG123_FLAGS = 1;
  // set all flags, p.ex val = MPG123_GAPLESS|MPG123_MONO_MIX (integer)
  MPG123_ADD_FLAGS = 2;  // add some flags (integer)
  MPG123_FORCE_RATE = 3;
  // when value > 0, force output rate to that value (integer)
  MPG123_DOWN_SAMPLE = 4;  // 0=native rate, 1=half rate, 2=quarter rate (integer)
  MPG123_RVA = 5;  // one of the RVA choices above (integer)
  MPG123_DOWNSPEED = 6;  // play a frame N times (integer)
  MPG123_UPSPEED = 7;  // play every Nth frame (integer)
  MPG123_START_FRAME = 8;  // start with this frame (skip frames before that, integer)
  MPG123_DECODE_FRAMES = 9;  // decode only this number of frames (integer)
  MPG123_ICY_INTERVAL = 10;
  // stream contains ICY metadata with this interval (integer)
  MPG123_OUTSCALE = 11;  // the scale for output samples (amplitude - integer
  // or float according to mpg123 output format, normally integer)
  MPG123_TIMEOUT = 12;  // timeout for reading from a stream (not supported
  // on win32, integer)
  MPG123_REMOVE_FLAGS = 13;  // remove some flags (inverse of MPG123_ADD_FLAGS, integer)
  MPG123_RESYNC_LIMIT = 14;  // Try resync on frame parsing for that many bytes
  // or until end of stream (<0 ... integer).
  MPG123_INDEX_SIZE = 15;  // Set the frame index size (if supported).
  // Values <0 mean that the index is allowed to grow
  // dynamically in these steps (in positive direction,
  // of course) -- Use this when you really want a
  // full index with every individual frame.
  MPG123_PREFRAMES = 16;

{** mpg123_param_flags - Flag bits for MPG123_FLAGS, use the usual binary or to combine. **}
  MPG123_FORCE_MONO = $7;   //     0111 Force some mono mode: This is a test bitmask
  //          for seeing if any mono forcing is active.
  MPG123_MONO_LEFT = $1;   //     0001 Force playback of left channel only.
  MPG123_MONO_RIGHT = $2;   //     0010 Force playback of right channel only.
  MPG123_MONO_MIX = $4;   //     0100 Force playback of mixed mono.
  MPG123_FORCE_STEREO = $8;   //     1000 Force stereo output.
  MPG123_FORCE_8BIT = $10;  // 00010000 Force 8bit formats.
  MPG123_QUIET = $20;
  // 00100000 Suppress any printouts (overrules verbose).                    *)
  MPG123_GAPLESS = $40;  // 01000000 Enable gapless decoding (default on
  // if libmpg123 has support).
  MPG123_NO_RESYNC = $80;
  // 10000000 Disable resync stream after error.                             *)
  MPG123_SEEKBUFFER = $100; // 000100000000 Enable small buffer on non-seekable
  // streams to allow some peek-ahead (for better MPEG sync).
  MPG123_FUZZY = $200; // 001000000000 Enable fuzzy seeks (guessing byte
  // offsets or using approximate seek points from Xing TOC)
  (* 1.72 *)
  MPG123_FORCE_FLOAT = $400; // 010000000000 Force floating point output
  // (32 or 64 bits depends on mpg123 internal precision).
  MPG123_PLAIN_ID3TEXT = $800;
  MPG123_IGNORE_STREAMLENGTH = $1000;

  MPG123_IGNORE_INFOFRAME = $4000;
  MPG123_AUTO_RESAMPLE = $8000;
  MPG123_PICTURE = $10000;
  MPG123_NO_PEEK_END = $20000;
  MPG123_SKIP_ID3V2 = $2000;
  MPG123_FORCE_SEEKABLE = $40000;

{** mpg123_param_rva - Choices for MPG123_RVA **}
  MPG123_RVA_OFF = 0;  // RVA disabled (default).
  MPG123_RVA_MIX = 1;  // Use mix/track/radio gain.
  MPG123_RVA_ALBUM = 2;  // Use album/audiophile gain
  MPG123_RVA_MAX = MPG123_RVA_ALBUM; // The maximum RVA code, may increase in future.

const  // mpg123_enc_enum
  MPG123_ENC_8 = $00f;  (**< 0000 0000 1111 Some 8 bit  integer encoding. *)
  MPG123_ENC_16 = $040;  (**< 0000 0100 0000 Some 16 bit integer encoding. *)
  MPG123_ENC_32 = $100;  (**< 0001 0000 0000 Some 32 bit integer encoding. *)
  MPG123_ENC_SIGNED = $080;  (**< 0000 1000 0000 Some signed integer encoding. *)
  MPG123_ENC_FLOAT = $800;  (**< 1110 0000 0000 Some float encoding. *)
  MPG123_ENC_SIGNED_16 = (MPG123_ENC_16 or MPG123_ENC_SIGNED or $10);
  (**< 0000 1101 0000 signed 16 bit *)
  MPG123_ENC_UNSIGNED_16 = (MPG123_ENC_16 or $20);
  (**< 0000 0110 0000 unsigned 16 bit*)
  MPG123_ENC_UNSIGNED_8 = $01;
  (**< 0000 0000 0001 unsigned 8 bit*)
  MPG123_ENC_SIGNED_8 = (MPG123_ENC_SIGNED or $02);
  (**< 0000 1000 0010 signed 8 bit*)
  MPG123_ENC_ULAW_8 = $04;
  (**< 0000 0000 0100 ulaw 8 bit*)
  MPG123_ENC_ALAW_8 = $08;
  (**< 0000 0000 1000 alaw 8 bit *)
  MPG123_ENC_SIGNED_32 = MPG123_ENC_32 or MPG123_ENC_SIGNED or $1000;
  (**< 0001 1001 0000 signed 32 bit *)
  MPG123_ENC_UNSIGNED_32 = MPG123_ENC_32 or $2000;
  (**< 0001 0010 0000 unsigned 32 bit *)
  MPG123_ENC_FLOAT_32 = $200;
  (**< 0010 0000 0000 32bit float *)
  MPG123_ENC_FLOAT_64 = $400;
  (**< 0100 0000 0000 64bit float *)
  MPG123_ENC_ANY = MPG123_ENC_SIGNED_16 or MPG123_ENC_UNSIGNED_16 or
                   MPG123_ENC_UNSIGNED_8 or MPG123_ENC_SIGNED_8 or
                   MPG123_ENC_ULAW_8 or MPG123_ENC_ALAW_8 or
                   MPG123_ENC_SIGNED_32 or MPG123_ENC_UNSIGNED_32 or
                   MPG123_ENC_FLOAT_32 or MPG123_ENC_FLOAT_64; (**< any encoding *)

  MPG123_LEFT = $1;
  MPG123_RIGHT = $2;
  MPG123_LR = $3;

const
  MPG123_CBR = 0;  (**< Constant Bitrate Mode (default) *)
  MPG123_VBR = 1;  (**< Variable Bitrate Mode *)
  MPG123_ABR = 2;  (**< Average Bitrate Mode *)

(** enum mpg123_version - Enumeration of the MPEG Versions *)
  MPG123_1_0 = 0;  (**< MPEG Version 1.0 *)
  MPG123_2_0 = 1;  (**< MPEG Version 2.0 *)
  MPG123_2_5 = 2;  (**< MPEG Version 2.5 *)

(** enum mpg123_mode - Enumeration of the MPEG Audio mode.
 *  Only the mono mode has 1 channel, the others have 2 channels. *)
  MPG123_M_STEREO = 0;  (**< Standard Stereo. *)
  MPG123_M_JOINT = 1;  (**< Joint Stereo. *)
  MPG123_M_DUAL = 2;  (**< Dual Channel. *)
  MPG123_M_MONO = 3;  (**< Single Channel. *)

  (** enum mpg123_flags - Enumeration of the MPEG Audio flag bits *)
  MPG123_CRC = $1;  (**< The bitstream is error protected using 16-bit CRC. *)
  MPG123_COPYRIGHT = $2;  (**< The bitstream is copyrighted. *)
  MPG123_PRIVATE = $4;  (**< The private bit has been set. *)
  MPG123_ORIGINAL = $8;  (**< The bitstream is an original, not a copy. *)

const
  MPG123_DONE = -12;  // Message: Track ended.
  MPG123_NEW_FORMAT = -11;
  // Message: Output format will be different on next call.
  MPG123_NEED_MORE = -10;  // Message: For feed reader: "Feed me more!"
  MPG123_ERR = -1;  // <Generic Error>
  MPG123_OK = 0;  // <Success>
  MPG123_BAD_OUTFORMAT = 1;  // Unable to set up output format!
  MPG123_BAD_CHANNEL = 2;  // Invalid channel number specified.
  MPG123_BAD_RATE = 3;  // Invalid sample rate specified.
  MPG123_ERR_16TO8TABLE = 4;
  // Unable to allocate memory for 16 to 8 converter table!
  MPG123_BAD_PARAM = 5;  // Bad parameter id!
  MPG123_BAD_BUFFER = 6;
  // Bad buffer given -- invalid pointer or too small size.
  MPG123_OUT_OF_MEM = 7;  // Out of memory -- some malloc() failed.
  MPG123_NOT_INITIALIZED = 8;  // You didn't initialize the library!
  MPG123_BAD_DECODER = 9;  // Invalid decoder choice.
  MPG123_BAD_HANDLE = 10;  // Invalid mpg123 handle.
  MPG123_NO_BUFFERS = 11;  // Unable to initialize frame buffers (out of memory?).
  MPG123_BAD_RVA = 12;  // Invalid RVA mode.
  MPG123_NO_GAPLESS = 13;  // This build doesn't support gapless decoding.
  MPG123_NO_SPACE = 14;  // Not enough buffer space.
  MPG123_BAD_TYPES = 15;  // Incompatible numeric data types.
  MPG123_BAD_BAND = 16;  // Bad equalizer band.
  MPG123_ERR_NULL = 17;
  // Null pointer given where valid storage address needed.
  MPG123_ERR_READER = 18;  // Error reading the stream.
  MPG123_NO_SEEK_FROM_END = 19;  // Cannot seek from end (end is not known).
  MPG123_BAD_WHENCE = 20;  // Invalid 'whence' for seek function.
  MPG123_NO_TIMEOUT = 21;  // Build does not support stream timeouts.
  MPG123_BAD_FILE = 22;  // File access error.
  MPG123_NO_SEEK = 23;  // Seek not supported by stream.
  MPG123_NO_READER = 24;  // No stream opened.
  MPG123_BAD_PARS = 25;  // Bad parameter handle.
  MPG123_BAD_INDEX_PAR = 26;  // Bad parameters to mpg123_index()
  MPG123_OUT_OF_SYNC = 27;  // Lost track in bytestream and did not try to resync.
  MPG123_RESYNC_FAIL = 28;  // Resync failed to find valid MPEG data.
  MPG123_NO_8BIT = 29;  // No 8bit encoding possible.
  MPG123_BAD_ALIGN = 30;  // Stack aligmnent error
  MPG123_NULL_BUFFER = 31;  // NULL input buffer with non-zero size...
  MPG123_NO_RELSEEK = 32;  // Relative seek not possible (screwed up file offset)
  MPG123_NULL_POINTER = 33;
  // You gave a null pointer somewhere where you shouldn't have.
  MPG123_BAD_KEY = 34;  // Bad key value given.
  MPG123_NO_INDEX = 35;  // No frame index in this build.
  MPG123_INDEX_FAIL = 36;  // Something with frame index went wrong.
  (* 1.72 *)
  MPG123_BAD_DECODER_SETUP = 37;  // Something prevents a proper decoder setup
  MPG123_MISSING_FEATURE = 38;  // This feature has not been built into libmpg123.
  MPG123_BAD_VALUE = 39;
  MPG123_LSEEK_FAILED = 40;
  MPG123_BAD_CUSTOM_IO = 41;
  MPG123_LFS_OVERFLOW = 42;

type
 Tmpg123_handle = Pointer;
 pmpg123_frameinfo = ^Tmpg123_frameinfo;
  Tmpg123_frameinfo = record
  mpg123_version_version: longword;  (**< The MPEG version (1.0/2.0/2.5). *)
  layer: integer;   (**< The MPEG Audio Layer (MP1/MP2/MP3). *)
  rate: longword;  (**< The sampling rate in Hz. *)
  mpg123_mode_mode: longint;
  (**< The audio mode (Mono, Stereo, Joint-stero, Dual Channel). *)
  mode_ext: integer;   (**< The mode extension bit flag. *)
  framesize: integer;   (**< The size of the frame (in bytes). *)
  mpg123_flags_flags: longword;  (**< MPEG Audio flag bits. *)
  emphasis: integer;   (**< The emphasis type. *)
  bitrate: integer;   (**< Bitrate of the frame (kbps). *)
  abr_rate: integer;   (**< The target average bitrate. *)
  mpg123_vbr_vbr: longword;  (**< The VBR mode. *)
 end;

 Tmpg_r_read =function(Handle:THandle;AData:Pointer;ACount:size_t):size_t; cdecl;
 Tmpg_r_lseek=function(Handle:THandle;offset:off_t;whence:Integer):off_t; cdecl;

 Tmpg_rh_read =function(user_data:Pointer;AData:Pointer;ACount:size_t):size_t; cdecl;
 Tmpg_rh_lseek=function(user_data:Pointer;offset:off_t;whence:Integer):off_t; cdecl;
 Tmpg_rh_cleanup=procedure(user_data:Pointer); cdecl;

function  mpg123_init():cint; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
procedure mpg123_exit; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_new(const decoder:PChar;var error:cint):Tmpg123_handle; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
procedure mpg123_delete(mh:Tmpg123_handle); cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};

procedure mpg123_rates(var list:pclong;var number:size_t); cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
procedure mpg123_encodings(var list:pcint; var number: size_t); cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_encsize(encoding: cint): cint; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_format_none(mh: Tmpg123_handle): cint; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_format_all(mh: Tmpg123_handle): cint; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_format(mh: Tmpg123_handle; rate: clong;channels: cint; encodings: cint): cint; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_format_support(mh: Tmpg123_handle; rate: clong;encoding: cint): cint; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_getformat(mh: Tmpg123_handle; var rate: clong;var channels, encoding: cint): cint; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_open(mh: Tmpg123_handle; path: PChar): cint; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_open_fd(mh: Tmpg123_handle; fd: Thandle): cint; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_open_handle(mh:Tmpg123_handle;pha:pointer):cint; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_close(mh:Tmpg123_handle):cint; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_replace_reader_handle(mh:Tmpg123_handle;r_read:Tmpg_rh_read;r_lseek:Tmpg_rh_lseek;cleanup:Tmpg_rh_cleanup):cint; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_replace_reader(mh:Tmpg123_handle;r_read:Tmpg_r_read;r_lseek:Tmpg_r_lseek):cint; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_getformat2(mh:Tmpg123_handle;var rate:clong;var channels,encoding:cint;var clear_flag:cint):cint; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_read(mh:Tmpg123_handle;outmemory:pcfloat;outmemsize:size_t;var done:size_t):cint; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_info(mh:Tmpg123_handle;var mi:Tmpg123_frameinfo):cint; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_decode(mh:Tmpg123_handle;inmemory:Pointer;inmemsize:size_t;outmemory:Pointer;outmemsize:size_t;var done:size_t):cint; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_tell(mh:Tmpg123_handle):off_t; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_seek(mh:Tmpg123_handle;sampleoff:off_t;whence:cint):cint; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_scan(mh:Tmpg123_handle):cint; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};
function  mpg123_length(mh:Tmpg123_handle):off_t; cdecl; external {$ifndef USE_STATIC_MPG123} libname {$endif};

implementation

{$ifdef USE_STATIC_MPG123}

function _malloc(size:size_t):Pointer; cdecl; external name 'malloc';
function _realloc(ptr:Pointer;newsize:size_t):Pointer; cdecl; external name 'realloc';

{$IFNDEF MPG_NOT_INT123_safe_realloc}
function INT123_safe_realloc(ptr:Pointer;newsize:size_t):Pointer; cdecl; export;
begin
 if (ptr=nil) then Result:=_malloc(newsize)
 else Result:=_realloc(ptr,newsize);
end;

function _INT123_safe_realloc(ptr:Pointer;newsize:size_t):Pointer; cdecl; export;
begin
 if (ptr=nil) then Result:=_malloc(newsize)
 else Result:=_realloc(ptr,newsize);
end;
{$endif}

{$IFNDEF MPG_NOT_INT123_compat_strdup}
function INT123_compat_strdup(s:PChar):PChar; cdecl; export;
var
 l:size_t;
begin
 if (s=nil) then Exit(nil);
 l:=System.StrLen(s)+1;
 Result:=_malloc(l);
 Move(s^,Result^,l);
end;

function _INT123_compat_strdup(s:PChar):PChar; cdecl; export;
var
 l:size_t;
begin
 if (s=nil) then Exit(nil);
 l:=System.StrLen(s)+1;
 Result:=_malloc(l);
 Move(s^,Result^,l);
end;
{$ENDIF}

{$IFNDEF MPG_NOT_INT123_compat_open}
function INT123_compat_open(filename:PAnsiChar;flags:cint):THandle; cdecl; export;
begin
 Result:=THandle(-1);
end;

function _INT123_compat_open(filename:PAnsiChar;flags:cint):THandle; cdecl; export;
begin
 Result:=THandle(-1);
end;
{$ENDIF}

{$IFNDEF MPG_NOT_INT123_compat_close}
function INT123_compat_close(fd:THandle):cint; cdecl; export;
begin
 Result:=-1;
end;

function _INT123_compat_close(fd:THandle):cint; cdecl; export;
begin
 Result:=-1;
end;
{$ENDIF}

{$endif}

end.

