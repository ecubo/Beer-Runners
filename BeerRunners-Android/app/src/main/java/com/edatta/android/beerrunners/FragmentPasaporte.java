package com.edatta.android.beerrunners;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Typeface;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Parcelable;
import android.support.v4.app.Fragment;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.squareup.picasso.Callback;
import com.squareup.picasso.Picasso;

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
public class FragmentPasaporte extends Fragment {

    //private static final String TAG = FragmentPasaporte.class.getName();
    private ViewPager pager;
    private View aviso;
    private ImageAdapter pasaporteAdapter;
    List<Pasaporte> listaPasaportes = new ArrayList<Pasaporte>();

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);

        loadPasaportesDescargados();

        /*
        //Con pasaporte por defecto

        Utils utils = new Utils(getActivity());
        try {
            JSONArray PasaportesArray = new JSONArray(utils.leerJson("pasaportes"));
            //Default passport si vacío
            if(PasaportesArray.length()==0) {
                listaPasaportes.add(new Pasaporte(R.drawable.mot01_keep_calm, 1970, Calendar.JANUARY, 1, true));
            }

            //Cargar pasaportes descargados anteriormente
            loadPasaportesDescargados();

        } catch (JSONException e) {
            Log.e(TAG, e.getLocalizedMessage());
        }
        */
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

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.menu_pasaporte, menu);
    }


    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.menu_add_pasaporte:
                PreguntarPasaporte("Introducir Pasaporte", "Agregue el código del bar", "Cancelar", "Ok");
                return true;
        }
        return super.onOptionsItemSelected(item);
    }


    public boolean PreguntarPasaporte(String Title, String ConfirmText, String CancelBtn, String OkBtn) {
        AlertDialog dialog = new AlertDialog.Builder(getActivity()).create();
        dialog.setTitle(Title);
        dialog.setMessage(ConfirmText);

        final EditText inputEditText = new EditText(getActivity());
        inputEditText.setSingleLine(true);
        dialog.setView(inputEditText);

        dialog.setCancelable(false);
        dialog.setButton(DialogInterface.BUTTON_POSITIVE, OkBtn,
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int buttonId) {
                        final String codigo = inputEditText.getText().toString().trim();

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
        dialog.setButton(DialogInterface.BUTTON_NEGATIVE, CancelBtn,
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int buttonId) {
                        //CancelarCodigo();
                    }
                });
        dialog.setIcon(android.R.drawable.ic_dialog_alert);
        dialog.show();
        return true;
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
                                    Toast.makeText(getActivity(), getString(R.string.pasaporte_ya_insertado), Toast.LENGTH_LONG).show();
                                }
                            }
                            if(!no_insertar) {
                                listaPasaportes.add(new Pasaporte(pasaporteObject.getString("url"), cal.get(Calendar.YEAR), cal.get(Calendar.MONTH), cal.get(Calendar.DAY_OF_MONTH), false));
                            }
                        } catch (JSONException e) {
                            no_insertar = true;
                            Toast.makeText(getActivity(), getString(R.string.pasaporte_error), Toast.LENGTH_LONG).show();
                            e.printStackTrace();
                        }
                    }
                    if(!no_insertar) {
                        savePasaportesDescargados();
                        pasaporteAdapter.notifyDataSetChanged();
                        pager.setCurrentItem(pasaporteAdapter.getCount());
                        remplazarVista();
                        Toast.makeText(getActivity(), getString(R.string.pasaporte_exito), Toast.LENGTH_LONG).show();
                    }
                }
                else {
                    Toast.makeText(getActivity(), getString(R.string.pasaporte_fallo), Toast.LENGTH_LONG).show();
                }
            }
        }
    }


    public void remplazarVista() {
        if(listaPasaportes.size()==0) {
            pager.setVisibility(View.GONE);
            aviso.setVisibility(View.VISIBLE);
        }
        else {
            aviso.setVisibility(View.GONE);
            pager.setVisibility(View.VISIBLE);
        }
    }

    public void replaceFonts(View v) {
        //Para todos
        Typeface tf = Typeface.createFromAsset(getActivity().getAssets(), "fonts/BebasNeue.otf");

        TextView tv;

        tv = (TextView) v.findViewById(R.id.txtAviso);
        tv.setTypeface(tf);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_pasaporte, container, false);

        pager = (ViewPager) v.findViewById(R.id.pagerPasaporte);
        aviso = v.findViewById(R.id.pasaporteAviso);

        replaceFonts(v);
        remplazarVista();

        pasaporteAdapter = new ImageAdapter(listaPasaportes);
        pager.setAdapter(pasaporteAdapter);
        pager.setCurrentItem(0);

        return v;
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        setUserVisibleHint(true);
    }



    private class ImageAdapter extends PagerAdapter {

        private Context context;
        private LayoutInflater inflater;

        ImageAdapter(List<Pasaporte> listaPasaportesInst) {
            context = getActivity();
            inflater = LayoutInflater.from(context);
            listaPasaportes = listaPasaportesInst;
        }

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            container.removeView((View) object);
        }

        @Override
        public int getCount() {
            return listaPasaportes.size();
        }


        @Override
        public Object instantiateItem(ViewGroup view, final int position) {

            final View pagerItem = inflater.inflate(R.layout.fragment_home_image_pager, view, false);
            final ImageView imageView = (ImageView) pagerItem.findViewById(R.id.image);
            final ProgressBar spinner = (ProgressBar) pagerItem.findViewById(R.id.loading);


            if (listaPasaportes.get(position).getUrl() instanceof Integer) {
                final Integer motivacional = (Integer) listaPasaportes.get(position).getUrl();
                Picasso.with(getActivity())
                        .load(motivacional)
                                //.error(R.drawable.error_detail)
                        .fit().centerCrop()
                        .into(imageView, new Callback.EmptyCallback() {
                            @Override public void onSuccess() {
                                spinner.setVisibility(View.GONE);
                            }
                            @Override
                            public void onError() {
                                spinner.setVisibility(View.GONE);
                            }
                        });
            }
            if (listaPasaportes.get(position).getUrl() instanceof String) {
                final String motivacional = getString(R.string.url_api_rest) + "pasaporte/" + listaPasaportes.get(position).getUrl();
                Picasso.with(getActivity())
                        .load(motivacional)
                                //.error(R.drawable.error_detail)
                        .fit().centerCrop()
                        .into(imageView, new Callback.EmptyCallback() {
                            @Override public void onSuccess() {
                                spinner.setVisibility(View.GONE);
                            }
                            @Override
                            public void onError() {
                                spinner.setVisibility(View.GONE);
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
        public void restoreState(Parcelable state, ClassLoader loader) { }
        @Override
        public Parcelable saveState() {
            return null;
        }

    }

}
