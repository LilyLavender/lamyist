@echo off
setlocal enabledelayedexpansion

REM check if Labels.txt exists, exit if not
if not exist "Labels.txt" (
    echo Labels.txt not found!
    pause
    exit
)

set "yml_count=0"

for %%F in (%*) do (
    set "input_file=%%~F"
    echo Input file: !input_file!
    set "file_extension="

    REM Get file extension
    for %%x in ("!input_file!") do (
        set "file_extension=%%~xx"
    )

    REM Remove leading dot & convert to lowercase
    set "file_extension=!file_extension:~1!"
    for %%A in (!file_extension!) do set "file_extension=%%A"

    REM Run yamlist cmd
    if /I "!file_extension!"=="bin" (
        set "output_file=!input_file!.yml"
        echo Processing !input_file! as BIN file...
        yamlist disasm "!input_file!" -l Labels.txt -o "!output_file!"
    ) else if /I "!file_extension!"=="yml" (
        set "output_file=!input_file!.bin"
        echo Processing !input_file! as YML file...
        yamlist asm "!input_file!" -o "!output_file!"
        set /a yml_count+=1
    ) else if /I "!file_extension!"=="yaml" ( REM ⎛⎝(•ⱅ•)⎠⎞ 
        set "output_file=!input_file!.bin"
        echo Processing !input_file! as YAML file...
        yamlist asm "!input_file!" -o "!output_file!"
        set /a yml_count+=1
    ) else (
        echo Unsupported file type: !input_file!
    )
)

if !yml_count! gtr 0 (
    echo Arcropolis does not require .yml files to be converted back to bin... yamlist converted !yml_count! yml files nonetheless.
)

endlocal
pause
