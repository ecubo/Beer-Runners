package com.edatta.android.beerrunners;

import java.util.Calendar;

public class Pasaporte {

    private Object url;
    private String fechaAgregado;
    private int fechaYear;
    private int fechaMonth;
    private int fechaDay;
    private boolean isHardCoded;

    public Pasaporte(Object url, int fechaYear, int fechaMonth, int fechaDay, boolean isHardCoded) {
        this.url = url;
        this.fechaYear = fechaYear;
        this.fechaMonth = fechaMonth;
        this.fechaDay = fechaDay;
        this.isHardCoded = isHardCoded;
        setFechaAgregado(fechaYear, fechaMonth, fechaDay);
    }

    public Object getUrl() {
        return url;
    }

    public void setUrl(Object url) {
        this.url = url;
    }

    public String getFechaAgregado() {
        return fechaAgregado;
    }

    public void setFechaAgregado( int fechaYear, int fechaMonth, int fechaDay) {
        Calendar calendar = Calendar.getInstance();
        calendar.clear();
        calendar.set(fechaYear, fechaMonth, fechaDay);
        this.fechaAgregado = calendar.toString();
    }

    public int getFechaYear() {
        return fechaYear;
    }

    public void setFechaYear(int fechaYear) {
        this.fechaYear = fechaYear;
    }

    public int getFechaMonth() {
        return fechaMonth;
    }

    public void setFechaMonth(int fechaMonth) {
        this.fechaMonth = fechaMonth;
    }

    public int getFechaDay() {
        return fechaDay;
    }

    public void setFechaDay(int fechaDay) {
        this.fechaDay = fechaDay;
    }

    public boolean isHardCoded() {
        return isHardCoded;
    }

    public void setHardCoded(boolean isHardCoded) {
        this.isHardCoded = isHardCoded;
    }
}
