
#importonce

.label RomBankSelector  = $DE00

// VIC-II Registers
.label EXTCOL           = $D020

// Keyboard Routines
.label XMAX             = $0289    // Max keyboard buffer size
.label RPTFLG           = $028A    // Which Keys Will Repeat?
.label SCNKEY           = $FF9F    // scan keyboard - kernal routine
.label GETIN            = $ffe4    // read keyboard buffer - kernal routine