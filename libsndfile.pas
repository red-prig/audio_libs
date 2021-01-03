{ Header for libsndfile

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

unit libsndfile;

{$mode objfpc}{$H+}
{$PACKRECORDS C}

interface

uses
 {$if defined(USE_STATIC_SNDFILE) and defined(WINDOWS)}
  {$if FPC_FULLVERSION< 30301}
   {$ERROR For static compilation use version FPC 3.3.1 or higher (Internal error 200603061)}
  {$ENDIF}
 libaudio_static,
 {$ENDIF}
 CTypes;

{$ifdef USE_STATIC_SNDFILE}
 {$Linklib libsndfile.a, static}
 {$Linklib libopus.a, static}
 {$Linklib libvorbis.a, static}
 {$Linklib libvorbisenc.a, static}
 {$Linklib libvorbisfile.a, static}
 {$Linklib libFLAC.a, static}
 {$Linklib libogg.a, static}
 {$IFDEF unix}
  {$Linklib libm}
  {$Linklib libc}
 {$ENDIF}
{$endif}

const
{$IFDEF unix}
 {$IFDEF darwin}
  libname='libsndfile.1.dylib';
 {$ELSE}
  libname='libsndfile.so.1';
 {$ENDIF}
 {$ELSE}
  libname='libsndfile-1.dll';
{$ENDIF}

type
 {$IFDEF WINDOWS}
  off_t = int64;
  {$ELSE}
  off_t    = clonglong;
  size_t   = culong;
  {$ENDIF}

const
  //* Major formats. *//
  SF_FORMAT_WAV   = $010000;    // Microsoft WAV format (little endian default).
  SF_FORMAT_AIFF  = $020000;    // Apple/SGI AIFF format (big endian).
  SF_FORMAT_AU    = $030000;    // Sun/NeXT AU format (big endian).
  SF_FORMAT_RAW   = $040000;    // RAW PCM data.
  SF_FORMAT_PAF   = $050000;    // Ensoniq PARIS file format.
  SF_FORMAT_SVX   = $060000;    // Amiga IFF / SVX8 / SV16 format.
  SF_FORMAT_NIST  = $070000;    // Sphere NIST format.
  SF_FORMAT_VOC   = $080000;    // VOC files.
  SF_FORMAT_IRCAM = $0A0000;    // Berkeley/IRCAM/CARL
  SF_FORMAT_W64   = $0B0000;    // Sonic Foundry's 64 bit RIFF/WAV
  SF_FORMAT_MAT4  = $0C0000;    // Matlab (tm) V4.2 / GNU Octave 2.0
  SF_FORMAT_MAT5  = $0D0000;    // Matlab (tm) V5.0 / GNU Octave 2.1
  SF_FORMAT_PVF   = $0E0000;    // Portable Voice Format
  SF_FORMAT_XI    = $0F0000;    // Fasttracker 2 Extended Instrument
  SF_FORMAT_HTK   = $100000;    // HMM Tool Kit format
  SF_FORMAT_SDS   = $110000;    // Midi Sample Dump Standard
  SF_FORMAT_AVR   = $120000;    // Audio Visual Research
  SF_FORMAT_WAVEX = $130000;    // MS WAVE with WAVEFORMATEX
  SF_FORMAT_SD2   = $160000;    // Sound Designer 2
  SF_FORMAT_FLAC  = $170000;    // FLAC lossless file format
  SF_FORMAT_CAF   = $180000;    // Core Audio File format
  SF_FORMAT_WVE   = $190000;   // Psion WVE format
  SF_FORMAT_OGG   = $200000;   // Xiph OGG container
  SF_FORMAT_MPC2K = $210000;   // Akai MPC 2000 sampler
  SF_FORMAT_RF64  = $220000;   // RF64 WAV file

const
  //Subtypes from here on.
  SF_FORMAT_PCM_S8 = $0001;    // Signed 8 bit data
  SF_FORMAT_PCM_16 = $0002;    // Signed 16 bit data
  SF_FORMAT_PCM_24 = $0003;    // Signed 24 bit data
  SF_FORMAT_PCM_32 = $0004;    // Signed 32 bit data

  SF_FORMAT_PCM_U8 = $0005;    // Unsigned 8 bit data (WAV and RAW only)

  SF_FORMAT_FLOAT  = $0006;    // 32 bit float data
  SF_FORMAT_DOUBLE = $0007;    // 64 bit float data

  SF_FORMAT_ULAW = $0010;    // U-Law encoded.
  SF_FORMAT_ALAW = $0011;    // A-Law encoded.
  SF_FORMAT_IMA_ADPCM = $0012;    // IMA ADPCM.
  SF_FORMAT_MS_ADPCM  = $0013;    // Microsoft ADPCM.

  SF_FORMAT_GSM610    = $0020;    // GSM 6.10 encoding.
  SF_FORMAT_VOX_ADPCM = $0021;    // OKI / Dialogix ADPCM

  SF_FORMAT_NMS_ADPCM_16 = $0022;    // 16kbs NMS G721-variant encoding.
  SF_FORMAT_NMS_ADPCM_24 = $0023;    // 24kbs NMS G721-variant encoding.
  SF_FORMAT_NMS_ADPCM_32 = $0024;    // 32kbs NMS G721-variant encoding.

  SF_FORMAT_G721_32 = $0030;    // 32kbs G721 ADPCM encoding.
  SF_FORMAT_G723_24 = $0031;    // 24kbs G723 ADPCM encoding.
  SF_FORMAT_G723_40 = $0032;    // 40kbs G723 ADPCM encoding.

  SF_FORMAT_DWVW_12 = $0040;    // 12 bit Delta Width Variable Word encoding.
  SF_FORMAT_DWVW_16 = $0041;    // 16 bit Delta Width Variable Word encoding.
  SF_FORMAT_DWVW_24 = $0042;    // 24 bit Delta Width Variable Word encoding.
  SF_FORMAT_DWVW_N  = $0043;    // N bit Delta Width Variable Word encoding.

  SF_FORMAT_DPCM_8  = $0050;    // 8 bit differential PCM (XI only)
  SF_FORMAT_DPCM_16 = $0051;    // 16 bit differential PCM (XI only)

  SF_FORMAT_VORBIS  = $0060;    // Xiph Vorbis encoding.
  SF_FORMAT_OPUS    = $0064;    // Xiph/Skype Opus encoding.
  SF_FORMAT_ALAC_16 = $0070;    // Apple Lossless Audio Codec (16 bit).
  SF_FORMAT_ALAC_20 = $0071;    // Apple Lossless Audio Codec (20 bit).
  SF_FORMAT_ALAC_24 = $0072;    // Apple Lossless Audio Codec (24 bit).
  SF_FORMAT_ALAC_32 = $0073;    // Apple Lossless Audio Codec (32 bit).

const
  SF_ENDIAN_FILE   = $00000000;  // Default file endian-ness.
  SF_ENDIAN_LITTLE = $10000000;  // Force little endian-ness.
  SF_ENDIAN_BIG    = $20000000;  // Force big endian-ness.
  SF_ENDIAN_CPU    = $30000000;  // Force CPU endian-ness.

  SF_FORMAT_SUBMASK  = $0000FFFF;
  SF_FORMAT_TYPEMASK = $0FFF0000;
  SF_FORMAT_ENDMASK  = $30000000;

const
  SFC_GET_LIB_VERSION = $1000;
  SFC_GET_LOG_INFO    = $1001;

  SFC_GET_NORM_DOUBLE = $1010;
  SFC_GET_NORM_FLOAT  = $1011;
  SFC_SET_NORM_DOUBLE = $1012;
  SFC_SET_NORM_FLOAT  = $1013;
  SFC_SET_SCALE_FLOAT_INT_READ = $1014;

  SFC_GET_SIMPLE_FORMAT_COUNT = $1020;
  SFC_GET_SIMPLE_FORMAT = $1021;

  SFC_GET_FORMAT_INFO = $1028;

  SFC_GET_FORMAT_MAJOR_COUNT = $1030;
  SFC_GET_FORMAT_MAJOR = $1031;
  SFC_GET_FORMAT_SUBTYPE_COUNT = $1032;
  SFC_GET_FORMAT_SUBTYPE = $1033;

  SFC_CALC_SIGNAL_MAX = $1040;
  SFC_CALC_NORM_SIGNAL_MAX = $1041;
  SFC_CALC_MAX_ALL_CHANNELS = $1042;
  SFC_CALC_NORM_MAX_ALL_CHANNELS = $1043;
  SFC_GET_SIGNAL_MAX = $1044;
  SFC_GET_MAX_ALL_CHANNELS = $1045;

  SFC_SET_ADD_PEAK_CHUNK = $1050;

  SFC_UPDATE_HEADER_NOW = $1060;
  SFC_SET_UPDATE_HEADER_AUTO = $1061;

  SFC_FILE_TRUNCATE = $1080;

  SFC_SET_RAW_START_OFFSET = $1090;

  SFC_SET_DITHER_ON_WRITE = $10A0;
  SFC_SET_DITHER_ON_READ  = $10A1;

  SFC_GET_DITHER_INFO_COUNT = $10A2;
  SFC_GET_DITHER_INFO = $10A3;

  SFC_GET_EMBED_FILE_INFO = $10B0;

  SFC_SET_CLIPPING = $10C0;
  SFC_GET_CLIPPING = $10C1;

  SFC_GET_INSTRUMENT = $10D0;
  SFC_SET_INSTRUMENT = $10D1;

  SFC_GET_LOOP_INFO = $10E0;

  SFC_GET_BROADCAST_INFO = $10F0;
  SFC_SET_BROADCAST_INFO = $10F1;

  // Following commands for testing only.
  SFC_TEST_IEEE_FLOAT_REPLACE = $6001;

  SFC_SET_ADD_DITHER_ON_WRITE = $1070;
  SFC_SET_ADD_DITHER_ON_READ  = $1071;

const
  SF_STR_TITLE     = $01;
  SF_STR_COPYRIGHT = $02;
  SF_STR_SOFTWARE  = $03;
  SF_STR_ARTIST    = $04;
  SF_STR_COMMENT   = $05;
  SF_STR_DATE      = $06;

  SF_STR_FIRST = SF_STR_TITLE;
  SF_STR_LAST  = SF_STR_DATE;

const
  // True and false
  SF_FALSE = 0;
  SF_TRUE  = 1;

const
  // Modes for opening files.
  SFM_READ  = $10;
  SFM_WRITE = $20;
  SFM_RDWR  = $30;

const
  SF_ERR_NO_ERROR             = 0;
  SF_ERR_UNRECOGNISED_FORMAT  = 1;
  SF_ERR_SYSTEM               = 2;
  SF_ERR_MALFORMED_FILE       = 3;
  SF_ERR_UNSUPPORTED_ENCODING = 4;

type
  TSNDFILE_HANDLE = Pointer;

const
  SF_COUNT_MAX = High(cint64);

type
  PSF_INFO = ^TSF_INFO;

  TSF_INFO = record
    frames: off_t;
    samplerate: ctypes.cint;
    channels: ctypes.cint;
    format: ctypes.cint;
    sections: ctypes.cint;
    seekable: ctypes.cint;
  end;

type
  PSF_FORMAT_INFO = ^TSF_FORMAT_INFO;

  TSF_FORMAT_INFO = record
    format: ctypes.cint;
    Name: ctypes.pcchar;
    extension: ctypes.pcchar;
  end;

const
  SFD_DEFAULT_LEVEL = 0;
  SFD_CUSTOM_LEVEL  = $40000000;

  SFD_NO_DITHER      = 500;
  SFD_WHITE          = 501;
  SFD_TRIANGULAR_PDF = 502;

type
  PSF_DITHER_INFO = ^TSF_DITHER_INFO;

  TSF_DITHER_INFO = record
    type_: ctypes.cint;
    level: ctypes.cdouble;
    Name: ctypes.pcchar;
  end;

type
  PSF_EMBED_FILE_INFO = ^TSF_EMBED_FILE_INFO;

  TSF_EMBED_FILE_INFO = record
    offset: off_t;
    length: off_t;
  end;

const
  SF_LOOP_NONE        = 800;
  SF_LOOP_FORWARD     = 801;
  SF_LOOP_BACKWARD    = 802;
  SF_LOOP_ALTERNATING = 803;

type
  PSF_INSTRUMENT = ^TSF_INSTRUMENT;

  TSF_INSTRUMENT = record
    gain: ctypes.cint;
    basenote,
    detune: ctypes.cchar;
    velocity_lo,
    velocity_hi: ctypes.cchar;
    loop_count: ctypes.cint;
    loops: array[0..15] of record
      mode: ctypes.cint;
      start: ctypes.cuint;
      end_: ctypes.cuint;
      Count: ctypes.cuint;
    end;
  end;

type
  PSF_LOOP_INFO = ^TSF_LOOP_INFO;

  TSF_LOOP_INFO = record
    time_sig_num: ctypes.cushort;
    // any positive integer    > 0
    time_sig_den: ctypes.cushort;
    // any positive power of 2 > 0
    loop_mode: ctypes.cint;                // see SF_LOOP enum

    num_beats: ctypes.cint;
    // this is NOT the amount of quarter notes !!!
    // a full bar of 4/4 is 4 beats
    // a full bar of 7/8 is 7 beats

    bpm: ctypes.cfloat;
    // suggestion, as it can be calculated using other fields:
    // file's lenght, file's sampleRate and our time_sig_den
    // -> bpms are always the amount of _quarter notes_ per minute

    root_key: ctypes.cint;
    // MIDI note, or -1 for None
    future: array[0..5] of ctypes.cint;
  end;

type
  PSF_BROADCAST_INFO = ^TSF_BROADCAST_INFO;

  TSF_BROADCAST_INFO = record
    description: array[0..255] of char;//ctypes.cchar;
    originator: array[0..31] of char;//ctypes.cchar;
    originator_reference: array[0..31] of char;//ctypes.cchar;
    origination_date: array[0..9] of char;//ctypes.cchar;
    origination_time: array[0..7] of char;//ctypes.cchar;
    time_reference_low: ctypes.cuint;//ctypes.cint;
    time_reference_high: ctypes.cuint;//ctypes.cint;
    version: ctypes.cshort;
    umid: array[0..63] of char;//ctypes.cchar;
    reserved: array[0..189] of char;//ctypes.cchar;
    coding_history_size: ctypes.cuint;
    coding_history: array[0..255] of char;//ctypes.cchar;
  end;

type
 sf_vio_seek  = function (offset: off_t; whence: cint32; user_data:Pointer): off_t; cdecl;
 sf_vio_read  = function (const buf: Pointer; count: off_t; user_data:Pointer): off_t; cdecl;
 sf_vio_tell  = function (user_data:Pointer): off_t; cdecl;

 TSF_VIRTUAL = packed object
  get_filelen:sf_vio_tell;
  seek       :sf_vio_seek;
  read       :sf_vio_read;
  write      :sf_vio_read;
  tell       :sf_vio_tell;
 end;

 PSF_VIRTUAL = ^TSF_VIRTUAL;

 sf_vio_flush       = Procedure(user_data:Pointer); cdecl;
 sf_vio_set_filelen = function(user_data:Pointer;len:off_t):cint; cdecl;
 sf_vio_is_pipe     = function(user_data:Pointer):cint; cdecl;
 sf_ref_callback    = function(user_data:Pointer):culong; cdecl;

 TSF_VIRTUAL_EX = packed object(TSF_VIRTUAL)
  flush      :sf_vio_flush;
  set_filelen:sf_vio_set_filelen;
  is_pipe    :sf_vio_is_pipe;
  ref        :sf_ref_callback;
  unref      :sf_vio_flush;
 end;
 PSF_VIRTUAL_EX = ^TSF_VIRTUAL_EX;

const
  SEEK_SET  = 0;      //* seek relative to beginning of file */
  SEEK_CUR  = 1;      //* seek relative to current file position */
  SEEK_END  = 2;      //* seek relative to end of file */
  SEEK_DATA = 3;      //* seek to the next data */
  SEEK_HOLE = 4;      //* seek to the next hole */
  SEEK_MAX = SEEK_HOLE;

function sf_open(path: PChar; mode: ctypes.cint; sfinfo: PSF_INFO): TSNDFILE_HANDLE; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_version_string(): PChar; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_open_fd(fd: ctypes.cint; mode: ctypes.cint; sfinfo: PSF_INFO;
  close_desc: ctypes.cint): TSNDFILE_HANDLE; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_open_virtual(sfvirtual: PSF_VIRTUAL; mode: ctypes.cint;
  sfinfo: PSF_INFO; user_data: Pointer): TSNDFILE_HANDLE; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_open_virtual_ex(sfvirtual: PSF_VIRTUAL_EX; mode: ctypes.cint;
  sfinfo: PSF_INFO; user_data: Pointer): TSNDFILE_HANDLE; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_error(sndfile: TSNDFILE_HANDLE): ctypes.cint; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_strerror(sndfile: TSNDFILE_HANDLE): PChar; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_error_number(errnum: ctypes.cint): PChar; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_perror(sndfile: TSNDFILE_HANDLE): ctypes.cint; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_error_str(sndfile: TSNDFILE_HANDLE;
  str: ctypes.pcchar; len: size_t): ctypes.cint; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_command(sndfile: TSNDFILE_HANDLE; command: ctypes.cint;
  Data: Pointer; datasize: ctypes.cint): ctypes.cint; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_format_check(var info: TSF_INFO): ctypes.cint; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_seek(sndfile: TSNDFILE_HANDLE; frame: off_t;
  whence: ctypes.cint): off_t; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_set_string(sndfile: TSNDFILE_HANDLE; str_type: ctypes.cint;
  str: ctypes.pcchar): ctypes.cint; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_get_string(sndfile: TSNDFILE_HANDLE;
  str_type: ctypes.cint): PChar; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_read_raw(sndfile: TSNDFILE_HANDLE; ptr: Pointer;
  bytes: off_t): off_t; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_write_raw(sndfile: TSNDFILE_HANDLE; ptr: Pointer;
  bytes: off_t): off_t; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_readf_short(sndfile: TSNDFILE_HANDLE; ptr: ctypes.pcshort;
  frames: off_t): off_t; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_writef_short(sndfile: TSNDFILE_HANDLE; ptr: ctypes.pcshort;
  frames: off_t): off_t; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_readf_int(sndfile: TSNDFILE_HANDLE; ptr: ctypes.pcint;
  frames: off_t): off_t; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_writef_int(sndfile: TSNDFILE_HANDLE; ptr: ctypes.pcint;
  frames: off_t): off_t; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_readf_float(sndfile: TSNDFILE_HANDLE; ptr: ctypes.pcfloat;
  frames: off_t): off_t; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_writef_float(sndfile: TSNDFILE_HANDLE; ptr: ctypes.pcfloat;
  frames: off_t): off_t; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_readf_double(sndfile: TSNDFILE_HANDLE; ptr: ctypes.pcdouble;
  frames: off_t): off_t; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_writef_double(sndfile: TSNDFILE_HANDLE; ptr: ctypes.pcdouble;
  frames: off_t): off_t; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_read_short(sndfile: TSNDFILE_HANDLE; ptr: ctypes.pcshort;
  frames: off_t): off_t; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_write_short(sndfile: TSNDFILE_HANDLE; ptr: ctypes.pcshort;
  frames: off_t): off_t; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_read_int(sndfile: TSNDFILE_HANDLE; ptr: ctypes.pcint;
  frames: off_t): off_t; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_write_int(sndfile: TSNDFILE_HANDLE; ptr: ctypes.pcint;
  frames: off_t): off_t; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_read_float(sndfile: TSNDFILE_HANDLE; ptr: ctypes.pcfloat;
  frames: off_t): off_t; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_write_float(sndfile: TSNDFILE_HANDLE; ptr: ctypes.pcfloat;
  frames: off_t): off_t; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function
  sf_read_double(sndfile: TSNDFILE_HANDLE; ptr: ctypes.pcdouble;
  frames: off_t): off_t; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_write_double(sndfile: TSNDFILE_HANDLE; ptr: ctypes.pcdouble;
  frames: off_t): off_t; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_close(sndfile: TSNDFILE_HANDLE): ctypes.cint; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

function sf_write_sync(sndfile: TSNDFILE_HANDLE): ctypes.cint; cdecl; external {$ifndef USE_STATIC_SNDFILE} libname {$endif};

implementation

end.

