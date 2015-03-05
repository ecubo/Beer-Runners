package com.edatta.android.beerrunners;

import android.content.Context;
import android.os.Bundle;
import android.os.Parcelable;
import android.support.v4.app.FragmentActivity;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ProgressBar;

import com.squareup.picasso.Callback;
import com.squareup.picasso.Picasso;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Tab Pasaporte Sellos
 */
public class FragmentPasaporteSellos extends FragmentActivity {

    //private static final String TAG = FragmentPasaporteSellos.class.getName();

    List<Pasaporte> listaPasaportes = new ArrayList<Pasaporte>();

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.fragment_pasaporte_sellos);

        loadPasaportesDescargados();

        ViewPager pager = (ViewPager) findViewById(R.id.pagerPasaporte);
        ImageAdapter sellosAdapter = new ImageAdapter(listaPasaportes);
        pager.setAdapter(sellosAdapter);
        //pager.setCurrentItem(0);
        pager.setCurrentItem(sellosAdapter.getCount());

    }

    public void loadPasaportesDescargados() {
        Utils utils = new Utils(getApplicationContext());
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

    private class ImageAdapter extends PagerAdapter {

        // Declare Variables
        private Context context;
        private LayoutInflater inflater;

        ImageAdapter(List<Pasaporte> listaPasaportesInst) {
            context = getApplicationContext();
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

            final View pagerItem = inflater.inflate(R.layout.fragment_pasaporte_image_pager, view, false);
            final ImageView imageView = (ImageView) pagerItem.findViewById(R.id.image);
            final ProgressBar spinner = (ProgressBar) pagerItem.findViewById(R.id.loading);


            if (listaPasaportes.get(position).getUrl() instanceof Integer) {
                final Integer motivacional = (Integer) listaPasaportes.get(position).getUrl();
                Picasso.with(getApplicationContext())
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
                Picasso.with(getApplicationContext())
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
        public void restoreState(Parcelable state, ClassLoader loader) {
        }
        @Override
        public Parcelable saveState() {
            return null;
        }
    }
}
