import wollok.game.*
import personajes.*
import obstaculos.*
import armas.*
import objetosUtiles.*

object aguaYsilla {
	var property height = 9
	var property width = 16
	const bombardero = new PersonajeAliado (position = game.at(5,8),health = 100 ,image = "gauchoGuitarra.png",presentacion = "Mandale mecha",range = 5)
	const soldado = new PersonajeAliado (position =game.at(7,5),health = 100, image = "gaucho.png" ,presentacion = "Amargo y retruco",range = 5)
	
	const medico = new Medico(position = game.at(2,7),health = 100,image = "enfermera.png",presentacion = "Vamos a curar!",range = 3)
	
	const inglesUno = new Enemigo (position = game.at(10,5),image = "ingles.png",health = 100)	
	const inglesDos = new Enemigo (position = game.at(10,4),image = "ingles.png",health = 100)	
	
	const cascote= new ArmaMunicion(damage=45,nombre="Cascote",range=6)
	const aguaHirviendo= new Arma(damage=30,nombre="Agua Hirviendo",range=4)
	const silla= new Arma(damage=10,nombre="Silla",range=3)
	
	const bendas = new ArmaCura(nombre ="Bendas",range = 3,damage=-20)
	const bisturi = new Arma (damage=10,nombre="bisturi",range=1.5)
	
	
	const botiquin = [bendas,bisturi]
	const armamento = [aguaHirviendo,cascote,silla]
	
	
	method jugar(){
		self.configurar()
		game.start()
	}
	
	method configurar(){
		self.configurarVentana()
		self.configurarTeclas()
		self.configurarPersonajes()
	}
	
	method configurarVentana() {
		game.width(width)
		game.height(height)
		game.title("ElNombreDelJuego")
		game.ground("CeldaPrueba.png")
		game.boardGround("Mapa.jpg")
		game.cellSize(70)
	}	
	method configurarTeclas(){
		keyboard.left().onPressDo({selector.irA(selector.position().left(1))})
		keyboard.up().onPressDo({selector.irA(selector.position().up(1))})
		keyboard.right().onPressDo({selector.irA(selector.position().right(1))})
		keyboard.down().onPressDo({selector.irA(selector.position().down(1))})
		keyboard.space().onPressDo({self.interaccion()})
		keyboard.num1().onPressDo({selector.aliadoactual().seleccionarArma(0)})
		keyboard.num2().onPressDo({selector.aliadoactual().seleccionarArma(1)})
		keyboard.num3().onPressDo({selector.aliadoactual().seleccionarArma(2)})
		keyboard.num4().onPressDo({selector.aliadoactual().seleccionarArma(3)})
		keyboard.t().onPressDo({turnos.terminarTurno()})
		keyboard.control().onPressDo({self.mostrarInstrucciones()})
	}
	method interaccion (){
		game.colliders(selector).findOrElse({objeto=>objeto.esInteractuable()},{return espacioBlanco}).interactuar(selector.aliadoactual())
	}
	
	method configurarPersonajes(){
		game.addVisual(selector)
		selector.aliadoactual(bombardero)
		self.configurarAliados()
		self.configurarEnemigos()
		self.configurarObstaculos()
	}
	
	method configurarAliados(){
		game.addVisual(bombardero)
		game.addVisual(soldado)
		game.addVisual(medico)
		medico.armar(botiquin)
		soldado.armar(armamento)
		bombardero.armar(armamento)	
	}
	method configurarEnemigos(){
		game.addVisual(inglesUno)
		game.addVisual(inglesDos)
	}
	method configurarObstaculos(){
		const edificio = new Obstaculo (position = game.at(5,4),image = "edificio.png")
		game.addVisual(edificio)
		
		const edificio1 = new Obstaculo (position = game.at(12,7),image = "edificio.png")
		game.addVisual(edificio1)
		
		const edificioCebado = new EdificioDefensa (position = game.at(7,2), image = "hospital.png")
		game.addVisual(edificioCebado)
		
		const edificioCebado1 = new EdificioDefensa (position = game.at(10,2), image = "hospital.png")
		game.addVisual(edificioCebado1)
		
		const edificioTrampa = new CasilleroTrampa  (position = game.at(9,4), image = "trampita.png")
		game.addVisual(edificioTrampa)
		
		const edificioTrampa1 = new CasilleroTrampa  (position = game.at(2,8), image = "trampita.png")
		game.addVisual(edificioTrampa1)
		
			const edificioTrampa2 = new CasilleroTrampa  (position = game.at(2,3), image = "trampita.png")
		game.addVisual(edificioTrampa2)
	}
	method invocarEnemigos(posicion){
		const enemigo = new Enemigo (position = posicion,image = "ingles.png",health = 70)
		game.addVisual(enemigo)
	
	}
	method invocarMunicion(posicion){
		game.addVisual(new CajaMunicion (position=posicion) )
	}
	method invocarEdificioDefensa(posicion){
		game.addVisual(new EdificioDefensa (position=posicion,image = "hospital.png"))
	}
	method invocarCasilleroTrampa(posicion){
		game.addVisual(new CasilleroTrampa (position=posicion,image = "trampita.png"))
	}
	method perdisteJuego(){
		game.clear()
		game.addVisual(perdiste)
		
	}
	method ganasteJuego(){
		game.clear()
		game.addVisual(ganaste)
		
	}
	method mostrarInstrucciones() {
		if (game.hasVisual(instrucciones)){
			game.removeVisual(instrucciones)
		}
		else{
		game.addVisual(instrucciones)
	}
	}
}
