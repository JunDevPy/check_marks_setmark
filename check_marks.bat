@echo off
chcp 65001
setlocal
setlocal EnableDelayedExpansion

set input=%~1
set PGPASSWORD=244615244615
set specialChars="'"

:: Проверка, является ли входной параметр файлом или строкой
IF EXIST "%input%" (
    set "file=%input%"
	:: Вывод !file! используется для отладки
    REM echo "FILE --- %input% --- "
) else (
    set "mark=%input%"
	:: Вывод !mark! используется для отладки
    REM echo "MARK --- %input% --- "
    FOR %%C IN (%specialChars%) DO (set "code=!mark:'=''!")
	:: Вывод !code! используется для отладки
    REM echo "PROCESSED STAMP --- !code!"
)

IF NOT "%file%"=="" (
    if defined SET_POSTGRES_BIN (
        for /f "tokens=*" %%i in (%file%) do (
            set input2=%%~i
            :: Вывод !INPUT2! используется для отладки
            REM echo "INPUT2 --- !input2! ---"
            FOR %%C IN (%specialChars%) DO (
                set "cod=!input2:'=''!" 
                :: Вывод !cod! используется для отладки
                REM echo "CYCLE WITH REPLACEMENT --- !cod! ---"
            )
			"%SET_POSTGRES_BIN%\psql.exe" -v gtin='!cod!' -h localhost -p 5432 -U postgres --no-password --dbname set_mark -x -f "%~dp0\query_marks.sql"> NUL
            :: Задержка -Milliseconds 200 в милисекундах после выполнения запроса
            set "delay=300" & @powershell -Command "Start-Sleep -Milliseconds %delay%" > NUL
        )
    ) else (
        echo "Переменная среды SET_POSTGRES_BIN не определена в системе"
    )
)

) ELSE IF NOT "%mark%"=="" (
    if defined SET_POSTGRES_BIN (
        "%SET_POSTGRES_BIN%\psql.exe" -v gtin='!code!' -h localhost -p 5432 -U postgres --no-password --dbname set_mark -x -f "%~dp0\query_marks.sql" > NUL
    ) else (
        echo "Переменная среды SET_POSTGRES_BIN не определена в системе"
    )
) ELSE (
    echo "Укажите путь к файлу с марками или марку : bat_file.bat [file_path | mark]"
)

endlocal
pause



REM @echo off
REM chcp 65001
REM setlocal
REM setlocal EnableDelayedExpansion

REM set input=%~1
REM set PGPASSWORD=244615244615
REM REM set delay=200
REM set specialChars="'"

REM :: Проверка, является ли входной параметр файлом или строкой
REM IF EXIST "%input%" (
    REM set "file=%input%"
	REM :: Вывод !file! используется для отладки
    REM REM echo "FILE --- %input% --- "
REM ) else (
    REM set "mark=%input%"
	REM :: Вывод !mark! используется для отладки
    REM REM echo "MARK --- %input% --- "
    REM FOR %%C IN (%specialChars%) DO (set "code=!mark:'=''!")
	REM :: Вывод !code! используется для отладки
    REM REM echo "PROCESSED STAMP --- !code!"
REM )

REM IF NOT "%file%"=="" (
    REM for /f "tokens=*" %%i in (%file%) do (
		REM set input2=%%~i
		REM :: Вывод !INPUT2! используется для отладки
		REM REM echo "INPUT2 --- !input2! ---"
        REM FOR %%C IN (%specialChars%) DO (
			REM set "cod=!input2:'=''!" 
			REM :: Вывод !cod! используется для отладки
			REM REM echo "CYCLE WITH REPLACEMENT --- !cod! ---"
			REM )
        REM if defined SET_POSTGRES_BIN (
            REM "%SET_POSTGRES_BIN%\psql.exe" -v gtin='!cod!' -h localhost -p 5432 -U postgres --no-password --dbname set_mark -x -f "C:\query_marks.sql"> NUL
			REM :: Задержка -Milliseconds 200 в милисекундах после выполнения запроса
			REM set "delay=300" & @powershell -Command "Start-Sleep -Milliseconds %delay%" > NUL
        REM ) else (s
            REM echo "SET_POSTGRES_BIN is not defined"
        REM )
    REM )
REM ) ELSE IF NOT "%mark%"=="" (
    REM if defined SET_POSTGRES_BIN (
        REM "%SET_POSTGRES_BIN%\psql.exe" -v gtin='!code!' -h localhost -p 5432 -U postgres --no-password --dbname set_mark -x -f "C:\query_marks.sql" > NUL
    REM ) else (
        REM echo "SET_POSTGRES_BIN is not defined"
    REM )
REM ) ELSE (
    REM echo "Укажите путь к файлу с марками или марку : bat_file.bat [file_path | mark]"
REM )

REM endlocal
REM pause
