import wollok.game.*
import personajes.*
import objetosUtiles.*
import juego.*

class Obstaculo {
	const property position 
	const property image
	method esInteractuable() = true
	method esAliado()=false
	method esEnemigo()=false
	
	method interactuar(aliado){
		selector.position(aliado.position())
		aliado.decir("No puedes moverte sobre Obstaculos")
	}
	method terminoElTurno(){}
}
class CasilleroTrampa inherits Obstaculo {
	var vida = 2
	const danio = 20
	override method interactuar(aliado){
		aliado.recibirDanio(danio)
		aliado.moverse(position)
		vida = vida -1
		if(vida==0){game.schedule(1000,{game.removeVisual(self) aguaYsilla.invocarCasilleroTrampa(movimientos.posicionAleatoria())})}
	}
}
class EdificioDefensa inherits Obstaculo{
	var vida = 3
	override method interactuar(aliado){
		aliado.moverse(position)
		aliado.recibirDanio(-20)
		vida = vida -1
		if(vida==0){game.schedule(1000,{game.removeVisual(self) aguaYsilla.invocarEdificioDefensa(movimientos.posicionAleatoria())})}
	}
}