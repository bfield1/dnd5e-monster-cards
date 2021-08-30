\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{monster5e}[2021/08/04 Dungeons and Dragons 5e Monster Cards]

\LoadClass[a4paper]{article}
\RequirePackage[landscape,left=1cm,right=1cm,top=0.5cm,bottom=0.5cm]{geometry}
\RequirePackage{fontspec}
\setmainfont{Calibri}
\RequirePackage{etoolbox}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{tikz}
\usetikzlibrary{calc}
\RequirePackage{multicol}
\RequirePackage{xstring}

\setlength{\parindent}{0 pt}

\pagestyle{empty}

\newcommand{\backgroundImage}{} % A first definition so renewcommand works.
\newcommand{\setBackground}[1]{\renewcommand{\backgroundImage}{#1}}

%Set the constants to be used in the card.
\pgfmathsetmacro{\cardwidth}{9.1}
\pgfmathsetmacro{\cardheight}{9.85}
\pgfmathsetmacro{\attributewidth}{8.5}
\pgfmathsetmacro{\bodywidth}{8.0}
\pgfmathsetmacro{\scorecolumnwidth}{\cardwidth/7}
\newcommand{\titlefont}[1][1]{\pgfmathmultiply{18}{#1}\fontsize{\pgfmathresult}{\pgfmathresult}\selectfont}
\newcommand{\sourcefont}[1][1]{\pgfmathmultiply{6}{#1}\fontsize{\pgfmathresult}{\pgfmathresult}\selectfont}
\newcommand{\typefont}[1][1]{\pgfmathmultiply{9}{#1}\fontsize{\pgfmathresult}{\pgfmathresult}\selectfont}
\newcommand{\scorefont}[1][1]{\pgfmathmultiply{10}{#1}\fontsize{\pgfmathresult}{\pgfmathresult}\selectfont}
\newcommand{\bodyfont}[1][1]{\pgfmathmultiply{8}{#1}\fontsize{\pgfmathresult}{\pgfmathresult}\selectfont}
\newcommand{\headerfont}[1][1]{\pgfmathmultiply{10}{#1}\fontsize{\pgfmathresult}{\pgfmathresult}\selectfont}

%Draw the border of the card.
\newcommand{\drawCardBorder}{
	\draw[rounded corners=1.4cm, draw=Plum, line width=3 pt] (0,0) rectangle (\cardwidth,\cardheight);
	\draw[rounded corners=1.4cm - 3pt, draw=Plum, line width=1 pt] (3 pt,3 pt) rectangle (\cardwidth cm-3pt,\cardheight cm-3pt);
}

%Write the title at the top of the card.
\newcommand{\cardTitle}[1]{
	\node (title) [anchor=north, align=center, text width=\attributewidth cm] at (0.5*\cardwidth,\cardheight-0.1) {\titlefont #1};
}

%Write the source of the card in the top right corner
\newcommand{\cardSource}[1]{
	\path let \p1 = (title.south) in node[anchor=north east] at (\cardwidth - 0.6,\y1)
	{\sourcefont{} #1};
}

%Write a subheading, where I put the monster type, size, alignment.
\newcommand{\monsterType}[1]{
	\path let \p1 = (title.south) in node[anchor=north west] (type) at (0.1,\y1)
	{\typefont{} #1};
}

%Converts 'ability score' to 'ability score (+- ability modifier)'
\newcommand{\attnum}[1]{
	#1 (\ifnum #1>9 {+}\fi\pgfmathparse{int(floor((#1-10)/2))}\pgfmathresult)
}

%Draw the table for the monster's ability scores.
%STR, DEX, CON, INT, WIS, CHA
\setlength\tabcolsep{0pt} %Default 6pt
\newcommand{\monsterScores}[6]{
	\path let \p1 = (type.south) in node[anchor=north] (scores) at (0.5*\cardwidth,\y1)
	{
		\scorefont{}
		\begin{tabular}{*{6}{p{\scorecolumnwidth cm}}}
			\textbf{STR} & \textbf{DEX} & \textbf{CON} & \textbf{INT} & \textbf{WIS} & \textbf{CHA} \\
			\attnum{#1} & \attnum{#2} & \attnum{#3} & \attnum{#4} & \attnum{#5} & \attnum{#6}
		\end{tabular}
	};
}

% Function which appends the XP value to CR.
\ExplSyntaxOn
\newcommand{\numtoCR}[1]{
	\str_case:nnTF {#1}
	{
		{0}{0~(10 XP)}
		{1/8}{1/8~(25 XP)}
		{1/4}{1/4~(50 XP)}
		{1/2}{1/2~(100 XP)}
		{1}{1~(200 XP)}
		{2}{2~(450 XP)}
		{3}{3~(700 XP)}
		{4}{4~(1100 XP)}
		{5}{5~(1800 XP)}
		{6}{6~(2300 XP)}
		{7}{7~(2900 XP)}
		{8}{8~(3900 XP)}
		{9}{9~(5000 XP)}
		{10}{10~(5900 XP)}
		{11}{11~(7200 XP)}
		{12}{12~(8400 XP)}
		{13}{13~(10000 XP)}
		{14}{14~(11500 XP)}
		{15}{15~(13000 XP)}
		{16}{16~(15000 XP)}
		{17}{17~(18000 XP)}
		{18}{18~(20000 XP)}
		{19}{19~(22000 XP)}
		{20}{20~(25000 XP)}
		{21}{21~(33000 XP)}
		{22}{22~(41000 XP)}
		{23}{23~(50000 XP)}
		{24}{24~(62000 XP)}
		{25}{25~(75000 XP)}
		{26}{26~(90000 XP)}
		{27}{27~(105000 XP)}
		{28}{28~(120000 XP)}
		{29}{29~(135000 XP)}
		{30}{30~(155000 XP)}
	}
	{}
	{#1}
}
\ExplSyntaxOff

% Keys for \monsterAttributes and also the rest of the card
\pgfkeys{/att/.is family, /att,
	default/.style = {ac=\empty,hp=\empty,speed=\empty,cr=-1,
		skills=\empty,senses=\empty,languages=None,
		damage immunities=\empty,condition immunities=\empty,
		resistances=\empty,saves=\empty,vulnerabilities=\empty,
		scale=1,source=\empty,title=\empty,type=\empty,
		str=0,dex=0,con=0,int=0,wis=0,cha=0},
	ac/.estore in = \attAC,
	hp/.estore in = \attHP,
	speed/.estore in = \attSpd,
	%cr/.estore in = \attCR,
	skills/.estore in = \attSkills,
	senses/.estore in = \attSenses,
	languages/.estore in = \attLang,
	damage immunities/.estore in = \attDImm,
	condition immunities/.estore in = \attCImm,
	resistances/.estore in = \attRes,
	saves/.estore in = \attSave,
	vulnerabilities/.estore in = \attVuln,
	cr/.code = \def\attCR{\numtoCR{#1}},
	scale/.estore in = \fontscale,
	source/.estore in = \attSource,
	title/.estore in = \attTitle,
	type/.estore in = \attType,
	str/.estore in = \attStr,
	dex/.estore in = \attDex,
	con/.estore in = \attCon,
	int/.estore in = \attInt,
	wis/.estore in = \attWis,
	cha/.estore in = \attCha
}

%Block of other attributes (HP, AC, etc.)
\newcommand{\monsterAttributes}[1][]{
	\node (attributes) at (scores.south) [anchor=north, text width=\attributewidth cm] {
		\begin{minipage}{\attributewidth cm}
			\vspace{-4pt}
			\begin{multicols}{2}
				\pgfkeys{/att,default,#1}%
				\typefont[\fontscale]
				\textbf{AC:} \attAC\\
				\textbf{HP:} \attHP\\
				\textbf{Speed:} \attSpd\\
				\IfStrEq{-1}{\attCR}{}{\textbf{CR:} \attCR\\}
				\bodyfont[\fontscale]
				\ifx\empty\attSave\else{\textbf{Saves:} \attSave\\}\fi
				\ifx\empty\attSkills\else{\textbf{Skills:} \attSkills\\}\fi
				\ifx\empty\attRes\else{\textbf{Resistances:} \attRes\\}\fi
				\ifx\empty\attVuln\else{\textbf{Vulnerabilities:} \attVuln\\}\fi
				\ifx\empty\attDImm{\ifx\empty\attCImm\else{\textbf{Immunities:} \textit{Conditions:} \attCImm\\}\fi}\else{\textbf{Immunities:} \textit{Damage:} \attDImm\ifx\empty\attCImm\else{ \textit{Conditions:} \attCImm}\fi\\}\fi
				\ifx\empty\attSenses\else{\textbf{Senses:} \attSenses\\}\fi
				\ifx\empty\attLang\else{\textbf{Languages:} \attLang}\fi
			\end{multicols}	
		\end{minipage}
	};
}

% Style blocks for abilities and attacks
\newcommand{\ability}[2]{\textbf{#1:} #2}
\newcommand{\attack}[4]{\textbf{#1:} \textit{#2 Attack:} #3 \textit{Hit:} #4}
\newcommand{\MeleeAttack}[3]{\attack{#1}{Melee}{#2}{#3}}
\newcommand{\MeleeThrownAttack}[3]{\attack{#1}{Melee or Thrown}{#2}{#3}}
\newcommand{\RangedAttack}[3]{\attack{#1}{Ranged}{#2}{#3}}
\newcommand{\MeleeSpellAttack}[3]{\attack{#1}{Melee Spell}{#2}{#3}}
\newcommand{\RangedSpellAttack}[3]{\attack{#1}{Ranged Spell}{#2}{#3}}
\newcommand{\spells}[2]{\textit{#1:} #2}
% Header, to be used inside \monsterAbilities only.
\newcommand{\abilityheader}[1]{{\headerfont[\fontscale]\pgfmathmultiply{2}{\fontscale}\vspace{\pgfmathresult pt}\underline{#1}\vspace{\pgfmathresult pt}}}
\newcommand{\Actions}{\abilityheader{Actions}}
\newcommand{\BonusActions}{\abilityheader{Bonus Actions}}
\newcommand{\Reactions}{\abilityheader{Reactions}}

% Main body text of monster, listing its abilities.
\newcommand{\monsterAbilities}[2][]{
	\pgfkeys{/att,scale=1,#1}
	\bodyfont[\fontscale]
	\node (abilities) at (attributes.south) [anchor=north, text width=\bodywidth cm] {#2};
}

%Make the card background
\newcommand{\monsterBackground}{\begin{tikzpicture}
	\path (0,0) rectangle (\cardwidth,\cardheight);
	\node at (\cardwidth/2,\cardheight/2) {\includegraphics{\backgroundImage}};
	\end{tikzpicture}}

\newcommand{\sixMonsterBackgrounds}{\monsterBackground\monsterBackground\monsterBackground
	
	\monsterBackground\monsterBackground\monsterBackground}

%Macro for making a whole card
\newcommand{\monsterCard}[2][]{\pgfkeys{/att,default,#1}%
	\begin{tikzpicture}
	\drawCardBorder
	\cardTitle{\attTitle}
	\cardSource{\attSource}
	\monsterType{\attType}
	\monsterScores{\attStr}{\attDex}{\attCon}{\attInt}{\attWis}{\attCha}
	\monsterAttributes[#1]
	\monsterAbilities[#1]{#2}
	\end{tikzpicture}}