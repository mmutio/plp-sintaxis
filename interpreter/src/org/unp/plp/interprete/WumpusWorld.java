package org.unp.plp.interprete;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.function.BiPredicate;
import java.util.function.BinaryOperator;
import java.util.HashSet;
import java.util.List;

public class WumpusWorld {

	public int filas;
	public int columnas;
	
	private Map<String, Celda> mundo = new HashMap<>();
	private Set<Celda> pozos = new HashSet<>();

	public void create(int filas, int columnas){
		this.filas = filas;
		this.columnas = columnas;

		mundo.put("hero", new Celda(0, 0));
		mundo.put("gold", new Celda(filas - 1, columnas - 1));
		mundo.put("wumpus", new Celda(filas - 1, 0));

		Matriz.world = this; // Registra el mundo en la clase matriz

	}

	public void putPit(Celda celda){
		pozos.add(celda);
	}

	public void putPits(Collection<Celda> celdas){
		pozos.addAll(celdas);
	}

	public void putOther(String objeto, Celda celda){
		mundo.put(objeto, celda);
	}

	void print(){
		System.out.println("world," + filas + "," + columnas );
		
		for(Map.Entry<String,Celda> object : mundo.entrySet()){
			System.out.println(object.getKey() + "," + object.getValue());
		}

		for(Celda pit : pozos){
			System.out.println("pit," + pit);
		}
	}

	public List<Celda> condicion(List<Celda> as, List<Celda> bs, BiPredicate<Float, Float> p){
		
		List<Celda> rs = new ArrayList<>();

		Celda a = null;
		Celda b = null;

		while (!as.isEmpty() && !bs.isEmpty()){
			if(a == null || index(a) < index(b)){
				a = as.remove(0); 
			}else if(b == null || index(a) > index(b)){
				b = bs.remove(0); 
			}else{
				if(p.test(a.valor, b.valor)) 
					rs.add(a);
				a = as.remove(0);
				b = bs.remove(0);
			}
		}

		return rs;
	}

	private int index(Celda c){
		if(c == null) 
			return -1;
		return c.fila * columnas + c.columna;
	}
}

class Celda {
	public int fila;
	public int columna;

	public float valor = 0;

	public Celda(int fila, int columna){
		this.fila = fila;
		this.columna = columna;
	}

	public Celda(int fila, int columna, float valor){
		this.fila = fila;
		this.columna = columna;
		this.valor = valor;
	}

	public String toString(){
		return "[" + String.valueOf(fila) + ", " + String.valueOf(columna) + "]";
	}
}

class Matriz {

	/* De Clase */

	public static WumpusWorld world = null;

	// Genera la representación de valores
	public static Matriz constante(int valor){
		return new Matriz(world, valor, 0, 0);
	}

	public static Matriz i(){
		return new Matriz(world, 0, 1, 0);
	}

	public static Matriz j(){
		return new Matriz(world, 0, 0, 1);
	}

	public static Matriz operar(Matriz a, Matriz b, BinaryOperator<Float> f){
		for (int i = 0; i < world.filas; i++){
			for (int j = 0; j < world.columnas; j++){
				a.celda[i][j] = f.apply(a.celda[i][j], b.celda[i][j]);
			}
		}
		return a;
	}

	/* De Instancia */
	public float[][] celda;

	public Matriz(WumpusWorld w, int valor, int fi, int fj){

		celda = new float[w.filas][w.columnas];

		for (int i = 0; i < w.filas; i++){
			for (int j = 0; j < w.columnas; j++){
				celda[i][j] = valor + i*fi + j*fj;
			}
		}
	}

	// Convierte la matriz en un conjunto de celdas
	public List<Celda> celdas(){
		List<Celda> rs = new ArrayList<>();
		for (int i = 0; i < celda.length; i++){
			for (int j = 0; j < celda[i].length; j++){
				rs.add(new Celda(i, j, celda[i][j]));
			}
		}
		return rs;
	}
	
}