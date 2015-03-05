package com.edatta.android.beerrunners;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.os.Parcelable;
import android.support.v4.app.Fragment;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.viewpagerindicator.CirclePageIndicator;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class FragmentRun4BeerPager extends Fragment {

    private static final String TAG = FragmentAgenda.class.getName();

    ListView listRun4Beer;
    Run4BeerListAdapter adapterRun4Beer;
    List<Carrera> carreras = new ArrayList<Carrera>();

    View pagerItemResumen;

    public static List<String> frases_0 = new ArrayList<String>();

    public static List<String> frases_1 = new ArrayList<String>();
    public static List<String> frases_2 = new ArrayList<String>();
    public static List<String> frases_3 = new ArrayList<String>();
    public static List<String> frases_4 = new ArrayList<String>();
    public static List<String> frases_5 = new ArrayList<String>();
    public static List<String> frases_6 = new ArrayList<String>();
    public static List<String> frases_7 = new ArrayList<String>();

    public static List<String> frases_11 = new ArrayList<String>();
    public static List<String> frases_12 = new ArrayList<String>();
    public static List<String> frases_13 = new ArrayList<String>();
    public static List<String> frases_14 = new ArrayList<String>();
    public static List<String> frases_15 = new ArrayList<String>();
    public static List<String> frases_16 = new ArrayList<String>();

    int lastid;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


        lastid = 50;

        Utils utils = new Utils(getActivity());

        try {
            JSONArray carrerasArray = new JSONArray(utils.leerJson("carreras"));

            for (int i = 0; i < carrerasArray.length(); i++) {
                try {
                    lastid = carrerasArray.getJSONObject(i).getInt("id");

                    carreras.add(
                            new Carrera(
                                    carrerasArray.getJSONObject(i).getInt("id"),
                                    carrerasArray.getJSONObject(i).getString("fecha"),
                                    carrerasArray.getJSONObject(i).getString("kilometros"),
                                    carrerasArray.getJSONObject(i).getString("frase")
                            ));
                } catch (JSONException e) {
                    Log.e(TAG, e.getLocalizedMessage());
                }
            }

        } catch (JSONException e) {
            Log.e(TAG, e.getLocalizedMessage());
        }

        try {
            JSONArray frasesArray = new JSONArray(utils.leerJson("frases"));

            frases_0.add("¿Preparado?\n¡Empieza a correr y gánate esa cerveza!");

            frases_1.add("¡Acabas de comenzar!\nConvence a algún amigo y salid juntos a correr");
            frases_2.add("¡Todavía no lo has dejado!\nQuizás seas un auténtico Beer Runner…");
            frases_3.add("Correr es saludable, así que nos tomamos una cerveza…\n¡A tu salud!");
            frases_4.add("¡Vaya! Parece que vas en serio…\nte mereces esa cerveza bien fresquita");
            frases_5.add("Tú sí que te mereces dos cervezas bien frías.\nDisfruta mientras piensas en nuevos retos");
            frases_6.add("¡Eres un destacado Beer Runner!\nTe pedirán consejo sobre running… ¡Y sobre cerveza!");
            frases_7.add("¡Eres la élite de los Beer Runners!\nLos jóvenes se sentarán en torno a hogueras y escucharán tus proezas");

            frases_11.add("¡Poco a poco!\nLleva con orgullo las zapatillas de correr");
            frases_12.add("¡Continúa!\nSe va adivinando tu cerveza en el horizonte");
            frases_13.add("¡Lo has conseguido!\nEl camarero te espera en la meta");
            frases_14.add("Sigues dejando atrás kilómetros...\n¡Disfruta de tu cerveza!");
            frases_15.add("¡Increíble, Beer Runner!\nTe mereces un par de cervezas");
            frases_16.add("¡Un par de cervezas con otros Beer Runners es lo mejor de la carrera!");

            for (int i = 0; i < frasesArray.length(); i++) {
                if(frasesArray.getJSONObject(i).getString("rango").equals("0")) {
                    frases_0.add(frasesArray.getJSONObject(i).getString("frase"));
                }

                else if(frasesArray.getJSONObject(i).getString("rango").equals("1")) {
                    frases_1.add(frasesArray.getJSONObject(i).getString("frase"));
                }
                else if(frasesArray.getJSONObject(i).getString("rango").equals("2")) {
                    frases_2.add(frasesArray.getJSONObject(i).getString("frase"));
                }
                else if(frasesArray.getJSONObject(i).getString("rango").equals("3")) {
                    frases_3.add(frasesArray.getJSONObject(i).getString("frase"));
                }
                else if(frasesArray.getJSONObject(i).getString("rango").equals("4")) {
                    frases_4.add(frasesArray.getJSONObject(i).getString("frase"));
                }
                else if(frasesArray.getJSONObject(i).getString("rango").equals("5")) {
                    frases_5.add(frasesArray.getJSONObject(i).getString("frase"));
                }
                else if(frasesArray.getJSONObject(i).getString("rango").equals("6")) {
                    frases_6.add(frasesArray.getJSONObject(i).getString("frase"));
                }
                else if(frasesArray.getJSONObject(i).getString("rango").equals("7")) {
                    frases_7.add(frasesArray.getJSONObject(i).getString("frase"));
                }

                else if(frasesArray.getJSONObject(i).getString("rango").equals("11")) {
                    frases_11.add(frasesArray.getJSONObject(i).getString("frase"));
                }
                else if(frasesArray.getJSONObject(i).getString("rango").equals("12")) {
                    frases_12.add(frasesArray.getJSONObject(i).getString("frase"));
                }
                else if(frasesArray.getJSONObject(i).getString("rango").equals("13")) {
                    frases_13.add(frasesArray.getJSONObject(i).getString("frase"));
                }
                else if(frasesArray.getJSONObject(i).getString("rango").equals("14")) {
                    frases_14.add(frasesArray.getJSONObject(i).getString("frase"));
                }
                else if(frasesArray.getJSONObject(i).getString("rango").equals("15")) {
                    frases_15.add(frasesArray.getJSONObject(i).getString("frase"));
                }
                else if(frasesArray.getJSONObject(i).getString("rango").equals("16")) {
                    frases_16.add(frasesArray.getJSONObject(i).getString("frase"));
                }
            }

        } catch (JSONException e) {
            Log.e(TAG, e.getLocalizedMessage());
        }
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.menu_r4b, menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        switch (item.getItemId()) {
            case R.id.menu_r4b_borrar:

                AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
                builder.setTitle("Borrar carreras");
                builder.setMessage("¿Deseas borrar todo el historial de carreras?")
                        .setCancelable(false)
                        .setPositiveButton("Sí", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {
                                try {
                                    Utils utils = new Utils(getActivity());
                                    JSONObject jObj = new JSONObject();
                                    jObj.put("carreras", new JSONArray());
                                    utils.escribirJson("carreras", jObj.getString("carreras"));
                                    adapterRun4Beer.carreras.clear();
                                    adapterRun4Beer.notifyDataSetChanged();
                                    actualizarResumenCarreras();

                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }
                            }
                        })
                        .setNegativeButton("No", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {
                                dialog.cancel();
                            }
                        });
                AlertDialog alert = builder.create();
                alert.show();
        }
        return super.onOptionsItemSelected(item);
    }
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View v = inflater.inflate(R.layout.fragment_run4beer_pager, container, false);
        setHasOptionsMenu(true);

        ViewPager pager = (ViewPager) v.findViewById(R.id.pagerR4B);
        pager.setAdapter(new Run4BeerPagerAdapter());
        pager.setCurrentItem(0);

        CirclePageIndicator mIndicator = (CirclePageIndicator) v.findViewById(R.id.indicator);

        final float density = getResources().getDisplayMetrics().density;

        //#AARRGGBB
        mIndicator.setBackgroundColor(0x00888888);
        mIndicator.setRadius(8 * density);
        mIndicator.setPageColor(0xFFFFFFFF);
        mIndicator.setFillColor(0xFF515150);
        mIndicator.setStrokeColor(0xFFFFFFFF);
        mIndicator.setStrokeWidth(0);

        mIndicator.setViewPager(pager);

        return v;
    }


    public void onActivityResult(int requestCode, int resultCode, Intent data) {

        if (requestCode == 0) { //Add
            if (resultCode == Activity.RESULT_OK) {

                final int position = data.getIntExtra("position", -1);
                final boolean editar = data.getBooleanExtra("editar", false);
                final boolean borrar = data.getBooleanExtra("borrar", false);

                Utils utils = new Utils(getActivity());

                //Borrar si edito o borro
                if(borrar || editar){

                    //Obtengo carreras actuales
                    try {
                        JSONArray nuevasCarreras = new JSONArray();

                        for (int i = 0; i < adapterRun4Beer.getCount(); i++) {

                            if(adapterRun4Beer.carreras.get(position).getId()!=adapterRun4Beer.carreras.get(i).getId()) {
                                JSONObject viejaCarrera = new JSONObject();
                                lastid = adapterRun4Beer.carreras.get(i).getId();
                                viejaCarrera.put("id", adapterRun4Beer.carreras.get(i).getId());
                                viejaCarrera.put("fecha", adapterRun4Beer.carreras.get(i).getFecha());
                                viejaCarrera.put("kilometros", adapterRun4Beer.carreras.get(i).getKilometros());
                                viejaCarrera.put("frase", adapterRun4Beer.carreras.get(i).getFrase());
                                nuevasCarreras.put(viejaCarrera);
                            }
                        }

                        //Salvo en el json txt
                        JSONObject jObj = new JSONObject();
                        jObj.put("carreras", nuevasCarreras);
                        utils.escribirJson("carreras", jObj.getString("carreras"));

                    } catch (JSONException e) {
                        Log.e(TAG, e.getLocalizedMessage());
                    }

                    adapterRun4Beer.removeItemId(position);
                    adapterRun4Beer.notifyDataSetChanged();
                } //Fin borrar

                if(!borrar){
                    try {
                        String kmrandom = data.getStringExtra("kmrec");
                        String fechahoy = data.getStringExtra("fechahoy");
                        String fraserandom = data.getStringExtra("fraserandom");

                        //Obtengo carreras actuales
                        JSONArray nuevasCarreras = new JSONArray();

                        for (int i = 0; i < adapterRun4Beer.getCount(); i++) {
                            //carrera que ya existe
                            JSONObject viejaCarrera = new JSONObject();
                            lastid = adapterRun4Beer.carreras.get(i).getId();
                            viejaCarrera.put("id", adapterRun4Beer.carreras.get(i).getId());
                            viejaCarrera.put("fecha", adapterRun4Beer.carreras.get(i).getFecha());
                            viejaCarrera.put("kilometros", adapterRun4Beer.carreras.get(i).getKilometros());
                            viejaCarrera.put("frase", adapterRun4Beer.carreras.get(i).getFrase());
                            nuevasCarreras.put(viejaCarrera);
                        }

                        //Agrego mi carrera
                        JSONObject nuevaCarrera = new JSONObject();
                        lastid++;
                        nuevaCarrera.put("id", lastid);
                        nuevaCarrera.put("fecha", fechahoy);
                        nuevaCarrera.put("kilometros", kmrandom);
                        nuevaCarrera.put("frase", fraserandom);

                        nuevasCarreras.put(nuevaCarrera);

                        //Salvo en el json txt
                        JSONObject jObj = new JSONObject();
                        jObj.put("carreras", nuevasCarreras);
                        utils.escribirJson("carreras", jObj.getString("carreras"));

                        //Actualizo estructuras
                        adapterRun4Beer.addItemId(lastid, fechahoy, kmrandom, fraserandom);
                        adapterRun4Beer.notifyDataSetChanged();

                    } catch (JSONException e) {
                        Log.e(TAG, e.getLocalizedMessage());
                    }
                }
                actualizarResumenCarreras();
            }
            /*
            if (resultCode == Activity.RESULT_CANCELED) {
                //Si ha cancelado, no hago nada
            }
            */
        }
    }//onActivityResult

    public void replaceFonts(View v, Context ctx) {

        //Para todos
        Typeface tf = Typeface.createFromAsset(ctx.getAssets(), "fonts/BebasNeue.otf");

        Button btn;

        btn = (Button) v.findViewById(R.id.agregarCarrera);
        btn.setTypeface(tf);

    }

    public void replaceFonts2(View v, Context ctx) {

        //Para todos
        Typeface tf = Typeface.createFromAsset(ctx.getAssets(), "fonts/BebasNeue.otf");

        TextView tv;
        Button btn;

        tv = (TextView) v.findViewById(R.id.r4b_str1);
        tv.setTypeface(tf);
        tv = (TextView) v.findViewById(R.id.r4b_str2);
        tv.setTypeface(tf);
        tv = (TextView) v.findViewById(R.id.r4b_str3);
        tv.setTypeface(tf);
        tv = (TextView) v.findViewById(R.id.r4b_str4);
        tv.setTypeface(tf);
        tv = (TextView) v.findViewById(R.id.r4b_str5);
        tv.setTypeface(tf);
        tv = (TextView) v.findViewById(R.id.r4b_str6);
        tv.setTypeface(tf);

        btn = (Button) v.findViewById(R.id.agregarCarrera);
        btn.setTypeface(tf);

    }



    public String fraseGeneral(double totalkm) {

        String fraserandom = getString(R.string.r4b_frase_default);
        Random aleatorio = new Random();

        if(totalkm == 0) {
            if(frases_0.size()!=0) {
                fraserandom = frases_0.get(aleatorio.nextInt(frases_0.size()));
            }
        }

        else if(totalkm > 0 && totalkm < 5) {
            if(frases_1.size()!=0) {
                fraserandom = frases_1.get(aleatorio.nextInt(frases_1.size()));
            }
        }
        else if(totalkm >= 5 && totalkm < 10) {
            if(frases_2.size()!=0) {
                fraserandom = frases_2.get(aleatorio.nextInt(frases_2.size()));
            }
        }
        else if(totalkm >= 10 && totalkm < 20) {
            if(frases_3.size()!=0) {
                fraserandom = frases_3.get(aleatorio.nextInt(frases_3.size()));
            }
        }
        else if(totalkm >= 20 && totalkm < 40) {
            if(frases_4.size()!=0) {
                fraserandom = frases_4.get(aleatorio.nextInt(frases_4.size()));
            }
        }
        else if(totalkm >= 40 && totalkm < 80) {
            if(frases_5.size()!=0) {
                fraserandom = frases_5.get(aleatorio.nextInt(frases_5.size()));
            }
        }
        else if(totalkm >= 80 && totalkm < 160) {
            if(frases_6.size()!=0) {
                fraserandom = frases_6.get(aleatorio.nextInt(frases_6.size()));
            }
        }
        else if(totalkm >= 160) {
            if(frases_7.size()!=0) {
                fraserandom = frases_7.get(aleatorio.nextInt(frases_7.size()));
            }
        }

        return fraserandom;
    }
    public void actualizarResumenCarreras() {

        double totalkm = adapterRun4Beer.getTotalkm();

        TextView str1 = (TextView) pagerItemResumen.findViewById(R.id.r4b_str1);
        str1.setText(fraseGeneral(totalkm).replace("\\n", System.getProperty("line.separator")));

        TextView str2 = (TextView) pagerItemResumen.findViewById(R.id.r4b_str2);
        String str2_plurals = getResources().getQuantityString(R.plurals.dias, adapterRun4Beer.getCount(), adapterRun4Beer.getCount());
        str2.setText(str2_plurals);

        TextView str4 = (TextView) pagerItemResumen.findViewById(R.id.r4b_str4);
        str4.setText(getString(R.string.r4b_str4).replace("{km}", adapterRun4Beer.getTotalkm() + ""));
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        setUserVisibleHint(true);
    }

    private class Run4BeerPagerAdapter extends PagerAdapter {

        private LayoutInflater inflater;

        Run4BeerPagerAdapter() {
            inflater = LayoutInflater.from(getActivity());
        }

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            container.removeView((View) object);
        }

        @Override
        public int getCount() {
            return 2;
        }

        @Override
        public Object instantiateItem(ViewGroup view, int position) {

            View pagerItem;
            adapterRun4Beer = new Run4BeerListAdapter(getActivity(), carreras);

            if(position==0){
                pagerItem = inflater.inflate(R.layout.fragment_run4beer_general, view, false);
                pagerItemResumen = pagerItem;
                replaceFonts2(pagerItemResumen, getActivity());

                Button buttonAgregarCarreraDesdeResumen;
                buttonAgregarCarreraDesdeResumen = (Button) pagerItem.findViewById(R.id.agregarCarrera);
                buttonAgregarCarreraDesdeResumen.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Intent i = new Intent(getActivity(), FragmentRun4BeerAdd.class);
                        startActivityForResult(i, 0);
                    }
                });

                actualizarResumenCarreras();

            }
            else {
                pagerItem = inflater.inflate(R.layout.fragment_run4beer, view, false);


                //oncreateview
                replaceFonts(pagerItem, getActivity());

                listRun4Beer = (ListView) pagerItem.findViewById(R.id.listRun4Beer);
                listRun4Beer.setAdapter(adapterRun4Beer);

                //Botón agregar carrera
                Button buttonAgregarCarrera;
                buttonAgregarCarrera = (Button) pagerItem.findViewById(R.id.agregarCarrera);
                buttonAgregarCarrera.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Intent i = new Intent(getActivity(), FragmentRun4BeerAdd.class);
                        startActivityForResult(i, 0);
                    }
                });

                // on click
                listRun4Beer.setOnItemClickListener(new AdapterView.OnItemClickListener() {

                    public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {

                        Intent i = new Intent(getActivity(), FragmentRun4BeerDetail.class);
                        i.putExtra("position", position);
                        i.putExtra("fecha", adapterRun4Beer.carreras.get(position).getFecha());
                        i.putExtra("kilometros", adapterRun4Beer.carreras.get(position).getKilometros());
                        i.putExtra("frase", adapterRun4Beer.carreras.get(position).getFrase());
                        startActivityForResult(i, 0);
                    }
                });
            }

            view.addView(pagerItem, 0);

            return pagerItem;
        }

        @Override
        public boolean isViewFromObject(View view, Object object) {
            return view.equals(object);
        }

        @Override
        public void restoreState(Parcelable state, ClassLoader loader) {
        }

        @Override
        public Parcelable saveState() {
            return null;
        }
    }

}
