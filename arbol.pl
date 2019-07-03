% Hechos del arbol genealogico
progenitor(juan,pedro).
progenitor(juan,maria).
progenitor(irma,pedro).
progenitor(irma,maria).
progenitor(pedro,carlos).
progenitor(pedro,elena).
progenitor(maria,rosa).
% Sexo
hombre(juan).
hombre(pedro).
hombre(carlos).
mujer(maria).
mujer(elena).
mujer(rosa).
mujer(irma).

% Reglas
% Abuelo
abuelo(Abuelo,Nieto):-progenitor(Padre,Nieto),progenitor(Abuelo,Padre).

% Hijo
hijo(Hijo,Padre):-progenitor(Padre,Hijo).

hermano(X,Y):-progenitor(Z,X),progenitor(Z,Y),X/=Y.

tio(Tio,Sobrino):-progenitor(Padre,Sobrino),hermano(Padre,Tio).

primo(X,Y):-tio(Z,X),hijo(Y,Z).

tieneabuela(Persona):-abuelo(X,Persona),mujer(X).

pareja(Persona1,Persona2):-progenitor(Persona1,Hijo),progenitor(Persona2,Hijo),Persona1\=Persona2.

parejahetero(Persona1,Persona2):-pareja(Persona1,Persona2),hombre(Persona1),mujer(Persona2).
