package com.edatta.android.beerrunners;

public class Carrera {

    private int id;
    private String fecha;
    private String kilometros;
    private String frase;

    public Carrera(int id, String fecha, String kilometros, String frase){
        this.id = id;
        this.fecha = fecha;
        this.kilometros = kilometros;
        this.frase = frase;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public String getKilometros() {
        return kilometros;
    }

    public void setKilometros(String kilometros) {
        this.kilometros = kilometros;
    }

    public String getFrase() {
        return frase;
    }

    public void setFrase(String frase) {
        this.frase = frase;
    }
}
