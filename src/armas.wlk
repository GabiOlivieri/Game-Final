import wollok.game.*
import personajes.*
import objetosUtiles.*

class Arma{
	const damage 
	const property range
	const property nombre
	method tieneMunicion()=false
	
	method armaCurativa()=false
	
	method disparar(enemy,aliado){
			enemy.recibirDanio(damage)
	}
	method llega(posEnemy,posAliado){
		return range >= posAliado.distance(posEnemy)
	
	}	
	method sumarMuni(cantidad){
		game.say(selector.aliadoactual(),"No necesito de esa munición")
	}
}

class ArmaMunicion inherits Arma {
	var property municion = 3
		override method tieneMunicion()=true
		method tengoMunicion(){return municion>0}
	
	 override method disparar(enemy,aliado) {
		if (self.tengoMunicion()){
		enemy.recibirDanio(damage)
		municion = municion - 1
		}
		else{game.say(aliado,"No tengo munición")
		}
	}
	override method sumarMuni(cantidad){
		municion = municion + cantidad
		game.say(selector.aliadoactual(),municion.toString())
	}
	

}
class ArmaCura inherits Arma {
	
	override method armaCurativa()=true
	
	override method disparar (enemy, aliado){
		enemy.recibirDanio(damage)
	} 
}

class CajaMunicion {
	var property position 
	const property image = "municion.png"
	const cantidad = 3
	method esAliado()=false
	method esEnemigo()=false
	method interactuar(aliado){
     aliado.armamento().findOrElse({objeto=>objeto.tieneMunicion()},aliado.weapon()).sumarMuni(cantidad)
     game.schedule(1000,{game.removeVisual(self)})
}
	method esInteractuable()= true
	method posicionAAparecer(posicion){ position = posicion }
	method terminoElTurno(){}
}

object desarmado inherits Arma {
}
