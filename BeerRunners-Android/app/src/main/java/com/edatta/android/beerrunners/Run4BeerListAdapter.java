package com.edatta.android.beerrunners;
 
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import android.content.Context;
import android.graphics.Typeface;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
 
public class Run4BeerListAdapter extends BaseAdapter {
 
    Context context;

    Run4BeerListAdapter adapterRun4Beer;
    List<Carrera> carreras;
    private double totalkm;


    LayoutInflater inflater;
 
    public Run4BeerListAdapter(Context context, List<Carrera> carreras) {
        this.context = context;
        this.carreras = carreras;
        Collections.sort(carreras, new Comparator<Carrera>() {
            public int compare(Carrera carrera1, Carrera carrera2) {
                return Utils.FormatearFechaParaDate(carrera2.getFecha()).compareTo(Utils.FormatearFechaParaDate(carrera1.getFecha()));
            }
        });
        setTotalkm();
    }

    @Override
    public void notifyDataSetChanged()
    {
        Collections.sort(carreras, new Comparator<Carrera>() {
            public int compare(Carrera carrera1, Carrera carrera2) {
                return Utils.FormatearFechaParaDate(carrera2.getFecha()).compareTo(Utils.FormatearFechaParaDate(carrera1.getFecha()));
            }
        });
        setTotalkm();
        super.notifyDataSetChanged();
    }

    public double getTotalkm() {
        return totalkm;
    }

    public void setTotalkm() {
        double km = 0;
        for (int i = 0; i < getCount(); i++) {
            km = km + Double.parseDouble(carreras.get(i).getKilometros());

        }
        this.totalkm = km;
    }

    public int getCount() {
    	return carreras.size();
    }
 
    public Object getItem(int position) {
        return null;
    }
 
    public long getItemId(int position) {
        return 0;
    }
    
    public boolean addItemId(Integer lastid, String fechahoy, String kmrandom, String fraserandom) {
        carreras.add(new Carrera(lastid, fechahoy, kmrandom, fraserandom));

        return true;
    }   
    
    public boolean removeItemId(int position) {
        carreras.remove(position);
        return true;
    }
 
    public View getView(int position, View convertView, ViewGroup parent) {
 
        // Declare Variables
        TextView txtfecha;
        TextView txtkilometros;
        TextView txtfrase;
        
 
        inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
 
        View itemView;
       	if ((position % 2) != 0) {
       		itemView = inflater.inflate(R.layout.run4beer_listview_item_impar, parent, false);
       	} else {
       		itemView = inflater.inflate(R.layout.run4beer_listview_item_par, parent, false);
       	}

        replaceFonts(itemView, context);

        txtfecha = (TextView) itemView.findViewById(R.id.run4beerFecha);
        txtkilometros = (TextView) itemView.findViewById(R.id.run4beerKilometros);
        txtfrase = (TextView) itemView.findViewById(R.id.run4beerFrase);
        
        txtfecha.setText(carreras.get(position).getFecha());
        txtkilometros.setText(carreras.get(position).getKilometros());
        txtfrase.setText(carreras.get(position).getFrase());
         
        return itemView;
    }

    public void replaceFonts(View v, Context ctx) {

        //Para todos
        Typeface tf = Typeface.createFromAsset(ctx.getAssets(), "fonts/BebasNeue.otf");

        TextView tv;

        tv = (TextView) v.findViewById(R.id.run4beerFecha);
        tv.setTypeface(tf);

        tv = (TextView) v.findViewById(R.id.run4beerKilometros);
        tv.setTypeface(tf);

        tv = (TextView) v.findViewById(R.id.run4beerFrase);
        tv.setTypeface(tf);

    }
}
