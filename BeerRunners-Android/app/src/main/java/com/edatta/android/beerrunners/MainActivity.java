package com.edatta.android.beerrunners;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.ActionBar;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;


public class MainActivity extends ActionBarActivity {

    //Utilidad para des/habilitar de forma rápida el pasaporte
    static boolean habilitarPasaporte = false;

    // Declaro Variables
    ActionBar mActionBar;
    NonSwipeableViewPager mPager;
    ActionBar.Tab tab;

    @SuppressWarnings("deprecation")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        if (savedInstanceState == null) {

            //Obtenemos datos de SplashScreenActivity
            Bundle b = getIntent().getExtras();
            boolean timeout = b.getBoolean("timeout");

            //Marco warnings para el usuario
            ConnectivityManager conMgr = (ConnectivityManager) getApplicationContext().getSystemService(Context.CONNECTIVITY_SERVICE);
            NetworkInfo netinfo = conMgr.getActiveNetworkInfo();
            if (timeout || netinfo == null || !netinfo.isConnected() || !netinfo.isAvailable()) {
                Toast.makeText(getApplicationContext(), getString(R.string.error_no_internet), Toast.LENGTH_LONG).show();
            }


            // Activo navegación en modo tabs y customizo presentación
            mActionBar = getSupportActionBar();
            mActionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
            mActionBar.setBackgroundDrawable(new ColorDrawable(Color.BLACK));
            mActionBar.setDisplayShowHomeEnabled(false);
            mActionBar.setDisplayShowTitleEnabled(false);
            //mActionBar.setIcon(R.drawable.ic_launcher);

            //Fuente título

            Typeface tf = Typeface.createFromAsset(getAssets(), "fonts/BebasNeue.otf");
            LayoutInflater inflater = LayoutInflater.from(this);
            @SuppressLint("InflateParams") View v = inflater.inflate(R.layout.action_bar, null);
            TextView titleTextView = (TextView) v.findViewById(R.id.custom_action_bar_title);
            titleTextView.setText(this.getTitle());
            titleTextView.setTypeface(tf);

            mActionBar.setDisplayShowCustomEnabled(true);
            mActionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_CUSTOM);
            mActionBar.setCustomView(v, new ActionBar.LayoutParams(ActionBar.LayoutParams.WRAP_CONTENT,ActionBar.LayoutParams.MATCH_PARENT, Gravity.CENTER));

            //Fuente otros
            replaceFonts(this);


            // Locate ViewPager in activity_main.xml
            mPager = (NonSwipeableViewPager) findViewById(R.id.pager);

            // Activate Fragment Manager
            FragmentManager fm = getSupportFragmentManager();

            // Capture ViewPager page swipes
            ViewPager.SimpleOnPageChangeListener ViewPagerListener = new ViewPager.SimpleOnPageChangeListener() {
                @Override
                public void onPageSelected(int position) {
                    super.onPageSelected(position);
                    //noinspection deprecation
                    mActionBar.setSelectedNavigationItem(position);
                }
            };

            mPager.setOnPageChangeListener(ViewPagerListener);
            ViewPagerAdapter viewpageradapter = new ViewPagerAdapter(fm);
            mPager.setAdapter(viewpageradapter);

            // Capture tab button clicks
            ActionBar.TabListener tabListener = new ActionBar.TabListener() {

                @Override
                public void onTabSelected(ActionBar.Tab tab, FragmentTransaction ft) {
                    mPager.setCurrentItem(tab.getPosition());
                }

                @Override
                public void onTabUnselected(ActionBar.Tab tab, FragmentTransaction ft) {
                }

                @Override
                public void onTabReselected(ActionBar.Tab tab, FragmentTransaction ft) {
                }
            };

            // Home
            tab = mActionBar.newTab()
                    .setIcon(getResources().getDrawable(R.drawable.tabbar_home_layout))
                    .setTabListener(tabListener);

            mActionBar.addTab(tab);

            // Agenda
            tab = mActionBar.newTab()
                    .setIcon(getResources().getDrawable(R.drawable.tabbar_agenda_layout))
                    .setTabListener(tabListener);
            mActionBar.addTab(tab);

            // Run4Beer
            tab = mActionBar.newTab()
                    .setIcon(getResources().getDrawable(R.drawable.tabbar_run4beer_layout))
                    .setTabListener(tabListener);
            mActionBar.addTab(tab);

            // Pasaporte
            if(habilitarPasaporte) {
                tab = mActionBar.newTab()
                        .setIcon(getResources().getDrawable(R.drawable.tabbar_pasaporte_layout))
                        .setTabListener(tabListener);
                mActionBar.addTab(tab);
            }

            // Mapa
            tab = mActionBar.newTab()
                    .setIcon(getResources().getDrawable(R.drawable.tabbar_mapa_layout))
                    .setTabListener(tabListener);
            mActionBar.addTab(tab);
        }
    }



    public void replaceFonts(Context ctx) {
        //Para todos
        Typeface tf = Typeface.createFromAsset(ctx.getAssets(), "fonts/BebasNeue.otf");

        TextView tv = (TextView) findViewById(R.id.custom_action_bar_title);
        tv.setTypeface(tf);
    }
}
