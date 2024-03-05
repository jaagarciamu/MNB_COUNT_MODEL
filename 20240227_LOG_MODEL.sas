proc import datafile='/home/u47420890/LOG_models/DATA_SAS_NOEST_LOG_VAL2.xlsx' 
		out=DATA_BASE_SAS_AÑO dbms=XLSX replace;
run;


/* RESULTADOS EN EXCEL*/
ODS TAGSETS.EXCELXP
file='/home/u47420890/LOG_models/00_RESULTADOS_MODELOS.xls'
STYLE=Statistical
OPTIONS ( 
FitToPage = 'yes'
Pages_FitWidth = '1'
Pages_FitHeight = '100'
sheet_interval='NONE'
sheet_interval="none"
sheet_name='Bogota' );

/* Modelo 1. Bogota Multivariado */
proc glimmix data=DATA_BASE_SAS_AÑO (where=((TIPO ="PDO" OR TIPO ="INJ" OR TIPO ="FAT")AND (YEAR=2015 OR YEAR=2016 OR YEAR=2017 OR YEAR=2018))) method= laplace PLOTS=residualpanel;
class YEAR TIPO CORRIDOR (ref=first);
model RESP = TIPO TIPO*LOG_ADTPH TIPO*P_MOTO TIPO*P_BUS TIPO*P_TRUCK TIPO*VELSD TIPO*CURV TIPO*INT TIPO*SIGINT TIPO*SIDWAL TIPO*BUSRO /noint s dist=negbinomial;
random int / subject=CORRIDOR TYPE=UNR solution;
COVTEST 'likelihood RT H: phi = 0 ' 0/ est;
output out=PRED_BOG_MULT (where=(VALIDACION ="TEST")) pred=prob_BOG_MUL pred(ilink)=pred_BOG_MUL pred(ilink noblup)=fix_BOG_MUL;
run;

/* Modelo 2. TRONCAL */
ods tagsets.excelxp options(sheet_interval="none" sheet_name='TRONCAL');
proc glimmix data=DATA_BASE_SAS_AÑO (where=((TIPO ="PDO" OR TIPO ="INJ" OR TIPO ="FAT") AND (TRON=1) AND (YEAR=2015 OR YEAR=2016 OR YEAR=2017 OR YEAR=2018))) method=laplace plots=residualpanel;
class YEAR TIPO SEC_TRON (ref=first);
model RESP =TIPO TIPO*LOG_ADTPH TIPO*P_MOTO TIPO*P_BUS TIPO*P_TRUCK TIPO*VELSD TIPO*CURV TIPO*INT TIPO*SIGINT TIPO*BUSRO TIPO*COMUS /noint s dist=negbinomial;
random int / subject= SEC_TRON  TYPE=UNR solution;
COVTEST 'likelihood RT H: phi = 0 ' 0/ est;
output out=PRED_TRON_MULT (where=(VALIDACION ="TEST")) pred=prob_TRON_MUL pred(ilink)=pred_TRON_MUL pred(ilink noblup)=fix_TRON_MUL;
run;

/* Modelo 1. CARRIL PREFERENCIAL */
ods tagsets.excelxp options(sheet_interval="none" sheet_name='CARRILES');
proc glimmix data=DATA_BASE_SAS_AÑO (where=((TIPO ="PDO" OR TIPO ="INJ" OR TIPO ="FAT") AND (LINE_PRE=1) AND (YEAR=2015 OR YEAR=2016 OR YEAR=2017 OR YEAR=2018))) method=laplace plots=residualpanel;
class YEAR TIPO SEC_LINE (ref=first);
model RESP =TIPO TIPO*LOG_ADTPH TIPO*P_TRUCK TIPO*VEL TIPO*VELSD TIPO*GRAD TIPO*PAV TIPO*INT TIPO*SIGINT TIPO*BUSRO /noint s dist=negbinomial;
COVTEST 'likelihood RT H: phi = 0 ' 0/ est;
output out=PRED_PREF_MULT (where=(VALIDACION ="TEST")) pred=prob_PREF_MUL pred(ilink)=pred_PREF_MUL pred(ilink noblup)=fix_PREF_MUL;
run;
ods tagsets.excelxp close;




/*GRAFICAS DE REGRESIONES */
	/* Modelo 1. Bogota Multivariado */
ods graphics / reset=index imagename='011_RESULT_RESIDUAL_ARTERIAL' imagefmt=JPEG;
ods listing gpath="/home/u47420890/LOG_models/RESULT_GRAF";
proc glimmix data=DATA_BASE_SAS_AÑO (where=((TIPO ="PDO" OR TIPO ="INJ" OR TIPO ="FAT")AND (YEAR=2015 OR YEAR=2016 OR YEAR=2017 OR YEAR=2018))) method=laplace PLOTS=residualpanel;
class YEAR TIPO CORRIDOR (ref=first);
model RESP =TIPO TIPO*LOG_ADTPH TIPO*P_MOTO TIPO*P_BUS TIPO*P_TRUCK TIPO*VELSD TIPO*CURV TIPO*INT TIPO*SIGINT TIPO*SIDWAL TIPO*BUSRO /noint s dist=negbinomial;
random int / subject=CORRIDOR TYPE=UNR solution;
run;
ods graphics off;
ods listing close;
/* Modelo 2. TRONCAL */
ods graphics / reset=index imagename='021_RESULT_RESIDUAL_TRONCAL' imagefmt=JPEG;
ods listing gpath="/home/u47420890/LOG_models/RESULT_GRAF";
proc glimmix data=DATA_BASE_SAS_AÑO (where=((TIPO ="PDO" OR TIPO ="INJ" OR TIPO ="FAT")AND (TRON=1) AND (YEAR=2015 OR YEAR=2016 OR YEAR=2017 OR YEAR=2018))) method=laplace plots=residualpanel;
class YEAR TIPO SEC_TRON (ref=first);
model RESP =TIPO TIPO*LOG_ADTPH TIPO*P_MOTO TIPO*P_BUS TIPO*P_TRUCK TIPO*VELSD TIPO*CURV TIPO*INT TIPO*SIGINT TIPO*BUSRO TIPO*COMUS /noint s dist=negbinomial;
random int / subject= SEC_TRON  TYPE=UNR solution;
run;
ods graphics off;
ods listing close;
/* Modelo 3. CARRIL PREFERENCIAL */
ods graphics / reset=index imagename='031_RESULT_RESIDUAL_CARRIL' imagefmt=JPEG;
ods listing gpath="/home/u47420890/LOG_models/RESULT_GRAF";
proc glimmix data=DATA_BASE_SAS_AÑO (where=((TIPO ="PDO" OR TIPO ="INJ" OR TIPO ="FAT")AND (LINE_PRE=1) AND (YEAR=2015 OR YEAR=2016 OR YEAR=2017 OR YEAR=2018))) method=laplace plots=residualpanel;
class YEAR TIPO SEC_LINE (ref=first);
model RESP =TIPO TIPO*LOG_ADTPH TIPO*P_TRUCK TIPO*VEL TIPO*VELSD TIPO*GRAD TIPO*PAV TIPO*INT TIPO*SIGINT TIPO*BUSRO /noint s dist=negbinomial;
run;
ods graphics off;
ods listing close;






/* EXPORTAR RESULTADOS */
proc export data=PRED_BOG_MULT
     outfile="/home/u47420890/LOG_models/RESULT_GRAF/014_PRED_BOG_MULT.xlsx"  dbms=xlsx ;
run;
proc export data=PRED_TRON_MULT
     outfile="/home/u47420890/LOG_models/RESULT_GRAF/024_PRED_TRON_MULT.xlsx"  dbms=xlsx ;
run;
proc export data=PRED_PREF_MULT
     outfile="/home/u47420890/LOG_models/RESULT_GRAF/034_PRED_PREF_MULT.xlsx"  dbms=xlsx ;
run;







/* GRAFICOS DISPERSION*/
/* MODELO BINOMIAL NEGATIVO MULTIVARIADO BOGOTA */
ods graphics / reset=index imagename='015_RESULT_RESIDUAL_ARTERIAL' imagefmt=JPEG;
ods listing gpath="/home/u47420890/LOG_models/RESULT_GRAF";
proc reg data=PRED_BOG_MULT;
   ods output fitstatistics=fs ParameterEstimates=c;
   model pred_BOG_MUL = RESP2;
run;
ods graphics off;
ods listing close;
data _null_;
   set fs;
   if _n_ = 1 then call symputx('R2'  , put(nvalue2, 4.2)   , 'G');
run;
ods graphics / reset=index imagename='012_DISPERSION_BOGOTA' imagefmt=JPEG;
ods listing gpath="/home/u47420890/LOG_models/RESULT_GRAF";
PROC SGPLOT DATA = PRED_BOG_MULT ;
ods graphics on / width=6.5in height=6.5in;
  scatter x=RESP2 y=pred_BOG_MUL / group=TIPO name="S"
     markerattrs=( symbol=circlefilled size=5 );
   lineparm x=0 y=0 slope=1 / lineattrs=(color=red thickness= 1px );
   reg x=RESP2 y=pred_BOG_MUL     /  nomarkers lineattrs=(pattern=MediumDash color=darkblue thickness=1.5);
      inset "R(*ESC*){sup '2'} = &r2" / position=topleft BORDER TEXTATTRS = (SIZE=10) ;
   xaxis grid values=(0 to 30 by 5) label="Valores observados";
   yaxis grid values=(0 to 30 by 5) label="Valores estimados";
	keylegend "S"/ title="Severidad";
   TITLE 'Gráfico de dispersión regresión MNBRE para red arterial de Bogotá.';
run;
ods graphics off;
ods listing close;

/* MODELO BINOMIAL NEGATIVO MULTIVARIADO TRONCAL */
ods graphics / reset=index imagename='025_RESULT_RESIDUAL_TRONCAL' imagefmt=JPEG;
ods listing gpath="/home/u47420890/LOG_models/RESULT_GRAF";
proc reg data=PRED_TRON_MULT;
   ods output fitstatistics=fs ParameterEstimates=c;
   model pred_TRON_MUL = RESP2;
run;
ods graphics off;
ods listing close;
data _null_;
   set fs;
   if _n_ = 1 then call symputx('R2'  , put(nvalue2, 4.2)   , 'G');
run;
ods graphics / reset=index imagename='022_DISPERSION_BOGOTA' imagefmt=JPEG;
ods listing gpath="/home/u47420890/LOG_models/RESULT_GRAF";
PROC SGPLOT DATA = PRED_TRON_MULT ;
ods graphics on / width=6.5in height=6.5in;
  scatter x=RESP2 y=pred_TRON_MUL / group=TIPO name="S"
     markerattrs=( symbol=circlefilled size=5 );
   lineparm x=0 y=0 slope=1 / lineattrs=(color=red thickness= 1px );
   reg x=RESP2 y=pred_TRON_MUL     /  nomarkers lineattrs=(pattern=MediumDash color=darkblue thickness=1.5);
      inset "R(*ESC*){sup '2'} = &r2" / position=topleft BORDER TEXTATTRS = (SIZE=10) ;
   xaxis grid values=(0 to 30 by 5) label="Valores observados";
   yaxis grid values=(0 to 30 by 5) label="Valores estimados";
	keylegend "S"/ title="Severidad";
   TITLE 'Gráfico de dispersión regresión MNBRE para red arterial troncal BRT.';
run;
ods graphics off;
ods listing close;


/* MODELO BINOMIAL NEGATIVO MULTIVARIADO CARRIL PREFERENCIAL */
ods graphics / reset=index imagename='035_RESULT_RESIDUAL_PREF' imagefmt=JPEG;
ods listing gpath="/home/u47420890/LOG_models/RESULT_GRAF";
proc reg data=PRED_PREF_MULT;
   ods output fitstatistics=fs ParameterEstimates=c;
   model pred_PREF_MUL = RESP2;
run;
ods graphics off;
ods listing close;
data _null_;
   set fs;
   if _n_ = 1 then call symputx('R2'  , put(nvalue2, 4.2)   , 'G');
run;
ods graphics / reset=index imagename='032_DISPERSION_CARRILES' imagefmt=JPEG;
ods listing gpath="/home/u47420890/LOG_models/RESULT_GRAF";
PROC SGPLOT DATA = PRED_PREF_MULT ;
ods graphics on / width=6.5in height=6.5in;
  scatter x=RESP2 y=pred_PREF_MUL / group=TIPO name="S"
     markerattrs=( symbol=circlefilled size=5 );
   lineparm x=0 y=0 slope=1 / lineattrs=(color=red thickness= 1px );
   reg x=RESP2 y=pred_PREF_MUL     /  nomarkers lineattrs=(pattern=MediumDash color=darkblue thickness=1.5);
      inset "R(*ESC*){sup '2'} = &r2" / position=topleft BORDER TEXTATTRS = (SIZE=10) ;
   xaxis grid values=(0 to 30 by 5) label="Valores observados";
   yaxis grid values=(0 to 30 by 5) label="Valores estimados";
	keylegend "S"/ title="Severidad";
   TITLE 'Gráfico de dispersión regresión MNB para red de carriles preferenciales.';
run;
ods graphics off;
ods listing close;






/* GRAFICAS ACUMULADOAS*/
/* MODELO BINOMIAL NEGATIVO MULTIVARIADO BOGOTA */
proc sort data = PRED_BOG_MULT;
  by pred_BOG_MUL;
run;
data PRED_BOG_MULT ;
set PRED_BOG_MULT;
retain PRED_CUM_BOG;
PRED_CUM_BOG+pred_BOG_MUL;
retain RESP_CUM_BOG;
RESP_CUM_BOG+RESP2;
COUNT+1;
run;
ods graphics / reset=index imagename='013_ACUMULADO_BOG' imagefmt=JPEG;
ods listing gpath="/home/u47420890/LOG_models/RESULT_GRAF";
PROC SGPLOT DATA = PRED_BOG_MULT;
 SERIES X = COUNT Y = PRED_CUM_BOG / legendlabel = 'Valores estimados' name="P" lineattrs=(pattern=MediumDash thickness=2); 
 SERIES X = COUNT Y = RESP_CUM_BOG / legendlabel = 'Valores observados' name="O" lineattrs=(thickness=2);
 TITLE 'Gráfico de frecuencia acumulada de siniestros para regresión MNBRE para red arterial de Bogotá.';
 xaxis label='Numero de observaciones.' grid offsetmin=0.0 offsetmax=0.05;
 Yaxis label='Siniestros acumulados.' grid offsetmin=0.0 offsetmax=0.05;
 keylegend "P" "O" / location=inside position=bottomright across=1;
RUN; 
ods graphics off;
ods listing close;

/* MODELO BINOMIAL NEGATIVO MULTIVARIADO TRONCAL */
proc sort data = PRED_TRON_MULT;
  by pred_TRON_MUL;
run;
data PRED_TRON_MULT ;
set PRED_TRON_MULT;
retain PRED_CUM_TRON;
PRED_CUM_TRON+pred_TRON_MUL;
retain RESP_CUM_TRON;
RESP_CUM_TRON+RESP2;
COUNT+1;
run;
ods graphics / reset=index imagename='023_ACUMULADO_TRONCAL' imagefmt=JPEG;
ods listing gpath="/home/u47420890/LOG_models/RESULT_GRAF";
PROC SGPLOT DATA = PRED_TRON_MULT;
 SERIES X = COUNT Y = PRED_CUM_TRON / legendlabel = 'Valores estimados' name="P" lineattrs=(pattern=MediumDash thickness=2); 
 SERIES X = COUNT Y = RESP_CUM_TRON / legendlabel = 'Valores observados' name="O" lineattrs=(thickness=2);
 TITLE 'Gráfico de frecuencia acumulada de siniestros para regresión MNBRE para red de corredores troncales BRT.';
 xaxis label='Numero de observaciones.' grid offsetmin=0.0 offsetmax=0.05;
 Yaxis label='Siniestros acumulados.' grid offsetmin=0.0 offsetmax=0.05;
 keylegend "P" "O" / location=inside position=bottomright across=1;
RUN; 
ods graphics off;
ods listing close;

/* MODELO BINOMIAL NEGATIVO MULTIVARIADO CARRIL */
proc sort data = PRED_PREF_MULT;
  by pred_PREF_MUL;
run;
data PRED_PREF_MULT ;
set PRED_PREF_MULT;
retain PRED_CUM_PREF;
PRED_CUM_PREF+pred_PREF_MUL;
retain RESP_CUM_PREF;
RESP_CUM_PREF+RESP2;
COUNT+1;
run;
ods graphics / reset=index imagename='033_ACUMULADO_CARRIL' imagefmt=JPEG;
ods listing gpath="/home/u47420890/LOG_models/RESULT_GRAF";
PROC SGPLOT DATA = PRED_PREF_MULT;
 SERIES X = COUNT Y = PRED_CUM_PREF / legendlabel = 'Valores estimados' name="P" lineattrs=(pattern=MediumDash thickness=2); 
 SERIES X = COUNT Y = RESP_CUM_PREF / legendlabel = 'Valores observados' name="O" lineattrs=(thickness=2);
 TITLE 'Gráfico de frecuencia acumulada de siniestros para regresión MNB para red de carriles preferenciales.';
 xaxis label='Numero de observaciones.' grid offsetmin=0.0 offsetmax=0.05;
 Yaxis label='Siniestros acumulados.' grid offsetmin=0.0 offsetmax=0.05;
 keylegend "P" "O" / location=inside position=bottomright across=1;
RUN; 
ods graphics off;
ods listing close;