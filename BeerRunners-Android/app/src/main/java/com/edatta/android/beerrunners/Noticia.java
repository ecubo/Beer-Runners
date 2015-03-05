package com.edatta.android.beerrunners;

public class Noticia {

    private String fecha;
    private String titulo;
    private String minidesc;
    private String desc;
    private String url;
    private String tag;

    public Noticia(String fecha, String titulo, String minidesc, String desc, String url, String tag){
        this.fecha = fecha;
        this.titulo = titulo;
        this.minidesc = minidesc;
        this.desc = desc;
        this.url = url;
        this.tag = tag;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getMinidesc() {
        return minidesc;
    }

    public void setMinidesc(String minidesc) {
        this.minidesc = minidesc;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getTag() {
        return tag;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }
}
