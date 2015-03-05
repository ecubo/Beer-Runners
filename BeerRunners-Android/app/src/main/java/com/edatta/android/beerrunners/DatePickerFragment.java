package com.edatta.android.beerrunners;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.text.format.DateFormat;
import android.text.format.Time;
import android.widget.DatePicker;
import android.widget.EditText;

import java.util.Calendar;


public class DatePickerFragment extends DialogFragment implements DatePickerDialog.OnDateSetListener {

    EditText updateButton;
    EditText edittext;

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        // Use the current date as the default date in the picker
        final Calendar c = Calendar.getInstance();
        int year = c.get(Calendar.YEAR);
        int month = c.get(Calendar.MONTH);
        int day = c.get(Calendar.DAY_OF_MONTH);

        // Create a new instance of DatePickerDialog and return it
        return new DatePickerDialog(getActivity(), this, year, month, day);
    }

    public void setUpdateButton(EditText btn) {
        this.updateButton = btn;
    }
    public void setUpdateEditText(EditText edittext) {
        this.edittext = edittext;
    }

    public void onDateSet(DatePicker view, int year, int month, int day) {
        // Do something with the date chosen by the user
        Time chosenDate = new Time();
        chosenDate.set(day, month, year);
        long dtDob = chosenDate.toMillis(true);
        CharSequence edittextDate = DateFormat.format("yyyy-MM-dd", dtDob);
        CharSequence btnDate = Utils.FormatearFecha(DateFormat.format("yyyy-MM-dd", dtDob).toString());

        this.edittext.setText(edittextDate.toString());
        this.updateButton.setText(btnDate.toString());
    }
}