package com.edatta.android.beerrunners;

public class Bar{
   	private int id;
	private String address;
   	private Double lat;
   	private Double lng;
   	private String name;
   	private String redsocial;
   	private String tel;
   	private String type;
   	private String web;

   	public static String replaceNull(String input) {
     	  return (input == null || input.equals("null")) ? "" : input;
    }
   	
 	public String getAddress(){
		return replaceNull(this.address);
	}
	public void setAddress(String address){
		this.address = address;
	}
 	public int getId(){
		return this.id;
	}
	public void setId(int id){
		this.id = id;
	}
 	public Double getLat(){
		return this.lat;
	}
	public void setLat(Double lat){
		this.lat = lat;
	}
 	public Double getLng(){
		return this.lng;
	}
	public void setLng(Double lng){
		this.lng = lng;
	}
 	public String getName(){
		return replaceNull(this.name);
	}
	public void setName(String name){
		this.name = name;
	}
 	public String getRedsocial(){
 		String _redSocial = ""; 
 		if(this.redsocial != null && !this.redsocial.equals("null")) {
 			//_redSocial = "<a href=\"" + this.redsocial + "\">Facebook</a>";
 			_redSocial = this.redsocial;
 		} else {
 			_redSocial = this.redsocial;
 		}
		
 		return replaceNull(_redSocial);
	}
	public void setRedsocial(String redsocial){
		this.redsocial = redsocial;
	}
 	public String getTel(){
		return replaceNull(this.tel);
	}
	public void setTel(String tel){
		this.tel = tel;
	}
 	public String getType(){
		return replaceNull(this.type);
	}
	public void setType(String type){
		this.type = type;
	}
 	public String getWeb(){
		return replaceNull(this.web);
	}
	public void setWeb(String web){
		this.web = web;
	}
}

