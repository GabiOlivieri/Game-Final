import wollok.game.*
import personajes.*
import juego.*

object espacioBlanco {
	method esInteractuable() = false
	
	method interactuar(aliado){
		if(aliado.puedoMoverme(selector.position())){
			aliado.moverse(selector.position())	
		}	else {aliado.decir("No puedo moverme")}
	}
}

object turnos {
	const todos = game.allVisuals()
	var ataques = 0
	method yaAtaque(){
		ataques = ataques + 1
		if(todos.filter{objeto=>objeto.esAliado()}.size()==ataques){
			self.terminarTurno()
		}
	}
	
	method terminarTurno(){
		if (game.allVisuals().any{objeto=>objeto.esEnemigo()}){
		if (game.allVisuals().any{objeto=>objeto.esAliado()}){
		todos.forEach{objeto => objeto.terminoElTurno()}
		ataques = 0
		} else {aguaYsilla.perdisteJuego()}	
		} else {aguaYsilla.ganasteJuego()}
		
	}
}
object selector {
	var property position = game.at(5,8)
	var property aliadoactual = null
	var property image = "selector.png"
	method esAliado()=false
	method esEnemigo()=false
	method esInteractuable()=true
	method irA(posicion){ 
		self.position(posicion)
		self.posibleMovimiento()
	}
	method posibleMovimiento(){ 
		if(aliadoactual.puedoMoverme(self.position())){
		self.image("Selector_posible_movimiento.png")	
		} else{self.image("Selector.png")}
	}
	method terminoElTurno(){
}
	
}

object movimientos {
	var posiblePosicion
	method posicionAleatoria(){
		posiblePosicion = game.at(0.randomUpTo(aguaYsilla.width()-1),0.randomUpTo(aguaYsilla.height()-1))
		if(self.puedeMoverse(posiblePosicion)){
			return posiblePosicion
		}else {return self.posicionAleatoria()}
	}
	method puedeMoverse(position){
        return not self.hayAlgo(position) and self.dentroDelMapa(position)
    }
	method hayAlgo(posicion){return game.getObjectsIn(posicion).any{objeto=>objeto.esInteractuable()}}
	  
    
     method dentroDelMapa(position) {
        return position.x().between(0,aguaYsilla.width()-1) and position.y().between(0,aguaYsilla.height()-1)
    }
}
object ganaste {
	const property position = game.at(0,0)
	const property image = "Ganaste.png"
}
object perdiste {
	const property position = game.at(0,0)
	const property image = "perdiste.jpg"
}
object instrucciones {
	const property position = game.at(0,0)
	const property image = "instrucciones.png"
}