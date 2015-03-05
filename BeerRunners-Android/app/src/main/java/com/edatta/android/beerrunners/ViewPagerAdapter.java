package com.edatta.android.beerrunners;
 
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
 
public class ViewPagerAdapter extends FragmentPagerAdapter {
 
    // número de páginas del viewpager
    final int PAGE_COUNT = 5;
 
    public ViewPagerAdapter(FragmentManager fm) {
        super(fm);
    }
 
    @Override
    public Fragment getItem(int arg0) {
        switch (arg0) {
 
        // Abro FragmentHome.java
        case 0:
            return new FragmentHome();
 
        // Abro FragmentAgenda.java
        case 1:
            return new FragmentAgenda();
 
        // Abro FragmentRun4Beer.java
        case 2:
            //return new FragmentRun4Beer();
            return new FragmentRun4BeerPager();
        
        
        // Abro FragmentPasaporte.java
        case 3:
        	if(MainActivity.habilitarPasaporte) {
                //return new FragmentPasaporte();
                return new FragmentPasaporteGeneral();
        	}
        	else {
                //return new FragmentMapa();
                return new FragmentMapa();
        	}

        // Abro FragmentMapa.java
        case 4:
            return new FragmentMapa();
        }
        return null;
    }
 
    @Override
    public int getCount() {
        int pageCount = PAGE_COUNT;

        if(!MainActivity.habilitarPasaporte) {
            pageCount--;
        }

        return pageCount;
    }
 
}
