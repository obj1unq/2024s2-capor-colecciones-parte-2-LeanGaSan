object espada{
	var fueUsado = false

	method poder(personaje) {
		// return if(fueUsado) poder else poder * 0.5 está bien
		// return poder * if(fueUsado) 0.5 else 1 también está bien
		return personaje.poderBase() * self.factorPorUso()
	}

	method factorPorUso() {
		return if(fueUsado) 0.5 else 1
	} 

	method serUsado() {
		fueUsado = true
	}
}

object collar {
	var usos = 0

	method poder(personaje) {
		return 3 + self.extraPorNivel(personaje.poderBase()) 
	}

	method extraPorNivel() {
		return if(poder > usos) usos else 0
	}

	method serUsado() {
		usos = usos + 1 
	}
}

object armadura {
	// const poder = 6

	method poder(personaje) {
		return 6
		//return poder
	}

	method serUsado() {
		// NO HACE NADA
	}
}

object libro {
	var hechizos = []

	method hechizos(_hechizos) {
		hechizos = _hechizos
	}

	method poder(personaje) {
		return if(self.quedanHechizos()) self.hechizoActual().poderQueAporta(personaje) 
	}

	method quedanHechizos() {
		return not hechizos.isEmpty()
	}
	
	method serUsado() {
		hechizos.remove(self.hechizoActual())
		// NO HACE NADA
	}

	method hechizoActual(){
		return hechizos.head()
	}

}

object bendicion {
	method poderQuAporta(personaje) {
		return 4
	}
}

object invisibilidad {
	method poderQueAporta(personaje) {
		return personaje.poderBase()
	}
}

object invocasion {
	method poderQueAporta(personaje) {
		return personaje.artefactoMasPoderosoEnMorada().poder(personaje)
	}
}

object castillo {
	
	const property artefactos = #{}
		
	method artefactoMasPoderoso(personaje) {
		return artefactos.max({artefacto => artefacto.poder(personaje)})
	}

	method agregarArtefactos(_artefactos) {
		artefactos.addAll(_artefactos)		
	}
	
}


object rolando {

	const property artefactos = #{}
	var property capacidad = 2
	const casa = castillo
	const property historia = []
	var poderBase = 5

	method hayArmaFatal(enemigo) {
		return artefactos.any({artefacto => artefacto.poder(self) > enemigo.poderDePelea()})
	}

	method armaFatal(enemigo) {
		return artefactos.find({artefacto => artefacto.poder(self) > enemigo.poderDePelea()})
	}

	method poderBase(_poderBase) {
		poderBase = _poderBase
	}

	method puedeVencer(enemigo) {
		return self.poderDePelea() > enemigo.poderDePelea() 
	}

	method artefactoMasPoderosoEnMorada() {
		return  casa.artefactoMasPoderoso(self)
	}

	 method luchar() {
		self.usarArtefactos()
		poderBase += 1
	 }

	 method usarArtefactos() {
		artefactos.forEach({artefacto => artefacto.serUsado()})
	 }

	method poderBase() {
		return poderBase
	}

	method poderDePelea() {
		return poderBase + self.poderArtefactos()
	}

	method poderArtefactos() {
		return artefactos.sum({artefacto => artefacto.poder(self)})
	}

	method encontrar(artefacto) {
		if(artefactos.size() < capacidad) {
			artefactos.add(artefacto)
		}
		historia.add(artefacto)
	}
	
	method volverACasa() {
		casa.agregarArtefactos(artefactos)
		artefactos.clear()
	}	
	
	method posesiones() {
		return self.artefactos() + casa.artefactos()
	}
	
	method posee(artefacto) {
		return self.posesiones().contains(artefacto)	
	}
		
}

object archibaldo {
	const property casa = palacioDeMarmol

	method poderDePelea() {
		return 16
	}

}

object caterina {
	const property casa = fortalezaDeAcero

	method poderDePelea() {
		return 28
	}
}

object astra {
	const property casa = torreDeMarfil

	method poderDePelea() {
		return 14
	}
}

object fortalezaDeAcero {}

object torreDeMarfil {}

object palacioDeMarmol {}

object erethia {
	const habitantes = #{archibaldo, astra, caterina}

	method poderoso(personaje) {
		return habitantes.all({habitante => personaje.puedeVencer(habitante) }) // Rolando puede vencer a todos
		// return not habitantes.any({habitante => personaje.puedeVencer(habitante) }) Existe alguno que Rolando no puede vencer 
	} 

	method conquistables(personaje) {
		return self.vencibles().map(#{habitante => habitante}) 
	}

	method vencibles(personajes) {
		return habitantes.filter(#{habitante => persoanje.puedeVencer(habitante)})
	}
}
