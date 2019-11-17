\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\ProvidesClass{universityreport}[2019/11/11 University report class by Ilya Sheprut @optozorax]
\LoadClass[a4paper,
	fontsize=14pt,
	headings=small,
	listof=leveldown, % Затем можно использовать \listoffigures\listoftables
	chapterentrydots=true, % В содержании включаются точки между названием главы и номером страницы, где она находится
	numbers=endperiod, % В конце чисел в разных частях форматирования ставятся точки
	%chapterprefix=true,
	%draft,
]{scrreprt}

%------------------------------------------------------------------------------
%            СЕКЦИЯ ОПЦИЙ: \documentclass[option1, option2]{diploma}
	%% Global indentation option
\newif\if@gost\@gostfalse
	\DeclareOption{gost}{
		\@gosttrue
	}
\ProcessOptions\relax

%------------------------------------------------------------------------------
%                               НАСТРОЙКА ШРИФТОВ

% Для распознавания компиляции через xelatex \ifxetex
\RequirePackage{ifxetex}

% Стандартный пакет для русского языка
\RequirePackage[russian]{babel}

\if@gost
	\ifxetex
		% Устанавливаем Times New Roman как шрифт по умолчанию, а далее самые стандартные шрифты
		\RequirePackage{fontspec}
		\defaultfontfeatures{Ligatures={TeX}}
		\setmainfont{Times New Roman}
		\setsansfont{Arial}
		\setmonofont{Courier New}
	\else
		% Запрещено компилировать, потому что должен быть шрифт Times New Roman
		\errmessage{You must use XeLaTeX to compile this document}
	\fi
\else
	\ifxetex
		% Компилируется xelatex'ом
		% В документе будет использоваться стандартный шрифт TeX'а с поддержкой русского языка
		\RequirePackage{fontspec}
		\setmainfont[
			Ligatures=TeX,
			Extension=.otf,
			BoldFont=cmunbx,
			ItalicFont=cmunti,
			BoldItalicFont=cmunbi,
		]{cmunrm}
		\setsansfont{Source Sans Pro} % Установите этот шрифт, раскомментируйте эту строку, закомментируйте Arial
		% \setsansfont{Arial}
		\setmonofont{Consolas}
		% CMU Typewriter Text
		\RequirePackage{polyglossia}
		\setdefaultlanguage{russian}
		\setotherlanguage{english}
	\else
		% Компилируется pdflatex'ом
		\RequirePackage[utf8]{inputenc}
	\fi
\fi

%------------------------------------------------------------------------------
%                                 НАСТРОЙКА ПОЛЕЙ

\if@gost
	% Поля: правое – 10 мм, верхнее – 20 мм, нижнее – 20 мм, левое – не менее 30 мм
	\RequirePackage[left=3cm,top=2cm,right=1cm,bottom=2cm,includefoot]{geometry}
\else
	% С более мелкими полями выглядит красивей
	\RequirePackage[left=1cm,top=1cm,right=1cm,bottom=1cm,includefoot]{geometry}
\fi

%------------------------------------------------------------------------------
%                                 НАСТРОЙКА ТЕКСТА

\if@gost
	% Полуторный интервал (без него выглядит красивей)
	\linespread{1.25} % Reason: the standard line skip means a factor of 1.2 (such as font height 10pt, base line skip 12pt). Multiply with \linespread, so you get 1.25*1.2 = 1.5, so one-half. https://latex.org/forum/viewtopic.php?t=28685
\fi

% Избавляемся от переполнений строки
\sloppy
% Запрещаем разрыв страницы после первой строки абзаца
\clubpenalty=10000
% Запрещаем разрыв страницы после последней строки абзаца
\widowpenalty=10000

% Чтобы у первого абазаца был отступ и определённого размера
\RequirePackage{indentfirst} % Красная строка
\setlength{\parindent}{1cm}  % Отступ для абзаца

% Отступ для абзаца, не работает
% \setlength{\parindent}{1cm}

%------------------------------------------------------------------------------
%                           НАСТРОЙКА CHAPTER, SECTION

% Делает chapter, section жирными, по центру, и нужного размера
\if@gost
	\RedeclareSectionCommand[beforeskip=0cm,tocnumwidth=1cm,font={\fontsize{18pt}{21.6pt}}]{chapter}
	\RedeclareSectionCommand[tocnumwidth=1cm,font={\fontsize{16pt}{19.2pt}}]{section}
\else
	\RedeclareSectionCommand[beforeskip=0cm,tocnumwidth=1cm,font={\Large}]{chapter}
	\RedeclareSectionCommand[tocnumwidth=1cm,font={\large}]{section}
\fi

% Chapter теперь по центру
\let\raggedchapter\centering
\if@gost
	% А ещё section и subsubsection итд
	\let\raggedsection\centering
\fi

\if@gost
	% Делает шрифты в chapter, section с засечками
	\setkomafont{disposition}{\bfseries}
\else
	% Делает шрифт в оглавлении жирным и с засечками, но не при объявлении заголвка
	\setkomafont{chapterentry}{\rmfamily\bfseries}
\fi

% chapter и section теперь написано в КАПСЕ
% https://tex.stackexchange.com/questions/234801/uppercase-chapter-with-koma-script
\addtokomafont{chapter}{\MakeUppercase}
\addtokomafont{section}{\MakeUppercase}

%------------------------------------------------------------------------------
%                   НАСТРОЙКА BEGIN{TABLE, FIGURE, EQUATION

% Чтобы отступ от и до формулы был равен одной строке
\RequirePackage{amsmath}
\makeatletter
	\AtBeginDocument{
		\setlength{\belowdisplayskip}{14pt} \setlength{\belowdisplayshortskip}{14pt}
		\setlength{\abovedisplayskip}{-7pt} \setlength{\abovedisplayshortskip}{-7pt}
	}
\makeatother

% Для задания заголовка таблиц и рисунков
\RequirePackage{caption}

% Параметры названия для иллюстраций (Рисунок 1 - <название>)
\DeclareCaptionLabelFormat{PictureCaptionFormat}{Рисунок {#2}}
\captionsetup[figure] {
	labelformat=PictureCaptionFormat,
	skip=0pt,
	format=hang,
	justification=raggedright,
	labelsep=endash
}

% Параметры названия для таблиц (Таблица 1 - <название>)
\DeclareCaptionLabelFormat{TableCaptionFormat}{Таблица {#2}}
\captionsetup[table] {
	labelformat=TableCaptionFormat,
	skip=0pt,
	format=hang,
	justification=raggedright,
	singlelinecheck=off,
	labelsep=endash
}

%\RequirePackage{stackengine}
\setlength\intextsep{0mm}

\RequirePackage{float}

% Создаём специальные окружения, создающие таблицы и рисунки по ГОСТу
\RequirePackage{environ}
\NewEnviron{gosttable}[2]{%
	\vspace{21pt}% 14pt * 1.5 = 21pt
	\begin{table}[H]
		\caption{#1}
		\label{#2}
		\centering
		\BODY
	\end{table}%
	\vspace{14pt}% А здесь полуторный интервал уже применился как отступ перед абзацем
}
\NewEnviron{gostimage}[2]{%
	\vspace{21pt}% 14pt * 1.5 = 21pt
	\begin{figure}[H]
		\centering
		\BODY
		\caption{#1}
		\label{#2}
	\end{figure}%
	\vspace{14pt}% А здесь полуторный интервал уже применился как отступ перед абзацем
}

%------------------------------------------------------------------------------
%                                ПРОЧИЕ НАСТРОЙКИ

% Чтобы в оглавлении pdf были ссылки
\RequirePackage[hidelinks, unicode=true, bookmarksnumbered=true]{hyperref}
\makeatletter
	% Добавляем точки после "Глава N" в оглавлении PDF
	\renewcommand{\Hy@numberline}[1]{#1. }
\makeatother

% Надо вставить где-то внутри текста, но не перед \tableofcontents. Фиксит баг, что при первом использовании texttt или textsf у них имеется какой-то идиотский большой отступ. По сути это костыль, я не разобрался в первопричине почему так происходит.
\newcommand{\fixTexttTextscSpaceBug}{\vphantom{\hphantom{\texttt{}\textsf{}}}}

%------------------------------------------------------------------------------
%                            ПЕРЕОПРЕДЕЛЕНИЕ НАЗВАНИЙ

\addto\captionsrussian{\renewcommand{\abstractname}{Аннотация}}
\addto\captionsrussian{\renewcommand{\appendixname}{Приложение}}
\addto\captionsrussian{\renewcommand{\bibname}{Список литературы}}
\addto\captionsrussian{\renewcommand{\chaptername}{Глава}}
\addto\captionsrussian{\renewcommand{\contentsname}{Оглавление}}
\addto\captionsrussian{\renewcommand{\figurename}{Рисунок}}
\addto\captionsrussian{\renewcommand{\indexname}{Предметный указатель}}
\addto\captionsrussian{\renewcommand{\listfigurename}{Список рисунков}}
\addto\captionsrussian{\renewcommand{\listtablename}{Список таблиц}}
\addto\captionsrussian{\renewcommand{\tablename}{Таблица}}

\endinput