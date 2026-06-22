@echo off
REM Slopnought — Windows polyglot wrapper for hook scripts
REM Routes to the appropriate session-start script based on agent detection.

setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "PLUGIN_ROOT=%SCRIPT_DIR%.."

if "%~1"=="session-start" (
    if defined COPILOT_CLI (
        if not defined CLAUDE_PLUGIN_ROOT (
            goto :run_session_start
        )
    )
    goto :run_session_start
)

if "%~1"=="session-start-codex" (
    goto :run_session_start_codex
)

echo Unknown hook: %~1 >&2
exit /b 1

:run_session_start
REM Try bash first (Git Bash / WSL), fall back to Python
where bash >nul 2>&1
if %errorlevel%==0 (
    bash "%SCRIPT_DIR%session-start"
    goto :eof
)
where python >nul 2>&1
if %errorlevel%==0 (
    python "%SCRIPT_DIR%session-start.py"
    goto :eof
)
echo No bash or python found for session-start hook >&2
exit /b 1

:run_session_start_codex
where bash >nul 2>&1
if %errorlevel%==0 (
    bash "%SCRIPT_DIR%session-start-codex"
    goto :eof
)
where python >nul 2>&1
if %errorlevel%==0 (
    python "%SCRIPT_DIR%session-start-codex.py"
    goto :eof
)
echo No bash or python found for session-start-codex hook >&2
exit /b 1
