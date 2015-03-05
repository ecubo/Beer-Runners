package com.edatta.android.beerrunners;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.Window;
import android.view.WindowManager;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class SplashScreenActivity extends Activity {

    private static final String TAG = SplashScreenActivity.class.getName();
    boolean timeout = false;
    ProgressDialog progressDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_splash_screen);


        DialogHandler appdialog = new DialogHandler();
        appdialog.Confirm(this, getString(R.string.splash_mayor_de_edad_title), getString(R.string.splash_mayor_de_edad), getString(R.string.home_no), getString(R.string.home_si), mayorDeEdad(), noMayorDeEdad());
    }

    public Runnable mayorDeEdad(){
        return new Runnable() {
            public void run() {
                progressDialog = new ProgressDialog(SplashScreenActivity.this);
                progressDialog.setMessage("Cargando...");
                progressDialog.setCancelable(false);
                progressDialog.show();
                new PrefetchData().execute();
            }
        };
    }
    public Runnable noMayorDeEdad(){return new Runnable() {public void run() {finish();}};}



    private class PrefetchData extends AsyncTask<Void, Void, Void> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }

        @Override
        protected Void doInBackground(Void... arg0) {

            JsonParser jsonParser = new JsonParser();
            try {
                String json = jsonParser.getJSONFromUrl(getString(R.string.url_api_rest) + "all");
                Utils utils = new Utils(SplashScreenActivity.this);
                JSONObject jObj = new JSONObject();

                //Local
                if(!utils.existeJson("bares")) {
                    jObj.put("bares", new JSONArray());
                    utils.escribirJson("bares", jObj.getString("bares"));
                }
                if(!utils.existeJson("motivacionales")) {
                    jObj.put("motivacionales", new JSONArray());
                    utils.escribirJson("motivacionales", jObj.getString("motivacionales"));
                }
                if(!utils.existeJson("noticias")) {
                    jObj.put("noticias", new JSONArray());
                    utils.escribirJson("noticias", jObj.getString("noticias"));
                }
                if(!utils.existeJson("carreras")) {
                    jObj.put("carreras", new JSONArray());
                    utils.escribirJson("carreras", jObj.getString("carreras"));
                }
                if(!utils.existeJson("frases")) {
                    jObj.put("frases", new JSONArray());
                    utils.escribirJson("frases", jObj.getString("frases"));
                }

                //Motivacionales Favs
                if(!utils.existeJson("motivacionalesfav")) {
                    jObj.put("motivacionalesfav", new JSONArray());
                    utils.escribirJson("motivacionalesfav", jObj.getString("motivacionalesfav"));
                }
                //Pasaportes Descargados
                if(!utils.existeJson("pasaportes")) {
                    jObj.put("pasaportes", new JSONArray());
                    utils.escribirJson("pasaportes", jObj.getString("pasaportes"));
                }

                if(json != null && !json.equals("")) {
                    jObj = new JSONObject(json).getJSONObject("all");
                    utils.escribirJson("motivacionales", jObj.getString("motivacionales"));
                    utils.escribirJson("bares", jObj.getString("bares"));
                    utils.escribirJson("noticias", jObj.getString("noticias"));
                    utils.escribirJson("frases", jObj.getString("frases"));
                }

            } catch (JSONException e) {
                Log.d(TAG, "timeout true: " + e.getLocalizedMessage());
                timeout = true;
            }

            return null;
        }

        @Override
        protected void onPostExecute(Void result) {
            super.onPostExecute(result);
            Intent i = new Intent(SplashScreenActivity.this, MainActivity.class);
            i.putExtra("timeout", timeout);
            startActivity(i);
            progressDialog.dismiss();
            finish();
        }
    }
}