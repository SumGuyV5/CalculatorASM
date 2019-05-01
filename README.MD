;/************************************************************************
;**  Program Name:   Calculator ASM			      		**
;**  Version Number: V1.0                                     		**
;**  Copyright (C):  September 6, 2010  Richard W. Allen	   	**
;**  Date Started:   September 1, 2010	                      		**
;**  Date Ended:     September 6, 2010    	             		**
;**  Author:         Richard W. Allen                         		**
;**  Webpage:        http://www.richardallenonline.com			**
;**  IDE:            RadASM 3.0.0.7					**
;**  Compiler:	     JWASM 2.03				      		**
;**  Langage:        MASM					     	**
;**  License:	     GNU GENERAL PUBLIC LICENSE Version 2		**
;**		     see license.txt for for details	      		**
;*************************************************************************/

Download gorc from www.godevtool.com
Download JWASM and win32inc from http://www.japheth.de
Download POLink from it is a part of the Pelles development kit http://www.smorgasbordet.com/pellesc/

Download the fpulib from http://www.ray.masmcode.com use the BuildFpulib.bat file to build the libaray with JWASM

add them to you Path system variables
(right Click "My COmputer">"Properties">"Advanced" tab>"Environment Variables">
select "Path" under "System variables">press the "Edit Botton">add the path of to your gorc.exe, JWASM.exe and POLink.exe install)

in the install directory of your win32inc run Comctl32.bat, KERNEL32.bat and USER32.bat

go into the CalculatorASM.inc file and change the include and includelib lines to the install directory of your win32inc install

finally run Build.bat or download RadASM 3.0.0.7 form https://fbedit.svn.sourceforge.net/svnroot/fbedit/RadASM30/Release/RadASM.zip
and open CalculatorASM.prra project file with RadASM.