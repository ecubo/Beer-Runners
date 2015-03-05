package com.edatta.android.beerrunners;

import com.squareup.picasso.Picasso;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.text.Html;
import android.text.method.LinkMovementMethod;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

public class SingleItemView extends Activity {

    TextView txtfecha;
    TextView txttitulo;
    TextView txtminidesc;
    TextView txtdescripcion;
    ImageView imgurl;

    String fecha;
    String titulo;
    String minidesc;
    String descripcion;
    String url;

    int position;
 
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.agenda_listview_singleitem);

        Intent i = getIntent();

        position = i.getExtras().getInt("position");

        fecha = i.getExtras().getString("fecha");
        titulo = i.getExtras().getString("titulo");
        minidesc = i.getExtras().getString("minidesc");
        descripcion = i.getExtras().getString("descripcion");
        url = i.getExtras().getString("url");

        txtfecha = (TextView) findViewById(R.id.agendaFecha2);
        txttitulo = (TextView) findViewById(R.id.agendaTitulo2);
        txtminidesc = (TextView) findViewById(R.id.agendaMinidesc2);
        txtdescripcion = (TextView) findViewById(R.id.agendaDesc2);
        imgurl = (ImageView) findViewById(R.id.agendaUrl2);

        txtfecha.setText(Utils.FormatearFecha(fecha));
        txttitulo.setText(titulo);
        txtminidesc.setText(minidesc);
        txtdescripcion.setText(Html.fromHtml(descripcion));
        txtdescripcion.setMovementMethod(LinkMovementMethod.getInstance());
        if(url.equals("")) {
        	imgurl.setVisibility(View.GONE);
        }
        else {
            Picasso
            .with(this)
            .load(getString(R.string.url_api_rest) + "agenda/" + url)
            .into(imgurl);            
        }

        replaceFonts(this);

    }

    public void replaceFonts(Context ctx) {
        //Para todos
        Typeface tf = Typeface.createFromAsset(ctx.getAssets(), "fonts/BebasNeue.otf");

        TextView tv;

        tv = (TextView) findViewById(R.id.agendaTitulo2);
        tv.setTypeface(tf);

        tv = (TextView) findViewById(R.id.agendaFecha2);
        tv.setTypeface(tf);

    }
}