#Simulaci�n de pago de pensiones

n<-100;      #N�mero de clientes para simulaci�n
TCI<-15;     #Tiempo de llegada m�nimo entre clientes 
             #(e.g. Un cliente llega m�nimo despu�s de TCI min. que el cliente anterior)
TCF<-30;     #Tiempo de llegada m�ximo entre clientes
             #(e.g. Un cliente tarda en llegar m�x. TCF min. desp�es que el cliente anterior)
TAI<-5;      #Tiempo de atenci�n m�nimo
             #(e.g. el tiempo de atenci�n m�nimo para cada cliente es de TAI minutos)
TAF<-15;     #Tiempo de atenci�n m�ximo
             #(e.g. el tiempo de atenci�n m�nimo para cada cliente es de TAI minutos)
HAM<-8;      #Hora de apertura (e.g. apertura a las 0800hrs)
HCM<-420;    #Hora de cierre en min�tos (0800hrs-1500hrs)

#Tabla General
# Formato: Cliente / Tiempo que tarda en llegar / Minuto en el cual llega / Tiempo de atenci�n / Tiempo de espera / Tiempo de finalizaci�n 
C=matrix(c(1),nrow=n,ncol=6)
for(i in 1:n){
  C[i,1]<-i                                  #Numero de cliente
  C[i,2]<-runif(1,min=0,max=1)*(TCF-TCI)     #Tiempo que tarda en llegar el cliente i despu�s que el cliente i-1
  if(i==1)
    C[i,3]<-C[i,2]                           #Minuto en el cual llega el cliente 1
  else
    C[i,3]<-C[i-1,3]+C[i,2]                  #Minuto en el cual llega el cliente i, donde i>1
  C[i,4]<-runif(1,min=0,max=1)*(TAF-TAI)     #Tiempo de atenci�n por cliente
  if(i==1)
    C[i,5]<-0                                #Tiempo de espera para el primer cliente (espera 0 min.)
  else
    if(C[i-1,6]>C[i,3])
      C[i,5]<-C[i-1,6]-C[i,3]                #Posible tiempo de espera (en cola) para el i-�simo cliente, en donde i>1
    else
      C[i,5]<-0                              #Posible tiempo de espera (en cola) para el i-�simo cliente, en donde i>1
  C[i,6]<-C[i,3]+C[i,4]+C[i,5]               #Minuto en el cual el cliente se retira de la sucursal (tiempo de finalizaci�n)
}

#Tabla de "N�mero de cliente" / "Ingreso del cliente" / "Salida del cliente" en minutos
D=matrix(c(1),nrow=n,ncol=3)
for(i in 1:n){
  D[i,1]<-C[i,1]
  D[i,2]<-C[i,3]
  D[i,3]<-C[i,6]
}

#Tabla para "Ingreso de cliente" - Desgloce en Horas, minutos y segundos
E=matrix(c(1),nrow=n,ncol=4)
for(i in 1:n){
  E[i,1]<-C[i,1] #Columna para identificar n�mero de cliente
  E[i,2]<-floor(D[i,2]/60)+HAM #COlumna para identificar hora de ingreso
  E[i,3]<-floor(D[i,2]-60*floor(D[i,2]/60)) #Columna para identificar minutos complementarios a la hora de ingreso
  E[i,4]<-round((D[i,2]-60*floor(D[i,2]/60)-floor(D[i,2]-60*floor(D[i,2]/60)))*60,digits=0) #Columna para ident. seg. complemetarios a la hora de ingreso
}

#Determinar el �ltimo cliente recibido.
#Supuesto: Se atienden a todos los clientes que lleguen antes de 15hrs (420 min.)
UCRH=matrix(c(1),nrow=1,ncol=4)
for(i in 1:n){
  if(C[i,3]<=HCM){
    UCR<-C[i,1]
    UCRH[1,1]<-E[i,1]
    UCRH[1,2]<-E[i,2]
    UCRH[1,3]<-E[i,3]
    UCRH[1,4]<-E[i,4]
  }  
}

#Tabla para "Finalizaci�n del cliente" - Desfloce en horas, minutos y segundos.
F=matrix(c(1),nrow=n,ncol=4)
for(i in 1:n){
  F[i,1]<-C[i,1] #Columna para identificar n�mero de cliente
  F[i,2]<-floor(D[i,3]/60)+HAM #COlumna para identificar hora de finalizaci�n
  F[i,3]<-floor(D[i,3]-60*floor(D[i,3]/60)) #Columna para identificar minutos complementarios a la hora de finalizaci�n
  F[i,4]<-round((D[i,3]-60*floor(D[i,3]/60)-floor(D[i,3]-60*floor(D[i,3]/60)))*60,digits=0) #Columna para ident. seg. complemetarios a la hora de finalizaci�n
}

#Determinar el �ltimo cliente atendido y su hora de finalizaci�n.
#Supuesto: Se atienden a todos los clientes que lleguen antes de 15hrs (420 min.), por lo tanto se cierra despu�s de las 15hrs.
UCAH=matrix(c(1),nrow=1,ncol=4)
UCA<-UCR
UCAH[1,1]<-F[UCR,1]
UCAH[1,2]<-F[UCR,2]
UCAH[1,3]<-F[UCR,3]
UCAH[1,4]<-F[UCR,4]

#Resultados relevantes de la simulaci�n:

UCR #N�mero de clientes que fueron atendidos y llegaron antes de las 15hrs.
#Hora en la cual lleg� el �ltimo cliente.
UCRH #Formato: (cl/hr/min/seg)
#Hora en la cual se termin� de atender al �ltimo cliente. 
UCAH #Formato: (cl/hr/min/seg)