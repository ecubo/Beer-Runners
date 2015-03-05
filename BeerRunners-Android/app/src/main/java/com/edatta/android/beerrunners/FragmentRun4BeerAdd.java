package com.edatta.android.beerrunners;

import java.util.Calendar;

import android.content.Context;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

public class FragmentRun4BeerAdd extends FragmentActivity {

    FragmentRun4BeerUtils r4butils;

    @Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.fragment_run4beer_add);

        final Button btnAceptarCarrera = (Button) findViewById(R.id.aceptarCarrera);
        final Button btnGuardarCarrera = (Button) findViewById(R.id.guardarCarrera);
        final Button btnCancelarCarrera = (Button) findViewById(R.id.cancelarCarrera);
        final EditText dpAddCarrera = (EditText) findViewById(R.id.dpAddCarrera);
        final EditText fechaAddCarrera = (EditText) findViewById(R.id.fechaAddCarrera);
        final TextView mensajeKmRecorridos = (TextView)findViewById(R.id.mensajeKmRecorridos);
        final EditText txtkmRecorridos = (EditText) findViewById(R.id.kilometrosRecorridos);

        r4butils = new FragmentRun4BeerUtils(getSupportFragmentManager(), dpAddCarrera, txtkmRecorridos, fechaAddCarrera, getString(R.string.r4b_frase_no_valido), getString(R.string.r4b_frase_no_valido_fecha), getString(R.string.r4b_frase_default));

        Calendar fecha = Calendar.getInstance();
        r4butils.initialDate(fecha.get(Calendar.YEAR), fecha.get(Calendar.MONTH), fecha.get(Calendar.DAY_OF_MONTH));

		getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_VISIBLE);

        dpAddCarrera.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                r4butils.showDatePickerDialog();
            }
        });

        btnAceptarCarrera.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                r4butils.aceptar(mensajeKmRecorridos);
            }
        });

        btnGuardarCarrera.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {

                EditText fechaAddCarrera = (EditText) findViewById(R.id.fechaAddCarrera);

                r4butils.guardar(fechaAddCarrera);

                Intent returnIntent = new Intent();

                if (r4butils.lastkm >= 0.1) {
                    returnIntent.putExtra("kmrec", r4butils.df().format(r4butils.lastkm));
                    returnIntent.putExtra("fechahoy",Utils.FormatearFecha(fechaAddCarrera.getText().toString()));
                    returnIntent.putExtra("fraserandom",r4butils.lastfrase);
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

        tv = (TextView) findViewById(R.id.r4b_add_str1);
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

        btn = (Button) findViewById(R.id.guardarCarrera);
        btn.setTypeface(tf);
        btn = (Button) findViewById(R.id.cancelarCarrera);
        btn.setTypeface(tf);
        btn = (Button) findViewById(R.id.aceptarCarrera);
        btn.setTypeface(tf);

    }

}
