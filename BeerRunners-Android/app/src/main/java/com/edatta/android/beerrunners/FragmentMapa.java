package com.edatta.android.beerrunners;

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.Marker;

import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.AlertDialog;
import android.text.Html;
import android.text.method.LinkMovementMethod;
import android.widget.TextView;

/**
 * Tab Mapa
 */
public class FragmentMapa extends SupportMapFragment  {

    private static final String TAG = FragmentMapa.class.getName();

    private GoogleMap mapa;
    private Bar[] bares;
    private HashMap<Marker, Bar> barMarker = new HashMap<Marker, Bar>();

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = super.onCreateView(inflater, container, savedInstanceState);
        setUpMapIfNeeded(inflater);
        return v;
    }

    private void setUpMapIfNeeded(LayoutInflater inflater) {
        // Do a null check to confirm that we have not already instantiated the map.
        if (mapa == null) {
            // Try to obtain the map from the SupportMapFragment.
            mapa = getMap();
            // Check if we were successful in obtaining the map.
            if (mapa != null) {
                setUpMap(inflater);
            }
        }
    }
    private void setUpMap(LayoutInflater inflater) {

        Utils utils = new Utils(getActivity());

        try {
            JSONArray baresArray = new JSONArray(utils.leerJson("bares"));

            bares = new Bar[baresArray.length()];

            for (int i = 0; i < bares.length; i++) {
                JSONObject baresObject = baresArray.getJSONObject(i);

                Bar bar = new Bar();

                bar.setId(baresObject.getInt("id"));
                bar.setAddress(baresObject.getString("address"));
                bar.setLat(baresObject.getDouble("lat"));
                bar.setLng(baresObject.getDouble("lng"));
                bar.setName(baresObject.getString("name"));
                bar.setRedsocial(baresObject.getString("redsocial"));
                bar.setTel(baresObject.getString("tel"));
                bar.setType(baresObject.getString("type"));
                bar.setWeb(baresObject.getString("web"));

                bares[i] = bar;
            }

        } catch (JSONException e) {
            Log.e(TAG, e.getLocalizedMessage());
        }

        mapa.setMyLocationEnabled(true);
        mapa.setInfoWindowAdapter(new PopupAdapter(inflater));
        mapa.setOnInfoWindowClickListener(new GoogleMap.OnInfoWindowClickListener() {
            @Override
            public void onInfoWindowClick(Marker marker) {

                Bar bar = barMarker.get(marker);

                String markerInfoHtml = "";
                if(!bar.getAddress().equals("")) {markerInfoHtml += "<b>Dirección: </b>" + bar.getAddress() + "<br />";}
                if(!bar.getTel().equals("")) {markerInfoHtml += "<b>Teléfono: </b>" + bar.getTel() + "<br />";}
                if(!bar.getWeb().equals("")) {markerInfoHtml += "<b>Web: </b>" + "<a href=\"" + bar.getWeb() + "\">" + bar.getWeb() + "</a><br />";}
                if(!bar.getRedsocial().equals("")) {markerInfoHtml += "<b>Red Social: </b>" + "<a href=\"" + bar.getRedsocial() + "\">Facebook</a><br />";}

                if(markerInfoHtml.equals("")) {return;}


                TextView tv  = new TextView(getActivity());
                tv.setMovementMethod(LinkMovementMethod.getInstance());
                tv.setText(Html.fromHtml(markerInfoHtml));
                tv.setPadding(30, 30, 30, 0);

                AlertDialog.Builder itemDialog = new AlertDialog.Builder(getActivity());
                itemDialog.setView(tv);
                itemDialog.setPositiveButton(android.R.string.ok, null);
                itemDialog.setTitle(bar.getName());
                itemDialog.show();

            }
        });

        LatLng madrid = new LatLng(40.416947, -3.703528);
        int zoom = 12;
        CameraPosition camPos = new CameraPosition.Builder().target(madrid).zoom(zoom).build();

        CameraUpdate camaraMadrid = CameraUpdateFactory.newCameraPosition(camPos);
        mapa.animateCamera(camaraMadrid);

        for (Bar bar : bares) {
            if ((bar.getLat() != null) && bar.getLng() != null && bar.getName() != null) {
                Marker mbar = placeMarker(bar);
                barMarker.put(mbar, bar);
            }
        }
    }


    public Marker placeMarker(Bar bar) {

        String snippet = "";

        if(!bar.getAddress().equals("")) {snippet += bar.getAddress() + "\n";}
        if (snippet.endsWith("\n")) { snippet = snippet.substring(0, snippet.length() - 1);}

        return mapa.addMarker(new MarkerOptions()
                        .position(new LatLng(bar.getLat(), bar.getLng()))
                        .title(bar.getName())
                        .icon(BitmapDescriptorFactory.fromResource(R.drawable.pinmap))
                        .snippet(snippet)
        );
    }




    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        setUserVisibleHint(true);
    }
}