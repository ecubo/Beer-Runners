package com.edatta.android.beerrunners;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import android.content.Context;

public class Utils {
	
    Context _context;
    public Utils(Context context) {
         _context = context;
    }
    
    public boolean existeJson(String nombre){
        File file = _context.getApplicationContext().getFileStreamPath(nombre + ".json");
        return file.exists();
    }
    
    public boolean escribirJson(String nombre, String archivo) {
        try {
            FileOutputStream outputStream;
            outputStream = _context.getApplicationContext().openFileOutput(nombre + ".json", Context.MODE_PRIVATE);
            outputStream.write(archivo.getBytes());
            outputStream.close();
          } catch (Exception e) {
            e.printStackTrace();
          }
        return true;			
	}
    
    public String leerJson(String nombre){
    	StringBuilder sb = new StringBuilder();
        try{
        	FileInputStream fis = _context.getApplicationContext().openFileInput(nombre + ".json");
        	BufferedReader reader = new BufferedReader(new InputStreamReader(fis, "UTF-8"));
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line).append("\n");
            }
            fis.close();
        } catch(OutOfMemoryError om){
            om.printStackTrace();
        } catch(Exception ex){
            ex.printStackTrace();
        }

        return sb.toString();
     }

    public static String FormatearFecha(String fechaOriginal) {
        try {
            SimpleDateFormat formatToDate = new SimpleDateFormat("yyyy-MM-dd");
            Date dateOriginal = formatToDate.parse(fechaOriginal);
            //SimpleDateFormat formatToString = new SimpleDateFormat("d 'de' MMMM 'de' yyyy");
            SimpleDateFormat formatToString = new SimpleDateFormat("d MMMM yyyy");
            return formatToString.format(dateOriginal).toUpperCase();
        } catch (Exception e) {
            e.printStackTrace();
            return fechaOriginal.toUpperCase();
        }
    }

    public static Calendar FormatearFechaParaDate(String fechaString) {
        try {
            Calendar cal = Calendar.getInstance();
            SimpleDateFormat sdf = new SimpleDateFormat("d MMMM yyyy");
            Date fechaFormatoCal = sdf.parse(fechaString);
            cal.setTime(fechaFormatoCal);
            return cal;
        } catch (Exception e) {
            e.printStackTrace();
            return Calendar.getInstance();
        }
    }


}
