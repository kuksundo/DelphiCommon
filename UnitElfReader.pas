unit UnitElfReader;

interface

uses
  SysUtils, StrUtils, Classes;

type
  // Define an enumeration for ABI values
  TElfABI = (
    ABI_SystemV = $00,
    ABI_HPUX = $01,
    ABI_NetBSD = $02,
    ABI_Linux = $03,
    ABI_GNUHurd = $04,
    ABI_Solaris = $06,
    ABI_AIX = $07,
    ABI_IRIX = $08,
    ABI_FreeBSD = $09,
    ABI_Tru64 = $0A,
    ABI_NovellModesto = $0B,
    ABI_OpenBSD = $0C,
    ABI_OpenVMS = $0D,
    ABI_NonStopKernel = $0E,
    ABI_AROS = $0F,
    ABI_FenixOS = $10,
    ABI_NuxiCloudABI = $11,
    ABI_OpenVOS = $12
  );

  // Define an enumeration for ELF file types
  TElfType = (
    ET_NONE = $00,      // Unknown
    ET_REL = $01,       // Relocatable file
    ET_EXEC = $02,      // Executable file
    ET_DYN = $03,       // Shared object
    ET_CORE = $04,      // Core file
    ET_LOOS = $FE00,    // Operating system specific (low range)
    ET_HIOS = $FEFF,    // Operating system specific (high range)
    ET_LOPROC = $FF00,  // Processor specific (low range)
    ET_HIPROC = $FFFF   // Processor specific (high range)
  );

  // Define an enumeration for ISA values : Instruction Set Architecture
  TElfISA = (
    ISA_None = $00,                         // No specific instruction set
    ISA_ATTWE32100 = $01,                   // AT&T WE 32100
    ISA_SPARC = $02,                        // SPARC
    ISA_x86 = $03,                          // x86
    ISA_Motorola68000 = $04,                // Motorola 68000 (M68k)
    ISA_Motorola88000 = $05,                // Motorola 88000 (M88k)
    ISA_IntelMCU = $06,                     // Intel MCU
    ISA_Intel80860 = $07,                   // Intel 80860
    ISA_MIPS = $08,                         // MIPS
    ISA_IBMSystem370 = $09,                 // IBM System/370
    ISA_MIPS_RS3000_LE = $0A,               // MIPS RS3000 Little-endian
    ISA_HP_PA_RISC = $0F,                   // Hewlett-Packard PA-RISC
    ISA_Intel80960 = $13,                   // Intel 80960
    ISA_PowerPC = $14,                      // PowerPC
    ISA_PowerPC64 = $15,                    // PowerPC (64-bit)
    ISA_S390 = $16,                         // S390, including S390x
    ISA_IBM_SPU_SPC = $17,                  // IBM SPU/SPC
    ISA_NEC_V800 = $24,                     // NEC V800
    ISA_FujitsuFR20 = $25,                  // Fujitsu FR20
    ISA_TRW_RH32 = $26,                     // TRW RH-32
    ISA_MotorolaRCE = $27,                  // Motorola RCE
    ISA_ARM = $28,                          // Arm (up to Armv7/AArch32)
    ISA_DigitalAlpha = $29,                 // Digital Alpha
    ISA_SuperH = $2A,                       // SuperH
    ISA_SPARC_Version_9 = $2B,              // SPARC Version 9
    ISA_SiemensTriCore = $2C,               // Siemens TriCore embedded processor
    ISA_ArgonautRISC = $2D,                 // Argonaut RISC Core
    ISA_HitachiH8_300 = $2E,                // Hitachi H8/300
    ISA_HitachiH8_300H = $2F,               // Hitachi H8/300H
    ISA_HitachiH8S = $30,                   // Hitachi H8S
    ISA_HitachiH8_500 = $31,                // Hitachi H8/500
    ISA_IA64 = $32,                         // IA-64
    ISA_StanfordMIPS_X = $33,               // Stanford MIPS-X
    ISA_MotorolaColdFire = $34,             // Motorola ColdFire
    ISA_MotorolaM68HC12 = $35,              // Motorola M68HC12
    ISA_FujitsuMMA = $36,                   // Fujitsu MMA Multimedia Accelerator
    ISA_SiemensPCP = $37,                   // Siemens PCP
    ISA_SonynCPU = $38,                     // Sony nCPU embedded RISC processor
    ISA_DensoNDR1 = $39,                    // Denso NDR1 microprocessor
    ISA_MotorolaStarCore = $3A,             // Motorola Star*Core processor
    ISA_ToyotaME16 = $3B,                   // Toyota ME16 processor
    ISA_STMicroST100 = $3C,                 // STMicroelectronics ST100 processor
    ISA_ALCTinyJ = $3D,                     // Advanced Logic Corp. TinyJ
    ISA_AMDx86_64 = $3E,                    // AMD x86-64
    ISA_SonyDSP = $3F,                      // Sony DSP Processor
    ISA_PDP10 = $40,                        // DEC PDP-10
    ISA_PDP11 = $41,                        // DEC PDP-11
    ISA_SiemensFX66 = $42,                  // Siemens FX66
    ISA_STMicroST9Plus = $43,               // STMicroelectronics ST9+ 8/16 bit microcontroller
    ISA_STMicroST7 = $44,                   // STMicroelectronics ST7 8-bit microcontroller
    ISA_MC68HC16 = $45,                     // Motorola MC68HC16 Microcontroller
    ISA_MC68HC11 = $46,                     // Motorola MC68HC11 Microcontroller
    ISA_MC68HC08 = $47,                     // Motorola MC68HC08 Microcontroller
    ISA_MC68HC05 = $48,                     // Motorola MC68HC05 Microcontroller
    ISA_SGIsvx = $49,                       // Silicon Graphics SVx
    ISA_STMicroST19 = $4A,                  // STMicroelectronics ST19 8-bit microcontroller
    ISA_DigitalVAX = $4B,                   // Digital VAX
    ISA_Axis32 = $4C,                       // Axis Communications 32-bit embedded processor
    ISA_Infineon32 = $4D,                   // Infineon Technologies 32-bit embedded processor
    ISA_Element14_64DSP = $4E,              // Element 14 64-bit DSP Processor
    ISA_LSI16DSP = $4F,                     // LSI Logic 16-bit DSP Processor
    ISA_TMS320C6000 = $8C,                  // TMS320C6000 Family
    ISA_ElbrusE2k = $AF,                    // MCST Elbrus e2k
    ISA_ARMv8 = $B7,                        // Arm 64-bits (Armv8/AArch64)
    ISA_ZilogZ80 = $DC,                     // Zilog Z80
    ISA_RISCV = $F3,                        // RISC-V
    ISA_BerkeleyPacketFilter = $F7,         // Berkeley Packet Filter
    ISA_WDC65C816 = $101,                   // WDC 65C816
    ISA_LoongArch = $102                    // LoongArch
  );

  TElfHeader = record
    Magic: array[0..3] of Byte; // ELF magic number: 0x7F, 'E', 'L', 'F'
    ClassType: Byte;           // 1 = 32-bit, 2 = 64-bit
    DataEncoding: Byte;        // 1 = Little-endian, 2 = Big-endian
    Version: Byte;             // File format version (always 1)
    OSABI: Byte;               // Target operating system ABI(Application Binary Interface)
    ABIVersion: Byte;          // ABI version
    Padding: array[0..6] of Byte;
  end;

  TElf32Header = packed record
    Ident: array[0..15] of Byte; // ELF Identification
    Type_: Word;                // Object file type
    Machine: Word;              // Machine type
    Version: Cardinal;          // Object file version
    Entry: Cardinal;            // Entry point address
    Phoff: Cardinal;            // Program header offset
    Shoff: Cardinal;            // Section header offset
    Flags: Cardinal;            // Processor-specific flags
    Ehsize: Word;               // ELF header size
    Phentsize: Word;            // Program header entry size
    Phnum: Word;                // Number of program header entries
    Shentsize: Word;            // Section header entry size
    Shnum: Word;                // Number of section header entries
    Shstrndx: Word;             // Section header string table index
  end;

  // Define the ELF64 header structure
  TElf64Header = packed record
    Ident: array[0..15] of Byte; // ELF Identification
    Type_: Word;                // Object file type
    Machine: Word;              // Machine type
    Version: Cardinal;          // Object file version
    Entry: UInt64;              // Entry point address
    Phoff: UInt64;              // Program header offset
    Shoff: UInt64;              // Section header offset
    Flags: Cardinal;            // Processor-specific flags
    Ehsize: Word;               // ELF header size
    Phentsize: Word;            // Program header entry size
    Phnum: Word;                // Number of program header entries
    Shentsize: Word;            // Section header entry size
    Shnum: Word;                // Number of section header entries
    Shstrndx: Word;             // Section header string table index
  end;

function ReadElfFileInfo(const FileName: string): TElfHeader;
function ReadElf32Header(const FileName: string): TElf32Header;
function ReadElf64Header(const FileName: string): TElf64Header;

// Function to convert TElfABI value to a readable string
function ABIToString(ABI: TElfABI): string;
// Function to convert TElfType value to a readable string
function ElfTypeToString(FileType: Word): string;
// Function to convert ISA value to string
function ISAToString(ISA: TElfISA): string;

implementation

function ABIToString(ABI: TElfABI): string;
begin
  case ABI of
    ABI_SystemV: Result := 'System V';
    ABI_HPUX: Result := 'HP-UX';
    ABI_NetBSD: Result := 'NetBSD';
    ABI_Linux: Result := 'Linux';
    ABI_GNUHurd: Result := 'GNU Hurd';
    ABI_Solaris: Result := 'Solaris';
    ABI_AIX: Result := 'AIX (Monterey)';
    ABI_IRIX: Result := 'IRIX';
    ABI_FreeBSD: Result := 'FreeBSD';
    ABI_Tru64: Result := 'Tru64';
    ABI_NovellModesto: Result := 'Novell Modesto';
    ABI_OpenBSD: Result := 'OpenBSD';
    ABI_OpenVMS: Result := 'OpenVMS';
    ABI_NonStopKernel: Result := 'NonStop Kernel';
    ABI_AROS: Result := 'AROS';
    ABI_FenixOS: Result := 'FenixOS';
    ABI_NuxiCloudABI: Result := 'Nuxi CloudABI';
    ABI_OpenVOS: Result := 'Stratus Technologies OpenVOS';
  else
    Result := 'Unknown ABI';
  end;
end;

function ElfTypeToString(FileType: Word): string;
begin
  case FileType of
    Ord(ET_NONE): Result := 'Unknown';
    Ord(ET_REL): Result := 'Relocatable file';
    Ord(ET_EXEC): Result := 'Executable file';
    Ord(ET_DYN): Result := 'Shared object';
    Ord(ET_CORE): Result := 'Core file';
    Ord(ET_LOOS): Result := 'Operating system specific (low range)';
    Ord(ET_HIOS): Result := 'Operating system specific (high range)';
    Ord(ET_LOPROC): Result := 'Processor specific (low range)';
    Ord(ET_HIPROC): Result := 'Processor specific (high range)';
  else
    Result := 'Invalid or Unknown Type';
  end;
end;

function ISAToString(ISA: TElfISA): string;
begin
  case ISA of
    ISA_None: Result := 'No specific instruction set';
    ISA_ATTWE32100: Result := 'AT&T WE 32100';
    ISA_SPARC: Result := 'SPARC';
    ISA_x86: Result := 'x86';
    ISA_Motorola68000: Result := 'Motorola 68000 (M68k)';
    ISA_Motorola88000: Result := 'Motorola 88000 (M88k)';
    ISA_IntelMCU: Result := 'Intel MCU';
    ISA_Intel80860: Result := 'Intel 80860';
    ISA_MIPS: Result := 'MIPS';
    ISA_IBMSystem370: Result := 'IBM System/370';
    ISA_MIPS_RS3000_LE: Result := 'MIPS RS3000 Little-endian';
    ISA_HP_PA_RISC: Result := 'Hewlett-Packard PA-RISC';
    ISA_Intel80960: Result := 'Intel 80960';
    ISA_PowerPC: Result := 'PowerPC';
    ISA_PowerPC64: Result := 'PowerPC (64-bit)';
    ISA_S390: Result := 'S390, including S390x';
    ISA_ARM: Result := 'ARM';
    ISA_RISCV: Result := 'RISC-V';
  else
    Result := 'Unknown';
  end;
end;

function ReadElfFileInfo(const FileName: string): TElfHeader;
var
  FileStream: TFileStream;
//  ElfHeader: TElfHeader;
begin
  if not FileExists(FileName) then
  begin
    Writeln('File not found: ' + FileName);
    Exit;
  end;

  FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    // Read the ELF header
    FileStream.ReadBuffer(Result, SizeOf(TElfHeader));

    // Validate ELF magic number
    if (Result.Magic[0] = $7F) and
       (Result.Magic[1] = Ord('E')) and
       (Result.Magic[2] = Ord('L')) and
       (Result.Magic[3] = Ord('F')) then
    begin
//      Writeln('Valid ELF file detected.');
//      Writeln('Class: ', IfThen(Result.ClassType = 1, '32-bit', '64-bit'));
//      Writeln('Data Encoding: ', IfThen(Result.DataEncoding = 1, 'Little-endian', 'Big-endian'));
//      Writeln('Version: ', Result.Version);
//      Writeln('OS ABI: ', Result.OSABI);
//      Writeln('ABI Version: ', Result.ABIVersion);
    end
    else
      Writeln('Not a valid ELF file.');
  finally
    FileStream.Free;
  end;
end;

function ReadElf32Header(const FileName: string): TElf32Header;
var
  FileStream: TFileStream;
//  ElfHeader: TElf32Header;
  I: Integer;
begin
  FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    // Read the ELF header
    FileStream.ReadBuffer(Result, SizeOf(TElf32Header));

//    // Print ELF Identification (magic number)
//    Write('ELF Identification: ');
//    for I := 0 to 3 do
//      Write(Chr(Result.Ident[I]));
//    Writeln;
//
//    // Print ELF file type
//    Writeln('File Type: ', Result.Type_);
//    // Print Machine type
//    Writeln('Machine: ', Result.Machine);
//    // Print Entry point address
//    Writeln('Entry Point Address: $', IntToHex(Result.Entry, 8));
//    // Print Program Header Offset
//    Writeln('Program Header Offset: ', Result.Phoff);
//    // Print Section Header Offset
//    Writeln('Section Header Offset: ', Result.Shoff);
//    // Print Number of Section Headers
//    Writeln('Number of Section Headers: ', Result.Shnum);
  finally
    FileStream.Free;
  end;
end;

function ReadElf64Header(const FileName: string): TElf64Header;
var
  FileStream: TFileStream;
//  ElfHeader: TElf64Header;
  I: Integer;
begin
  FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    // Read the ELF header
    FileStream.ReadBuffer(Result, SizeOf(TElf64Header));

//    // Print ELF Identification (magic number)
//    Write('ELF Identification: ');
//    for I := 0 to 3 do
//      Write(Chr(Result.Ident[I]));
//    Writeln;
//
//    // Validate ELF magic number
//    if (Result.Ident[0] <> $7F) or
//       (Chr(Result.Ident[1]) <> 'E') or
//       (Chr(Result.Ident[2]) <> 'L') or
//       (Chr(Result.Ident[3]) <> 'F') then
//    begin
//      Writeln('Error: Not a valid ELF file.');
//      Exit;
//    end;
//
//    // Print ELF file class (32-bit or 64-bit)
//    case Result.Ident[4] of
//      1: Writeln('Class: 32-bit');
//      2: Writeln('Class: 64-bit');
//    else
//      Writeln('Class: Unknown');
//    end;
//
//    // Print ELF data encoding
//    case Result.Ident[5] of
//      1: Writeln('Data Encoding: Little-endian');
//      2: Writeln('Data Encoding: Big-endian');
//    else
//      Writeln('Data Encoding: Unknown');
//    end;
//
//    // Print ELF file type
//    Writeln('File Type: ', Result.Type_);
//    // Print Machine type
//    Writeln('Machine: ', Result.Machine);
//    // Print Entry point address
//    Writeln('Entry Point Address: $', IntToHex(Result.Entry, 16));
//    // Print Program Header Offset
//    Writeln('Program Header Offset: ', Result.Phoff);
//    // Print Section Header Offset
//    Writeln('Section Header Offset: ', Result.Shoff);
//    // Print Number of Section Headers
//    Writeln('Number of Section Headers: ', Result.Shnum);
//    // Print String Table Index
//    Writeln('Section Header String Table Index: ', Result.Shstrndx);
  finally
    FileStream.Free;
  end;
end;

end.
