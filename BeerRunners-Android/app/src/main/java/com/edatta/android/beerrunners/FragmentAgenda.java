package com.edatta.android.beerrunners;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;

/**
 * Tab Agenda
 */
public class FragmentAgenda extends Fragment {

    private static final String TAG = FragmentAgenda.class.getName();

    JSONObject[] noticias;
    ListView listAgenda;
    AgendaListAdapter adapterAgenda;

    List<Noticia> listaNoticias = new ArrayList<Noticia>();

    TreeSet tags = new TreeSet();

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Utils utils = new Utils(getActivity());

        try {
            JSONArray noticiasArray = new JSONArray(utils.leerJson("noticias"));

            noticias = new JSONObject[noticiasArray.length()];

            for (int i = 0; i < noticiasArray.length(); i++) {
                noticias[i] = noticiasArray.getJSONObject(i);
                listaNoticias.add(new Noticia(
                        noticiasArray.getJSONObject(i).getString("fecha"),
                        noticiasArray.getJSONObject(i).getString("titulo"),
                        noticiasArray.getJSONObject(i).getString("minidesc"),
                        noticiasArray.getJSONObject(i).getString("descripcion"),
                        noticiasArray.getJSONObject(i).getString("url"),
                        noticiasArray.getJSONObject(i).getString("tag")
                ));
                if(!noticiasArray.getJSONObject(i).getString("tag").equals("Sin tag")) {
                    tags.add(noticiasArray.getJSONObject(i).getString("tag"));
                }

            }

        } catch (JSONException e) {
            Log.e(TAG, e.getLocalizedMessage());
        }
        utils = null;

    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {

        inflater.inflate(R.menu.menu_agenda, menu);

        int i = 0;
        menu.add(0, i++, 0, "Ver todos");
        for(Object tag : tags) {
            if(!tag.equals("General")) {
                menu.add(0, i++, 0, (String) tag);
            }
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        switch (item.getItemId()) {
            case 0:
                adapterAgenda.getFilter().filter("Ver todos");
                return true;
            default:
                adapterAgenda.getFilter().filter(item.getTitle());
        }
        return super.onOptionsItemSelected(item);
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View v = inflater.inflate(R.layout.fragment_agenda, container, false);
        setHasOptionsMenu(true);

        //Noticia default
        if(noticias.length==0) {
            listaNoticias.add(new Noticia("",getString(R.string.agenda_0noticias_titulo),getString(R.string.agenda_0noticias_minidesc),"","", getString(R.string.agenda_sin_tag)));
        }

        listAgenda = (ListView) v.findViewById(R.id.listAgenda);
        adapterAgenda = new AgendaListAdapter(getActivity(), listaNoticias);
        listAgenda.setAdapter(adapterAgenda);

        listAgenda.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                Intent i = new Intent(getActivity(), SingleItemView.class);

                i.putExtra("fecha", listaNoticias.get(position).getFecha());
                i.putExtra("titulo", listaNoticias.get(position).getTitulo());
                i.putExtra("minidesc", listaNoticias.get(position).getMinidesc());
                i.putExtra("descripcion", listaNoticias.get(position).getDesc());
                i.putExtra("url", listaNoticias.get(position).getUrl());

                i.putExtra("position", position);

                startActivity(i);
            }

        });

        return v;
    }


    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        setUserVisibleHint(true);
    }
}
