package com.edatta.android.beerrunners;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.conn.ConnectTimeoutException;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;

public class JsonParser {

    private static final String TAG = JsonParser.class.getName();

	static InputStream is = null;
	static String json = "";

	// constructor
	public JsonParser() {

	}

	public String getJSONFromUrl(String url) {

        json = "";

		// Making HTTP request
		try {
			
			int timeoutConnection = 3000;
			int timeoutSocket = 10000;
			
			// defaultHttpClient
			HttpGet httpGet = new HttpGet(url);			

			HttpParams httpParameters = new BasicHttpParams();			
			HttpConnectionParams.setConnectionTimeout(httpParameters, timeoutConnection);			
			HttpConnectionParams.setSoTimeout(httpParameters, timeoutSocket);

			DefaultHttpClient httpClient = new DefaultHttpClient(httpParameters);

			HttpResponse httpResponse = httpClient.execute(httpGet);
			HttpEntity httpEntity = httpResponse.getEntity();
			
			is = httpEntity.getContent();

		} catch (ConnectTimeoutException e) {
			e.printStackTrace();			
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			BufferedReader reader = new BufferedReader(new InputStreamReader(is, "iso-8859-1"), 8);
			StringBuilder sb = new StringBuilder();
			String line = null;
			while ((line = reader.readLine()) != null) {
				sb.append(line + "\n");
			}
			is.close();
			json = sb.toString();
		} catch (Exception e) {
            //Log.e(TAG, "Buffer Error: Error converting result " + e.getLocalizedMessage());
		}

		return json;

	}
}