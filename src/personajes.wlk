import wollok.game.*
import armas.*
import juego.*
import objetosUtiles.*


class PersonajeAliado inherits Personaje {
	var property armamento = []
	const presentacion
	const range
	var movimientoDisponible = true
	var property ataqueDisponible = true
	method esEnemigo()=false
	method esAliado()= true
	method puedeCurar() = false
	method armar(armas){armamento=armas}
	method moverse(posicion){ 
		self.position(posicion)
		movimientoDisponible = false
	}
	
	method atacar(enemigo) { 
		weapon.disparar(enemigo,self)
		ataqueDisponible = false
		movimientoDisponible = false
		turnos.yaAtaque()
	}
	
	method seleccionarArma(posicion){
		weapon = armamento.get(posicion)
		self.decir(weapon.nombre())
		if(ataqueDisponible){self.apuntarEnemigos()}
	}
	method interactuar(aliado){
		if (aliado.puedeCurar()){selector.aliadoactual().curar(self)}
		else{
		selector.aliadoactual(self)
		self.decir(presentacion)
		self.desapuntarEnemigos()
		}
	}
	method puedeAtacarme(posicion) {return ataqueDisponible and weapon.llega(posicion,position)}
	method apuntarEnemigos(){game.allVisuals().filter{objeto=>objeto.esEnemigo()}.forEach{objeto => objeto.puedoAtacarte(weapon,position)}}
	method desapuntarEnemigos(){game.allVisuals().filter{objeto=>objeto.esEnemigo()}.forEach{objeto=>objeto.desapuntado()}}
	method puedoMoverme(posicion) {return range >= posicion.distance(self.position()) and movimientoDisponible}
	
	method terminoElTurno(){
		movimientoDisponible = true
		ataqueDisponible = true
		weapon= desarmado
	}
}

class Medico inherits PersonajeAliado {
	var curacionDisponible = true
	method curar(aliado) { 
		weapon.disparar(aliado,self)
		curacionDisponible = false
		movimientoDisponible = false
		turnos.yaAtaque()
	}
	
	override method puedeCurar(){return curacionDisponible and weapon.armaCurativa()}
	
	override method interactuar(aliado){
		selector.aliadoactual(self)
		self.decir(presentacion)
		self.desapuntarEnemigos()
}

	override method morir(){
		self.decir("Hasta acá llegué")
		self.image("calavera.png")
		game.removeVisual(self)
	}

	
	override method seleccionarArma(posicion){
		weapon = armamento.get(posicion)
		self.decir(weapon.nombre())
		if(not weapon.armaCurativa()){self.apuntarEnemigos()}
		else {self.desapuntarEnemigos()}
	}
	override method terminoElTurno(){
		super()
		curacionDisponible=true
	}
}

class Enemigo inherits Personaje {
	const armaCortaDistancia = new Arma(damage=30,nombre="Sable",range=1)
	const armaMediaDistancia = new Arma(damage=20,nombre="ArmaEnemigo",range=5)
	const armaLargaDistancia = new Arma(damage=10,nombre="ArmaLargaDistancia",range=7)
	const armamento = [armaCortaDistancia,armaMediaDistancia,armaLargaDistancia]
	
	var posiblePosicion= game.at(0,0)
	
	const rutinasAgresivas = 
	[{},{self.rutinaDiagonalDerSup2()},{self.rutinaDiagonalDerInf2()},{self.rutinaDiagonalIzqSup2()},{self.rutinaDiagonalIzqInf2()},
		{self.rutinaDiagonalDerSup3()},{self.rutinaDiagonalDerInf3()},{self.rutinaDiagonalIzqSup3()},{self.rutinaDiagonalIzqInf3()},
		{self.rutinaCuerpoACuerpoDer()},{self.rutinaCuerpoACuerpoIzq()},{self.rutinaDefensiva()}
	]
	const rutinasDefensivas= 
	[{},{self.llamarAliados()},{self.moverseAleatoriamente()},
		{self.rutinaDiagonalDerSup5()},{self.rutinaDiagonalDerInf5()},{self.rutinaDiagonalIzqSup5()},{self.rutinaDiagonalIzqInf5()}
	]
	method esEnemigo() = true
	method esAliado()= false
	
	method enemigoCercano(){ 
		return game.allVisuals().filter{objeto => objeto.esAliado()}.min{objeto=>objeto.position().distance(self.position())}
	}
	
	method interactuar(aliado){
		if(aliado.puedeAtacarme(position)){
			aliado.atacar(self)
			aliado.desapuntarEnemigos()
		}
	}
	
	method atacar() {
		weapon.disparar(self.enemigoCercano(),self)
	}
	
	method puedoAtacarte (arma,posicion) {
		if (arma.llega(position,posicion)){self.apuntado()}else {self.desapuntado()}
	}
	method decidirRutina(){
		if (health > 50){
		rutinasAgresivas.get(0.randomUpTo(11)).apply()	
		}else{self.rutinaDefensiva()}
	}
	
	method rutinaDefensiva(){rutinasDefensivas.get(0.randomUpTo(6).roundUp()).apply()}
	
	method terminoElTurno(){
		self.desapuntado() 
		self.decidirRutina()
		
	}
	method apuntado(){image = "inglesApuntadoPrueba.png"}
	method desapuntado(){image = "ingles.png"}
	
	method moverseAleatoriamente(){ position= movimientos.posicionAleatoria()}
	
	method rutinaDiagonalDerSup2(){
		self.atacarPosicionDelEnemigo(2,2,1)
		}
	method rutinaDiagonalIzqSup2(){
		self.atacarPosicionDelEnemigo(-2,2,1)
		}
	method rutinaDiagonalDerInf2(){
		self.atacarPosicionDelEnemigo(2,-2,1)
		}
	method rutinaDiagonalIzqInf2(){
		self.atacarPosicionDelEnemigo(-2,-2,1)
		}	
	method rutinaDiagonalDerSup3(){
	self.atacarPosicionDelEnemigo(3,3,1)
		}
	method rutinaDiagonalIzqSup3(){
	self.atacarPosicionDelEnemigo(-3,3,1)
		}
	method rutinaDiagonalDerInf3(){
	self.atacarPosicionDelEnemigo(3,-3,1)
		}
	method rutinaDiagonalIzqInf3(){
	self.atacarPosicionDelEnemigo(-3,-3,1)
		}
	method rutinaDiagonalDerSup5(){
		self.atacarPosicionDelEnemigo(5,5,2)
		}
	method rutinaDiagonalIzqSup5(){
	self.atacarPosicionDelEnemigo(-5,5,2)
		}
	method rutinaDiagonalDerInf5(){
		self.atacarPosicionDelEnemigo(5,-5,2)
		}
	method rutinaDiagonalIzqInf5(){
	self.atacarPosicionDelEnemigo(-5,-5,2)
		}
	method rutinaCuerpoACuerpoDer(){
	self.atacarPosicionDelEnemigo(1,0,0)	
		}
	method rutinaCuerpoACuerpoIzq(){
		self.atacarPosicionDelEnemigo(-1,0,0)
		}
	
	method llamarAliados(){
		posiblePosicion = movimientos.posicionAleatoria()
		aguaYsilla.invocarEnemigos(posiblePosicion)
	}
	method atacarPosicionDelEnemigo(x,y,posArma){
		if(movimientos.puedeMoverse(game.at(self.enemigoCercano().position().x()+x,self.enemigoCercano().position().y()+y))){
			position = game.at(self.enemigoCercano().position().x()+x,self.enemigoCercano().position().y()+y)
			weapon=armamento.get(posArma)
			self.atacar()
		}else {self.decidirRutina()}
	}
	}


	
class Personaje {
	var property position 
	var property image 
	var property weapon = desarmado
	var property health 
	
	method esInteractuable() = true
	
	method morir(){
		self.decir("AAAAAAAAH!")
		self.image("calavera.png")
		self.dropearMuni(position)
		
	}

	method dropearMuni(posicion){
		game.removeVisual(self)
		aguaYsilla.invocarMunicion(posicion)
	}
	
	method recibirDanio(danio){
		health -= danio
		if(health<=0){
			self.morir()
		} else {game.say(self,health.toString())}
		}
	method decir(mensaje){game.say(self,mensaje)}
	
	}

