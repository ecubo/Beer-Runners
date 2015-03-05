package com.edatta.android.beerrunners;


import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
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
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.squareup.picasso.Callback;
import com.squareup.picasso.Picasso;
import com.squareup.picasso.Target;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Tab Home
 */
public class FragmentHome extends Fragment {

    private ImageAdapter homeAdapter;
    private ViewPager pager;
    ImageView btn_motivacional_fav;
    ImageView btn_motivacional_save;
    Object[] tag;
    private static final String TAG = FragmentHome.class.getName();

    List<Motivacional> listaMotivacionales = new ArrayList<Motivacional>();
    List<Motivacional> filteredListaMotivacionales = null;
    int firstLoadListaMotivacionales = 0;
    boolean menuMostrandoFavs=false;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Utils utils = new Utils(getActivity());

        try {
            JSONArray motivacionalesArray = new JSONArray(utils.leerJson("motivacionales"));

            listaMotivacionales.add(new Motivacional(R.drawable.mot01_keep_calm, "R.drawable.mot01_keep_calm", true, false));
            listaMotivacionales.add(new Motivacional(R.drawable.mot02_will_run, "R.drawable.mot02_will_run", true, false));
            listaMotivacionales.add(new Motivacional(R.drawable.mot03_50_por_ciento, "R.drawable.mot03_50_por_ciento", true, false));
            listaMotivacionales.add(new Motivacional(R.drawable.mot04_la_canya, "R.drawable.mot04_la_canya", true, false));
            listaMotivacionales.add(new Motivacional(R.drawable.mot05_dime_con_quien, "R.drawable.mot05_dime_con_quien", true, false));
            listaMotivacionales.add(new Motivacional(R.drawable.mot06_la_meta, "R.drawable.mot06_la_meta", true, false));
            listaMotivacionales.add(new Motivacional(R.drawable.mot07_bebeme_despacio, "R.drawable.mot07_bebeme_despacio", true, false));


            for (int i = 0; i < motivacionalesArray.length(); i++) {
                JSONObject motivacionalObject = motivacionalesArray.getJSONObject(i);
                listaMotivacionales.add(new Motivacional(getString(R.string.url_api_rest) + "motivacional/" + motivacionalObject.getString("url"), getString(R.string.url_api_rest) + "motivacional/" + motivacionalObject.getString("url"), false, false));
            }
            loadFavs();

        } catch (JSONException e) {
            Log.e(TAG, e.getLocalizedMessage());
        }
    }

    public void loadFavs() {
        Utils utils = new Utils(getActivity());
        JSONArray favs;
        try {
            favs = new JSONArray(utils.leerJson("motivacionalesfav"));
            for (int i = 0; i < favs.length(); i++) {
                JSONObject motivacionalFavObject = favs.getJSONObject(i);
                String thisfav = motivacionalFavObject.getString("fav");
                for (Motivacional listaMotivacional : listaMotivacionales) {
                    if (listaMotivacional.getUrlStr().equals(thisfav)) {
                        listaMotivacional.setFav(true);
                    }
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public void saveFavs() {
        Utils utils = new Utils(getActivity());
        JSONArray favs = new JSONArray();

        try {
            for (Motivacional listaMotivacional : listaMotivacionales) {
                if (listaMotivacional.isFav()) {
                    JSONObject motivacionalFavObject = new JSONObject();
                    motivacionalFavObject.put("fav", listaMotivacional.getUrlStr());
                    favs.put(motivacionalFavObject);
                }
            }
            JSONObject jObj = new JSONObject();
            jObj.put("motivacionalesfav", favs);
            utils.escribirJson("motivacionalesfav", jObj.getString("motivacionalesfav"));
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public int posFav(String tag) {
        int posFav = -1;
        for (int j = 0; j < listaMotivacionales.size(); j++) {
            if(listaMotivacionales.get(j).getUrlStr().equals(tag)) {
                if(listaMotivacionales.get(j).isFav()) {posFav=j;}
            }
        }
        return posFav;
    }
    public boolean isFav(String tag) {
        return posFav(tag)>-1;
    }

    public void setFav(ImageView btn, boolean state) {
        if(state){
            btn.setImageResource(R.drawable.btn_rating_star_off_selected);
            //btn.setColorFilter(Color.argb(255, 255, 0, 0));
        }
        else {
            btn.setImageResource(R.drawable.btn_rating_star_off_normal);
            //btn.setColorFilter(Color.argb(255, 255, 255, 255));
        }
    }


    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        //super.onCreateOptionsMenu(menu, inflater);
        inflater.inflate(R.menu.menu_home, menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.menu_ver_favs:
                if(menuMostrandoFavs) {
                    menuMostrandoFavs = false;
                    item.setTitle("Ver Favoritos");
                    homeAdapter.getFilter().filter("Ver Todos");
                    btn_motivacional_fav.setVisibility(View.VISIBLE);
                }
                else {
                    int numFavs = 0;
                    for (Motivacional listaMotivacional : listaMotivacionales) {
                        if (listaMotivacional.isFav()) {
                            numFavs++;
                        }
                    }
                    if(numFavs==0) {
                        Toast.makeText(getActivity(), "No hay marcada ninguna imagen como favorita. Para guardar tus favoritos, utiliza la estrella en la parte inferior de la pantalla.", Toast.LENGTH_LONG).show();
                        return false;
                    }
                    menuMostrandoFavs = true;
                    item.setTitle("Ver Todos");
                    homeAdapter.getFilter().filter("Ver Favoritos");
                    btn_motivacional_fav.setVisibility(View.GONE);
                }
                return true;

        }
        return super.onOptionsItemSelected(item);
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_home, container, false);
        //setHasOptionsMenu(true);
        pager = (ViewPager) v.findViewById(R.id.pager);
        btn_motivacional_fav = (ImageView) v.findViewById(R.id.btn_motivacional_fav);
        btn_motivacional_save = (ImageView) v.findViewById(R.id.btn_motivacional_save);

        homeAdapter = new ImageAdapter(listaMotivacionales);
        pager.setAdapter(homeAdapter);
        pager.setCurrentItem(firstLoadListaMotivacionales);

        tag = new Object[]{filteredListaMotivacionales.get(firstLoadListaMotivacionales).getUrl(), filteredListaMotivacionales.get(firstLoadListaMotivacionales).getUrlStr()};
        setFav(btn_motivacional_fav, isFav(tag[1].toString()));


        btn_motivacional_save.setOnClickListener(new ImageButton.OnClickListener() {
            @Override
            public void onClick(View view) {
                DialogHandler appdialog = new DialogHandler();
                appdialog.Confirm(getActivity(), getString(R.string.home_guardar), getString(R.string.home_guardar_en_galeria), getString(R.string.home_no), getString(R.string.home_si), guardarEnGaleria(), noGuardarEnGaleria());
            }
            public Runnable guardarEnGaleria(){
                return new Runnable() {
                    public void run() {

                        if (tag[0] instanceof Integer) {
                            final Integer motivacional = (Integer) tag[0];
                            Picasso.with(getActivity()).load(motivacional).into(mTarget);
                        }
                        else {
                            Picasso.with(getActivity()).load(tag[1].toString()).into(mTarget);
                        }
                    }
                };
            }
            public Runnable noGuardarEnGaleria(){return new Runnable() {public void run() {}};}

        });


        btn_motivacional_fav.setOnClickListener(new ImageButton.OnClickListener() {
            @Override
            public void onClick(View view) {
                int posFav = posFav(tag[1].toString());
                boolean isFav = posFav>-1;

                for (Motivacional filteredListaMotivacional : filteredListaMotivacionales) {
                    if (filteredListaMotivacional.getUrlStr().equals(tag[1].toString())) {
                        filteredListaMotivacional.setFav(!isFav);
                    }
                }
                setFav(btn_motivacional_fav, !isFav);
                saveFavs();

            }
        });

        // listen for page changes so we can track the current index
        pager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {

            public void onPageScrollStateChanged(int arg0) {
            }

            public void onPageScrolled(int arg0, float arg1, int arg2) {
            }

            public void onPageSelected(int currentPage) {
                tag[0] = filteredListaMotivacionales.get(currentPage).getUrl();
                tag[1] = filteredListaMotivacionales.get(currentPage).getUrlStr();
                setFav(btn_motivacional_fav, isFav(tag[1].toString()));
            }

        });

        return v;
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        setUserVisibleHint(true);
    }

    private Target mTarget = new Target() {
        @Override
        public void onBitmapLoaded(final Bitmap bitmap, Picasso.LoadedFrom from) {

            try
            {
                CapturePhotoUtils.insertImage(getActivity().getContentResolver(), bitmap, "Run4Beer", "Imagen motivacional Run4Beer");
                Toast.makeText(getActivity(), "Imagen guardada correctamente en galería", Toast.LENGTH_LONG).show();
            }
            catch (Exception e)
            {
                Toast.makeText(getActivity(), "Error al guardar la imagen", Toast.LENGTH_LONG).show();
                e.printStackTrace();
            }
        }
        @Override
        public void onBitmapFailed(Drawable errorDrawable) {
            Toast.makeText(getActivity(), "Error al guardar la imagen", Toast.LENGTH_LONG).show();
        }

        @Override
        public void onPrepareLoad(Drawable placeHolderDrawable) {
        }

    };

    private class ImageAdapter extends PagerAdapter implements Filterable {

        // Declare Variables
        private Context context;
        private LayoutInflater inflater;
        private ItemFilter mFilter = new ItemFilter();

        ImageAdapter(List<Motivacional> listaMotivacionalesInst) {
            context = getActivity();
            inflater = LayoutInflater.from(context);
            listaMotivacionales = listaMotivacionalesInst;
            filteredListaMotivacionales = listaMotivacionalesInst;
        }

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            container.removeView((View) object);
        }

        @Override
        public int getCount() {
            return filteredListaMotivacionales.size();
        }


        @Override
        public Object instantiateItem(ViewGroup view, final int position) {

            final View pagerItem = inflater.inflate(R.layout.fragment_home_image_pager, view, false);
            final ImageView imageView = (ImageView) pagerItem.findViewById(R.id.image);
            final ProgressBar spinner = (ProgressBar) pagerItem.findViewById(R.id.loading);


            if (filteredListaMotivacionales.get(position).getUrl() instanceof Integer) {
                final Integer motivacional = (Integer) filteredListaMotivacionales.get(position).getUrl();
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
            if (filteredListaMotivacionales.get(position).getUrl() instanceof String) {
                final String motivacional = (String) filteredListaMotivacionales.get(position).getUrl();
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
        public void restoreState(Parcelable state, ClassLoader loader) {
        }

        @Override
        public Parcelable saveState() {
            return null;
        }

        @Override
        public Filter getFilter() {
            return mFilter;
        }

        @Override
        public int getItemPosition(Object object) {
            return POSITION_NONE;
        }

        private class ItemFilter extends Filter {
            @Override
            protected FilterResults performFiltering(CharSequence constraint) {

                String filterString = constraint.toString().toLowerCase();

                FilterResults results = new FilterResults();

                final List<Motivacional> list = listaMotivacionales;

                int count = list.size();
                final ArrayList<Motivacional> nlist = new ArrayList<Motivacional>(count);

                for (Motivacional aList : list) {
                    if (!filterString.equals("ver todos") && aList.isFav()) {
                        nlist.add(aList);
                    }
                }

                results.values = nlist;
                results.count = nlist.size();

                return results;
            }

            @SuppressWarnings("unchecked")
            @Override
            protected void publishResults(CharSequence constraint, FilterResults results) {
                if (results.count == 0) {
                    filteredListaMotivacionales = listaMotivacionales;
                    notifyDataSetChanged();
                } else {
                    filteredListaMotivacionales = (ArrayList<Motivacional>) results.values;
                    notifyDataSetChanged();
                }
                pager.setCurrentItem(0);
                tag[0] = filteredListaMotivacionales.get(0).getUrl();
                tag[1] = filteredListaMotivacionales.get(0).getUrlStr();
                setFav(btn_motivacional_fav, isFav(tag[1].toString()));
            }

        }
    }

}
