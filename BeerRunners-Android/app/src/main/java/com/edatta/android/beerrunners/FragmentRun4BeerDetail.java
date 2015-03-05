package com.edatta.android.beerrunners;

import android.content.Context;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import java.util.Calendar;

public class FragmentRun4BeerDetail extends FragmentActivity {

    FragmentRun4BeerUtils r4butils;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.fragment_run4beer_detail);


        final Button btnBorrarCarrera = (Button) findViewById(R.id.borrarCarrera);
        final Button btnEditarCarrera = (Button) findViewById(R.id.editarCarrera);
        final Button btnCancelarCarrera = (Button) findViewById(R.id.cancelarCarrera);

        final EditText dpAddCarrera = (EditText) findViewById(R.id.dpAddCarrera);
        final EditText fechaAddCarrera = (EditText) findViewById(R.id.fechaAddCarrera);
        final TextView mensajeKmRecorridos = (TextView)findViewById(R.id.mensajeKmRecorridos);
        final EditText kilometrosRecorridos = (EditText) findViewById(R.id.kilometrosRecorridos);

        r4butils = new FragmentRun4BeerUtils(getSupportFragmentManager(), dpAddCarrera, kilometrosRecorridos, fechaAddCarrera, getString(R.string.r4b_frase_no_valido), getString(R.string.r4b_frase_no_valido_fecha), getString(R.string.r4b_frase_default));

        Bundle bundle = getIntent().getExtras();
        final int position = bundle.getInt("position", -1);
        final String fechaIntent = bundle.getString("fecha");
        final Calendar fecha = Utils.FormatearFechaParaDate(fechaIntent);
        final String kilometros = bundle.getString("kilometros");
        final String frase = bundle.getString("frase");

        if(position>-1){
            r4butils.initialDate(fecha.get(Calendar.YEAR), fecha.get(Calendar.MONTH), fecha.get(Calendar.DAY_OF_MONTH));
            kilometrosRecorridos.setText(kilometros);
            mensajeKmRecorridos.setText(frase);
        }

        dpAddCarrera.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                r4butils.showDatePickerDialog();
            }
        });

        btnBorrarCarrera.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                Intent returnIntent = new Intent();
                returnIntent.putExtra("borrar", true);
                returnIntent.putExtra("position",position);
                setResult(RESULT_OK, returnIntent);
                finish();
            }
        });

        btnEditarCarrera.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                EditText fechaAddCarrera = (EditText) findViewById(R.id.fechaAddCarrera);

                r4butils.guardar(fechaAddCarrera);

                Intent returnIntent = new Intent();

                if (r4butils.lastkm >= 0.1) {
                    returnIntent.putExtra("kmrec", r4butils.df.format(r4butils.lastkm));
                    returnIntent.putExtra("fechahoy",Utils.FormatearFecha(fechaAddCarrera.getText().toString()));
                    returnIntent.putExtra("fraserandom",r4butils.lastfrase);

                    //Borro y edito
                    returnIntent.putExtra("editar", true);
                    returnIntent.putExtra("position",position);

                    setResult(RESULT_OK,returnIntent);
                    finish();
                }
                else {
                    r4butils.aceptar(mensajeKmRecorridos);
                }
            }
        });

        btnCancelarCarrera.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                Intent returnIntent = new Intent();
                setResult(RESULT_CANCELED,returnIntent);
                finish();
            }
        });

        replaceFonts(this);
    }

    public void replaceFonts(Context ctx) {

        //Para todos
        Typeface tf = Typeface.createFromAsset(ctx.getAssets(), "fonts/BebasNeue.otf");

        TextView tv;
        Button btn;

        tv = (TextView) findViewById(R.id.r4b_edit_str1);
        tv.setTypeface(tf);
        tv = (TextView) findViewById(R.id.dpAddCarrera);
        tv.setTypeface(tf);
        tv = (TextView) findViewById(R.id.fechaAddCarrera);
        tv.setTypeface(tf);
        tv = (TextView) findViewById(R.id.kilometrosRecorridos);
        tv.setTypeface(tf);
        tv = (TextView) findViewById(R.id.r4b_str5);
        tv.setTypeface(tf);
        tv = (TextView) findViewById(R.id.mensajeKmRecorridos);
        tv.setTypeface(tf);

        btn = (Button) findViewById(R.id.editarCarrera);
        btn.setTypeface(tf);
        btn = (Button) findViewById(R.id.cancelarCarrera);
        btn.setTypeface(tf);
        btn = (Button) findViewById(R.id.borrarCarrera);
        btn.setTypeface(tf);

    }

}
