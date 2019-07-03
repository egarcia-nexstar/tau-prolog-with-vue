<template lang="pug">
    b-row
      b-col(cols="2")
      b-col(cols="8")
        b-textarea( v-model="program" style="height: 300px; margin: 20px 0px")
        b-form-group(
          id="PersonGroup"
          label="Persona a consultar:"
          label-for="PersonInput"
        )
          b-form-input(
              id='PersonInput'
              placeholder="Escriba un nombre"
              v-model='person'
          )
        b-button( @click="abuelos"
          variant="primary"
          class="centered bg-info" 
          style="margin: 20px 15px 20px 30px; width: 130px;"
        ) Abuelos
        b-button( @click="padres"
          variant="primary"
          class="bg-info" 
          style="margin: 20px 15px; width: 130px;"
        ) Padres
        b-button( @click="hermanos"
          variant="primary"
          class="centered bg-info" 
          style="margin: 20px 15px; width: 130px;"
        ) Hermanos
        b-button( @click="hijos"
          variant="primary"
          class="centered bg-info" 
          style="margin: 20px 15px; width: 130px;"
        ) Hijos
        b-button( @click="tios"
          variant="primary"
          class="centered bg-info" 
          style="margin: 20px 15px; width: 130px;"
        ) Tios
        b-button( @click="primos"
          variant="primary"
          class="centered bg-info" 
          style="margin: 20px 15px; width: 130px;"
        ) Primos
        h3 Consulta sin constantes
        b-button( @click="parejas"
          variant="primary"
          class="centered bg-info" 
          style="margin: 20px 15px 20px 30px; width: 130px;"
        ) Parejas
        b-card(
            v-for="answer in response"
            style="margin-top:25px; background-color:coral;"
            class="shadow-sm p-1 bg-light rounded"
        )
          p
            strong {{answer}}
      b-col(cols="2")
      b-row(style="margin: 50px")
</template>

<script>

export default {
  name: 'app',
  data() {
      return {
        program: `% Hechos del arbol genealogico
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

hermano(X,Y):-progenitor(Z,X),progenitor(Z,Y),X \\= Y.

tio(Tio,Sobrino):-progenitor(Padre,Sobrino),hermano(Padre,Tio).

primo(X,Y):-tio(Z,X),hijo(Y,Z).

tieneabuela(Persona):-abuelo(X,Persona),mujer(X).

pareja(Persona1,Persona2):-progenitor(Persona1,Hijo),progenitor(Persona2,Hijo),Persona1 \\= Persona2.

parejahetero(Persona1,Persona2):-pareja(Persona1,Persona2),hombre(Persona1),mujer(Persona2).`,
        response: [],
        person: '',
        father: '',
        son: '',
      }
  },
  methods: {
    abuelos() {
      let pl = require('tau-prolog');
      // Create session
      let session = pl.create(1000);
      // Clear output
      this.response = []
      // Consult program
      session.consult(this.program);
      // Query goal
      session.query("abuelo(X,"+ this.person +").");
      // Find answers
      session.answers( this.getAbuelos );
    },
    hermanos() {
      let pl = require('tau-prolog');
      let session = pl.create(1000);
      this.response = []
      session.consult(this.program)
      session.query("hermano(" + this.person + ", X).")
      session.answers( this.getHermanos )
    },
    padres() {
      let pl = require('tau-prolog');
      let session = pl.create(1000);
      this.response = []
      session.consult(this.program)
      session.query("progenitor(X,"+ this.person +").");
      session.answers( this.getPadres )
    },
    hijos() {
      let pl = require('tau-prolog');
      let session = pl.create(1000);
      this.response = []
      session.consult(this.program)
      session.query("hijo(X,"+ this.person +").");
      session.answers( this.getHijos )
    },
    tios() {
      let pl = require('tau-prolog');
      let session = pl.create(1000);
      this.response = []
      session.consult(this.program)
      session.query("tio(X,"+ this.person +").");
      session.answers( this.getTios )
    },
    primos() {
      let pl = require('tau-prolog');
      let session = pl.create(1000);
      this.response = []
      session.consult(this.program)
      session.query("primo(" + this.person + ", X).")
      session.answers( this.getPrimos )
    },
    parejas() {
      let pl = require('tau-prolog');
      let session = pl.create(1000);
      this.response = []
      session.consult(this.program)
      session.query("pareja(X, Y).")
      session.answers( this.getParejas )
    },
    getAbuelos(answer) {
     const aux = answer.lookup('X')
     this.response.push(aux + " es abuelo/a de " + this.person)
    },
    getHermanos(answer) {
     const aux = answer.lookup('X')
     this.response.push(this.person + " es hermano/a de " + aux)
    },
    getPadres(answer) {
     const aux = answer.lookup('X')
     this.response.push(aux + " es padre/madre de " + this.person)
    },
    getHijos(answer) {
     const aux = answer.lookup('X')
     this.response.push(aux + " es hijo/a de " + this.person)
    },
    getTios(answer) {
     const aux = answer.lookup('X')
     this.response.push(aux + " es tio/a de " + this.person)
    },
    getPrimos(answer) {
     const aux = answer.lookup('X')
     this.response.push(aux + " es primo/a de " + this.person)
    },
    getParejas(answer) {
     const aux = answer.lookup('X')
     const aux2 = answer.lookup('Y')
     this.response.push(aux + " es pareja de " + aux2)
    },
  },
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

textarea {
  width: 200px;
  height: 200px;
}

</style>

