package com.edatta.android.beerrunners;
 
import android.content.Context;
import android.graphics.Typeface;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

public class AgendaListAdapter extends BaseAdapter implements Filterable {
 
    private Context context;
    private List<Noticia> listaNoticias = new ArrayList<Noticia>();
    private List<Noticia> filteredListaNoticias = null;
    private LayoutInflater mInflater;
    private ItemFilter mFilter = new ItemFilter();

    public AgendaListAdapter(Context context, List<Noticia> listaNoticias) {
        this.context = context;
        this.listaNoticias = listaNoticias;
        this.filteredListaNoticias = listaNoticias;
        mInflater = LayoutInflater.from(context);
    }
 
    public int getCount() {
        return filteredListaNoticias.size();
    }

    public Object getItem(int position) {
        return filteredListaNoticias.get(position);
    }
 
    public long getItemId(int position) {
        return position;
    }

    public View getView(int position, View convertView, ViewGroup parent) {

        TextView txtfecha;
        TextView txttitulo;
        TextView txtminidesc;
        TextView txtdesc;
        TextView txturl;

        View itemView = mInflater.inflate(R.layout.agenda_listview_item, parent, false);

        replaceFonts(itemView, context);

        txtfecha = (TextView) itemView.findViewById(R.id.agendaFecha);
        txttitulo = (TextView) itemView.findViewById(R.id.agendaTitulo);
        txtminidesc = (TextView) itemView.findViewById(R.id.agendaMinidesc);
        txtdesc = (TextView) itemView.findViewById(R.id.agendaDesc);
        txturl = (TextView) itemView.findViewById(R.id.agendaUrl);

        txtfecha.setText(Utils.FormatearFecha(filteredListaNoticias.get(position).getFecha()));
        txttitulo.setText(filteredListaNoticias.get(position).getTitulo());
        txtminidesc.setText(filteredListaNoticias.get(position).getMinidesc());
        txtdesc.setText(filteredListaNoticias.get(position).getDesc());
        txturl.setText(filteredListaNoticias.get(position).getUrl());

        return itemView;
    }

    public void replaceFonts(View v, Context ctx) {

        Typeface tf = Typeface.createFromAsset(ctx.getAssets(), "fonts/BebasNeue.otf");

        TextView tv;

        tv = (TextView) v.findViewById(R.id.agendaTitulo);
        tv.setTypeface(tf);

        tv = (TextView) v.findViewById(R.id.agendaFecha);
        tv.setTypeface(tf);

    }

    @Override
    public Filter getFilter() {
        return mFilter;
    }

    private class ItemFilter extends Filter {
        @Override
        protected FilterResults performFiltering(CharSequence constraint) {

            String filterString = constraint.toString().toLowerCase();

            FilterResults results = new FilterResults();

            final List<Noticia> list = listaNoticias;

            int count = list.size();
            final ArrayList<Noticia> nlist = new ArrayList<Noticia>(count);

            String filterableString;

            for (Noticia aList : list) {
                filterableString = aList.getTag();
                if (filterableString.toLowerCase().contains(filterString)) {
                    nlist.add(aList);
                }
                else if (!filterString.toLowerCase().equals("ver todos") && filterableString.toLowerCase().equals("general")) {
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
                filteredListaNoticias = listaNoticias;
                notifyDataSetChanged();
            } else {
                filteredListaNoticias = (ArrayList<Noticia>) results.values;
                notifyDataSetChanged();
            }
        }

    }
}
