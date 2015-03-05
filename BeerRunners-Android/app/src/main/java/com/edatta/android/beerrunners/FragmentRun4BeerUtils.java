package com.edatta.android.beerrunners;

import android.support.v4.app.FragmentManager;
import android.widget.EditText;
import android.widget.TextView;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Random;

public class FragmentRun4BeerUtils {

    double lastkm = -1;
    String lastfrase = "";
    boolean errorkm = false;

    //init elements
    EditText txtkmRecorridos;
    EditText fechaAddCarrera;
    EditText dpAddCarrera;
    String frasenovalido;
    String frasenovalidofecha;
    String frasedefault;

    DecimalFormat df;
    DatePickerFragment dtp;
    FragmentManager fm;

    FragmentRun4BeerUtils(FragmentManager fm, EditText dpAddCarrera, EditText txtkmRecorridos, EditText fechaAddCarrera, String frasenovalido, String frasenovalidofecha, String frasedefault) {

        this.txtkmRecorridos = txtkmRecorridos;
        this.fechaAddCarrera = fechaAddCarrera;
        this.dpAddCarrera = dpAddCarrera;
        this.frasenovalido = frasenovalido;
        this.frasenovalidofecha = frasenovalidofecha;
        this.frasedefault = frasedefault;


        df = new DecimalFormat("##.##");
        DecimalFormatSymbols dfs = new DecimalFormatSymbols();
        dfs.setDecimalSeparator('.');
        df.setDecimalFormatSymbols(dfs);

        dtp = new DatePickerFragment();

        this.fm = fm;
    }

    public void aceptar(TextView mensajeKmRecorridos) {
        verKm(true);
        fraseCarrera();
        mensajeKmRecorridos.setText(lastfrase);
    }

    public void guardar(EditText fechaAddCarrera) {
        if(verKm(false) != lastkm || fechaAddCarrera.equals("")) {
            verKm(true);
            fraseCarrera();
        }
    }


    public void showDatePickerDialog() {

        dtp.setUpdateButton(dpAddCarrera);
        dtp.setUpdateEditText(fechaAddCarrera);

        dtp.show(fm, "Seleccionar Fecha");

    }

    public void initialDate(int year, int month, int day) {

        //DatePickerFragment dtp = new DatePickerFragment();

        dtp.setUpdateButton(dpAddCarrera);
        dtp.setUpdateEditText(fechaAddCarrera);

        DecimalFormat mFormat= new DecimalFormat("00");
        String _month = mFormat.format(Double.valueOf(month+1));
        String _day = mFormat.format(Double.valueOf(day));

        CharSequence edittextDate = year+"-"+_month+"-"+_day;
        CharSequence btnDate = Utils.FormatearFecha(edittextDate.toString());

        fechaAddCarrera.setText(edittextDate.toString());
        dpAddCarrera.setText(btnDate.toString());
    }

    public DecimalFormat df() {
        final DecimalFormat df = new DecimalFormat("##.##");
        final DecimalFormatSymbols dfs = new DecimalFormatSymbols();
        dfs.setDecimalSeparator('.');
        df.setDecimalFormatSymbols(dfs);
        return df;
    }


    public void fraseCarrera() {

        String fraserandom = "";
        if(!errorkm) {

            Random aleatorio = new Random();
            fraserandom = frasedefault;


            if(lastkm < 1) {
                if(FragmentRun4BeerPager.frases_11.size()!=0) {
                    fraserandom = FragmentRun4BeerPager.frases_11.get(aleatorio.nextInt(FragmentRun4BeerPager.frases_11.size()));
                }
            }
            else if(lastkm >= 1 && lastkm < 3) {
                if(FragmentRun4BeerPager.frases_12.size()!=0) {
                    fraserandom = FragmentRun4BeerPager.frases_12.get(aleatorio.nextInt(FragmentRun4BeerPager.frases_12.size()));
                }
            }
            else if(lastkm >= 3 && lastkm < 10) {
                if(FragmentRun4BeerPager.frases_13.size()!=0) {
                    fraserandom = FragmentRun4BeerPager.frases_13.get(aleatorio.nextInt(FragmentRun4BeerPager.frases_13.size()));
                }
            }
            else if(lastkm >= 10 && lastkm < 20) {
                if(FragmentRun4BeerPager.frases_14.size()!=0) {
                    fraserandom = FragmentRun4BeerPager.frases_14.get(aleatorio.nextInt(FragmentRun4BeerPager.frases_14.size()));
                }
            }
            else if(lastkm >= 20 && lastkm < 40) {
                if(FragmentRun4BeerPager.frases_15.size()!=0) {
                    fraserandom = FragmentRun4BeerPager.frases_15.get(aleatorio.nextInt(FragmentRun4BeerPager.frases_15.size()));
                }
            }
            else if(lastkm >= 40) {
                if(FragmentRun4BeerPager.frases_16.size()!=0) {
                    fraserandom = FragmentRun4BeerPager.frases_16.get(aleatorio.nextInt(FragmentRun4BeerPager.frases_16.size()));
                }
            }

        }
        else {
            fraserandom = lastfrase;
        }

        lastfrase = fraserandom.replace("\\n", System.getProperty("line.separator"));
    }

    public double verKm(boolean recordar) {

        double kmrec = 0;

        String kmstr = txtkmRecorridos.getText().toString();

        String fechahoy = fechaAddCarrera.getText().toString();

        if(fechahoy.matches("")){
            lastfrase = frasenovalidofecha;
            kmrec = 0;
            errorkm = true;
        }
        else {
            if (kmstr.matches("")) {
                txtkmRecorridos.setText("0");
                kmstr = "0";
            }


            try {
                kmrec = Double.parseDouble(kmstr);
                errorkm = false;

                if(kmrec==0){
                    lastfrase = frasenovalido;
                    kmrec = 0;
                    errorkm = true;
                }

            } catch (Exception e) {
                lastfrase = frasenovalido;
                kmrec = 0;
                errorkm = true;
            }

            if (recordar) {
                lastkm = kmrec;
            }
        }

        return kmrec;
    }

}
