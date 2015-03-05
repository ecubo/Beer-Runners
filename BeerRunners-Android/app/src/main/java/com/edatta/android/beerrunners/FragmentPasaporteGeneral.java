package com.edatta.android.beerrunners;

import android.content.Context;
import android.content.Intent;
import android.graphics.Typeface;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

/**
 * Tab Pasaporte
 */
public class FragmentPasaporteGeneral extends Fragment {

    private static final String TAG = FragmentPasaporteGeneral.class.getName();

    List<Pasaporte> listaPasaportes = new ArrayList<Pasaporte>();

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        loadPasaportesDescargados();
    }
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_pasaporte_general, container, false);
        replaceFonts(v);

        final Button verSellos = (Button) v.findViewById(R.id.verSellos);
        final Button verificarCodigo = (Button) v.findViewById(R.id.verificarCodigo);
        final EditText pasaporteCodigo = (EditText) v.findViewById(R.id.pasaporteCodigo);

        verSellos.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                if(listaPasaportes.size()==0) {
                    Toast.makeText(getActivity(), getString(R.string.pasaporte_mensaje_inicial), Toast.LENGTH_LONG).show();
                }
                else {
                    Intent i = new Intent(getActivity(), FragmentPasaporteSellos.class);
                    startActivityForResult(i, 0);
                }
            }
        });

        verificarCodigo.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {

                final String codigo = pasaporteCodigo.getText().toString().trim();

                String hashedCode = "";
                try {
                    hashedCode = AeSimpleSHA1.SHA1("1687b6bc2c9389c33" + codigo);
                } catch (NoSuchAlgorithmException e) {
                    e.printStackTrace();
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
                ObtenerPasaporte obtenerPasaporte = new ObtenerPasaporte(hashedCode);
                obtenerPasaporte.execute();

            }
        });
        return v;
    }

    public void loadPasaportesDescargados() {
        Utils utils = new Utils(getActivity());
        JSONArray pasaportes;
        try {
            pasaportes = new JSONArray(utils.leerJson("pasaportes"));
            for (int i = 0; i < pasaportes.length(); i++) {
                JSONObject pasaporteObject = pasaportes.getJSONObject(i);
                listaPasaportes.add(new Pasaporte(pasaporteObject.getString("url"), pasaporteObject.getInt("fechaY"), pasaporteObject.getInt("fechaM"), pasaporteObject.getInt("fechaD"), false));
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public void savePasaportesDescargados() {
        Utils utils = new Utils(getActivity());
        JSONArray pasaportes = new JSONArray();

        try {
            for (Pasaporte listaPasaporte : listaPasaportes) {
                if (!listaPasaporte.isHardCoded()) {
                    JSONObject pasaporteObject = new JSONObject();
                    pasaporteObject.put("url", listaPasaporte.getUrl().toString());
                    pasaporteObject.put("fechaY", listaPasaporte.getFechaYear());
                    pasaporteObject.put("fechaM", listaPasaporte.getFechaMonth());
                    pasaporteObject.put("fechaD", listaPasaporte.getFechaDay());
                    pasaportes.put(pasaporteObject);
                }
            }
            JSONObject jObj = new JSONObject();
            jObj.put("pasaportes", pasaportes);
            utils.escribirJson("pasaportes", jObj.getString("pasaportes"));
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public void replaceFonts(View v) {
        //Para todos
        Typeface tf = Typeface.createFromAsset(getActivity().getAssets(), "fonts/BebasNeue.otf");

        Button btn;


        btn = (Button) v.findViewById(R.id.verSellos);
        btn.setTypeface(tf);
        btn = (Button) v.findViewById(R.id.verificarCodigo);
        btn.setTypeface(tf);
    }



    private class ObtenerPasaporte extends AsyncTask<Void, Void, Void> {

        private String hashedCode;
        private JSONArray pasaporteArray = new JSONArray();
        private boolean timeout = false;

        private ObtenerPasaporte(String hashedCode) {
            this.hashedCode = hashedCode;
        }

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }

        @Override
        protected Void doInBackground(Void... arg0) {
            JsonParser jsonParser = new JsonParser();
            try {
                String jsonPasaportes = jsonParser.getJSONFromUrl(getString(R.string.url_api_rest) + "bares/pasaporte/"+hashedCode);
                JSONObject object = new JSONObject(jsonPasaportes);
                pasaporteArray = object.getJSONArray("bares");
            } catch (JSONException e) {
                timeout = true;
                e.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(Void result) {
            super.onPostExecute(result);

            //Marco warnings para el usuario
            ConnectivityManager conMgr = (ConnectivityManager) getActivity().getSystemService(Context.CONNECTIVITY_SERVICE);
            NetworkInfo netinfo = conMgr.getActiveNetworkInfo();
            if (timeout || netinfo == null || !netinfo.isConnected() || !netinfo.isAvailable()) {
                Toast.makeText(getActivity(), getString(R.string.error_no_internet), Toast.LENGTH_LONG).show();
            }
            else {

                boolean no_insertar = false;

                if(pasaporteArray.length() > 0){
                    for (int i = 0; i < pasaporteArray.length(); i++) {
                        try {
                            JSONObject pasaporteObject;
                            pasaporteObject = pasaporteArray.getJSONObject(i);
                            Calendar cal = Calendar.getInstance();
                            for (Pasaporte listaPasaporte : listaPasaportes) {
                                if (listaPasaporte.getUrl().toString().equals(pasaporteObject.getString("url"))) {
                                    no_insertar = true;
                                    Toast.makeText(getActivity(), getString(R.string.pasaporte_ya_insertado), Toast.LENGTH_SHORT).show();
                                }
                            }
                            if(!no_insertar) {
                                listaPasaportes.add(new Pasaporte(pasaporteObject.getString("url"), cal.get(Calendar.YEAR), cal.get(Calendar.MONTH), cal.get(Calendar.DAY_OF_MONTH), false));
                            }
                        } catch (JSONException e) {
                            no_insertar = true;
                            Toast.makeText(getActivity(), getString(R.string.pasaporte_error), Toast.LENGTH_SHORT).show();
                            e.printStackTrace();
                        }
                    }
                    if(!no_insertar) {
                        savePasaportesDescargados();
                        Toast.makeText(getActivity(), getString(R.string.pasaporte_exito), Toast.LENGTH_SHORT).show();
                    }
                }
                else {
                    Toast.makeText(getActivity(), getString(R.string.pasaporte_fallo), Toast.LENGTH_SHORT).show();
                }
            }
        }
    }
}
